{% extends "../layout.swig" %}
{% set title = "Thorin.js - auth-password plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-auth-password') }}
         plugin-auth-password
      </h2>
      <p>
         The password authentication plugin is used to attach identity & password login to your application.
         It does so by altering your <i>account</i> model, adding a <code>password</code> field and the <code>identity</code> field configured.<br/>
         Behind the scenes, it uses <a href="https://npmjs.com/package/bcryptjs">bcryptjs</a> to correctly hash user passwords.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-auth-password@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-auth-password'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash">#update config/app.js with your configuration</code>
<code class="bash"># run to setup the models and module
   node app.js --setup=plugin.auth-password
</code></pre>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>modelName</b><span class="type">account</span>the name of your model that contains account information
         </li>
         <li>
            <b>store</b><span class="type">sql</span>the store-sql name to use as the database
         </li>
         <li>
            <b>identity.field</b><span class="type">user</span>the identity field to use for the user id (eg, email, username, etc)
         </li>
         <li>
            <b>identity.type</b><span class="type">username</span>the type of identity. Currently only <i>username</i> and <i>email</i>
         </li>
         <li>
            <b>identity.options</b><span class="type">{}</span>additional field opt to set on the identity field.
         </li>
         <li>
            <b>password.field</b><span class="type">password</span>the name of the field that will hold the user's password
         </li>
         <li>
            <b>password.policy.min</b><span class="type">the minimum number of chars for the password</span>
         </li>
         <li>
            <b>password.policy.upper</b><span class="type">false</span>should we ask for upper case chars for passwords
         </li>
         <li>
            <b>password.policy.numbers</b><span class="type">false</span>should we ask for numbers in the password
         </li>
         <li>
            <b>password.policy.special</b><span class="type">false</span>should we ask for special chars, like !@#
         </li>
         <li>
            <b>password.options</b><span class="type">{}</span>additional options to attach to the password model field
         </li>
         <li>
            <b>loginAt.field</b><span class="type">login_at</span>field used to store the last login time. Set <code>loginAt</code> to <code>false</code> to disable.
         </li>
         <li>
            <b>loginAt.options</b><span class="type">{}</span>additional options to attach to the loginAt model field
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.checkPolicy(password)</h6>
         <div class="desc">
            Verifies if the given password is accepted by the password policy. If it is not accepted, it will return
            a <code>thorin.error</code>, otherwise return <code>undefined</code>
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.hashPassword(password) : Promise</h6>
         <div class="desc">
            Asynchronously uses bcrypt to hash the given password and resolve with the hashed version of it. Useful for user registration.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.comparePassword(password, hashedPassword) : Promise</h6>
         <div class="desc">
            Compares the two passwords and resolves the promise if they match or reject if they do not.
         </div>
      </div>

      <h5 class="padding-top">Authorization middleware</h5>
      <div class="function">
         <h6>auth#password.login</h6>
         <div class="desc">
            Authorization middleware to be used in your <i>authenticate</i> endpoint. It will check if the intent has
            the <i>identity</i> and <i>password</i> field names. If so, query for the account and match the password.
            Once an account was found and matched the password, it will place in the intent's data object under the configured
            <code>modelName</code>.
         </div>
         <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql');
dispatcher
   .addAction('account.login')
   // The authorization will essentially add:
   // input({
   //    user: dispatcher.validate('string'),
   //    password: dispatcher.validate('string')
   // })
   // and check the account matching the two.
   .authorize('auth#password.login')
   .use((intentObj, next) => {
      const accountObj = intentObj.data('account');
      log.info('Account logged in');
      next();
   });
</code></pre>
      </div>
      <div class="function">
         <h6>auth#password.change</h6>
         <div class="desc">
            Authorization middleware used to change the password of an account. It will check if the input has
            <code>{opt.password.field}</code>, <code>{opt.password.field}_new</code> and <code>{opt.password.field}_check</code>, check if they match
            and finally update the account entity with the new password.
         </div>
         <div class="notes">
            <b>Note</b>: this authorization middleware requires that the <code>account</code> model be placed in the intent's data object
            under the <code>{opt.modelName}</code> key.
         </div>
         <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql');
dispatcher
   .addAction('account.password.change')
   .use((intentObj, next) => {
      const Account = storeObj.model('account');
      // first read the accountObj that wants to change the password
      Account.find({
         where: {id: 1}
      }).then((accObj) => {
         // and place it under the "account" data field.
         intentObj.data('account', accObj);
      });
   })
   // The authorization will essentially add:
   // input({
   //    password: dispatcher.validate('string'),
   //    password_new: dispatcher.validate('string'),
   //    password_check: dispatcher.validate('string')
   // });
   .authorization('auth#password.change')
   .use((intentObj, next) => {
      log.info('Password changed');
      next();
   });
</code></pre>
         <p>
            Every time the user performs a login or changes his password, a <code>auth:history</code> event is fired through
            the dispatcher. For a more complex example, visit <a href="https://github.com/Thorinjs/examples" target="_blank">our examples</a>.
         </p>
      </div>
   </div>
{% endblock %}