{% extends "../layout.swig" %}
{% set title = "Thorin.js - Key concepts" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Key concepts of a Thorin app</h2>
      <p>
         Before you start a Thorin app, there are a few key concepts that you should understand:
      </p>
      <ul>
         <li>
            It uses <a href="/transport/http">Transports</a> to abstract away incoming requests to your application.
            Whether it's from a web server, web socket or raw TCP socket, you shouldn't change much of your handlers to
            accommodate it.
         </li>
         <li>
            It uses <a href="/store/sql">Stores</a> to manage and abstract access to data stores, in one way or another.
         </li>
         <li>
            It uses <a href="/sanitize/index">Sanitizers</a> to verify incoming data and <i>cast</i> it to its appropriate
            type. You can think of them as raw functions that check if a value is of a specified type.
         </li>
         <li>
            It uses <a href="/plugin/auth-password">Plugins</a> to extend the core functionality and attach or handle additional functionality
         </li>
         <li>
            It uses <a href="/core/libraries">Libraries</a> to handle business logic in one place
         </li>
         <li>
            It uses <a href="/core/action">Actions</a> to define how your application behaves and the data structure it expects
            when interacting with external entities.
         </li>
         <li>
            It uses <a href="/core/intent">Intents</a> to abstract away the <b>incoming</b> data and provide an <b>output</b> result.
         </li>
         <li>
            It uses <a href="/core/middleware">Middleware</a> and <a href="/core/authorization">Authorization</a> functions to
            prevent code duplication and encourage code reuse for your actions.
         </li>
      </ul>
   </div>
{% endblock %}
