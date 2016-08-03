{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">ARRAY</h2>
      <p>
         Verifies if the input data is an array. Default delimiter for string checking: <b>,</b>
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>parse</b><span class="type">boolean, false</span> should we <code>JSON.parse()</code> the items of the array. Items that cannot be parsed will be ignored.
            </li>
            <li>
               <b>delimiter</b><span class="type">string, <i>comma</i></span> the delimiter to use when splitting the string
            </li>
            <li>
               <b>min</b><span class="type">number</span>if specified, the minimum length of the array
            </li>
            <li>
               <b>max</b><span class="type">number</span>if specified, the maximum number of items.
            </li>
            <li>
               <b>type</b><span class="type">string</span>if specified, the <code>typeof</code> value of the inner array items. If at least one fails the check, the validation fails.
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('ARRAY', 'inputString', {
   parse: false,
   delimited: ',',
   min: 10,
   max: 100,
   type: "string"
});
</code></pre>
   </div>
{% endblock %}