{% extends "../layout.swig" %}
{% set title = "Thorin.js - JSON sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">JSON</h2>
      <p>
         Verifies if the input data is a valid JSON with the specified max size
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>max</b><span class="type">number, 10000</span> the maximum length of the JSON string. If it exceeds the size, we reject it
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('JSON', 'inputString', {
   max: 10000
});
</code></pre>
   </div>
{% endblock %}