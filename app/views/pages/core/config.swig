{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Configuration loading</h2>
      <p>
         One of the key aspects of a Thorin application is the way it loads the configuration data from various sources, based on the
         environment it is launched in. A configuration source is a place from which we can read and parse data, that our application
         will later use as configuration. Out of the box, Thorin offers two configuration sources: <b>disk</b> and <b>sconfig</b>.
         When you start your application, Thorin will automatically look for configuration under <b>config/{entryFile}.js</b> and
         <b>config/env/{environment}.js</b>
      </p>
      <p>
         You can add additional configuration sources by calling the <code>thorin.addConfig(name, opt, _fn)</code> function.
      </p>
      <div class="function">
         <h6>thorin.addConfig(sourceType, options, onLoaded)</h6>
         <div class="desc">Registers a new configuration source in your application.</div>
         <ul class="arguments">
            <li><b>sourceType</b><span class="type">enum(disk, sconfig)*</span> the configuration source type.</li>
            <li><b>opt</b><span class="type">object*</span> configuration passed to the source loader (see below)</li>
            <li><b>onLoaded</b><span class="type">function, optional</span> callback function to call after calling the source</li>
         </ul>
      </div>

      <h5>Disk loader options</h5>
      <ul class="arguments">
         <li><b>path</b><span class="type">string*</span> the path of the file to load, including extension. Current extensions: <i>json</i>, <i>js</i></li>
         <li><b>absolute</b><span class="type">boolean, false</span> if set to true, use the full path, otherwise use thorin.root + path</li>
         <li><b>required</b><span class="type">boolean, true</span> should the app be shutdown if we cannot load this source</li>
      </ul>
      <h5 class="padding-top">SConfig loader options</h5>
      <ul class="arguments">
         <li><b>key</b><span class="type">string*</span>The 32-char API key or the long access token</li>
         <li><b>secret</b><span class="type">string</span>When used with the 32-char API key, the sconfig application's secret key.</li>
         <li><b>version</b><span class="type">string, latest</span>The configuration version to load from sconfig.io</li>
      </ul>
      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
const thorin = require('thorin');
thorin
   .addConfig('disk', {
      path: 'config/custom.js'  // loaded from app/config/custom.js
   })
   .addConfig('sconfig', {
      key: '{32-char API key}',
      secret: '{32-char API Secret}',
      version: 'latest'
   })
   .run();
</code></pre>


   </div>
{% endblock %}