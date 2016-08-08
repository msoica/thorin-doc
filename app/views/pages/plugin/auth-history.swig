{% extends "../layout.swig" %}
{% set title = "Thorin.js - auth-history plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-auth-history') }}
         plugin-auth-history
      </h2>
      <p>
         The plugin seamlessly handles account history events. When used with any <code>auth</code> plugin, an entry will
         be created in the history table, describing the action that occurred (login, logout, change password, etc). It does so by creating
         a new table (by default, <code>account_history</code>) and starts listening for <code>auth:history</code> events
         coming from the dispatcher.
      </p>
      <p>
         For now, the plugin only works with <code>store-sql</code>, therefore it is a dependency you shoul have configured
         for your application.
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-auth-history@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-auth-history'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run to setup the models
node app.js --setup=plugin.auth-history
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>store</b><span class="type">sql</span>the name of the SQL store your application uses
         </li>
         <li>
            <b>accountModel</b><span class="type">account</span>the <strong>code</strong> of your account model. We use this for foreign key definition setup in the history table.
         </li>
         <li>
            <b>history.modelName</b><span class="type">accountHistory</span>the name of the history model we're going to add.
         </li>
         <li>
            <b>history.tableName</b><span class="type">account_history</span>the name of the history table that will be created.
         </li>
         <li>
            <b>events</b><span class="type">null</span>If we want the history plugin to listen to <strong>specific</strong> events,
            set an array of events here.
         </li>
      </ul>

      <h5 class="padding-top">History table fields</h5>
      <ul class="arguments">
         <li>
            <b>type</b><span class="type">string</span>the event type: LOGIN, LOGOUT, etc.
         </li>
         <li>
            <b>user_agent</b><span class="type">string</span>the user-agent of the account
         </li>
         <li>
            <b>ip</b><span class="type">string</span>the IP address of the account
         </li>
         <li>
            <b>account_id</b><span class="type">integer</span>a foreign key to the <i>account</i> table
         </li>
      </ul>
      <p>
         If you want to add additional fields to the history table, create a new file in <b>app/models/{opt.history.modelName}.js</b>,
         and export a function called <b>extend</b>. It will receive the history model object and the Sequelize instance.
      </p>
      <pre><code class="javascript">'use strict';
// File: app/models/accountHistory.js
module.exports = function extend(modelObj, Seq) {
   modelObj
      .field('location', Seq.STRING)
      .field('app_source', Seq.STRING)
      // add as many fields and methods you want.
};
</code></pre>


      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.create(accountObj, event, data) : Promise</h6>
         <div class="desc">
            Manually insert an account event in the history table.
         </div>
      </div>
   </div>
{% endblock %}