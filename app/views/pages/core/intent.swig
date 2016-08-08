{% extends "../layout.swig" %}
{% set title = "Thorin.js - The intent" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">The thorin Intent</h2>
      <p>
         The thorin intent is the object that encapsulates abstracts any incoming events or request to your application.
         They are usually created at the transport layer when a request containing a valid payload is captured. In Thorin,
         requests do not have querystring, body or url parameters, as they are all merged together into a single
         <b>input</b> object.
         This approach makes it easier for your application to handle and validate any input data as a single source of truth.
      </p>
      <p>
         Using this approach, you will essentially write functions that process <b>input</b> data and end up having a
         <b>output</b> response,
         be it an error, a JSON or plain html. This adds portability, as you no longer depend on a single transport layer (eg. express in traditional apps)
         and can seamlessly process actions from other transport sources (eg. websockets)
      </p>
      <p>
         The default representation of a successful result object is
      </p>
      <pre><code class="javascript">{
   "type": "{actionType}",
   "result": {},     // the result object
   "meta": {}        // any additional metadata
}</code></pre>
      <p>The default representation of an error object is</p>
      <pre><code class="javascript">{
   "error": {
      "code": "{error code in full caps}",
      "ns": "{error namespace}",
      "message": "Additional error message",
      "data": {}, // additional information about the error
      "status": 400  // the status code of the error.
   }
}</code></pre>
      <p>
         The core intent class is under <code>thorin.Intent</code> and can be extended by other thorin components, using the
         pattern below:
      </p>
      <pre><code class="javascript">'use strict';
const CoreIntent = thorin.Intent;
thorin.Intent = class ThorinIntent extends CoreIntent {
   constructor(name) {
      super(name);
      // your custom functionality
   }
}
</code></pre>
      <h5 class="padding-top">Functionality</h5>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>completed</b> <span class="type">boolean, false</span> Is the intent completed
            </li>
            <li>
               <b>action</b><span class="type">string</span> the action name that it addresses.
            </li>
            <li>
               <b>authorization</b><span class="type">string</span> the authorization value by default, the Authorization header
            </li>
            <li>
               <b>authorizationSource</b><span class="type">string</span> the authorization source, by default TOKEN
            </li>
            <li>
               <b>alias</b><span class="type">string</span> the alias that matched the action, if any
            </li>
            <li>
               <b>rawInput</b><span class="type">object</span> the raw merged input object that contains all the payload keys
            </li>
            <li>
               <b>took</b><span class="type">number</span> the number of milliseconds it took for the intent to complete.
            </li>
         </ul>
      </div>


      <div class="function">
         <h6>intentObj.input(key, val)</h6>
         <div class="desc">
            A thorin intent has two objects that hold data: the <code>rawInput</code> field that holds
            <b>all</b> incoming fields
            and the <code>input()</code> one that holds only
            <b>curated</b> input fields (fields defined by your action when using input()).
            This acts both as a getter and as a setter. The initial input object is set by the dispatcher after it has sanitized the input data.
            When requesting a non-existing input key, <code>null</code> will be returned.
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string</span> the name of the key we wish to access in the curated input object
            </li>
            <li>
               <b>val</b><span class="type">any</span> the value we want to associate to the particular input key, if any.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.data(key, val)</h6>
         <div class="desc">
            You can attach additional data to your intent by using this function. Actually, this is the preferred way
            of sending data from one middleware to another. It acts both as a setter and as a getter
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string | object</span> the key of the data field we want to get or set
            </li>
            <li>
               <b>val</b><span class="type">any</span> the value of the data field we want to set, if any.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.result(key, val)</h6>
         <div class="desc">
            Sets or gets the result object of the intent. Usually, the result is an object that will later be converted
            to JSON by the transport layer. When calling this function with an object, it will first try to use it's
            <code>toJSON()</code>
            function, if available.
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string | object</span> the key we want to access or set.
            </li>
            <li>
               <b>val</b><span class="type">any</span> when using the key as string, it should hold the value of the key.
            </li>
         </ul>
         <div class="notes">
            This can be used as follows:
            <ul>
               <li><code>intentObj.result({"my": "object"})</code></li>
               <li><code>intentObj.result("myKey", "myValue")</code></li>
               <li><code>intentObj.result()</code> //returns full result object</li>
               <li><code>intentObj.result("myKey")</code>// returns myKey from the result object.</li>
            </ul>
         </div>
      </div>
      <div class="function">
         <h6>intentObj.setMeta(key, val)</h6>
         <div class="desc">
            Set metadata information for the intent's result. This will create a <code>meta</code> key
            in the final result object and should contain metadata information such as pagination
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string</span> the key name we want to access or modify
            </li>
            <li>
               <b>val</b><span class="type">any</span> the value we want to set to the given key.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.error(err)</h6>
         <div class="desc">
            Attaches an error to the intent object. When the matched action detects that the intent has
            an error, it will stop the call stack and send the error back to the transport layer.
         </div>
         <ul class="arguments">
            <li>
               <b>err</b><span class="type">instance of thorin.error</span> the error we encountered.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.send(obj)</h6>
         <div class="desc">
            Finalizes the current intent, marking it complete and ignoring any other handler in the matched action's
            call stack. This will send to the transport layer the result or error attached to the intent.
         </div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object | instance of thorin.error</span> manually set a result or an error right before sending.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.client(key, val)</h6>
         <div class="desc">
            Sets or gets specific client information that is set at the transport layer. As an example, the HTTP transport
            will have <b>ip</b> and <b>headers</b> as available client information.
         </div>
         <ul class="arguments">
            <li>
               <b>key</b><span class="type">string</span> the key name we want to access or modify
            </li>
            <li>
               <b>val</b><span class="type">any</span> the value we want to set to the given key.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>intentObj.hasError(): bool</h6>
         <div class="desc">
            Checks if the input has any generated error.
         </div>
      </div>
      <div class="function">
         <h6>intentObj.hasResult(): bool</h6>
         <div class="desc">
            Checks if the input has any generated result.
         </div>
      </div>
      <div class="function">
         <h6>intentObj.hasRawResult(): bool</h6>
         <div class="desc">
            Checks if the input has any raw result attached. By default, the intent's result should be a JSON. Raw results
            can be anything from strings to buffers.
         </div>
      </div>
      <div class="function">
         <h6>intentObj.rawResult(val)</h6>
         <div class="desc">
            When used, in stead of the regular JSON response, it will set the given value as the raw result of the intent
            and it will be treated by the transport layer. This can be used together with <code>resultHeaders</code>
         </div>
         <ul class="arguments">
            <li>
               <b>val</b><span class="type">any</span> the raw result, array, buffer, string, etc.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>intentObj.resultHeaders(name, val)</h6>
         <div class="desc">
            Manually set or get custom result headers that will be sent in the response data, by the transport layer.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string | object</span> the name of the header, or an object containing key-value headers
            </li>
            <li>
               <b>val</b><span class="type">string</span> when used with a string name, the value of the header.
            </li>
         </ul>
         <div class="notes">
            You can call this function as follows:
            <ul>
               <li><code>intentObj.resultHeaders("X-Some-Header", "someValue");</code></li>
               <li><code>intentObj.resultHeaders({"X-Some-Header": "some value"});</code></li>
               <li><code>intentObj.resultHeaders()</code> // returns the result headers object</li>
               <li>
                  <code>intentObj.resultHeaders("X-Some-Header")</code>// returns the value of the given header or null.
               </li>
            </ul>
         </div>
      </div>

      <div class="function">
         <h6>intentObj.on(event, fn)</h6>
         <div class="desc">Listens for specific events triggered by the intent. Currently only <i>end</i> is supported
         </div>
         <ul>
            <li>
               <b>event</b><span class="type">string</span> the event name
            </li>
            <li>
               <b>fn</b><span class="type">function</span> the function to call when the event occurs.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.proxy(fn)</h6>
         <div class="desc">
            An intent's send() function can be proxied and called before the action send() function is called to send
            the output back to the transport layer. It can usually alter errors or result structure.
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the callback function to use when proxying.
            </li>
         </ul>
         <div class="notes">
            When proxying an intent, you <b>must</b> call the <code>send()</code> function at some point, otherwise
            it will not finalize and can provoke memory leaks. Example:
            <pre><code class="javascript">intentObj.proxy(function(obj) {
                  console.log("proxied result", obj);
                  this.send({something: "else"});
                  });</code></pre>
         </div>
      </div>

      <div class="function">
         <h6>intentObj.runCreate(fn)</h6>
         <div class="desc">
            When an intent is triggered by the dispatcher, this function is called asynchronously, enabling other
            components to handle any kind of functionality, before the intent reaches an action by overriding the function.
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the function to call when creating an intent.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.__setRawInput(obj)</h6>
         <div class="desc">
            Sets the raw input object of the intent. This is usually done at the transport layer that has access to
            the incoming payload.
         </div>
         <ul class="arguments">
            <li>
               <b>obj</b><span class="type">object</span> a key-value object containing all raw input data.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>intentObj._setAuthorization(source, id)</h6>
         <div class="desc">
            Sets the authorization information for this intent. It is usually set at the transport level that
            has access to the raw request headers or authorization source.
         </div>
         <ul class="arguments">
            <li>
               <b>source</b><span class="type">string</span> the source type, values may be: TOKEN, SESSION, etc
            </li>
            <li>
               <b>id</b><span class="type">string</span> the authorization raw content
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>intentObj.destroy()</h6>
         <div class="desc">
            This is called by the transport layer once the intent has completed, so that it can manually clean up all its references.
         </div>
      </div>
   </div>
{% endblock %}