{% extends "../layout.swig" %}
{% set title = "Thorin.js - Loggers" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">Thorin loggers</h2>
      <p>
         Logging is an important part of any application. It outputs in a readable form the things that happen inside your
         application. As Node.js has its default <code>console</code> logger, thorin provides the default <code>log</code>
         logging functionality and uses the console to output data.<br/>
         You can always use <a href="https://loglet.io" target="_blank">loglet.io</a> as the centralized logging storage,
         by using the <a href="/plugin/loglet">loglet plugin</a>.
      </p>
      <p>
         Thorin enables you to create namespaced loggers for various parts of your application, and enable you
         to manually configure every one of them. As an example, you might want to create a <code>payment</code> logger
         for when you process payments, so that if you use centralized logging, it would be easier for you to search
         after the payment logger name.
      </p>
      <p>
         The thorin logger can be viewed as a continuous stream of events, with a default handler that outputs to the console.
         If you want to pipe your log entries to a separate target, you can just use <code>log.pipe()</code> and receive
         the stream of log events.
      </p>
      <h5 class="padding-top">Creating a namespaced logger</h5>
      <p>
         As previously said, you can create as many namespaced loggers as you wish, calling the function below.
      </p>
      <div class="function">
         <h6>thorin.logger(namespace) : loggerObj</h6>
         <div class="desc">Creates or returns the logger with the given namespace</div>
         <ul class="arguments">
            <li><b>namespace</b><span class="type">string*</span>the namespace of the logger we wish to access</li>
         </ul>
      </div>

      <h5 class="padding-top">Example</h5>
      <pre><code class="javascript">'use strict';
const thorin = require('thorin');

const pLogger = thorin.logger('payment');
pLogger.info(`This is my payment logger`);
// outputs [INFO] [2016-08-01 18:16:19.935] [payment] This is my payment logger
log.info(`This is the default logger`);
// outputs [INFO] [2016-08-01 18:16:19.935] [default] This is the default logger

</code></pre>
      <h5 class="padding-top">Enabling, disabling and piping console logging</h5>
      <p>Console logging can be globally enabled or disabled by calling </p>
      <div class="function">
         <h6>thorin.logger.disableConsole()</h6>
         <div class="desc">Disables console logging for all namespaces</div>
      </div>
      <div class="function">
         <h6>thorin.logger.enableConsole()</h6>
         <div class="desc">Enables console logging for all namespaces</div>
      </div>
      <div class="function">
         <h6>thorin.logger.replaceConsole()</h6>
         <div class="desc">Replaces the default <code>console.log</code> logs with the default logger.</div>
      </div>
      <p>Logs can be piped either from the global logger or for specific namespaces by calling</p>
      <div class="function">
         <h6>thorin.logger.pipe(namespace, fn)</h6>
         <div class="desc">Calls the given function whenever a new log entry is generated.</div>
         <ul class="arguments">
            <li><b>namespace</b><span class="type">string</span>This will only pipe generated log entries from the given namespace.</li>
            <li><b>fn</b><span class="type">function*</span>The callback function that will be called whenever a new log entry is generated</li>
         </ul>
         <div class="notes">
            A log entry is an object that has the following structure:<br/>
            <ul>
               <li><b>ts</b> - the timestamp of the log entry, eg: Date.now()</li>
               <li><b>name</b> - the namespace of the log entry, defaults to <i>default</i></li>
               <li><b>message</b> - the string representation of the log entry</li>
               <li><b>level</b> - the log entry level (see below)</li>
               <li><b>args</b> - an array with all the arguments that were given when the log function was called.</li>
            </ul>
         </div>
      </div>


      <h5 class="padding-top">Logger levels</h5>
      <ul>
         <li>log.trace</li>
         <li>log.debug</li>
         <li>log.info</li>
         <li>log.warn</li>
         <li>log.error</li>
         <li>log.fatal</li>
      </ul>
   </div>
{% endblock %}