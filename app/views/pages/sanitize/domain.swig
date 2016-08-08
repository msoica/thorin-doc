{% extends "../layout.swig" %}
{% set title = "Thorin.js - domain sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">DOMAIN</h2>
      <p>
         Verifies if the input data is a valid domain name
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>private</b><span class="type">boolean, false</span> should we allow local or private domains
            </li>
            <li>
               <b>underscore</b><span class="type">boolean, true</span> should we allow underscores in the domain
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('DOMAIN', 'inputString', {
   private: false,
   underscore: true
});
</code></pre>
   </div>
{% endblock %}