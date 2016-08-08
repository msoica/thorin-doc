{% extends "../layout.swig" %}
{% set title = "Thorin.js - URL sanitizer" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">URL</h2>
      <p>
         Verifies if the input data is a valid URL. Internally, it uses node's <code>url</code> module.
         The result will be the <code>URL</code> object returned from <code>url.parse(input)</code>
      </p>
      <div class="function">
         <h6>Options</h6>
         <ul class="arguments">
            <li>
               <b>public</b><span class="type">boolean, true</span>should we verify the URL is public
            </li>
            <li>
               <b>protocol</b><span class="type">string | array(string)</span>if specified, should we verify the URL's protocol is one of the given ones. Default values are http, https
            </li>
            <li>
               <b>hash</b><span class="type">boolean, false</span>if specified, should we preserve the hashtag of the URL. By default, we remove it.
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
thorin.validate('URL', 'inputString', {
   public: true,
   protocol: 'http', // or ['http','https','ftp']
   hash: false
});
</code></pre>
   </div>
{% endblock %}