{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The thorin middleware</h2>
      <p>
         You can define middleware functions by registering them in the dispatcher (using a name) and use them in your
         application's action definition. Your middleware functions should contain simple functionality and alter the incoming
         <code>intentObj</code> by overriding input data, or pass data from one middleware to the next, by using the <code>data()</code>
         function of an intent.
      </p>
      <p>
         The core middleware class is under <code>thorin.Middleware</code> and can be extended by other thorin components, using the
         pattern below:
      </p>
      <pre><code class="javascript">'use strict';
const CoreMiddleware = thorin.Middleware;
thorin.Middleware = class ThorinMiddleware extends CoreMiddleware {
   constructor(name) {
      super(name);
      // your custom functionality
   }
}
</code></pre>

      <h5 class="padding-top">Functionality</h5>

      <div class="function">
         <h5>Properties</h5>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the middleware name
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>middlewareObj.input(obj)</h6>
         <div class="desc">
            Adds an input validator to the middleware before calling any use() functions from the call stack.
         </div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object</span> An object containing validation rules for the incoming input.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>middlewareObj.use(name, opt)</h6>
         <div class="desc">
            A middleware can make use of other middlewares by registering them as a named middleware requirement with <code>use("middlewareName")</code>.
            A middleware can also register an anonymous handler using <code>use((intentObj, next, opt) => {})</code>, that will receive the
            incoming intent object as well as any options that were passed by higher dependencies. (see below)
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string | function</span> the name of the middleware to use as a dependency or
               the function of the inline handler
            </li>
            <li>
               <b>opt</b><span class="type">object</span> when using another middleware as a dependency, you can pass options to it.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>middlewareObj.end(fn)</h6>
         <div class="desc">
            Registers a function that will be called once the middleware has completed its call stack. This is useful for logging and other
            post-middleware actions
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the function to call when the middleware has ended
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>middlewareObj._runStack(intentObj, opt, done)</h6>
         <div class="desc">
            Similar to the action's <code>_runStack</code> function, it will execute the internal middleware call stack in the
            chronological order they were defined. This is usually called by the dispatcher.
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> the current intent object
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options passed by the higher dependents
            </li>
            <li>
               <b>done</b><span class="type">function</span> the function to call once the run stack has been called.
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
const dispatcher = thorin.dispatcher;
// Register our middleware.
dispatcher
   .addMiddleware('mid.one')
   .input({
      name: dispatcher.validate('STRING') // it will fail with a generic error if no name is provided
   })
   .use((intentObj, next, opt) => {
      log.info(`Should process action ${intentObj.action} using middleware options `, opt);
      if(opt.nickname) {
         intentObj.data('nick', 'A silly object name');
      }
      next();
   });

// Add a separate middleware
dispatcher
   .addMiddleware('mid.two')
   .use('mid.one', {
      nickname: true
   })
   .use((intentObj, next) => {
      log.info(`Got nickname: ${intentObj.data('nick')}`);
      next();
   });

// Add an action that will use the second middleware.
dispatcher
   .addAction('home.example')
   .use('mid.two')
   .use((intentObj, next) => {
      log.info(`Done`);
      intentObj.result({
         nick: intentObj.data('nick')
      }).send();
   });
</code></pre>
   </div>
{% endblock %}