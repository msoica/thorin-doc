{% extends "../layout.swig" %}
{% set title = "Thorin.js - ws transport" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-transport-ws') }}
         transport-ws
      </h2>
      <p>
         WebSocket Transport layer that (currently) works with the HTTP transport to handle websocket connections. Internally,
         it uses <i>socket.io@1.4.x</i> to handle web sockets. The transport is under active development and changes might occur over time.
      </p>
      <p>
         The transport was specialized to work with <a href="http://socket.io/docs/rooms-and-namespaces/" target="_blank">rooms and namespaces</a> in stead
         of individual sockets. However, this might change over time and additional functionality will be added to address individual socket event sending.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-transport-ws@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addTransport(require('thorin-transport-ws'));  // <-- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run once to allow the transport to set itself up
node app.js --setup=transport.ws</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>debug</b><span class="type">true</span> Enables or disables event logging
         </li>
         <li>
            <b>adapter.store</b><span class="type">null</span>A redis store name to use as an adapter. The default adapter is the in-memory one.
         </li>
         <li>
            <b>adapter.channel</b><span class="type">thorin:ws</span>The redis channel to use for publishing and subscribing
         </li>
         <li>
            <b>authorization</b><span class="type">null</span> If specified, override the default authorization source of the http transport
         </li>
         <li>
            <b>transport</b><span class="type">http</span>Since this transport uses the http transport as the base one, this contains the name of the http transport inside your app
         </li>
         <li>
            <b>actionName</b><span class="type">dispatch</span>The name of the event to listen for when clients send events.
         </li>
         <li>
            <b>options</b><span class="type">{}</span>Additional options to send to socket.io
         </li>
      </ul>
      <p>
         A web-based client example can be found <a href="https://github.com/Thorinjs/Thorin-fetch-ws" target="_blank">here</a>.
         A list of default events a client can <i>send</i>:
      </p>
      <ul>
         <li>
            <code>action</code> sent when the socket wants to trigger an action
         </li>
         <li>
            <code>room.join</code> sent when the socket wants to join a room
         </li>
         <li>
            <code>room.leave</code> sent when the socket wants to leave a room he is in.
         </li>
         <li>
            <code>room.clear</code> sent when the socket wants to leave all the rooms he is in.
         </li>
      </ul>
      <p>
         A list of server actions that can (and should) be treated on the server side:
      </p>
      <ul>
         <li>
            <code>ws#socket.connect</code> triggered when a new socket connects to the server. This is where authorization logic should be placed
         </li>
         <li>
            <code>ws#room.join</code> triggered when a socket wants to join a room
         </li>
         <li>
            <code>ws#room.leave</code> triggered when a socket wants to leave a room he is in
         </li>
         <li>
            <code>ws#room.clear</code> triggered when a socket wants to leave all the rooms he is in
         </li>
         <li>
            <code>ws#socket.disconnect</code> triggered when an authorized client disconnects.
         </li>
      </ul>

      <h5 class="padding-top">Extended Thorin.Action</h5>
      <div class="function">
         <h6>roomName(pattern)</h6>
         <div class="desc">Matches the <code>ws#room</code> event to a room name pattern </div>
         <ul class="arguments">
            <li>
               <b>pattern</b><span class="type">string | regex</span> the pattern to use when matching the room events
            </li>
         </ul>
         <div class="desc">
            <pre><code class="javascript">'use strict';
thorin.dispatcher
   .addAction('ws#room.join')
   .roomName('/myroom/:room_id')
   .input({
      room_id: dispatcher.validate('NUMBER')
   })
   .use((intentObj, next) => {
      // Check if user can join room. If not, return next(thorin.error());
      log.info(`User joined room ${intentObj.input('room_id')}`);
      next();
   })</code></pre>
         </div>
      </div>

      <h5 class="padding-top">Extended Thorin.Intent</h5>
      <div class="function">
         <h6>intentObj.socket : WebSocket</h6>
         <div class="desc">
            The <code>socket</code> property is added to an intent, containing the raw client websocket object.
         </div>
      </div>
      <div class="function">
         <h6>intentObj.socketConnectionTime()</h6>
         <div class="desc">Returns the number of milliseconds that have passed since the socket connected to the server (uptime tick)</div>
      </div>
      <div class="function">
         <h6>intentObj.socketData(key, val)</h6>
         <div class="desc">
            Get or ser data to the intent's web socket object. The value is <b>not</b> persisted after disconnects, it is only available
            during the lifetime of a socket connection to the server. It is usually called the first time an authorization function
            authorizes a new connection.
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string | object</span> the key that we want to get from the socket data, or the {key or object} we want to use when setting socket data.
            </li>
            <li>
               <b>val</b><span class="type">any</span>when key is a string, the function will act as a setter and use this argument as its value.
            </li>
         </ul>
         <div class="desc">
            The function can only be called on intents that are handled by the <b>ws</b> transport, and not from any other transports.
         </div>
      </div>

      <h5 class="padding-top">Exported class ws.Event</h5>
      <p>
         When the server is sending events, it uses an instance of the <code>Event</code> class that it exposes.
         The instance is supposed to contain the payload, target action and rooms that will be sent to. Websocket events
         also work with target actions and events.
      </p>
      <div class="function">
         <h6>constructor(action, payload)</h6>
         <div class="desc">Construct an event object passing the action and payload directly</div>
         <ul class="arguments">
            <li>
               <b>action</b><span class="type">string</span> the action name that we want to send.
            </li>
            <li>
               <b>payload</b><span class="type">object</span> the payload that we want to send.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>eventObj.addRoom(name)</h6>
         <div class="desc">Adds a new target room by its name.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the target room name
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>eventObj.payload(obj)</h6>
         <div class="desc">Manually set the event's payload and override any previous data.</div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object</span> the payload that we wish to send.
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
const wsObj = thorin.transport('ws');
const myEvent = new wsObj.Event('target.action.name', {
   "with": "some",
   "payload": {
      "right": "here"
   }
});
myEvent
   .addRoom('room_1')   // send the action to room 1 and 2
   .addRoom('room_2');
wsObj.send(myEvent);
</code></pre>

      <h5 class="padding-top">Transport functionality</h5>
      <div class="function">
         <h6>sendIntent(intentObj, fn)</h6>
         <div class="desc">
            Converts the intentObj into a ws.Event class and use it to send out events to clients. This functionality is under development
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> the intent used to extract the data and target client.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>optional callback function called once the ack is received from the client.
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
         <h6>app : ThorinSocketIoApp</h6>
         <div class="desc">Expose the internal thorin socket.io app wrapper. This property should only be accessible by components
            that somehow require access to the internal app. Backward-compatibility is not guaranteed in this case.</div>
      </div>

      <h5 class="padding-top">Short example</h5>
      <pre><code class="javascript">'use strict';
// File: config/app.js
module.exports = {
   "transport.http": {  // use http as base transport
      "port": 3500
   },
   "transport.ws": {    // use websockets attached to the http one
      "authorization": {
         "cookie": "logapi"   // use the Set-Cookie: logapi as authorization source
      },
      "adapter": {   // use the redis instance to work as an adapter.
         "store": "redis",
         "name": "store:ws"
      }
   },
   "plugin.session": {  // use the session plugin
      "cookieName": "logapi",
      "store": "redis"
   },
   "store.redis": {  // additional redis connection configuration
   }
};
</code>
<code class="javascript">'use strict';
// File: app.js
const thorin = require('thorin');

thorin
   .addTransport(require('thorin-transport-http'))
   .addTransport(require('thorin-transport-ws'))
   .addStore(require('thorin-store-redis'))
   .addPlugin(require('thorin-plugin-session'));

thorin.run((err) => {
   log.info('Running');
});
</code>
<code class="javascript">'use strict';
// File: app/actions/stream.js
const dispatcher = thorin.dispatcher;
// Listen to socket connect events
dispatcher
   .addAction('ws#socket.connect')
   .use((intentObj, next) => {
      if (intentObj.session.isNew() || !intentObj.session.account) {
         return next(thorin.error('AUTH.REQUIRED', 'Session expired', 403))
      }
      intentObj.socketData('account', intentObj.session.account);
      log.info('Socket connected');
      next();
   });
// Listen to socket disconnect events
dispatcher
   .addAction('ws#socket.disconnect')
   .use((intentObj, next) => {
      log.info(`User ${intentObj.socketData('account')} disconnected.`);
   });

// Listen if somebody wants to join a room
dispatcher
   .addAction('ws#room.join')
   .use((intentObj, next) => {
      const socketObj = intentObj.socket,
         roomName = intentObj.room;
      log.info(`Socket ${socketObj.id} wants to join room ${roomName}`);
      intentObj.result({
         welcome: 'to the new room!'
      });
      next();
   });

</code></pre>
   <p>A more in-detail example can be found <a href="https://github.com/Thorinjs/Thorin-transport-ws/blob/master/example.js" target="blank">here</a>

   </div>
{% endblock %}