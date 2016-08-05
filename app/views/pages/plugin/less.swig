{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-less') }}
         plugin-less
      </h2>
      <p>
         A small css-compiler plugin that works with <code>less</code> files. It is essentially a wrapper over
         <a href="https://npmjs.com/package/less" target="_blank">less</a> version 2.6
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-less@1.x</code>
<code class="javascript">'use strict';
   // app.js entry file
   const thorin = require('thorin');

   thorin.addPlugin(require('thorin-plugin-less'));   // <- add this line
   thorin.run((err) => {});
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>watch</b><span class="type">true</span>should less files be watched for changes? Useful in development
         </li>
         <li>
            <b>debug</b><span class="type">false</span>should we log every time we make changes? Useful in development
         </li>
         <li>
            <b>files</b><span class="type">array(object)</span>an array of <code>input</code> and <code>output</code> files to work with. The path of both the input
            and the output files are relative to <code>thorin.root</code>
         </li>
         <li>
            <b>options</b><span class="type">object</span>additional less specific options.
         </li>
      </ul>
      <pre><code class="javascript">'use strict';
module.exports = {
   'plugin.sass': {
      watch: false,
      files: [{
         input: 'app/styles/main.scss',
         output: 'public/css/main.css'
      }, {
         input: 'app/styles/admin.scss',
         output: 'public/css/admin.css'
      }]
   }
};
</code></pre>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.add(item, opt, onCompile)</h6>
         <div class="desc">
            Manually add a new file entry to be processed.
         </div>
         <ul class="arguments">
            <li>
               <b>item</b><span class="type">object</span>an object containing <code>input, output</code> keys
            </li>
            <li>
               <b>opt</b><span class="type">object</span>additional options to pass to node-sass
            </li>
            <li>
               <b>onCompile</b><span class="type">function</span>if specified, the function to be called when css is compiled.
            </li>
         </ul>
      </div>
   </div>
{% endblock %}