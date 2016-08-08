{% extends "../layout.swig" %}
{% set title = "Thorin.js - float sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">FLOAT</h2>
      <p>
         Verifies if the input data is a float number
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>min</b><span class="type">number</span>if specified, the minimum value of the input number
            </li>
            <li>
               <b>max</b><span class="type">number</span>if specified, the maximum value of the input number
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('FLOAT', 'inputString', {
   min: 10,
   max: 100
});
</code></pre>
   </div>
{% endblock %}