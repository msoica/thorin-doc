{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">IP_RANGE</h2>
      <p>
         Verifies if the input data is a valid CIDR notation
      </p>
      <pre><code class="javascript">'use strict';
thorin.validate('IP_RANGE', '1.2.3.0/24');
</code></pre>
   </div>
{% endblock %}