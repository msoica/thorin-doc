{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-render') }}
         plugin-render
      </h2>
      <p>
         The render plugin enables your application to handle server-side rendering (currently) using
         <a href="https://www.npmjs.com/package/nunjucks" target="_blank">nunjucks</a>, extending the
         default <b>action</b> and <b>intent</b> classes.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the plugin
npm i --save thorin-plugin-render@1.x
# install nunjucks
npm i --save nunjucks@2.4.2
</code>
<code class="javascript">'use strict';
   // app.js entry file
   const thorin = require('thorin');

   thorin.addPlugin(require('thorin-plugin-render'));   // <-- add this line
   thorin.run((err) => {});
</code>
<code class="bash"># run once to allow the plugin to set itself up
   node app.js --setup=plugin.render</code></pre>


      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>engine</b><span class="type">nunjucks</span>the rendering engine to use. Currently, only this is supported.
         </li>
         <li>
            <b>path</b><span class="type">app/views</span>the path to your views folder, relative to <code>thorin.root</code>
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.render(template, locals, fn)</h6>
         <div class="desc">
            Manually call the render function on a template with the given local variables. Once the HTML is generated, callback the function
         </div>
         <ul class="arguments">
            <li>
               <b>template</b><span class="type">string</span>the template path, relative to <code>thorin.root</code>
            </li>
            <li>
               <b>locals</b><span class="type">object</span>the locals variable that can be accessed by the template.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the function to call when rendering is completed or error.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.addLocal(key, val)</h6>
         <div class="desc">
            Extends the global locals object by adding keys to it or merging other objects with it.
         </div>
         <ul class="arguments">
            <li>
               <code>pluginObj.addLocal({some: 'object'})</code> merge the given object with the global locals
            </li>
            <li>
               <code>pluginObj.addLocal('aKey', 'aValue')</code> add the given key to the global locals object.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.getLocals() : Object</h6>
         <div class="desc">
            Returns the current global locals object of the plugin.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.instance() : Nunjucks</h6>
         <div class="desc">
            Returns the render instance. This is useful when you want to add custom filters or access other features.
         </div>
      </div>

      <h5 class="padding-top">Extended Thorin.Action</h5>
      <div class="function">
         <h6>actionObj.render(template, when)</h6>
         <div class="desc">
            The function will enable you to render <code>swig</code> or <code>html</code> templates that have access
            to rendering utilities and the <code>intent</code> object.
         </div>
         <ul class="arguments">
            <li>
               <b>template</b><span class="type">string</span>the template path you wish to use
            </li>
            <li>
               <b>when</b><span class="type">number | string</span>when should the given template be used. By default, it will be used on <strong>success</strong> requests. You can also
               render specific templates for generic <code>error</code> requests or specific <code>status codes</code>.
            </li>
         </ul>
         <pre><code class="javascript">'use strict';
thorin.dispatcher
   .addAction('my.action')
   .alias('GET', '/home')
   .render('home.swig')          // render the home.swig template by default
   .render('error.swig', 500);   // render the error.swig template on 500 errors

// You can also select the template dynamically, based on the incoming intent
thorin.dispatcher
   .addAction('account')
   .alias('GET', '/admin/:type')
   .input({
      type: dispatcher.validate('STRING')
   })
   .render('invalid_type.swig', 400)   // render this when no type is given
   .render('error.swig', 'error')      // when other any kind of error occurs.
   .render((intentObj) => {      // conditional rendering
      let type = intentObj.input('type');
      if(type === 'app') return 'app.swig';
      return 'dashboard.swig';
   });
</code></pre>
      </div>
      <div class="function">
         <h6>action event: <code>render</code></h6>
         <div class="desc">
            Whenever an action will render the HTML of a template, the <code>render</code> action event will be triggered,
            therefore you can inject functionality before and after the rendering.
         </div>
         <ul class="arguments">
            <li><b>actionObj.before('render', fn)</b> calls the function with <code>fn(intentObj)</code>, before we begin rendering the template</li>
            <li><b>actionObj.after('render', fn)</b> calls the function with <code>fn(intentObj, html)</code>, after the HTML output was generated.</li>
         </ul>
      </div>

      <h5 class="padding-top">Rendering utilities</h5>
      <div class="function">
         <h6>{% raw %}{{ config(key) }}{% endraw %}</h6>
         <div class="desc">
            Access the application's configuration, essentially translates to <code>thorin.config</code>
         </div>
      </div>
      <div class="function">
         <h6>{% raw %}{{ asset(path, version) }}{% endraw %}</h6>
         <div class="desc">
            Builds up an asset path that will be used with the <code>config.cdn</code> setting.
         </div>
         <ul class="arguments">
            <li>
               <b>path</b><span class="type">string</span>the asset path, relative to the <code>/public</code> folder.
            </li>
            <li>
               <b>version</b><span class="type">string | boolean</span>if specified, add a <code>?v={version}</code> in the querystrin of the asset.
               If it is set on <code>true</code>, extract the version from the project's package.json file.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>{% raw %}{{ actionAlias(action) }}{% endraw %}</h6>
         <div class="desc">
            Returns the first alias path for the given action or an empty string. This is used to map
            url's to actions in your views, so that in the event of a path change, you do not have to update your routes.
         </div>
      </div>
      <div class="function">
         <h6>{% raw %}{{ isAction(action, result) }}{% endraw %}</h6>
         <div class="desc">
            A small utility function that verifies if the given action code is the one of the current request. If
            it matches, output the <code>result</code> param
         </div>
         {% raw %}<pre><code class="html">
&lt;div class="{{ isAction('home.index','active') }}"&gt;Home menu item.&lt;/div&gt;
</code></pre>{% endraw %}
      </div>
      <div class="function">
         <h6>thorin</h6>
         <div class="desc">The thorin app reference is also available in templates.</div>
      </div>
      <div class="function">
         <h6>intent</h6>
         <div class="desc">The intent object of a request is also available in templates.</div>
      </div>
   </div>
{% endblock %}