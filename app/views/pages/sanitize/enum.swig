{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">ENUM</h2>
      <p>
         Verifies if the input data is one of the given enum values.
         The validator's options must be an array containing the exact ENUM values.<br/>
         It is a good practice to have your enums as full upper case strings or numbers.
      </p>
      <pre><code class="javascript">'use strict';
thorin.validate('ENUM', 'inputString', ['VALUE1', 'VALUE2']);
</code></pre>
   </div>
{% endblock %}