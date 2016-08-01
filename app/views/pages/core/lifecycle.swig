{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Component lifecycle and prioritization</h2>
      <p>
         When working with a Thorin component or accessing another part of the application from within a component,
         it is important that you now how the core module will load them up.
      </p>
      <h5 class="padding-top">Booting up</h5>
      <p>
         The Thorin core module acts as a global singleton (placed under
         <b>global.thorin</b> for convenience). Therefore,
         whenever you launch your thorin app using <code class="bash">node app.js --env=development</code>,
         and <code class="javascript">require('thorin')</code>, it will perform the following steps
      </p>
      <ul class="numbered">
         <li>
            Gather information about the environment, such as the application's root path, extract information from
            package.json, parse the running environment mode, parse any command-line arguments and give your application
            a name.
         </li>
         <li>
            Bootstrap the thorin singleton instance, loading up all core sanitizers, interfaces, validate the .gitignore
            to include the <b>.thorin</b> persist file, load up all core utilities and functionality
         </li>
         <li>
            From the moment you <code>require('thorin')</code>, until the moment you call <code>thorin.run()</code>, it
            will register all the components that you add via <i>addTransport</i>, <i>addStore</i>, <i>addPlugin</i>,
            <i>addLibrary</i>, <i>addSanitizer</i> or <i>addErrorParser</i>
         </li>
         <li>
            The moment you call <code>thorin.run()</code>, it will start running all registered components and start the
            application (see below).
         </li>
      </ul>
      <h5 class="padding-top">Component lifecycle</h5>
      <p>
         Once you've called <code>thorin.run()</code>, the initialization process begins and the following steps will be taken
      </p>
      <ul class="numbered">
         <li>Load up the application's configuration data, from the registered sources, then merge them together into a single config object</li>
         <li>
            Creates all the registered components by following the priority list below.
            <ul>
               <li>Create all registered <i>sanitizers</i></li>
               <li>Create all registered <i>stores</i></li>
               <li>Create all registered <i>libraries</i></li>
               <li>Create all registered <i>transports</i></li>
               <li>Create all registered <i>plugins</i></li>
            </ul>
         </li>
         <li>
            For every component loaded, verify if it exports a <b>init()</b> function. If so, call it.
            This is the moment where you can access the state of other components, by listening to their <b>init</b> or <b>run</b> event.
            Note that this is a <b>synchronous</b> call.
         </li>
         <li>
            Load and require any application action, middleware or file that was added via <code>thorin.loadPath()</code>
         </li>
         <li>
            If our application is run with the <b>--setup</b> flag, check if we have to setup <b>all</b> components, or just
            specific ones. Depending on the case, verify if the selected components have a <b>setup()</b> function exported and
            call it. As this is an <b>asynchronous</b> call, we will pass a callback function to setup() and each component should
            call it once it's done setting up, with the standard <code>callback(error, null)</code>. Note that this is a <b>asynchronous</b>
            call.
         </li>
         <li>
            For every component loaded, verify if it exports a <b>run()</b> function. If so, call it and pass it a callback as <code>callback(error, null)</code>.
            This is the time where components should initialize any kind of external connection, perform binding or do any
            kind of file altering, since the call is done <b>asynchronously</b>.
         </li>
         <li>
            If at least <b>one</b> component encountered any kind of error in the lifecycle, stop the booting and call thorin.run's callback with
            the encountered error. Otherwise, the application should be up and running in a stable state.
         </li>
      </ul>

      <h5 class="padding-top">Thorin core events</h5>
      <p>
         During the startup period of a Thorin app, on every step of the way and for each component, thorin will emit a specific <b>event</b>.
         You can tap into these events by calling <code>thorin.on({eventName}, {componentName} callback)</code>. The following events
         are triggered:
      </p>
      <ul>
         <li>
            <b>init</b> - triggered right after calling the <code>init()</code> function of a given component.
         </li>
         <li>
            <b>setup</b> - triggered right after a component has finished setting up, as a result of the <code>setup()</code> call.
         </li>
         <li>
            <b>run</b> - triggered right after a component has finished its running process, as a result of the <code>run()</code> call.
         </li>
      </ul>
      <p>
         The above core events are available only in the boot period of a thorin app, and are triggered <b>exactly once</b> for
         each component. A short example can be seen below.
      </p>
      <pre><code class="javascript">'use strict'
const thorin = require('thorin');
// Add the SQL store and the HTTP transport
thorin
   .addStore(require('thorin-store-sql'))
   .addTransport(require('thorin-transport-http'));

// Capture the init event for our SQL store.
thorin.on(thorin.EVENT.INIT, 'store.sql', (storeObj) => {
   log.info(`SQL store initialized but not yet connected to store`);
});

// Capture the run event for our HTTP transport
thorin.on(thorin.EVENT.RUN, 'transport.http', (transportObj) => {
   log.info(`HTTP web server is binded and accepting connections`);
});
// Capture the moment when thorin finished calling the init() function of ALL our registered components.
thorin.on(thorin.EVENT.INIT, () => {
   log.info(`All components successfully initialized`);
});

thorin.run();
</code></pre>
   </div>
{% endblock %}