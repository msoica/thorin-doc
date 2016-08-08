{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-utils') }}
         plugin-utils
      </h2>
      <p>
         The plugin adds extended utility functions to your application's <code>thorin.util</code>
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-utils@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-utils'));   // <- add this line
thorin.run((err) => {});
</code></pre>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>thorin.util.getDomainRoot(fullDomain) : String</h6>
         <div class="desc">
            Returns the root domain of the given domain, or null if it is invalid.
         </div>
         <div class="notes">
            some.example.com -> example.com<br/>
            google.com -> google.com<br/>
            some.other.misc.domain.co.uk -> domain.co.uk<br/>
            invalid-domain -> null
         </div>
      </div>
      <div class="function">
         <h6>thorin.util.getDomainTld(fullDomain) : String</h6>
         <div class="desc">
            Returns the top-level-domain (com, com.uk, net, etc) for the given full domain
         </div>
      </div>
      <div class="function">
         <h6>thorin.util.getSubdomain(fullDomain)</h6>
         <div class="desc">
            Returns the sub-domain of the given domain
         </div>
         <div class="notes">
            some.example.com -> some<br />
            google.com -> null<br/>
         </div>
      </div>
      <div class="function">
         <h6>thorin.util.minifyCss(source) : Promise</h6>
         <div class="desc">
            Performs CSS cleaning and minification
         </div>
      </div>

   </div>
{% endblock %}