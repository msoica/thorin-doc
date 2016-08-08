{% extends "../layout.swig" %}
{% set title = "Thorin.js - docs plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-docs') }}
         plugin-docs
      </h2>
      <p>
         The plugin will wait until your Thorin application is booted and, given your application actions, it will generate
         a markdown <i>.md</i> file describing your actions and their input data. This should be included in the development
         only.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin.docs@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');
if(thorin.env === 'development') {
   thorin.addPlugin(require('thorin-plugin-docs'));   // <- add this line
}
thorin.run((err) => {});
</code>
<code class="bash"># run to setup the plugin
node app.js --setup=plugin.docs
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>path</b><span class="type">string, docs/actions.md</span> the default output file path
         </li>
         <li>
            <b>theme</b><span class="type">string, markdown</span> the theme to use when generating doc, currently only markdown
         </li>
      </ul>
      <p>
         The plugin will listen for the <code>thorin.EVENT.RUN</code> event of your application, use all registered actions
         to generate the docs markdown file with the action's input data and possible authorizations and place it under <code>docs/actions.md</code>
      </p>
   </div>
{% endblock %}