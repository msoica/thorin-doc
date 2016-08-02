{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The thorin authorization</h2>
      <p>
         An authorization middleware's sole purpose is to authorize incoming requests into your application by either verifying
         session data, header data or tokens sent through the input of an application.
      </p>
      <p>
         Authorization middleware functions should be placed among the first middlewares of your action, since it verifies
         the source of a request and can stop any unauthorized requests from further processing. Once it validates the
         authorization source, it should attach any custom data or object to the intentObj via the <code>data()</code> function.
      </p>
      <p>
         The core authorization middleware class is under <code>thorin.Authorization</code> and can be extended by other thorin
         components, using the pattern below:
      </p>
      <pre><code class="javascript">'use strict'
const CoreAuthorization = thorin.Authorization;
thorin.Authorization = class ThorinAuthorization extends CoreAuthorization {
   constructor(name) {
      super(name);
      // your custom functionality
   }
}
</code></pre>

      <h5 class="padding-top">Functionality</h5>
      <div class="function">
         <h6>authObj.input(obj)</h6>
         <div class="desc">
            Registers an input validator that will take the given key-value pairs and validate them before
            your call stack is called.
         </div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object</span> An object containing validation rules for the incoming input.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>authObj.use(func)</h6>
         <div class="desc">
            Registers an inline anonymous middleware function that will be called with <code>func(intentObj, next)</code>,
            after all input validation had completed. Note that it only works with inline pure functions and not named middleware.
         </div>
         <ul class="arguments">
            <li>
               <b>func</b><span class="type">function*</span> the function that will be called
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>authObj.end(fn)</h6>
         <div class="desc">
            Registers a function that will be called once the authorization middleware has completed its call stack. This is useful for logging and other
            post-authorization actions
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the function to call when the middleware has ended
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>authObj._runStack(intentObj, opt, done)</h6>
         <div class="desc">
            Similar to the middleware's <code>_runStack</code> function, it will execute the internal authorization call stack in the
            chronological order they were defined. This is usually called by the dispatcher.
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> the current intent object
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options passed by any higher dependents
            </li>
            <li>
               <b>done</b><span class="type">function</span> the function to call once the run stack has been called.
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
// Register our authorization header that will check the Authorization headers (default authorization source in thorin-transport-http)
const dispatcher = thorin.dispatcher;
const ADMIN_TOKEN = 'admin123';
dispatcher
   .addAuthorization('api.token')
   .use((intentObj, next) => {
      const authType = intentObj.authorizationSource,
         authToken = intentObj.authorization;
      if(authType !== 'TOKEN') {
         return next(thorin.error('AUTHORIZATION', 'Authorization method unsupported', 401));
      }
      if(authToken !== ADMIN_TOKEN) {
         return next(thorin.error('AUTHORIZATION', 'Invalid authorization token', 401));
      }
      // Attach any kind of information to the intent
      next();
   });

// Define an action that uses the above authorization
dispatcher
   .addAction('admin.show')
   .alias('GET', '/resource')
   .authorize('api.token')
   .use((intentObj, next) => {
      log.info('Admin request completed');
      next();
   })
   .before('authorize', (intentObj) => {
      log.info('Authorization will happen');
   });
</code></pre>
   </div>
{% endblock %}