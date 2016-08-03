{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">EMAIL</h2>
      <p>
         Verifies if the input data is a valid e-mail
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>tld</b><span class="type">boolean, true</span> should we verify the TLD of the email
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('EMAIL', 'inputString', {
   tld: true
});
</code></pre>
   </div>
{% endblock %}