{% extends "../layout.swig" %}
{% set title = "Thorin.js - number sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">NUMBER</h2>
      <p>
         Verifies if the input data is a valid number
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>string</b><span class="type">boolean</span>if specified, verifies if it is a string number. A string number contains only numbers, and will not be parsed, eg, 00304560
            </li>
            <li>
               <b>min</b><span class="type">number</span>if specified, the minimum value of the number
            </li>
            <li>
               <b>max</b><span class="type">number</span>if specified, the maximum value of the number.
            </li>
            <li>
               <b>float</b><span class="type">boolean</span>if specified, it will use <code>parseFloat()</code> in stead of <code>parseInt()</code>
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('NUMBER', 'inputString', {
   min: 10,
   max: 100,
   float: true,
   string: false
});
</code></pre>
   </div>
{% endblock %}