{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         thorin-transport-http
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-transport-http') }}
      </h2>
      <p>
         HTTP Transport layer that wraps over <i>express@4.x</i> and abstracts away any transport-related information.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-transport-http@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addTransport(require('thorin-transport-http'));   // <-- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run once to allow the transport to set itself up
node app.js --setup=transport.http</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>debug</b><span class="type">true</span> Enables or disables request debugging
         </li>
         <li>
            <b>port</b><span class="type">3000</span> Default port to bind the server
         </li>
         <li>
            <b>basePath</b><span class="type">/</span> Default base path to mount the root router
         </li>
         <li>
            <b>actionPath</b><span class="type">/dispatch</span> Action path used to dispatch actions
         </li>
         <li>
            <b>authorization.header</b><span class="type">Authorization</span> The HTTP Header to use as the source of an
            intent's authorization property, with the authorization type set to "TOKEN"
         </li>
         <li>
            <b>authorization.cookie</b><span class="type">tps</span>If set, the set cookie name will be the source of an intent's authorization
            property with the authorization type set to "COOKIE"
         </li>
         <li>
            <b>ip</b><span class="type">0.0.0.0</span> Default IP to bind the server to
         </li>
         <li>
            <b>cors</b><span class="type">false</span> If set to true, add Access-Control-Allow-(Origin|Methods|Credentials|Headers) HTTP Headers
            to enable Cross-Origin Resource Sharing. You can also specify the array of <code>domains</code> that CORS will be enabled on
         </li>
         <li>
            <b>trustProxy</b><span class="type">true</span> Trust or not the <code>X-Forwarded-For</code> HTTP header.
         </li>
         <li>
            <b>static</b><span class="type">thorin.root + '/public'</span> The absolute path to the public directory containing static assets.
         </li>
         <li>
            <b>options.payloadLimit</b><span class="type">50000</span> The maximum size of any incoming request payload.
            If you're expecting large payloads, you should consider changing this to the appropriate value.
         </li>
         {# TODO: add helmet headers #}
      </ul>

      <h5 class="padding-top">Extended Thorin.Action</h5>
      <div class="function">
         <h6>actionObj.aliasOnly()</h6>
         <div class="desc">If called, the action will only be processed via an alias, and it will not be processed by the action's name.</div>
         <div class="desc">
            <pre><code class="javascript">'use strict';
thorin.dispatcher
   .addAction('my.action')
   .alias('GET', '/home')
   .aliasOnly();  // accessible only via GET /home, and not dispatch my.action
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>actionObj.enableCors(domain, opt)</h6>
         <div class="desc">Enables CORS on the current action when requested either via an alias or dispatch.</div>
         <ul class="arguments">
            <li>
               <b>domain</b><span class="type">string</span>if specified, the origin domain that the CORS request will work with
            </li>
            <li>
               <b>opt.credentials</b><span class="type">boolean</span> if set true, adds the <code>Access-Control-Allow-Credentials</code> header
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Transport functionality</h5>
      <div class="function">
         <h6>addMiddleware(fn)</h6>
         <div class="desc">
            Manually register an express middleware. Express middlewares are registered <i>after</i> CORS handlers and the static middleware.
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the express middleware function that will be called with <code>fn(req, res, next)</code>
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>disableAction(name)</h6>
         <div class="desc">
            Stops routing intents that come for the specified action, temporary disabling the action processing
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the action name
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>enableAction(name)</h6>
         <div class="desc">
            Re-enables routing to the given action.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the action name
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>_handleIntentJson(fn)</h6>
         <div class="desc">
            Override the default API intent response structure by registering a custom function to call when providing the
            JSON structure in an intent's response. This should only be used to provide backward compatibility in response structures.
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the callback function to use as
            </li>
         </ul>
         <div class="desc">
            The callback will be called with the default <code>fn(err, data)</code>. If err is set,
            the intent contained an error and you should generate your own error format. Otherwise, generate
            your result format from the data object.
         </div>
      </div>
      <div class="function">
         <h6>trustProxy() : boolean</h6>
         <div class="desc">Returns whether or not the http server trusts the X-Forwarded-For header</div>
      </div>
      <div class="function">
         <h6>app : ThorinExpressApp</h6>
         <div class="desc">Expose the internal thorin express app wrapper. This property should only be accessible by components
         that somehow require access to the internal app. Backward-compatibility is not guaranteed in this case.</div>
      </div>
   </div>
{% endblock %}