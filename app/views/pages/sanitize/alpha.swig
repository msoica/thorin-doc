{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">ALPHA</h2>
      <p>
         Verifies if the given input is an alpha or an alpha-numeric string.
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>dot</b><span class="type">boolean, false</span>should we allow dots in the string
            </li>
            <li>
               <b>dash</b><span class="type">boolean, false</span>should we allow dashes in the string
            </li>
            <li>
               <b>underscore</b><span class="type">boolean, false</span>should we allow underscores in the string.
            </li>
            <li>
               <b>numeric</b><span class="type">boolean, false</span>should the string contain numbers, essentially transforming into an alpha-numeric check
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('ALPHA', 'inputString', {
   dot: true,
   dash: true,
   underscore: true,
   numeric: true
});
</code></pre>
   </div>
{% endblock %}