{% extends "../layout.swig" %}
{% set title = "Thorin.js - string sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">STRING</h2>
      <p>
         Verifies if the input data is a non-empty string. By default, escape &gt; &lt; " and '
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>min</b><span class="type">number</span> the minimum length of the string
            </li>
            <li>
               <b>max</b><span class="type">number</span> the maximum length of the string
            </li>
            <li>
               <b>html</b><span class="type">boolean</span>if set to true, we will not remove &gt; and &lt; tags
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('STRING', 'inputString', {
   min: 10,
   max: 50
});
</code></pre>
   </div>
{% endblock %}