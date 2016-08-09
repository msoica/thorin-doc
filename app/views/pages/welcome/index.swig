{% extends "../layout.swig" %}
{% set title = "Thorin.js official documentation" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Welcome</h2>
      <p>
         <b>Thorin.js</b> is the Node.js framework that you can use to easily:
      </p>
      <ul>
         <li>Boot up a pre-configured web-server, sanitize and validate all your input</li>
         <li>Render static HTML files using a templating engine, compile your less & sass styles</li>
         <li>Integrate centralized logging with <a href="https://loglet.io" target="_blank">loglet.io</a></li>
         <li>Use secure sessions in your requests, stored in redis, MySQL or file system</li>
         <li>Use already written components for some wide-spread services (Redis, ElasticSearch, Sequelize)</li>
         <li>Use a centralized dispatcher to handle your redux actions via HTTP or WebSockets</li>
         <li>Schedule recurring tasks that may use a redis queue to process events</li>
         <li>Extend the core functionality with use-case specific plugins</li>
         <li>Integrate with <a href="https://sconfig.io" target="_blank">sconfig.io's</a> discovery system for microservice discovery & authorization</li>
         <li>And much much more...</li>
      </ul>
      <p>
         The bootstrapping time of an application built with Thorin is dramatically reduced, as most critical decisions
         were made by the accumulated experience on working with large scale applications over time. The project structure
         is simple yet powerful, enabling you to boot up an application within minutes.
      </p>

      <h5 class="padding-top">Use cases</h5>
      <p>
         The <b>Thorin.js</b> framework actually contains a single
         <b>core</b> module that is used and extended by various
         other components. Therefore, when we talk about a use-case, we actually talk about which components are suited for
         the job. Some of the use cases we had in mind can be viewed below.
      </p>
      <ul>
         <li>
            <b>Static HTML site with a powerful rendering engine</b> - Enables you to use:
            <ul>
               <li>the
                  <a href="/plugin/render">rendering plugin</a> to generate dynamic HTML content, using a templating engine
               </li>
               <li>the
                  <a href="/plugin/less">LESS plugin</a> to convert your less files into css files, with no additional dependencies
               </li>
               <li>the
                  <a href="/plugin/static-html">Static HTML generator</a> to convert all your dynamic routes and templates into static
                  HTML files that you can upload to a CDN
               </li>
            </ul>
         </li>
         <li>
            <b>Administration interface</b> - A generic node application that uses:
            <ul>
               <li>the
                  <a href="/transport/http">HTTP Transport</a> as the web server to handle incoming HTTP connections
               </li>
               <li>the
                  <a href="/store/sql">SQL Store</a> to store your data in a MySQL or Postgres database, in an ORM fashion
               </li>
               <li>the
                  <a href="/plugin/auth-password">Password authentication plugin</a> to use authentication for your pages
               </li>
               <li>the
                  <a href="/plugin/render">rendering plugin</a> to render your admin templates, or just as a simple SPA app
               </li>
            </ul>
         </li>
         <li>
            <b>E-mail processor</b> - A small microservice app that uses:
            <ul>
               <li>the <a href="/transport/http">HTTP Transport</a> to enable communication with other node.js apps</li>
               <li>the <a href="/plugin/discovery">Cluster discovery plugin</a> as a discovery system and authorization system for communication
                  between your node.js apps
               </li>
               <li>
                  the <a href="/plugin/mail">Mailing plugin</a> to deliver outgoing e-mails
               </li>
               <li>
                  the <a href="/plugin/render">Rendering plugin</a> to use a templating engine for your e-mail templates.
               </li>
               <li>
                  the <a href="/plugin/sass">SASS plugin</a> to convert your sass css to plain css used in your e-mail templates
               </li>
            </ul>
         </li>
         <li>
            <b>Background worker</b> - A small microservice app that processes data as a worker that uses:
            <ul>
               <li>
                  the <a href="/plugin/tasks">Tasks plugin</a> to schedule various actions to be executed
               </li>
               <li>
                  the <a href="/store/redis">Redis store</a> for caching and queue source
               </li>
               <li>
                  the <a href="/plugin/queue">Queue plugin</a> to extract incoming events from a queue
               </li>
               <li>
                  the <a href="/plugin/stripe">Stripe plugin</a> to process subscriptions and charges
               </li>
               <li>
                  the <a href="/plugin/loglet">Loglet.io plugin</a> to send out logs and trigger events for the processed entities
               </li>
            </ul>
         </li>
      </ul>
      <p>
         You can use any combination of plugins, stores or transports to facilitate your app's need, in a microservice
         oriented architecture, to avoid monolithic problems in the future.
      </p>
   </div>
{% endblock %}