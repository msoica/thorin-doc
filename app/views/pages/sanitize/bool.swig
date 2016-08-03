{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">BOOL</h2>
      <p>
         Verifies if the given input is a boolean.<br/>
         True values: <b>"true"</b>, <b>"1"</b>, <b>1</b>, <b>true</b><br/>
         False values: <b>"false"</b>, <b>"0"</b>, <b>0</b>, <b>false</b>
      </p>
      <pre><code class="javascript">'use strict';
thorin.validate('BOOL', 'inputString');
</code></pre>
   </div>
{% endblock %}