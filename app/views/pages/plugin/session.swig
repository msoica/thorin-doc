{% extends "../layout.swig" %}
{% set title = "Thorin.js - session plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-session') }}
         plugin-session
      </h2>
      <p>
         The session plugin is used to enable session support in your application. It will use the specified store as
         the session storage mechanism and extend the default thorin action with additional functionality.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-session@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-session'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash">#update config/app.js with your configuration</code>
<code class="bash"># run to setup the store
node app.js --setup=plugin.session
</code></pre>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>store</b><span class="type">string</span>the default store to use for persisting session information, see bellow additional info.
         </li>
         <li>
            <b>cookiePrefix</b><span class="type">string</span>if specified, the cookie key will have this prefix (eg: sess-qejkwjkernjkwnrjk)
         </li>
         <li>
            <b>cookieName</b><span class="type">string, tps</span>the cookie name, used in <code>Set-Cookie</code> header.
         </li>
         <li>
            <b>secure</b><span class="type">boolean, false</span> set to true to enable secure https-only cookies.
         </li>
         <li>
            <b>encrypt</b><span class="type">boolean, true</span> setting this to true will encrypt the contents of the session. By default, the session JSON is stored in plaintext.
         </li>
         <li>
            <b>authorization</b><span class="type">boolean, true</span> should the plugin add itself as an authorization source? This will attach the plain session id to <code>intentObj.authorization</code> and set the <code>intentObj.authorizationSource</code> to <code>SESSION</code> , if found empty
         </li>
         <li>
            <b>secret</b><span class="type">string</span>the secret key used to sign the cookie id. This should differ from one app to another
         </li>
         <li>
            <b>expire</b><span class="type">number, 86400</span>the number of seconds until a session expires.
         </li>
         <li>
            <b>namespace</b><span class="type">string, session</span>the name of the namespace that will be used by the store, to save sessions.
         </li>
      </ul>
      <p style="margin-bottom: 4px;"><i>Store configuration</i></p>
      <ul class="arguments">
         <li>
            <b>store = file</b> saves all the sessions using the file system, under the configured <strong>opt.path</strong> directory (defaults thorin.root + /sessions). This should be used
            in development mode.
         </li>
         <li>
            <b>store = redis</b> saves all the sessions inside the specified redis store. This can also be the name of the store instance (eg, redis-session). All sessions
            will be stored using the configured <code>namespace</code> with the help of <code>GET, SETEX, DEL</CODE>,
         </li>
         <li>
            <b>store = sql</b> saves all the sessions to the SQL database, using the <code>opt.namespace</code> as the sessions table name.
         </li>
      </ul>
      <p>
         The stores will never store the actual session id set in the <code>Set-Cookie</code> header, but rather use the <code>sha2</code> hash
         mechanism to hash them. When we check if a session exists, we hash the id and check if the hash exists. This mechanism makes it hard for
         any malicious user to use the session storage to impersonate users by using their session ids, since these ids are never in plain text.
      </p>
      <p>
         Using the plugin with <code>encrypt=true</code> takes the security concerns to the next level. Before we store the session content (the JSON)
         to the specified store (file, sql, redis), we <code>encrypt</code> its content with the plaintext <code>session id</code>. This way, only users
         that posses the session id have access to the session's content.<br /> A small proof of concept can be viewed bellow
      </p>
      <pre><code class="javascript">'use strict';
let sessionId = thorin.util.randomString(32);   // let this be the generated session id.
let sessionData = {
   "someSession": "data right",     // let this be the session content
   "here": true
}
let storedSessionHash = thorin.util.sha2(sessionId),
   storedSessionData = thorin.util.encrypt(JSON.stringify(sessionData), sessionId);
save(storedSessionHash, storedSessionData) // Store the hashed & encrypted session information.
</code></pre>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.store</h6>
         <div class="desc">
            Expose the underlying <code>SessionStore</code> wrapper, see below for more info.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.generateId() : String</h6>
         <span class="desc">
            Generates a new cryptographically safe random session ID, using the cookiePrefix specified.
         </span>
      </div>
      <div class="function">
         <h6>pluginObj.signId(sid) : String</h6>
         <div class="desc">
            Signs the given plain session id using the specified secret. If no secret is found, returns the sid.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.verifySignature(sid) : Boolean</h6>
         <div class="desc">
            Verifies that the incoming session id was previously signed by the app and is a valid one. If no secret was
            defined, returns true.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.saveSession(sessionObj, fn)</h6>
         <div class="desc">
            Saves the given session ID with the attached data.<br />
            Note: when we store session ids, we do not store the actual sess ID as a key,
            we hash it like a password, so that session stealing is less likely if someone
            gains access to the session store.
         </div>
         <ul class="arguments">
            <li>
               <b>sessionObj</b><span class="type">instance of SessionData</span> the session object to persist.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the callback function to call once saved.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.destroySession(sid, fn)</h6>
         <div class="desc">
            Destroys the given session id, deleting it from the session store.
         </div>
         <ul class="arguments">
            <li>
               <b>sid</b><span class='type'>string</span>the plaintext session id coming from the user.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the callback function to call once deleted.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.readSession(sid, done, shouldUseSessionData)</h6>
         <div class="desc">
            Tries to read the information of a session from the data store. If
            <code>shouldUseSessionData</code> is set  to true, wrap the result data in a SessionData object.
         </div>
         <ul class="arguments">
            <li>
               <b>sid</b><span class='type'>string</span>the plaintext session id coming from the user.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the callback function to call once read.
            </li>
            <li>
               <b>shouldUseSessionData</b><span class="type">boolean, true</span>if set to false, callback with the raw session json object.
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Extended thorin.Intent</h5>
      <div class="function">
         <h6>intentObj.session</h6>
         <div class="desc">
            Contains the request's <code>SessionData</code> instance. It will contain all session data we want to persist.
         </div>
         <pre><code class="javascript">'use strict';
thorin.dispatcher
   .addAction('my.action')
   .use((intentObj, next) => {
      if(!intentObj.session.value) {
         log.info('New session was just created');
         intentObj.session.value = "Hello world";
      }
      next();
   });

thorin.dispatcher
   .addAction('account.logout')
   .use((intentObj, next) => {
      intentObj.session.destroy();
      next();
   });
</code></pre>
      </div>
      <div class="function">
         <h6>intentObj.skipSave()</h6>
         <div class="desc">
            This will not update the session store with the session changes.
         </div>
      </div>

      <h5 class="padding-top">The <code>SessionData</code> class</h5>
      <div class="function">
         <h6>session.id</h6>
         <div class="desc">
            The current session id in plaintext.
         </div>
      </div>
      <div class="function">
         <h6>session.isNew() : boolean</h6>
         <div class="desc">
            Verifies if the session was previously stored or has just been created.
         </div>
      </div>
      <div class="function">
         <h6>session.isDestroyed() : boolean</h6>
         <div class="desc">
            Verifies if the session is marked to be destroyed.
         </div>
      </div>
      <div class="function">
         <h6>session.createdAt() : Date</h6>
         <div class="desc">
            Returns the date the session was first created.
         </div>
      </div>
      <div class="function">
         <h6>session.clear()</h6>
         <div class="desc">
            Removes all the data that was placed in the session but still persists
            the session id.
         </div>
      </div>
      <div class="function">
         <h6>session.getData() : object</h6>
         <div class="desc">
            Internal function that returns the JSON object representation of the session. This is the object that will
            be persisted by the session store
         </div>
      </div>
      <div class="function">
         <h6>session.shouldSave() : boolean</h6>
         <div class="desc">
            Internal function that checks if the session suffered any change and if we should store it.
         </div>
      </div>
      <h5>The <code>SessionStore</code> class</h5>
      <p>
         We currently offer a wrapper for <code>file, redis, sql</code>. If you want your own session store, make sure it implements the following functionality.
      </p>
      <div class="function">
         <h6>store.read(id, fn)</h6>
         <div class="desc">
            Reads a session from the database, calling back with an error or the result object
         </div>
      </div>
      <div class="function">
         <h6>store.save(id, data, fn)</h6>
         <div class="desc">
            Persists the given data to the store, under the given id
         </div>
      </div>
      <div class="function">
         <h6>store.destroy(id, fn)</h6>
         <div class="desc">
            Deletes the associated session information given the session id.
         </div>
      </div>

   </div>
{% endblock %}