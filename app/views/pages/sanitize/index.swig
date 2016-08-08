{% extends "../layout.swig" %}
{% set title = "Thorin.js - Sanitizers" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">About sanitizers</h2>
      <p>
         Sanitizers are an important aspect of your application, as they handle the validation of the input data you process.
         Having this in mind, it is <b>mandatory</b> that your sanitizers are fully tested and functional. If you want your
         sanitizer to be in thorin's core sanitizers, create a <a target="_blank" href="https://github.com/Thorinjs/Thorin-sanitize">pull request</a>.
      </p>
      <p>
         The general rule of a sanitizer is to verify if the input data has the expected shape, check any limitation or restriction
         and convert it into the expected type. A <i>number</i> sanitizers should convert the input data into a <i>number</i>, that means
         <code>typeof output === 'number'</code> should <b>always</b> be true. A <i>boolean</i> sanitizers should convert to <i>true</i> or <i>false</i>,
         and so on. Keeping things predictable will minimize the errors your application will encounter.
      </p>
      <p>
         Thorin offers a set of sanitizers out of the box. You can also add your own sanitizers by <a href="/interface/sanitizer">implementing</a> the interface.
         Custom sanitizers should be placed under the <b>app/sanitizers</b> folder and should be manually loaded via <code>thorin.loadPath('app/sanitizers')</code>.
         A small example can be viewed below
      </p>
      <pre><code class="javascript">'use strict';
// File: app.js
const thorin = require('thorin');
// add your components, stores, transports, etc.
thorin.addStore(require('thorin-store-sql'));
// Load up all your sanitizer .js files under app/sanitizers Each one should include itself in thorin.
thorin.loadPath('app/sanitizers', thorin);

thorin.run((err) => {
   log.info('Running');
});
</code>
<code class="javascript">'use strict';
// File: app/sanitizers/string.js
module.exports = (thorin) => {
   class StringSanitizer extends thorin.Interface.Sanitizer {
      // implement the sanitizers
   }
   // register your sanitizer so that it can be used.
   thorin.addSanitizer(StringSanitizer);
};
</code>
</pre>
   </div>
{% endblock %}