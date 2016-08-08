{% extends "../layout.swig" %}
{% set title = "Thorin.js - Sanitizer interface" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">thorin.Interface.Sanitizer</h2>
      <p>
         You can write your own sanitization and validation functions by implementing
         <code>thorin.Interface.Sanitizer</code> and
         calling <code>thorin.addSanitizer()</code>
      </p>
      <h5>Interface functionality</h5>
      <div class="function">
         <h6>static code() : string</h6>
         <div class="desc">Must return the full upper-case code of the sanitizer. This is the code used together with
            <i>dispatcher.validate</i> calls
         </div>
      </div>
      <div class="function">
         <h6>static publicName() : string</h6>
         <div class="desc">
            Must return the publicly available name of the sanitizer. This is the value used when generating a validation error and
            including the validator's public name
         </div>
      </div>
      <div class="function">
         <h6>static aliases() : array[string]</h6>
         <div class="desc">
            You can define the alias codes your sanitizer will respond to, eg INTEGER -> [NUMBER, NUMERIC]
         </div>
      </div>
      <div class="function">
         <h6>validate(input, opt)</h6>
         <div class="desc">
            This is the function that is called when a validation is done by your sanitizer. It will call with the
            input data and the given set of options. (see notes)
         </div>
         <ul class="arguments">
            <li>
               <b>input</b> <span class="type">any</span> the raw input value to sanitize
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options passed to the sanitizer
            </li>
         </ul>
         <div class="notes">
            It is important to know <i>how</i> your validation function returns data:
            <ul>
               <li>If the validation fails, it must return a <b>falsy</b> value, preferably <b>false</b></li>
               <li>If the validation passes, it must return:</li>
               <ul>
                  <li>a <i>promise</i> and resolve it with an <i>object</i> with a <b>value</b> key, containing the sanitized input</li>
                  <li>an <i>object</i> with a <b>value</b> key, containing the sanitized input</li>
               </ul>
            </ul>
         </div>
      </div>
      <h5>Example</h5>
      <pre><code class="javascript">'use strict';
class SanitizeString extends thorin.Interface.Sanitizer {
   static code() { return 'STRING'; }
   static publicName() { return 'String' }
   static aliases() { return ['TEXT', 'VARCHAR'] }
   
   validate(input, opt) {
      if(typeof input !== 'string' || !string) return false;
      // add additional processing steps
      return {
         value: input.trim()
      }
   }
}
thorin.addSanitizer(SanitizeString);
</code></pre>
   </div>
{% endblock %}