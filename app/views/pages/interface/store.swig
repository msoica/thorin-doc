{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Thorin.Interface.Store</h2>
      <p>
         You can write your own Thorin stores by implementing <code>thorin.Interface.Store</code> and calling <code>thorin.addStore()</code>
      </p>
      <p>
         Since Thorin stores are designed as an abstraction layer between your application and your databases, a set of minimal
         functionality is required to be implemented. The store interface also extends the native <code>EventEmitter</code> class,
         transforming your store into an event emitter by default.
      </p>
      <p>
         The configuration of a store should be placed under the <code>store</code> key of the application's root configuration object
         and under the store's <code>name</code> property. A small example is available below.
      </p>
      <pre><code class="javascript">'use strict';
// config/app.js file
module.exports = {
   "store.redisDb": {  // the "redisDb" key is the store's name property
      port: 12345
   }
};
</code></pre>
      <h5>Interface functionality</h5>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the type (or code) of your store, eg: sql, redis.
            </li>
            <li>
               <b>name</b><span class="type">string</span> the name of the store instance when constructed.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>constructor()</h6>
         <div class="desc">
            It is mandatory that you call the <code>super()</code> constructor from your class, so that it can initiate any
            other dependencies of the store class.
         </div>
      </div>
      <div class="function">
         <h6>static publicName() : string</h6>
         <div class="desc">Returns the publicly available name of your store, eg SQL Store or Data Store</div>
      </div>
      <div class="function">
         <h6>setName(name)</h6>
         <div class="desc">Manually set the name of a store's instance. By default, it will change the <code>name</code> property.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the name of the store instance
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>stop(done)</h6>
         <div class="desc">
         The function is called when the app is shutting down. By default, it does nothing. However, if your store must
         handle connection termination, you should override it.
         </div>
         <ul class="arguments">
            <li>
               <b>done</b><span class="type">function</span> the callback function to call once the store has stopped
            </li>
         </ul>
      </div>

      <h5>Example</h5>
      <pre><code class="javascript">'use strict';
class ThorinRedisStore extends thorin.Interface.Store {
   static publicName() { return 'Redis' }
   // Constructor
   constructor(){
      super(); // this will set the name of the store.
      this.type = "redis";
      this.connection = null;
   }
   
   // Called when the store's configuration is available.
   init(config) {
      this.config = config;
   }
   
   // Called when the application is booting.
   // We should connect to the redis store, handle reconnect, etc.
   run(done) {
      // do async stuff
      done();
   }
   
   // Terminate the connection, flush anything and callback.
   stop(done) {
      // disconnect from the server.
      done();
   }
}

thorin.addStore(ThorinRedisStore, 'redisDb');
</code></pre>
   </div>
{% endblock %}