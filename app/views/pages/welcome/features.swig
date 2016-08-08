{% extends "../layout.swig" %}
{% set title = "Thorin.js - Features" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Main features</h2>
      <p>
         Thorin.js's power comes from its components and the way they interact and extend the core functionality.
      </p>
      <h5 class="padding-top">Powerful and extendable core</h5>
      <p>
         Thorin as itself has some core concepts implemented and define how you initiate the bootstrapping process of
         your application. Its plugins, transports, libraries and stores define how your app interacts with external
         services. If you need some functionality that is not available in the open source space of thorin modules,
         you can write your own and just use it inside your microservices. You can also contact us to to add it as a
         official component so that others may use it.
      </p>
      <h5 class="padding-top">Simple integration with other services</h5>
      <p>
         Thorin's official components were designed to seamlessly integrate with other external services and utilities,
         so that you won't spend time on the integration process and just use them. You don't have to worry about
         an additional publisher/subscriber connection for Redis, Sequelize model loading and prioritization or securing
         your HTTP server. Our components do that for you.
      </p>
      <h5 class="padding-top">Production ready with our tools</h5>
      <p>
         Here at <a href="https://unloqsystems.com" target="_blank">UNLOQ</a> we've invested a lot of time into deploying,
         securing and monitoring a node.js application the right way. So, you can always use our <a href="https://sconfig.io" target="_blank">sconfig.io</a>
         service to store your app's configuration data in a secure way, or use <a href="https://loglet.io" target="_blank">loglet.io</a> to
         store, query and livestream any incoming logs from all your microservices, in a centralized way.
      </p>
      <h5 class="padding-top">Built on top of other tested frameworks</h5>
      <p>
         We did not re-invent the wheel, nor do we say we've created from thin air this framework. However, we've selected
         some of the most stable node.js frameworks and integrated them with the core module by creating a wrapper over them,
         to abstract away low-level configurations, loadings or any kind of feature that would make you search for <i>How to do this</i>.
         We use <b>express</b> for the HTTP transport, <b>socket.io</b> for the WebSocket transport, <b>sequelize</b> for ORM,
         <b>redis</b> as the client, and so on.
      </p>
   </div>
{% endblock %}