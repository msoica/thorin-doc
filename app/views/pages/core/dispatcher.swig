{% extends "../layout.swig" %}
{% set title = "Thorin.js - The dispatcher" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The thorin dispatcher</h2>
      <p>
         The Thorin dispatcher can be viewed as a small router within your application, handling action matching,
         intent creation, sending and receiving. You use <code>thorin.dispatcher</code> to register any kind of
         action that your application is capable to handle as well as any middleware or authorization functions that
         can be reused in other actions.
      </p>
      <p>
         Some Thorin plugins extend the core functionality of your application by registering <code>authorization</code>
         middleware that you can later include in your action declaration as dependencies.
      </p>
      <p>
         Since most Thorin components will interact with the dispatcher, it also emits a few events:
      </p>
      <ul>
         <li><b>middleware</b> - emitted when a new middleware was registered in the dispatcher</li>
         <li><b>action</b> - emitted when a new action was registered in the dispatcher</li>
         <li><b>transport</b> - emitted when a new transport was registered in the dispatcher</li>
         <li><b>intent</b> - emitted whenever an intent has generated an output (success or error) and completed.</li>
      </ul>

      <h5 class="padding-top">Functionality</h5>
      <p>
         Next to the functions exported below, the Thorin dispatcher also exposes its <code>actions</code> property,
         as an array of <code>actionObj</code> that were registered.
      </p>
      <div class="function">
         <h6>dispatcher.registerTransport(transportObj)</h6>
         <div class="desc">
            Registers the given transport instance and attaches any previously registered actions to it. Transports will
            then be able to trigger actions by creating an intent and allowing the dispatcher to route that intent to
            the respective actions.
         </div>
         <ul class="arguments">
            <li>
               <b>transportObj</b><span class="type">instance of Transport</span> - a transport instance that extends <code>thorin.Interface.Transport</code>
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>dispatcher.addTemplate(actionObj)</h6>
         <div class="desc">
            Registers a new template action to the dispatcher. Template actions are special actions that are used to encapsulate
            action specific information (such as middlewares, authorisations or root alias paths). An action can then extend a
            template, essentially inheriting its preconditions.
         </div>
         <ul class="arguments">
            <li>
               <b>actionObj</b><span class="type">instance of thorin.Action</span> an action instance that will be used as a template
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.addAction(actionObj, opt)</h6>
         <div class="desc">
            Registers an action to the dispatcher. Whenever the given action's code is triggered by one of the transports,
            it will be routed through its inner callback stack. You can also add actions that are attached only to specific transports,
            by specifying the transport's name in <code>opt.transport</code>
         </div>
         <ul class="arguments">
            <li>
               <b>actionObj</b><span class="type">instance of thorin.Action* | string*</span> an action instance that will be used by the inner routing system. If
               a string is provided, a new action will be created by the dispatcher and use the string as a code.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options that can be attached for this action.
            </li>
         </ul>
         <div class="notes">
            When specifying <code>opt.transport</code>, the action will only be attached to the given transport name.
         </div>
      </div>

      <div class="function">
         <h6>dispatcher.addMiddleware(middlewareObj)</h6>
         <div class="desc">
            Registers a new middleware inside the dispatcher. A middleware encapsulates specific functionality that can be used
            and reused throughout the application when defining an action, another middleware or authorization.
         </div>
         <ul class="arguments">
            <li>
               <b>middlewareObj</b><span class="type">instance of thorin.Middleware* | string*</span> a middleware instance that will
               be available to other actions or middlewares to include in their execution stack. If a string is provided, a new
               middleware will be created by the dispatcher and use the string as its name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.addAuthorization(authObj)</h6>
         <div class="desc">
            Authorization functions should be used to perform any kind of authorization on the incoming action request.
         </div>
         <ul class="arguments">
            <li>
               <b>authObj</b><span class="type">instance of thorin.Authorization* | string*</span> an authorization instance. If a string
               is provided, a new authorization instance will be created by the dispatcher and use the string as its name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.getMiddleware(name) : middlewareObj</h6>
         <div class="desc">Returns a previously registered middleware by its name.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the middleware name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.getAuthorization(name) : authObj</h6>
         <div class="desc">Returns a previously registered authorization by its name.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the authorization name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.getAction(name) : actionObj</h6>
         <div class="desc">Returns a previously registered action by its name.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span> the action name.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.validate(sanitizeType, opt) : validateObj</h6>
         <div class="desc">
            Returns a new intent validator instance that is used to sanitize a key in the incoming payload
         </div>
         <ul class="arguments">
            <li>
               <b>sanitizeType</b><span class="type">string*</span> the sanitizer code to use for sanitization.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> an object containing additional options to pass to the sanitizer function.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.start()</h6>
         <div class="desc">Starts the dispatcher and binds all the registered actions to all transports. This is used internally.</div>
      </div>

      <div class="function">
         <h6>dispatcher.triggerIntent(intentObj)</h6>
         <div class="desc">
            The function should be called by the transport layer to signal a new intent. The dispatcher will then route the intent
            to the appropriate action handler
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent</span> The intent instance to trigger.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>dispatcher.validateIntent(intentObj, validations, done)</h6>
         <div class="desc">
            Validates the incoming intent data by applying any previous validations. This is an internal function.
         </div>
         <ul class="arguments">
            <li>
               <b>intentObj</b><span class="type">instance of thorin.Intent*</span> The intent instance to validate
            </li>
            <li>
               <b>validations</b><span class="type">array of validateObj*</span> An array of validation objects to apply on the intent's input data
            </li>
            <li>
               <b>done</b><span class="type">function*</span> a function to call back when the validation is completed.
            </li>
         </ul>
      </div>
   </div>
{% endblock %}