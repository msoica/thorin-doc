{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-store-redis') }}
         thorin-store-redis
      </h2>
      <p>
         The Redis store is a wrapper over <a href="https://npmjs.com/package/redis" target="_blank">redis</a> that provides
         connection state management and automatic creation of publisher/subscriber connections. All commands can run in both
         callback and promise mode.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-store-redis@1.x</code>
<code class="javascript">'use strict';
   // app.js entry file
   const thorin = require('thorin');

   thorin.addStore(require('thorin-store-redis'));   // <- add this line
   thorin.run((err) => {});
</code>
<code class="bash"># run to setup the database and module
   node app.js --setup=store.redis
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>debug</b><span class="type">false</span>if set to true, log all redis operations
         </li>
         <li>
            <b>host</b><span class="type">localhost</span>the redis server host
         </li>
         <li>
            <b>port</b><span class="type">6379</span>the redis server port
         </li>
         <li>
            <b>password</b><span class="type">null</span>the redis auth password (if any)
         </li>
         <li>
            <b>options</b><span class="type">{}</span>additional redis-specific options.
         </li>
         <li>
            <b>namespace</b><span class="type">rns:</span>The default project namespace to prepend for <code>key()</code> calls.
         </li>
      </ul>
      <div class="desc">
         For a complete set of connection options, please visit the <a href="https://github.com/NodeRedis/node_redis" target="_blank">redis repository</a>
      </div>
      <h5 class="padding-top">Store functionality</h5>
      <div class="function">
         <h6>storeObj.publish(channel, data) : Promise</h6>
         <div class="desc">
            Performs a publish to the given channel, of the given data. Internally, it will try to use the <code>publish</code> named redis connection.
            If no such connection exist, create a new one and use it in <i>publish mode</i>
         </div>
         <ul class="arguments">
            <li>
               <b>channel</b><span class="type">string</span> the channel to publish to
            </li>
            <li>
               <b>data</b><span class="type">any</span>the data to publish. If an object, will be stringified.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.subscribe(channel, callback) : Promise</h6>
         <div class="desc">
            Subscribes to the given channel, calling the callback function when a new event was published. Internally, it will try to use the <code>subscribe</code> named redis connection.
            If no such connection exists, create a new one and use it in <i>subscribe mode</i>.
         </div>
         <ul class="arguments">
            <li>
               <b>channel</b><span class="type">string</span> the channel name to subscribe to
            </li>
            <li>
               <b>callback</b><span class="type">function</span>the function to call when an event was published.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.unsubscribe(channel, callback) : Promise</h6>
         <div class="desc">
            Unsubscribes from the given channel. If no callback is given, it will unsubscribe from all previously-subscribed channels.
         </div>
         <ul class="arguments">
            <li>
               <b>channel</b><span class="type">string</span> the channel name to unsubscribe from.
            </li>
            <li>
               <b>callback</b><span class="type">function</span>the function that was used in the <code>subscribe()</code> call.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.exec(commands, fn) : Promise?</h6>
         <div class="desc">
            Executes any redis specific commands, returning a promise. If the last argument is a function,
            it will act as the callback and promises will not be used.
         </div>
         <div class="notes">
            For a complete set of redis commands, visit <a href="http://redis.io/commands" target="_blank">the official docs.</a>
            <pre><code class="javascript">'use strict';
const storeObj = thorin.store('redis');
storeObj.exec('GET', 'myKey').then((val) => log.info(val));
storeObj.exec('SETEX', 'myKey', 30, 'myValue', (err, res) => log.info(err, res));
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>storeObj.multi() : multiObj</h6>
         <div class="desc">Prepares for a <code>MULTI</code> command, returning an object that
         has <code>exec()</code> functions for command queueing and <code>commit()</code> to send out
         all the queued commands.
         </div>
         <div class="notes">
            <pre><code class="javascript">'use strict';
const storeObj = thorin.store('redis');
storeObj.multi()
   .exec('GET', 'myKey')
   .exec('SETEX', 'myKey', 'newVal')
   .commit()
   .then((results) => {});
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>storeObj.getConnection(name, opt) : Promise</h6>
         <div class="desc">
            Creates a new named connection or returns a previously created one.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the name of the new connection.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options that will merge with the store's default configuration
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>storeObj.createConnection(name, opt, fn)</h6>
         <div class="desc">
            Creates a new named connection to the redis server.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the name of the new connection.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options that will merge with the store's default configuration
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the callback function to call when the connection is ready.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.isConnected(name) : boolean</h6>
         <div class="desc">
            Verifies if the default or named redis connection is connected or not.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the name of the new connection.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.key(name) : string</h6>
         <div class="desc">
            Utility function that will use the configured namespace to generate a new key name.
         </div>
      </div>

      <h5 class="padding-top">Connection specific events</h5>
      <ul class="arguments">
         <li><b>disconnect</b> - the connection got disconnected</li>
         <li><b>reconnect</b> - the connection got reconnected</li>
         <li><b>connect</b> - fired once, when the connection was established</li>
         <li><b>close</b> - fired when the connection was closed.</li>
         <li><b>subscribe.message (channel, msg)</b> fired when a message was caught by a subscribed handler</li>
         <li><b>subscribe.channel (channel, msg)</b> fired when a handler was subscribed to a channel</li>
         <li><b>unsubscribe (channel)</b> - fired when a handler was unsubscribed from a channel</li>
         <li><b>publish (channel, msg)</b> - fired when a message was published to a channel by the current app</li>
         <li><b>command (args)</b> - fired when a command was executed</li>
         <li><b>multi (args)</b> - fired when a multi command was executed</li>
      </ul>

      <pre><code class="javascript">'use strict';
const storeObj = thorin.store('redis');

storeObj.subscribe('my.channel', (message) => {
   log.info('Got a message', message);
}).then(() => {
   // subscription was created
   return storeObj.publish('my.channel', 'Hello world');
}).then(() => {
   // message got published.
   return storeObj.exec('SET', 'published:1', true);
});
</code></pre>
   </div>
{% endblock %}