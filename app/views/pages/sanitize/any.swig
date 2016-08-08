{% extends "../layout.swig" %}
{% set title = "Thorin.js - any sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title"></h2>
      <p>
         Verifies that the input data is not undefined. If specified, checks the maximum allowed size.
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>max</b><span class="type">number, 10000</span> the maximum JSON or string length
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('ANY', 'inputString', {
   max: 10000
});
</code></pre>
   </div>
{% endblock %}