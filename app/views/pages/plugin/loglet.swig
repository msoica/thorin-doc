{% extends "../layout.swig" %}
{% set title = "Thorin.js - loglet plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-loglet') }}
         plugin-loglet
      </h2>
      <p>
         <a href="https://loglet.io" target="_blank">Loglet.io</a> is a centralized encrypted log management system that
         stores all your application logs in a single place, encrypted, streaming them in your browser.
      </p>
      <p>
         The Loglet.io project uses UNLOQ.io personal encryption keys to generate shared secret keys, used to perform end-to-end encryption (above TLS) from your node.js apps to your browser. In this scenario, the loglet.io servers are working in zero-knowledge state.
      </p>
      <p>
         The plugin was created to seamlessly integrate your application with loglet.io. For a more extensive view on how
         the logs are going to be sent, visit <a href="https://github.com/UNLOQIO/loglet-node-client" target="_blank">the repo.</a>
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the plugin
npm i --save thorin-plugin-loglet@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-loglet'));   // <-- add this line
thorin.run((err) => {});
</code></pre>

      <h5 class="padding-top">Getting started</h5>
      <ul class="numbered">
         <li>
            Download the UNLOQ app from the <a href="https://itunes.apple.com/us/app/unloq/id993213198?ls=1&mt=8" target="_blank">App Store</a> or from <a href="https://play.google.com/store/apps/details?id=io.unloq.android" target="_blank">Google Play</a>
            and create an account
         </li>
         <li>
            Login with <a href="https://account.unloq.io" target="_blank">UNLOQ</a> at <a href="https://loglet.io" target="_blank">loglet.io</a>
         </li>
         <li>
            Create an application with an environment and a minimal description. A default API key will be generated for you
         </li>
         <li>
            Click the <i>view</i> icon on your generated API key and use the provided API Key and Secret, or the full Bearer token as credentials.
         </li>
         <li>
            You now have centralized logging for your application
         </li>
      </ul>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>enabled</b><span class="type">true</span> should log events be streamed or not.
         </li>
         <li>
            <b>boot</b><span class="type">true</span>by default, the logger will send a <b>BOOT</b> event, marking the boot of your app
         </li>
         <li>
            <b>ignore</b><span class="type">[]</span>an array of logger names to ignore when streaming logs.
         </li>
         <li>
            <b>key</b><span class="type">process.env.LOGLET_KEY</span> the API key (short key) of your loglet application <strong>or</strong> the <i>Bearer</i> token (the long key)
         </li>
         <li>
            <b>secret</b><span class="type">process.env.LOGLET_SECRET</span>the API Secret of your loglet application. This works when providing the <strong>short</strong> API Key
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.disable()</h6>
         <div class="desc">Temporary disable the log streaming, stopping any log from exiting the app</div>
      </div>
      <div class="function">
         <h6>pluginObj.enable()</h6>
         <div class="desc">Re-enables the log streaming.</div>
      </div>
      <h5 class="padding-top">Log entry information</h5>
      <p>
         By default, the plugin will send the following information inside a log entry. Additional informatino can also be sent
         when logging.
      </p>
      <ul class="arguments">
         <li>
            <b>name</b><span class="type">thorin.id</span>the ID of your thorin application
         </li>
         <li>
            <b>namespace</b><span class="type">default</span> the namespace used when calling <code>thorin.logger(namespace)</code>
         </li>
         <li>
            <b>message</b> the string message resulted from calling log functions
         </li>
         <li>
            <b>data</b> additional data that will be sent
         </li>
         <li>
            <b>tags</b><span class="type">array(string)</span>additional tags that can be attached to the log entry
         </li>
         <li>
            <b>error</b><span class="type">erorr</span> an instance of an Error or a thorin error that will be sent.
         </li>
      </ul>
      <pre><code class="javascript">'use strict';
log.info('Simple message');
log.warn('Some weird stuff happened', {
   tags: ['something','weird']
});
log.error('Oh well...', {
   data: {
      yourOwn: 'custom logger',
      id: 2333
   }
});
log.fatal('Fudge....', {
   error: new Error("An error with its stacktrace captured"),
   tags: ['somewhere-in-the-app']
});
</code></pre>
   </div>
{% endblock %}