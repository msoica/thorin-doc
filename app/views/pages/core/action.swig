{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The thorin action</h2>
      <p>
         In Thorin, actions can be regarded as routes that have a call stack containing input validators, middleware functions,
         authorization functions and aliases. When defining an action, you are preparing your application to react to an
         external stimuli (initiated by the transport layer). To keep things predictable, your action will define the structure
         of the input data, acting like a contract between your application and the outside world.
      </p>
      <p>
         When the transport layer creates a new Intent, that instance will be matched to one of your defined actions and
         sent out to be processed. An intent can be viewed as both the <code>req</code> and the <code>res</code> objects of
         a regular express app.
      </p>
      <h5 class="padding-top">Functionality</h5>
      <p>
         The core thorin intent implements the functions below. However, keep in mind that some plugins can <b>extend</b>
         it by adding additional functions or injecting themselves in specific points in its lifecycle.
      </p>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>hasDebug</b> <span class="type">boolean, true</span> Does the action enable debugging?
            </li>
            <li>
               <b>isTemplate</b><span class="type">boolean, false</span> Is this action a template one?
            </li>
            <li>
               <b>root</b><span class="type">string</span> When the action is a template, the root path to apply to sub aliases
            </li>
            <li>
               <b>stack</b><span class="type">array</span> The internal call stack to use when an intent is triggered. Contains middlewares, authorizations, validations, etc.
            </li>
            <li>
               <b>name</b><span class="type">string</span> The action name (identifier)
            </li>
            <li>
               <b>aliases</b><span class="type">array of object</span> Array of {verb, name} for HTTP aliases
            </li>
            <li>
               <b>templates</b><span class="type">array of string</span> Array of template names to extend from
            </li>
            <li>
               <b>ends</b><span class="type">array of function</span> Array of functions to call when the intent is completed
            </li>
            <li>
               <b>events</b><span class="type">object</span> Map of internal <i>before</i> nad <i>after</i> event handlers.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.debug(bool)</h6>
         <div class="desc">Enables or disable debugging for the given action.</div>
      </div>

      <div class="function">
         <h6>actionObj.alias(verb, path)</h6>
         <div class="desc">
            Sets an alias to this action. An alias will be typically used by the HTTP transport to
            map URL requests to this action, essentially enabling you to define a POST /todo handler
            that will convert to this action. When an action extends a template action, the alias
            path will have the template's <code>root</code> property prepended.
         </div>
         <ul class="arguments">
            <li>
               <b>verb</b><span class="type">string</span> the HTTP Verb to use (GET,POST,PUT,DELETE,PATCH)
            </li>
            <li>
               <b>path</b><span class="type">string</span> the HTTP path to use
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.input(obj)</h6>
         <div class="desc">
            Specifies the required input data for the action to work properly. The dispatcher will
            apply the specified sanitization on the payload and continue or stop the call stack.
         </div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object</span> An object that uses its <b>keys</b> to define the structure of the
               input payload, and the associated validator function (see below example)
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.authorize(name, opt)</h6>
         <div class="desc">
            Adds a previously registered authorization to the internal call stack.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span> the name of the previously registered thorin.Authorization instance
            </li>
            <Li>
               <b>opt</b><span class="type">object</span> additional options to pass to the authorization handler, when called
            </Li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.use(middleware, opt)</h6>
         <div class="desc">
            Adds the given middleware(s) to the action's call stack.
         </div>
         <ul class="arguments">
            <li>
               <b>middleware</b><span class="type">string* | function* | array of strings*</span> Specifies which middleware to register.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> Additional options to be passed to the middleware's handler when called.
            </li>
         </ul>
         <div class="notes">
            You can register a middleware as such:
            <ul>
               <li><code>actionObj.use('middleware.name');</code> named middleware</li>
               <li><code>actionObj.use('middleware.name', {my: 'options'})</code> named middleware with options</li>
               <li><code>actionObj.use((intentObj, next) => { next()})</code> inline middleware</li>
               <li><code>actionObj.use(['middleware.one', 'middleware.two'])</code>multiple named middlewares</li>
            </ul>
         </div>
      </div>

      <div class="function">
         <h6>actionObj.before(type, name, fn)</h6>
         <div class="desc">
            Registers a callback handler that will be called <b>before</b> an item from the call stack
            is executed. The handler can be either for specific handler names, or after all handlers of a specific type were called.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the event hook type. Values are: <i>authorize, validate, middleware, use</i>
            </li>
            <li>
               <b>name</b><span class="type">string | func</span> if string, the handler will be called only for the specified hook name.
            </li>
            <li>
               <b>fn</b><span class="type">func</span> the callback function to call when the hook is triggered.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>actionObj.after(type, name, fn)</h6>
         <div class="desc">
            Registers a callback handler that will be called <b>after</b> an item from the call stack
            is executed. The handler can be either for specific handler names, or after all handlers of a specific type were called.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the event hook type. Values are: <i>authorize, validate, middleware, use</i>
            </li>
            <li>
               <b>name</b><span class="type">string | func</span> if string, the handler will be called only for the specified hook name.
            </li>
            <li>
               <b>fn</b><span class="type">func</span> the callback function to call when the hook is triggered.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.end(fn)</h6>
         <div class="desc">
            Registers an <i>end</i> callback, similar to the before and after ones, it will be called
            whenever the intent will complete with either a success or an error. When called, it will receive
            the intentObj as a parameter.
         </div>
         <ul class="arguments">
            <li><b>fn</b><span class="type">function</span> the callback function to use</li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.onRegister(fn)</h6>
         <div class="desc">
            The function will be called when the dispatcher has registered the action, <b>after</b> it inherited
            any functionality from all its parent templates (if any)
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the callback function to use.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>actionObj._runCustomType(intentObj, handler, done)</h6>
         <div class="desc">
            Plugins or other components can inject functionality into an action by
            overriding this function. Whenever a custom action handler that is not the
            default handler will be registered, it will call this function (see below)
         </div>
         <div class="arguments">
            <ul>
               <li>
                  <b>intentObj</b><span class="type">instance of thorin.Intent</span> the incoming intent object
               </li>
               <li>
                  <b>handler</b><span class="type">object</span> an object containing the handler description (with a type key)
               </li>
               <li>
                  <b>done</b><span class="type">function</span> the callback function to call when ready.
               </li>
            </ul>
         </div>
         <div class="notes">
            <pre><code class="javascript">// The render plugin extending the custom type.
_runCustomType(intentObj, handler, done) {
   if(handler.type !== Action.HANDLER_TYPE.RENDER) {
      return super._runCustomType.apply(this, arguments);
   }
   intentObj._setTemplateSource(getTemplateSource.bind(this));
   if(this.events.before.render || this.events.after.render) {
      intentObj._setTemplateSuccess(this._runHandler.bind(this, 'after', 'render', intentObj));
   }
   done();
}
</code></pre>
         </div>
      </div>

      <div class="function">
         <h6>actionObj._runStack(intentObj, done)</h6>
         <div class="desc">
            When an intent was dispatcher by the transport layer, the dispatcher will call this
            function of the matched action. Internally, it will execute all the handlers that
            were registered in its call stack, <b>chronologically</b> and trigger <i>before</i> and <i>after</i> events (if any).
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> the incoming intent
            </li>
            <li>
               <b>done</b><span class="type">function</span> the function to call when the action has finished processing the intent.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj.template(name)</h6>
         <div class="desc">
            Specifies that the current action will use the given template as a parent and
            essentially have the template's stack be executed before any of the internal stack.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">name</span> a previously registered template name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj._extendFromParent(actionObj)</h6>
         <div class="desc">
            The function is called by the dispatcher once all the action's parents were registered
            and essentially copies the structure of the parent action. This should more likely be used only by other components
         </div>
         <ul class="arguments">
            <li>
               <b>actionObj</b><span class="type">instance of thorin.Action</span> the parent action to extend.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>actionObj._runHandler(handlerType, sourceEvent, intentObj, sourceName)</h6>
         <div class="desc">
            Whenever a custom event is triggered (eg, before validate), the triggering source will call
            this function to run all the handlers that are listening to the given event). It can be seen as
            a specialized trigger() function.
         </div>
         <ul class="arguments">
            <li>
               <b>handlerType</b><span class="type">string</span> the handler type, values are <i>before</i> or <i>after</i>
            </li>
            <li>
               <b>sourceEvent</b><span class="type">string</span> the event that occurred, eg: <i>validation</i> or <i>authorization</i>
            </li>
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> the intent that was used
            </li>
            <li>
               <b>sourceName</b><span class="type">string</span> if specified, the name of the source event
            </li>
         </ul>
         <div class="note">
            A small example of the render action can be viewed below
            <pre><code class="javascript">this._runHandler('before', 'render', intentObj, templateName);</code></pre>
         </div>
      </div>
      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
const dispatcher = thorin.dispatcher;
// A small authorization function
dispatcher
   .addAuthorization('session.check')
   .use((intentObj, next) => {
      if(!intentObj.session.account) return next(thorin.error('AUTH', 'Please login', 403));
      next();
   });
// Create a small template action
dispatcher
   .addTemplate('session.account')
   .alias('/todo/:id')
   .authorize('session.check')
   .input({// if no id in payload, stop request.
      id: dispatcher.validate('NUMBER').error('INVALID_TODO', 'Missing todo', 400)
   });

// Define an action that uses the above template.
dispatcher
   .addAction('todo.view')
   .template('session.account')
   .alias('GET', '/')
   .input({ // if no time in payload, use "now"
      time: dispatcher.validate('DATE').default("now")
   })
   .use((intentObj, next) => {
      // Your code here
      intentObj.result({
         "some": "result"
      });
      next();
   })
   .before('authorize', 'session.account', (intentObj) => {
      log.info(`Checking session`);
   })
   .end((intentObj) => {
      log.info(`Intent completed for ${intentObj.action}`);
   });
</code></pre>
   </div>
{% endblock %}