{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Component loading and registration</h2>
      <p>
         You can load up any kind of Thorin component, by calling the appropriate registration function.
      </p>
      <div class="function">
         <h6>thorin.addTransport(transport, name)</h6>
         <div class="desc">Registers the given transport component inside your Thorin app</div>
         <ul class="arguments">
            <li>
               <b>transport</b><span class="type">string* | transportObj*</span>either the class that extends <code>thorin.Interface.Transport</code>,
               or the full name of the transport and Thorin will try to perform
               <code>require(transport)</code>.
            </li>
            <li>
               <b>name</b><span class="type">string</span>override the default transport name and use this one in stead.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.addStore(store, name)</h6>
         <div class="desc">Registers the given store component inside your Thorin app</div>
         <ul class="arguments">
            <li>
               <b>store</b><span class="type">string* | storeObj*</span>either the class that extends <code>thorin.Interface.Store</code>
               or the full name of the store module, as Thorin will try to perform <code>require(store)</code>.
            </li>
            <b>name</b><span class="type">string</span>override the default store name and use this one in stead or create multiple
            instances from the given store component (see example below)
         </ul>
      </div>
      <div class="function">
         <h6>thorin.addPlugin(plugin, name, opt)</h6>
         <div class="desc">
            Registers the given plugin in your Thorin application. You can override its default name and pass any kind of
            contextual options. The <code>opt</code> object will override any application-level configuration for the plugin.
         </div>
         <ul class="arguments">
            <li>
               <b>plugin</b><span class="type">string* | function*</span>either the plugin function or the full name name of the plugin,
               as Thorin will try to perform <code>require(name)</code>. If a function, it will be called with <code>fn(thorin, opt, name)</code>
            </li>
            <li>
               <b>name</b><span class="type">string</span>override the default plugin name and use this one in stead
            </li>
            <li>
               <b>opt</b><span class="type">object</span>provide inline options for the plugin.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.addErrorParser(fn)</h6>
         <div class="desc">
            Registers a custom error parser inside your thorin app. Error parsers are used when an error is
            encountered inside the application to alter the information that it will expose to the end user.
         </div>
         <ul class="arguments">
            <li><b>fn</b><span class="type">function*</span>the error parser function that will be called with an error as the first argument</li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.addSanitizer(items)</h6>
         <div class="desc">Registers the given custom sanitizers inside your thorin app</div>
         <ul class="arguments">
            <li>
               <b>items</b><span class="type">class* | array&lt;class&gt;*</span>the custom sanitizer class or an array of classes
               that extends <code>thorin.Interface.Sanitizer</code>
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.addLibrary(module, name)</h6>
         <div class="desc">Registers your libraries inside your thorin app.</div>
         <ul class="arguments">
            <li>
               <b>module</b><span class="type">string* | function*</span>either the name of the library, the library object or the
               library constructor function.
            </li>
            <li>
               <b>name</b><span class="type">string</span>when provided, the name of the library.
            </li>
         </ul>
         <div class="notes">
            If you call <code>addLibrary(module)</code> with no name and module as an object or constructor function, the name of the library will
            be taken from <i>module.name</i><br/>
            Ways of calling:<br/>
            <code>thorin.addLibrary(module=string)</code> // it will perform require(module);<br/>
            <code>thorin.addLibrary(module=function, name=string)</code> // use the constructor function with a specific name<br/>
            <code>thorin.addLibrary(module=string, name=string)</code>  // it will perform require(module) and register the library with the given name<br/>
            <code>thorin.addLibrary(module=function)</code> // it will register the the library using the module's prototype.name or module.name
         </div>
      </div>
      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
const thorin = require('thorin');
thorin.addTransport(require('thorin-transport-http'))
   .addStore(require('thorin-store-redis'), 'sessionDb', 'cacheDb')
   .addPlugin(require('thorin-plugin-less'), {
      watch: true
   })
   .addLibrary('app/lib/myLib.js', 'myLib');
thorin.run();
</code></pre>
   </div>
{% endblock %}