{% extends "../layout.swig" %}
{% set title = "Thorin.js - IP sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">IP</h2>
      <p>
         Validates if the input data is a valid IP address or if it is within a specified CIDR range.
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>private</b><span class="type">boolean</span>if specified, check if we have an IP address from a private block
            </li>
            <li>
               <b>public</b><span class="type">boolean</span>if specified, check if we have a publicly accessible IP address
            </li>
            <li>
               <b>range</b><span class="type">array of ip | CIDR notation</span>if specified, check if the input IP is within the specified CIDR block
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('IP', 'inputString', {
   private: false,
   public: true,
   range: ['4.4.4.0/24']
});
</code></pre>
   </div>
{% endblock %}