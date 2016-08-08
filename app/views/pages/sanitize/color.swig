{% extends "../layout.swig" %}
{% set title = "Thorin.js - color sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">COLOR</h2>
      <p>
         Verifies if the given string is a color representation
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>hex</b><span class="type">boolean, true</span> should we validate hex colors, including or excluding #
            </li>
            <li>
               <b>rgb</b><span class="type">boolean, true</span> should we validate rgb colors, eg: rgb(0,0,0)
            </li>
            <li>
               <b>rgba</b><span class="type">boolean, false</span> should we validate rgba colors, eg: rgba(0,0,0,0.2)
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('COLOR', 'inputString', {
   hex: true,
   rgb: true,
   rgba: false
});
</code></pre>
   </div>
{% endblock %}