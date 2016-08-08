{% extends "../layout.swig" %}
{% set title = "Thorin.js - Transport interface" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">thorin.Interface.Transport</h2>
      <p>
         You can write your own transport layer by implementing <code>thorin.Interface.Transport</code> and calling <code>thorin.addTransport()</code>
      </p>
      <p>
         Since Thorin transports are designed to abstract away incoming connections and connection handling,
         they must provide a common interface to make switching from one transport to another seamless and maintain your
         application transport agnostic. The transport interface also extends the native <code>EventEmitter</code> class,
         transforming your transport into an event emitter by default.
      </p>
      <p>
         The configuration of a transport should be placed under the <code>transport</code> key of the application's root configuration object
         and under the transport's <code>name</code> property. A small example is available below.
      </p>
      <pre><code class="javascript">'use strict';
// config/app.js file
module.exports = {
   "transport.http": {  // the "http" key is the transport's name property
      port: 12345
   }
};
</code></pre>
      <h5>Interface functionality</h5>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">enum</span> the type of a transport, see below
            </li>
            <li>
               <b>name</b><span class="type">string</span> the name of the transport when constructed.
            </li>
         </ul>
         <div class="notes">
            A transport can have the following types:
            <ul>
               <li>
                  <code>Transport.TYPE.BI_DIRECTIONAL</code> [1], the transport can process both <i>incoming</i> and <i>outgoing</i> traffic (eg. websocket)
               </li>
               <li>
                  <code>Transport.TYPE.RECEIVER</code> [2], the transport will only process <i>inbound</i> traffic, acting as a <i>receiver</i> (eg. http)
               </li>
               <li>
                  <code>Transport.TYPE.SENDER</code> [3], the transport will only process <i>outbound</i> traffic, acting as a <i>sender</i> (eg. push notifications)
               </li>
            </ul>
         </div>
      </div>
      <div class="function">
         <h6>constructor()</h6>
         <div class="desc">
            It is mandatory that you call the <code>super()</code> constructor from your class, so that it can initiate any
            other dependencies of the transport class.
         </div>
      </div>
      <div class="function">
         <h6>static publicName() : string</h6>
         <div class="desc">Returns the publicly available name of your transport, eg. Web Server</div>
      </div>
      <div class="function">
         <h6>setName(name)</h6>
         <div class="desc">Manually set the name of a transport's instance. By default, it will change the <code>name</code> property.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the name of the transport instance
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>sendIntent(intentObj) : Promise</h6>
         <div class="desc">
            The function should be used by bi-directional or sender transports, that implement
            their custom logic for sending intents <i>from</i> the server <i>to</i> the client.
            The configuration of an intent and its settings is specific for each transport that implements it.
            The function should return a promise.
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b> <span class="type">instance of thorin.Intent</span> the intent that encapsulates data that will be sent.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>routeAction(actionObj)</h6>
         <div class="desc">
            The function is called whenever an action is registered in the application's dispatcher. A receiver or bi-directional
            transport therefore must implement its custom functionality to handle the internal action routing.
            Transports that do not process actions can simply override the function and return undefined
         </div>
         <ul class="arguments">
            <li>
               <b>actionObj</b><span class="type">instance of thorin.Action</span> the action object that contains the call stack definition of an action processing.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>disableAction(name)</h6>
         <div class="desc">
            The function is called when an action is disabled programatically from within the application and should
            temporarily stop the handling of any incoming event that matches the given action. This should be implemented by
            <i>receiver</i> and <i>bi-directional</i> transports.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span calss="type">string</span> the action name that should be disabled.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>enableAction(name)</h6>
         <div class="desc">
            The function is called when an action was previously disabled programatically from within the application and should
            be enabled again. This should be implemented by <i>receiver</i> and <i>bi-directional</i> transports.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the action name that should be enabled.
            </li>
         </ul>
      </div>
      <h5>Example</h5>
      <pre><code class="javascript">'use strict';
class ThorinTransportHttp extends thorin.Interface.Transport {
   // Our constructor function
   constructor() {
      super();
      this.name = 'http';
      this.server = null;
   }
   publicName() { return "Web server"; }
   
   // Called when transport configuration is available
   init(config) {
      this.config = config;
   }
   
   // This is where we should bind our server and listen to a port
   run(done) {
      // initiate server and bind it.
      done();
   }
   
   // Register an action with the server's handlers
   routeAction(actionObj) {
      // server specific functionality for routing.
   }
   
   // Toggle an action processing
   disableAction(actionName) {
      // remove or disable the action from the server's handlers
   }
   enableAction(actionName) {
      // enable the processing of the given action
   }
}
thorin.addTransport(ThorinTransportHttp, 'http');
</code></pre>
   </div>
{% endblock %}