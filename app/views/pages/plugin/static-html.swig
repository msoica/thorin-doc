{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-static-html') }}
         plugin-static-html
      </h2>
      <p>
         The static HTML generator will essentially use the rendering engine and the http transport to
         save all the rendered HTML for all the given routes, to the file system, as static HTML pages.
      </p>
      <p>
         Note that this plugin works by performing a GET request to the alias of all registered actions
         and saving the result HTML into the static folder, using the given alias as the file path.
         This entire documentation is made with this plugin, so you can <a href="https://github.com/thorinjs/docs" target="_blank">check it out.</a>
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the plugin
npm i --save thorin-plugin-static-html@1.x</code>
<code class="javascript">'use strict';
   // app.js entry file
   const thorin = require('thorin');

   thorin.addPlugin(require('thorin-plugin-static-html'));   // <-- add this line
   thorin.run((err) => {});
</code>
<code class="bash"># run once to allow the plugin to set itself up
   node app.js --setup=plugin.static-html</code></pre>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>actions</b><span class="type">null</span> specific actions to download only. If set, it should be an array of action names.
         </li>
         <li>
            <b>output</b><span class="type">thorin.root + public/static</span>the output directory for the static HTML pages. You can also make this <code>public/</code> in order to ship your entire public/ folder as the static page.
         </li>
         <li>
            <b>transport</b><span class="type">http</span>the name of the HTTP transport to work with
         </li>
         <li>
            <b>wait</b><span class="type">1000</span>the number of milliseconds before we start performing request and saving the HTML.
         </li>
         <li>
            <b>autorun</b><span class="type">true</span>automatically start compiling the HTML files. If set to false, you have to manually call the <code>generate()</code> function
         </li>
         <li>
            <b>sitemap.compile</b><span class="type">function</span>the compile function that we use to generate the <code>sitemap.xml</code> file. You do not have to override this, as it defaults to the internal one.
         </li>
         <li>
            <b>sitemap.frequency</b><span class="type">weekly</span>specify how frequent the page changes are.
         </li>
         <li>
            <b>sitemap.domain</b><span class="type">null</span>if you want the sitemap file to work with your domain, enter it here.
         </li>
      </ul>
      <div class="notes">
         Note: setting <code>sitemap</code> to false will avoid generating the <code>sitemap.xml</code> file
      </div>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.generate(fn)</h6>
         <div class="desc">
            Manually start the HTML and sitemap generator and call the function when done.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.generatePaths(paths, fn)</h6>
         <div class="desc">
            Given an array of HTTP paths, it will perform the generate() on them. This is useful when your
            application consists of dynamic routes or aliases.
         </div>
         <ul class="arguments">
            <li>
               <b>paths</b><span class="type">array(string)</span> an array of HTTP paths to perform the GET on. The resulting HTML path will be the same as the URL.
            </li>
         </ul>
         <div class="notes">
            Note: when we do this, we essentially simulate the custom actions, by adding them to the dispatcher.<br/>
            It is <b>advised</b> that you terminate the process once the generator has completed.<br/>
            A small example:<br/>
            <code>/my/action/right/here</code> converts to <code>thorin.root + /public/static/my/action/right/here.html</code>
         </div>
      </div>

   </div>
{% endblock %}