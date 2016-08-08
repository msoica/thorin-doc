{% extends "../layout.swig" %}
{% set title = "Thorin.js - Input validator" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The input validator</h2>
      <p>
         One of the key features of a thorin app is the way you validate your input data by using sanitizers. Since
         sanitizers are pure synchronous functions, given an input value it will check if it's valid or not, and if it is,
         return the validated version.
      </p>
      <p>
         So, the <code>dispatcher.validate()</code> function will return a a <code>ThorinIntentValidator</code> instance
         that you can use to specify additional information about your input set. The validator's functionality is available below.
      </p>
      <div class="function">
         <h6>validatorObj.default(val)</h6>
         <div class="desc">
            If the value of an input is not valid, it will set the specified
            <code>val</code> value in the intent's input value
            for the failed key (see example below)
         </div>
         <ul class="arguments">
            <li>
               <b>val</b><span class="type">any</span> the default value to use when an incoming validation fails
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>validatorObj.error(err)</h6>
         <div class="desc">
            If the value of an input is not valid, use a custom error to return to the client and override the default <code>INPUT.NOT_VALID</code> error.
         </div>
         <ul class="arguments">
            <li>
               <b>err</b><span class="type">thorin.error instance</span> the error to send back to the client.
            </li>
         </ul>
         <div class="notes">
            If you call the function as <code>validatorObj.error('errorCode, 'errorMessage', statusCode)</code>, the validator will automatically create the error instance for you.
         </div>
      </div>
      <div class="function">
         <h6>validatorObj.promise(fn)</h6>
         <div class="desc">
            Used for asynchronous validations, the callback function will be called with the input value and expect a promise
            to be returned. Once the promise is fulfilled, the call stack resumes.
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the function to call when validating the given input field. Should return a promise
            </li>
         </ul>
         <div class="notes">
            A short example can be viewed below.
            <pre><code class="javascript">'use strict'
const dispatcher = thorin.dispatcher;
dispatcher
   .addAction('some.action')
   .input({
      name: dispatcher
               .validate('STRING', {min: 2})
               .default('John')
               .promise((inputName) => {
                  log.info('Todo some async operation');
                  return Promise.resolve('Doe');
               });
   })
   .use((intentObj) => {
      log.info(intentObj.input('name'));  // should output Doe
      intentObj.send():
   });
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>validatorObj.callback(done)</h6>
         <div class="desc">Similar to the above <code>promise()</code>, used for asynchronous validations, the callback function will be called with the input value and a <code>done</code>
         function that should be called with the standard (err, result)</div>
         <ul class="arguments">
            <li>
               <b>done</b><span class="type">function</span> the callback function to use as the async validator.
            </li>
         </ul>
      </div>
      <p>
         The dispatcher will automatically handle input data when used in an action or a middleware context. However,
         you can also use thorin to validate data outside the scope of an action or middleware, by using a special sanitization
         function found under <code>thorin.sanitize</code>.
      </p>
      <div class="function">
         <h6>thorin.sanitize(name, input, opt, defaultValue)</h6>
         <div class="desc">
            Apply the given validator on the input data with the given options. Based on the sanitizer used,
            it will either return the sanitized version of the input, the default value given or <code>null</code>
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> the sanitizer name that will be used
            </li>
            <li>
               <b>input</b><span class="type">any</span> the input value we want to verify
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options that we will pass to the sanitizer
            </li>
            <li>
               <b>defaultValue</b><span class="type">any</span> the default value to use should the validation fails.
            </li>
         </ul>
      </div>
      <h5 class="padding-top">Inline sanitization example</h5>
      <pre><code class="javascript">'use strict'
thorin.sanitize('STRING', 'myString'); // => 'myString'
thorin.sanitize('NUMBER', '30'); // => 30
thorin.sanitize('IP', 'a.b.c.d', '127.0.0.1'); // => '127.0.0.1'
</code></pre>

      <h5 class="padding-top">Middleware or action input sanitization example</h5>
      <pre><code class="javascript">'use strict';
const dispatcher = thorin.dispatcher;
dispatcher
   .addAction('my.action')
   .input({
      name: dispatcher.validate('STRING', {min: 3, max: 20}).default('John'),
      age: dispatcher.validate('NUMBER', {min: 13}).error('INVALID.AGE', 'Please provide a valid age', 400),
      gender: dispatcher.validate('ENUM', ['male', 'female']).error('INVALID.GENDER', 'Please select a gender')
   });
</code></pre>
   </div>
{% endblock %}