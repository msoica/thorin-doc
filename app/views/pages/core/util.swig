{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Thorin utilities</h2>
      <p>
         Out of the box, Thorin offers a few utilities that either abstract away some functionality or adds basic one.
         All utility functions are and should be placed under <code>thorin.util</code>
      </p>
      <div class="function">
         <h6>thorin.error(code, message, status, error)</h6>
         <div class="desc">
            Generates a custom thorin error given the error information. It is <b>highly</b> recommended that you
            wrap <b>all</b> your application errors using <code>thorin.error(err)</code> so that thorin can properly
            capture stack traces and disable stack trace leaking to any clients.
         </div>
         <div class="notes">
            Ways to call:
            <ul>
               <li><code>thorin.error(code=string)</code>// generic error message and status 400</li>
               <li><code>thorin.error(code=string, message=string)</code>// default status 400</li>
               <li><code>thorin.error(code=string, message=string, statusCode=number)</code></li>
               <li><code>thorin.error(code=string, message=string, error=Error)</code>// attach error stack to the custom error</li>
               <li><code>thorin.error(error=Error)</code> // wrap a node.js error inside a thorin error with a default <i>SERVER_ERROR</i> code and status 500</li>
            </ul>
         </div>
         <div class="notes">
            <b>Do's</b>
            <pre><code class="javascript">'use strict';
const fs = require('fs');
function readFile(fpath) {
   fs.readFile(fpath, (err, content) => {
      if(err) return Promise.reject(thorin.error(err));  // wrap the default error in a thorin.error()
      return content;
   });
}
</code></pre>
         <b>Dont's</b>
         <pre><code class="javascript">'use strict';
const fs = require('fs');
function readFile(fpath) {
   fs.readFile(fpath, (err, content) => {
      if(err) throw err;         // NEVER throw in an async context, but gracefully handle the error.
      // do something with content
   });
}
</code></pre>
         </div>
      </div>

      <div class="function">
         <h6>thorin.util.randomString(length, onlyAlpha) : string</h6>
         <div class="desc">Synchronously generates a cryptographically safe random string using the specified length</div>
         <ul class="arguments">
            <li>
               <b>length</b><span class="type">number</span> the length of the string, defaults to 16
            </li>
            <li>
               <b>onlyAlpha</b><span class="type">boolean</span> if set to true, it will only return a-zA-Z characters.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.util.extend()</h6>
         <div class="desc">A utility function that will extend the first object with the other sources and recursively merge them.</div>
         <ul class="arguments">
            <li>
               <b>arguments</b><span class="type">object</span> called with as many objects as needed in the arguments scope.
            </li>
         </ul>
         <div class="notes">
            This would be equivalent with <code>Object.assign</code>. A short example of the extend function:
            <pre><code class="javascript">'use strict';
const myObj = thorin.util.extend({"v1": "one"}, {"v2": "two"});
// myObj is now {"v1": "one", "v2": "two"} with a new object reference.
</code></pre>
         </div>
      </div>

      <div class="function">
         <h6>thorin.util.readDirectory(path, opt) : array(string)</h6>
         <div class="desc">Synchronously and recursively reads the contents of a directory</div>
         <ul class="arguments">
            <li>
               <b>path</b> <span class="type">string</span>the absolute path of the directory
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options to use (see below)
            </li>
         </ul>
         <div class="notes">
            Available options:
            <ul>
               <li>
                  <b>ext</b> - only include files with the specified extension, <b>OR</b>
               </li>
               <li>
                  <b>dirs</b> - if set to true, return <b>only</b> directories
               </li>
               <li>
                  <b>modules</b> - if set to true, will go into <b>node_modules</b> folders, by default it excludes them.
               </li>
               <li>
                  <b>relative</b> - if set to true, all resulting paths will be converted to the relative path of the search path, <i>excluding</i> the first slash
                  (eg: /home/ec2-user/myapp/myfolder/app.js => myfolder/app.js)
               </li>
            </ul>
         </div>
      </div>

      <div class="function">
         <h6>thorin.util.isDirectory(path) : boolean</h6>
         <div class="desc">Synchronously checks if the given path is a directory or not</div>
         <ul class="arguments">
            <li>
               <b>path</b> <span class="type">string</span> the absolute path of the directory to check.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.isFile(path) : boolean</h6>
         <div class="desc">Synchronously checks if the given path is a file or not</div>
         <ul class="arguments">
            <li>
               <b>path</b> <span class="type">string</span> the absolute path of the file to check.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>thorin.util.sha1(text) : string</h6>
         <div class="desc">Hashes the given text using SHA-1</div>
         <ul class="arguments">
            <li>
               <b>text</b> <span class="type">string</span> the text to hash
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.sha2(text, count) : string</h6>
         <div class="desc">Hashes the given text using SHA-2, <i>count</i> times</div>
         <ul class="arguments">
            <li>
               <b>text</b> <span class="type">string</span> the text to hash
            </li>
            <li>
               <b>count</b><span class="type">number</span> the number of rounds to apply the hash, defaults to 1.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.hmac(text, secret, alg) : string</h6>
         <div class="desc">Creates an HMAC with the given secret and hashes the given text</div>
         <ul class="arguments">
            <li>
               <b>text</b> <span class="type">string</span> the text to hash
            </li>
            <li>
               <b>secret</b> <span class="type">string</span> the secret key to initiate the HMAC with
            </li>
            <li>
               <b>alg</b><span class="type">string</span> the HMAC algorithm to use, defaults to sha256.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.encrypt(data, key, iv) : string</h6>
         <div class="desc">Encrypts the given data with Node's native crypto module using AES-256-CBC. If the decryption process
         fails, returns <code>false</code></div>
         <ul class="arguments">
            <li>
               <b>data</b><span class="type">string | buffer</span> the data to encrypt
            </li>
            <li>
               <b>key</b><span class="type">string</span> the 32-character key to use for encryption
            </li>
            <li>
               <b>iv</b><span class="type">boolean | buffer | string</span> if set to true, generate an IV on the spot. If string or buffer, use the provided one.
            </li>
         </ul>
         <div class="notes">
            The encoding used for both the ciphertext and IV (if any) is <code>hex</code>. When using with an <code>IV</code>, the ciphertext
            pattern is:<br/>
            <code>{32-char hex-encoded IV}${hex-encoded ciphertext}</code><br/>
            Notice the dollar <b>$</b> sign between the IV and the ciphertext. We use it to differentiate between IV and non-IV encryptions, when
            decrypting the ciphertext.
         </div>
      </div>
      <div class="function">
         <h6>thorin.util.decrypt(ciphertext, key, iv) : string</h6>
         <div class="desc">
            Tries to decrypt the ciphertext using the given key and (optional) IV with Node's native crypto module,
            using AES-256-CBC. If the decryption process fails, returns <code>false</code>
         </div>
         <ul class="arguments">
            <li>
               <b>ciphertext</b><span class="type">string</span>the generated ciphertext of a previous encryption
            </li>
            <li>
               <b>key</b><span class="type">string</span> the 32-char key used for decryption
            </li>
            <li>
               <b>iv</b><span class="type">string</span> If the ciphertext does not contain an IV (see above), it will look for it
               in this argument. If none is specified, initiates the decipher with no IV.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.compare(a,b) : boolean</h6>
         <div class="desc">Performs a safe byte comparison on the two strings. This is useful to mitigate timing attacks.</div>
         <ul class="arguments">
            <li>
               <b>a, b</b><span class="type">string</span> the two strings to compare.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.downloadFile(url, done)</h6>
         <div class="desc">Downloads a given static <code>css</code> or <code>js</code> resource from the given url and
         calls back with its string content.</div>
         <ul class="arguments">
            <li>
               <b>url</b> <span class="type">string</span> the URL to download the asset from
            </li>
            <li>
               <b>done</b><span class="type">function</span> the callback to call when download is ready.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>thorin.util.Event</h6>
         <div class="desc">A small wrapper over Node's EventEmitter that exposes the <code>destroy()</code> function, removing
         all registered listeners. This is to prevent memory leaks.</div>
      </div>

      <h5 class="padding-top">The Thorin Fetcher</h5>
      <p>
         Thorin also exposes a small wrapper over fetch's implementation that facilitates communication between other thorin
         microservices. Since the de-facto transport layer used by most microservices is the <code>thorin-transport-http</code>,
         we can leverage the <code>/dispatch</code> endpoint to handle action triggering between microservices.
      </p>

      <p>
         One of thorin's fetch wrappers is exposed under <code>thorin.fetch</code> that wraps the default node-fetch module
         in a error-checker result-parser way.
      </p>
      <div class="function">
         <h6>thorin.fetch(url, opt, done)</h6>
         <div class="desc">
            Performs a fetch on the given url using the given node-fetch options. If a callback is specified, use it
            otherwise return a promise. The fetch's result is considered a success if the statusCode is 2xx and the its content-type
            is set to application/json and the result is a valid JSON object, <b>OR</b> the result is a plain text.
         </div>
         <ul class="arguments">
            <li>
               <b>url</b><span class="type">string</span> the URL to perform the request to
            </li>
            <li>
               <b>opt</b><span class="type">object</span> the options to send to node-fetch. For a full list, <a href="https://www.npmjs.com/package/node-fetch" target="blank">click here</a>.
            </li>
            <li>
               <b>done</b><span class="type">function</span> if specified, use the callback for passing the response. Otherwise, use promises.
            </li>
         </ul>
         <div class="notes">
            You can quickly set an <code>Authorization: Bearer {code}</code> header by using <code>opt.authorization: "yourToken"</code>.
         </div>
      </div>

      <p>
         A more complex fetcher can be configured by using <code>thorin.fetcher</code>. It essentially configures and caches
         the way your application communicates with another thorin microservice.
      </p>
      <div class="function">
         <h6>thorin.fetcher(name, url, opt)</h6>
         <div class="desc">
            Creates and caches a new fetcher instance using the given options or returns a previously registered one. If the
            fetcher's name is omitted, it will not be cached.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b> <span class="type">string</span> the fetcher name used to cache.
            </li>
            <li>
               <b>url</b><span class="type">string</span> the full url containing the <code>/dispatch</code> path of the target microservice.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional options to use with node-fetch (see note above)
            </li>
         </ul>
         <div class="notes">
            A fetcher instance will contain a <code>dispatch(action, payload)</code> function that will perform
            a POST request to the target's <code>/dispatch</code> endpoint, using the given action and payload.
            Returns a promise.
         </div>
         <div class="notes">
            Ways to call:
            <ul>
               <li>
                  <code>thorin.fetcher(url=string, opt=object)</code> // creates a fetcher but does not cache it
               </li>
               <li>
                  <code>thorin.fetcher(name=string, url=string, opt=object</code> // creates a fetcher and caches it using the given name
               </li>
               <li>
                  <code>thorin.fetcher(name=string)</code>  // returns a previously cached fetcher
               </li>
            </ul>
            Example:<br/>
            <pre><code class="javascript">'use strict';
const mailer = thorin.fetcher('mailer', 'http://localhost:12301/dispatch', {authorization: 'SOME_TOKEN'});
mailer
   .dispatch('my.action', {some: "payload"})
   .then((res) => {
      log.info('Mailer responded with', res);
   })
   .catch((e) => {});

// Access a previously defined fetcher.
const mailerApi = thorin.fetcher('mailer');
</code></pre>
         </div>
      </div>
      <h5 class="padding-top">Additional utilities</h5>
      <p>
         Thorin internally makes use of additional utility libraries. Since we do not want to duplicate dependencies, they
         will be exported under <code>thorin.util.{library}</code>
      </p>

      <div class="function">
         <h6>thorin.util.fs</h6>
         <div class="desc">Expose the internal dependency of <a href="https://npmjs.com/package/fs-extra" target="blank">fs-extra</a></div>
      </div>
      <div class="function">
         <h6>thorin.util.async</h6>
         <div class="desc">Expose the internal dependency of <a href="https://npmjs.com/package/async" target="blank">async</a></div>
      </div>
      <div class="function">
         <h6>thorin.util.fetch</h6>
         <div class="desc">Expose the internal dependency of <a href="https://npmjs.com/package/node-fetch">node-fetch</a></div>
      </div>
      <div class="function">
         <h6>thorin.loadPath(paths, ignoreInitialized, args)</h6>
         <div class="desc">
            Recursively requires the given file paths or folders. It is useful when you want to require all the files
            inside a folder, recursively.
         </div>
         <ul class="arguments">
            <li>
               <b>paths</b><span class="type">string | array[string]</span>A path or an array of paths to require. If the path is not absolute, thorin.root will be used to prepend it.
            </li>
            <li>
               <b>ignoreInitialized</b><span class="type">boolean</span> By default, it will wait until the thorin application will start initializing. Defaults to false (see below)
            </li>
         </ul>
         <div class="notes">
            <ul>
               <li>The paths that are to be loaded can be either <b>directory</b> or <b>file</b> paths. If a path is a directory, thorin will try to 
               recursively load all the <b>.js</b> files inside that directory.</li>
               <li>
                  If the path is not absolute, the full path will be <code>thorin.root + '/' + path</code> (use the application folder as the root path).
               </li>
               <li>
                  When calling <code>loadPath(path, true)</code>, the <code>require()</code> call will wait untill you call thorin's <code>run()</code> function
                  to boot up the application and wait untill all components had their <code>init()</code> function called.
               </li>
               <li>
                  If the exported variable of a required file is a <code>function</code>, thorin will <b>call</b> it, passing any additional arguments that
                  you've specified in the <code>loadPaths()</code> call, <i>excluding</i> the <i>paths</i> and <i>ignoreInitialized</i> arguments.
               </li>
            </ul>
            <pre><code class="javascript">'use strict';
const thorin = require('thorin');
// File: app.js
thorin.loadPath('app/lib', thorin, "Hello"); // pass thorin and true as a variable for the exported functions.
</code>
<code class="javascript">'use strict';
// File: app/lib/file.js
module.exports = (thorin, word) => {
   log.info('Required with word:', word);
   // do stuff.
}
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>thorin.series(items, fn, stopOnError)</h6>
         <div class="desc">
            A utility function that will perform a <code>series()</code> on the array of functions provided. The items array
            should be an array that contains functions. Each function will be called and should return<br/>
            - promises, in which case it will wait for them to resolve<br/>
            - undefined, in which case we consider them successful.
         </div>
         <ul class="arguments">
            <li>
               <b>items</b><span class="type">array of functions</span> an array of functions that are waiting to be called in a serial model.
            </li>
            <li>
               <b>fn</b><span class="type">if specified, use it as the callback, otherwise return a promise</span>
            </li>
            <li>
               <b>stopOnError</b><span class="type">if set to false, we will ignore all errors or promise rejections. By default, we stop at the first occurance of an error.</span>
            </li>
         </ul>
         <div class="notes">
            Ways to call:
            <ul>
               <li>
                  <code>thorin.series(items=array,stopOnError=false)</code>   // work with promises and won't stop on first error.
               </li>
               <li>
                  <code>thorin.series(items=array, onComplete=function, stopOnError=false)</code> // work with callback and won't stop on the first error.
               </li>
               <li>
                  <code>thorin.series(items=array, onComplete=function)</code> // works with callback, stops at first error
               </li>
               <li>
                  <code>thorin.series(items=array)</code> // works with promises, stops at first error.
               </li>
            </ul>
         </div>
         <div class="notes">
<pre><code class="javascript">'use strict';
const store = thorin.store('sql');
const calls = [];
let appObj;
calls.push(() => {
   const Account = store.model('account');
   return Account.build({email: 'john@doe.com'});
});
if(thorin.env === 'production') {
   calls.push(() => {
      log.info('Account created');
      return Application.find({where: { id: 1 }).then((obj) => appObj = obj);
   });
}
calls.push(() => {
   if(!appObj) return;
   return appObj.update({is_active: true});
});

thorin.series(calls, (e) => {
   log.info('All done!');
});
</code></pre>
         </div>
      </div>
   </div>
{% endblock %}