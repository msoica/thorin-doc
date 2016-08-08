{% extends "../layout.swig" %}
{% set title = "Thorin.js - Getting started" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Getting started with Thorin.js</h2>
      <p>
         In order to initialize a thorin.js project, the first thing you have to do is install the core module. Note that
         Thorin.js will only work with Node.js &gt;= <b>4.x</b>. If your application is still running on Node &lt;= 0.12, it
         is time to upgrade.
      </p>
      <pre><code class="bash">npm install thorin@latest</code></pre>
      <p>
         Next, depending on the functionality you want to implement, you'd take a look at the existing plugins, stores
         and transports. Once you've decided on the list of components you want, install them in your project. In the
         use case bellow, we will use <b>type</b> as the component type and <b>name</b> as its name. Current component
         types are <i>transport</i>, <i>store</i>, <i>plugin</i>, <i>library</i>.
      </p>
      <pre><code class="bash">npm install thorin-{type}-{name} # eg: thorin-transport-http</code></pre>
      <p>
         Once you've installed your components, create your entry file (app.js) and load up all your components.
         It is recommended that the first time you add a new component to set it up, so that it can execute setup specific
         functionality. You do so by running your app with <code class="bash">node app.js --setup={type}.{name}</code>
      </p>
      <p>
         You should now create your application's
         <i>entry file</i>, app.js and tell it which components to load and capture
         any other events that you wish to handle.
      </p>
      <pre><code class="javascript">'use strict';
const thorin = require('thorin');
// Tell thorin to load and work with the required components
thorin
   .addTransport(require('thorin-transport-http'))
   .addStore(require('thorin-store-sql'));
if(thorin.env === 'development') {
   thorin.addPlugin(require('thorin-plugin-docs'));
}
// Once we've done so, boot up the application
thorin.run((err) => {
   if(err) {
      log.fatal(`Something bad happened: ${err.code}`, err);
      return process.exit(1);
   }
   log.info(`Application launched`);
});
</code></pre>
      <p>
         By default, Thorin's core will automatically recursively require your application's <b>app/actions</b> and <b>app/middleware</b> folders.
         Other Thorin components will provide the auto-loading feature, depending on their structure dependencies (see below).
      </p>
      <p>
         As a friendly reminder, we strongly recommend that <b>before</b> you start coding on your application, have an
         architectural overview for it and divide it into multiple specialized microservices, that will work with the discovery plugin
         for inter-communication. This will save you a lot of headaches down the line.
      </p>
      <h5 class="padding-top">Default project structure</h5>
      <p>
         A regular Thorin app will have the following folder structure. Depending on which components you end up using,
         it will influence it. This is the structure we encourage you to use, to avoid any compatibility issues.
      </p>
      <ul>
         <li>
            <b>app/</b> - Your application's root folder
            <ul>
               <li>
                  <b>actions/</b> - Place all your app's actions here.
               </li>
               <li>
                  <b>middleware/</b> - Place all your app's middleware and authorizations here.
               </li>
               <li>
                  <b>models/</b> - When using the SQL store, place all your application's models here.
               </li>
               <li>
                  <b>lib/</b> - Place all your application's library files here.
               </li>
               <li>
                  <b>styles/</b> - When using the LESS or SASS css processor, place all your application styles here.
               </li>
               <li>
                  <b>views/</b> - When using the render plugin, place all your view templates here.
               </li>
               <li>
                  <b>emails/</b> - When using the email plugin, place all your email related templates here.
               </li>
               <li>
                  <b>tasks/</b> - When using the tasks plugin, place all your task definitions here.
               </li>
            </ul>
         </li>
         <li>
            <b>config/</b> - Folder to place any kind of configuration.
            <ul>
               <li>
                  <b>env/</b> - Place all your environment specific configuration here, as <b>development.js</b> or
                  <b>production.js</b>
               </li>
               <li>
                  <b>{entryFile}.js</b> - The general configuration for your application's entry file. Defaults to app.js
               </li>
            </ul>
         </li>
         <li>
            <b>public/</b> - If you use the HTTP transport, all your application's public assets go here,
         </li>
         <li>
            <b>docs/</b> - If you're using the docs generator plugin, it will generate your markdown documentation and place it here.
         </li>
         <li>
            <b>package.json</b> - Your application's package file containing project dependencies and other.
         </li>
         <li>
            <b>.gitignore</b> - Your git repository's git ignore file.
         </li>
         <li>
            <b>{entryFile}.js</b> - The entry point for your application, defaults to app.js
         </li>
      </ul>
   </div>
{% endblock %}