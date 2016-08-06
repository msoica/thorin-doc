{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-discovery') }}
         plugin-discovery
      </h2>
      <p>
         The cluster discovery module enables you to write your applications in a microservice-oriented way. It provides
         service discovery and communication. It was specially designed to work with thorin apps. This plugin acts as
         the <b>client</b> that communicates with a <b>discovery registry</b>. <a href="https://sconfig.io" target="_blank">sconfig.io</a> offers
         deep integration with their self-hosted discovery service, at <a href="https://discovery.sconfig.io" target="_blank">discovery.sconfig.io</a>.
      </p>
      <p>
         You can also choose to host your own discovery gateway, by setting up your own registry from <a href="https://github.com/unloqer-io/sconfig-discovery" target="_blank">the git repo</a>
         and direct your clients to work with it.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">#install the plugin
npm i --save thorin-plugin-discovery@1.x</code>
<code class="javascript">'use strict';
//app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-discovery')); // <-- add this line
thorin.run((err) => {});
</code></pre>
      <h5 class="padding-top">Getting started with the <a href="https://sconfig.io" target="_blank">sconfig.io</a> discovery registry</h5>
      <ul class="numbered">
         <li>
            Download the UNLOQ app from the <a href="https://itunes.apple.com/us/app/unloq/id993213198?ls=1&mt=8" target="_blank">App Store</a> or from <a href="https://play.google.com/store/apps/details?id=io.unloq.android" target="_blank">Google Play</a>
            and create an account
         </li>
         <li>
            Login with <a href="https://account.unloq.io" target="_blank">UNLOQ</a> at <a href="https://sconfig.io" target="_blank">sconfig.io</a>
         </li>
         <li>
            Create an application with an environment and a minimal description and make sure to toggle <b>Use sconfig discovery</b>. A default API key will be generated for you and the Discovery key
            will appear in your application's details page.
         </li>
         <li>
            Use the <b>discovery key</b> provided by sconfig io to place under your plugin's <b>token</b> configuration
         </li>
      </ul>
      <div class="notes">
         If your application already uses sconfig.io for config management and have checked the <b>use sconfig discovery</b> field, the
         plugin will automatically request the registry's token from sconfig, so you do not need to manually place it in your configuration.
      </div>
      <h5 class="padding-top">Getting started with your self-hosted registry</h5>
      <p>
         The discovery registry is an open source node.js application that handles your cluster's discovery and feeds information
         about the microservices it works with. You can setup your own self-hosted registry by <a href="https://github.com/unloqer-io/sconfig-discovery" target="_blank">visiting the official repo</a>. All you
         need is <b>redis</b> and <b>node.js > 4.x</b>. We suggest using nginx as the reverse proxy and TLS termination handler.
      </p>
      <p>
         Once you've setup your registry, just override the default <b>gateway</b> configuration to your registry's <b>/dispatch</b> full URL. and
         you're done!
      </p>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>gateway</b><span class="type">https://discovery.sconfig.io/dispatch</span> the registry full dispatch URL to work with.
         </li>
         <li>
            <b>dispatchPath</b><span class="type">/dispatch</span>the dispatch path configured in your microservices. This should be the same for all your microservices
         </li>
         <li>
            <b>token</b><span class="type">process.env.DISCOVERY_TOKEN</span>your registry's discovery token used to authorize requests
         </li>
         <li>
            <b>interval</b><span class="type">18000</span>the number of milliseconds between registry announces. This is automatically calculated based on your specified TTL
         </li>
         <li>
            <b>cache</b><span class="type">true</span>cache the cluster information locally using <code>thorin.persist</code>, so that in the event of a failure in the registry, you still have the latest representation of your cluster to work with.
         </li>
         <li>
            <b>retry</b><span class="type">1</span>the number of retries before marking a microservice as unavailable, when you dispatch an action to a microservice
         </li>
         <li>
            <b>timeout</b><span class="type">3000</span>the default microservice response timeout
         </li>
         <li>
            <b>service</b><span class="type">microservice config, see below</span> the information about your microservice node. This is where you define how other nodes can contact this one.
         </li>
      </ul>
      <p style="margin-bottom: 4px;"><i>Microservice configuration</i></p>
      <ul class="arguments">
         <li>
            <b>service.type</b><span class="type">thorin.app</span>the type of the application (mailer, notifier, api, etc), defaults to the thorin application name
         </li>
         <li>
            <b>service.name</b><span class="type">thorin.id</span>the unique identifier of the application, used in logging and such, defaults to the thorin application id
         </li>
         <li>
            <b>service.proto</b><span class="type">http</span>the default protocol to use for inter-communication
         </li>
         <li>
            <b>service.ttl</b><span class="type">60</span>the time-to-live in seconds used by the registry. If no announces were made by this node to the registry in the configured seconds, the registry will automatically
            remove the node from the cluster when other microservices announce their presence.
         </li>
         <li>
            <b>service.tags</b><span class="type">[]</span>additional tags that you can attach to your microservice information
         </li>
         <li>
            <b>service.host</b><span class="type">internal</span>specifies the publicly available hostname used by other microservices to connect to this microservice. The values it can take are listed bellow.
         </li>
         <li>
            <b>service.port</b><span class="type">{transport.http.port}</span>specifies the HTTP port the microservice binded to. If a http transport is registered, it will default to the configured transport port.
         </li>
         <li>
            <b>service.path</b><span class="type">{transport.http.actionPath}</span>specifies the <i>dispatch</i> path that your microservice uses to handle actions. If a http transport is present, we will use its configured actionPath
         </li>
      </ul>
      <p style="margin-bottom: 8px;">The <b>service.host</b> possible values</p>
      <ul>
         <li>
            <code>internal</code> - use the  first private IPv4 from <code>10.0.0.0/8</code>, <code>172.16.0.0/12</code>, <code>192.168.0.0/16</code>, useful when the microservices are in
            a private network that use the same private block.
         </li>
         <li>
            <code>public</code> - use the first publicly accessible IPv4 address offered by all the network interfaces.
         </li>
         <li>
            <code>{CIDR Block}</code> - if you specify a CIDR block, we will use the first IP address that matches the given block. This is useful when your machine has more than one IP address and you want to use one from a specific block.
         </li>
         <li>
            <code>{static IP address}</code> - if you specify a static IP address, we will use it.
         </li>
         <li>
            <code>{static domain}</code> - if you specify a domain name, we will use it.
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.getRegistry() : Object</h6>
         <div class="desc">
            Returns the current state of the registry, containing all available microservices.
         </div>
         <pre>
<code class="javascript">'use strict';
thorin.plugin('discovery').getRegistry(); // returns
/* 
{ api: 
   [ { name: 'api-xxxxx',
       host: '1.2.3.4',
       proto: 'http',
       port: 14000,
       path: '/dispatch',
       tags: [],
       ttl: 60,
       sid: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
       healthy: true } 
   ],
  mailer: 
   [ { name: 'mailer-xxxxx',
       host: '2.3.4.5',
       proto: 'http',
       port: 14001,
       path: '/dispatch',
       tags: [],
       ttl: 60,
       sid: 'yyyyyyyyyyyyyyyyyyyyy',
       healthy: true } ]
}
*/
</code></pre>
      </div>
      <div class="function">
         <h6>pluginObj.elect(serviceName) : Object</h6>
         <div class="desc">
            Manually elect a service node that can be used to dispatch an action.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.refresh() : Promise</h6>
         <div class="desc">
            Manually refresh the registry by announcing our presence and updating the local registry information
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getServiceKey() : string</h6>
         <div class="desc">
            Returns the registry service authorization key assigned by the registry server. This can be used as an additional 
            authorization token between microservice communication.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.dispatch(serviceName, action, payload, opt) : Promise</h6>
         <div class="desc">
            Performs an HTTP request to the given service, using the action and payload specified. The registry should ultimately have multiple 
            <code>serviceName</code> nodes and the plugin will <code>elect()</code> one. This functionality will essentially enable cross-service
            communication.<br />
            This is where the configured <code>retries</code> is useful. If setting retry to a higher number, in the event of a microservice being
            offline, the plugin will elect a new one and try to dispatch the action to it.
         </div>
         <ul class="arguments">
            <li>
               <b>serviceName</b><span class="type">string</span> the service name we want to dispatch an action to
            </li>
            <li>
               <b>action</b><span class="type">string</span>the action name we want to dispatch 
            </li>
            <li>
               <b>payload</b><span class="type">object</span> if specified, the action payload we want to send (essentially the BODY data).
            </li>
            <li>
               <b>opt</b><span class="type">object</span> if specified, additional options to use while using <code>thorin.util.fetch</code>.
            </li>
         </ul>
      </div>
      <h5 class="padding-top">Extended Thorin.Action</h5>
      <p>
         The discovery plugin will extend the <code>thorin.Action</code> class, adding additonal functionality such as request proxying.
         The request proxying is actually adding a custom middleware in the <code>use</code> chain, that will use the intent <code>input()</code> as the
         <code>payload</code> to dispatch an action to another microservice. 
      </p>
      <div class="function">
         <h6>actionObj.proxy(serviceName, opt)</h6>
         <div class="desc">
            Allows the action handlers of one service to proxy the incoming input to another service using the discovery system.
            The service`s result is then placed under the intent`s <code>result</code>.
         </div>
         <ul class="arguments">
            <li>
               <b>serviceName</b><span class="type">string</span> the name of the service we want to call, see pattern below
            </li>
            <li>
               <b>opt.action</b><span class="type">string</span> the action we want to dispatch to the service, defaults to the current action name.
            </li>
            <li>
               <b>opt.payload</b><span class="type">object</b> the base payload that we will be override by the intent input.
            </li>
            <li>
               <b>opt.rawInput</b><span class="type">false</b> if set to true, we will use the intent`s <code>rawInput</code> object and not the filtered input.
            </li>
         </ul>
         <div class="note">
            <b>Note</b>: the name of the <code>serviceName</code> <b>must</b> have the prefix <code>discovery#</code> so that the plugin knows that we 
            are going to proxy to a discovery service, and not an internal proxy. The pattern is <code>discovery#{serviceName}</code>
         </div>
         <pre><code class="javascript">'use strict';
// The sender app
thorin.dispatcher
   .addAction('myAction')
   .use((intentObj, next) => {
      intentObj.input('someValue', 1);    // override the intent`s input.
      next();
   })
   .before('proxy', (intentObj, serviceData) => {
      console.log('Will proxy action to ${serviceData.ip}');
   })
   .proxy('discovery#myOtherService', {
      action: 'some.other.custom.action'  // override the default "myAction"
   })
   .after('proxy', (intentObj, response) => {
      console.log(`Proxy successful. Response:`, response);
   })
   .use((intentObj) => {
      console.log("myOtherService responded with: ", intentObj.result());
      // here is where we can mutate the result of the intent to send back to the client.
      intentObj.result("wasCalled", true);
      intentObj.send();
   });
</code>
<code class="javascript">'use strict';
// The receiver app
thorin.dispatcher
   .addAction('some.other.custom.action')
   .authorize('discovery#proxy') // verifies the incoming authorization token to be from an application within the cluster
   .use((intentObj, next) => {
      log.info(`Got called the microservice: ${intentObj.data('proxy_name')} with: ${intentObj.rawResult}`);
      intentObj.result({
         serviceResult: 'right here'
      }).send();
   });
</code>
</pre>
      </div>
      
      <h5>Security concerns</h5>
      <p>
         Whenever a service will call another service, it will also generate an <code>Authorization</code> HTTP header that uses
         a signed token to identify the service that is initiating the request. The signature is then verified by the service that is expecting
         the action by using the <code>discovery#proxy</code> authorization middleware.
      </p>
      <p>
         The <code>discovery#proxy</code> authorization middleware will place under the intent`s data object the <code>proxy_name</code>, which is
         the name of the service that is calling, and the <code>proxy_type</code> key, which specifies the service`s type.
      </p>
      <p>
         A short example can be found in the <a href="https://github.com/thorinjs/examples/todo-mailer" target="blank">todo-mailer</a>
         and <a href="https://github.com/thorinjs/examples/todo-app" target="_blank">todo-app</a> example applications.
      </p>
   </div>
{% endblock %}