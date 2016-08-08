{% extends "../layout.swig" %}
{% set title = "Thorin.js - auth-unloq plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-auth-password') }}
         plugin-auth-unloq
      </h2>
      <p>
         <a href="https://unloq.io" target="_blank">UNLOQ.io</a> is a simple & secure multi-factor authentication, transaction authorisation and data encryption service. This
         plugin enables passwordless authentication via push notifications. It wil seamlessly integrate with the UNLOQ API and only
         request a few lines of code to enable in your thorin app. You can visit the <a href="https://docs.unloq.io" target="_blank">full documentation</a> of the service
         and take a look at the <a href="https://docs.unloq.io/getting-started" target="_blank">Getting Started</a> tutorial to get things going!
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-auth-unloq@1.x</code>
<code class="javascript">'use strict';
   // app.js entry file
   const thorin = require('thorin');

   thorin.addPlugin(require('thorin-plugin-auth-unloq'));   // <- add this line
   thorin.run((err) => {});
</code>
<code class="bash">#update config/app.js with your configuration</code>
<code class="bash"># run to setup the models and module
   node app.js --setup=plugin.auth-unloq
</code></pre>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>key</b><span class="type">null</span>your application's <code>API Key</code>
         </li>
         <li>
            <b>secret</b><span class="type">null</span>your application's <code>API Secret</code>
         </li>
         <li>
            <b>modelName</b><span class="type">account</span>the name of your model that contains account information
         </li>
         <li>
            <b>store</b><span class="type">sql</span>the store-sql name to use as the database
         </li>
         <li>
            <b>unloqId.unloqId</b><span class="type">unloq_id</span>the field used in your account model to store the user's UnloqID
         </li>
         <li>
            <b>unloqId.options</b><span class="type">{}</span>additional field opt to set on the unloqId field.
         </li>
         <li>
            <b>loginAt.field</b><span class="type">login_at</span>field used to store the last login time. Set <code>loginAt</code> to <code>false</code> to disable.
         </li>
         <li>
            <b>loginAt.options</b><span class="type">{}</span>additional options to attach to the loginAt model field
         </li>
         <li>
            <b>registration</b><span class="type">true</span>by default, users that do not exist in the database will be automatically on-boarded.
            Set this to <code>false</code> if you want only users that have an account to login with UNLOQ
         </li>
         <li>
            <b>sessionPlugin</b><span class="type">session</span>if your application uses the <code>session</code> plugin,
            we will try to enable remote logout for your users. Setting this to null will completely disable remote logout.
         </li>
      </ul>
      <p>
         Once you've configured the plugin, you just need to include the <a href="https://docs.unloq.io/web-application/api-widget" target="_blank">login widget script</a> in your
         login page and create an action that will handle the <a href="https://docs.unloq.io/web-application/web-hooks" target="_blank">login webhook</a>.
      </p>
      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.api</h6>
         <div class="desc">
            Exposes the UnloqAPI object that can be used to perform API calls. For more information on the API, visit <a href="https://github.com/UNLOQIO/unloq-node-client" target="_blank">the docs.</a>
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getScript(theme)</h6>
         <div class="desc">
            Returns the script tag that you can include in your login page view.
         </div>
         <ul class="arguments">
            <li>
               <b>theme</b><span class="type">string</span>the theme to use for the login widget. Values are <i>light</i>, <i>dark</i>
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Authorization middleware</h5>
      <div class="function">
         <h6>auth#unloq.login</h6>
         <div class="desc">
            This should be used with your <code>/uauth/login</code> action that handles
            the login webhook. It will read the access token from the URL and fetch its associated user information
            from UNLOQ. If everything's ok, create or read the account (if necessary) and place it
            in the intent's data object under the configured <code>modelName</code>.
         </div>
         <pre><code class="javascript">'use strict';
dispatcher
   .addAction('uauth.login')
   .alias('GET', '/uauth/login')
   .authorization('auth#unloq.login')
   .use((intentObj, next) => {
      const accountObj = intentObj.data('account'),
         unloqData = intentObj.data('unloq');
      log.info(`Account ${accountObj.id} logged in with data:`, unloqData);
      intentObj.session.account = accountObj.id;
      intentObj.redirect('/welcome');
   });
</code></pre>
      </div>
      <div class="function">
         <h6>auth#unloq.logout</h6>
         <div class="desc">
            This should be used with your <code>/uauth/logout</code> webhook, to easily enable remote logout for your users.
            If your application is using <code>plugin-session</code>, the user's session will be automatically deleted. If not,
            a <code>sid</code> key will be placed in the intent's data object, so that you can manually invalidate the session token.
         </div>
         <pre><code class="javascript">'use strict';
dispatcher
   .addAction('uauth.logout')
   .alias('POST', '/uauth/logout')
   .authorization('auth#unloq.logout')
   .end((intentObj) => {
      let sid = intentObj.data('sid'),
         unloqId = intentObj.input('id');
      log.info(`Terminated session ${sid} of user ${unloqId}`);
      next()
   });
</code></pre>
      </div>
      <p>
         Every time the user performs a login a <code>auth:history</code> event is fired through
         the dispatcher. This event is captured by plugin-auth-history (if used) and create an authentication log entry.
         For a more complex example, visit <a href="https://github.com/Thorinjs/examples" target="_blank">our examples</a>.
      </p>
   </div>
{% endblock %}