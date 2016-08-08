{% extends "../layout.swig" %}
{% set title = "Thorin.js - Libraries" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Thorin libraries</h2>
      <p>
         In a Thorin app, libraries are those bits of code that can be reused in various parts of the application, such as
         a payment gateway or a communication layer between other services. If you find yourself writing the same code twice,
         consider moving it to a library and call your functions from there.
      </p>
      <p>
         Since libraries can come in various sizes and forms, Thorin is quite open when registering your libraries in your app.
         You can use classes, objects or prototypes try following the pattern below.
      </p>
      <div class="function">
         <h6>thorin.addLibrary(module, name)</h6>
         <div class="desc">Registers the given library module inside the thorin app, so that it can be accessible via
            <code>thorin.lib(name)</code>
            from anywhere inside your application.
         </div>
         <div class="arguments">
            <ul>
               <li>
                  <b>module</b><span class="type">string | function</span> the library module to register (see below use cases)
               </li>
               <li>
                  <b>name</b><span class="type">string</span> the name of the library
               </li>
            </ul>
         </div>
         <div class="notes">
            Ways to call:
            <ul>
               <li>
                  <code>thorin.addLibrary(module=string)</code> // will use require(module) and use its <i>name</i> property
               </li>
               <li>
                  <code>thorin.addLibrary(module=string, name=string)</code> // will use require(module) and use the given name
               </li>
               <li>
                  <code>thorin.addLibrary(module=function)</code> // will use the given function, prototype or class and use its <i>name</i> property
               </li>
               <li>
                  <code>thorin.addLibrary(module=function, name=string)</code> // will use the given function, prototype or class and use the given name
               </li>
            </ul>
         </div>
      </div>
      <pre><code class="javascript">'use strict'
// Option 1
class MyLib {
   doSomething() {}
}
thorin.addLibrary(MyLib, 'libName');
// Option 2
const libOne = {
   doSomething: () => {}
};
thorin.addLibrary(libOne, 'libOne');

// Option 3
const libTwo = function myLib() {}
libTwo.prototype.name = 'libTwo';
thorin.addLibrary(libTwo);

// Option 4
const libThree = function myLibThree() {}
thorin.addLibrary(libThree);  // use the function's name as the fallback.
</code></pre>
   </div>
{% endblock %}