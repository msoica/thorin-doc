{% extends "../layout.swig" %}
{% set title = "Thorin.js - date sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">DATE</h2>
      <p>
         Verifies if the given input is a valid representation of a date.
         It tries to create a date from:
      </p>
      <ul>
         <li>
            <b>numbers</b> as timestamps, using new Date(timestamp)
         </li>
         <li>
            <b>YYYY-MM-DD</b> format for date-only check
         </li>
         <li>
            <b>MM-DD-YYYY</b> format for date-only check
         </li>
         <li>
            <b>YYYY-MM-DD HH:MM:SS</b> or <b>YYYY-MM-DD HH:MM</b> format for date + time check
         </li>
         <li>
            <b>MM-DD-YYYY HH:MM:SS</b> or <b>MM-DD-YYYY HH:MM</b> format for date + time check.
         </li>
      </ul>
      <p>
         Additional date options will be added in the near future.
      </p>
      <pre><code class="javascript">'use strict';
thorin.validate('DATE', '2016-12-03 10:00'); // =>Sat Dec 03 2016 10:00:00 GMT+0200 (GTB Standard Time)
thorin.validate('DATE', 1470209505271);   // Wed Aug 03 2016 10:31:45 GMT+0300 (GTB Summer Time)
</code></pre>
   </div>
{% endblock %}