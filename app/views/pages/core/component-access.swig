{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Component accessing</h2>
      <p>
         Once you're application was successfully initialized, all the components you've registered in the Thorin app
         are available and accessible throughout the application. Since Thorin acts as a global singleton, all registered
         component instances will be cached and accessed by their name.
      </p>

      <div class="function">
         <h6>thorin.store(name) : storeObj</h6>
         <div class="desc">Returns the store instance that was registered with the given name or <code>null</code> if non existing.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span>the name of the store
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.plugin(name) : pluginObj</h6>
         <div class="desc">Returns the plugin instance that was registered with the given name or <code>null</code> if non existing.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span>the name of the plugin
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.transport(name) : storeObj</h6>
         <div class="desc">Returns the transport instance that was registered with the given name or <code>null</code> if non existing.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span>the name of the transport
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.lib(name) : libraryObj</h6>
         <div class="desc">Returns the library instance that was registered with the given name or <code>null</code> if non existing.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string*</span>the name of the library
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
// File: actions/myAction.js
const thorin = require('thorin'),   // or global.thorin
   store = thorin.store('sql');

const MyModel = store.model('myModel');   // model() function from the sql store instance.
</code></pre>

   </div>
{% endblock %}