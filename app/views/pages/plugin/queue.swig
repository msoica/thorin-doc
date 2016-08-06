{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-queue') }}
         plugin-queue
      </h2>
      <p>
         The queue plugin implements simple queueing functionality that uses <code>redis</code> as the preferred underlying
         storage.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-queue@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-queue'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash"># setup the queue plugin
node app.js --setup=plugin.queue
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>store</b><span class="type">string</span>the redis store name to use for enqueue/dequeue. If no store is given, we will work with an in-memory queue (not suitable for production)
         </li>
         <li>
            <b>channel</b><span class="type">string, thorin.queue</span>the default channel (or list) name used to enqueue/dequeue from
         </li>
         <li>
            <b>logFile</b><span class="type">string, thorin.root + config/.queue</span> if specified, this will be the file that we're going to use to write queue logs.
         </li>
         <li>
            <b>logPersist</b><span class="type">number, 1000</span>the number of milliseconds between queue log persistence calls. This is done to minimize the number of lost queue items.
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.create(opt)</h6>
         <div class="desc">
            Manually create a new queue instance, using the given options
         </div>
      </div>

      <h5 class="padding-top">The <code>Queue</code> class</h5>
      <div class="function">
         <h6>queueObj.enqueue(item, channel, fn)</h6>
         <div class="desc">Enqueues the given item to the queue. If channel is specified, use that one in stead of the default channel.</div>
         <ul class="arguments">
            <li>
               <b>item</b><span class="type">any</span>the item to enqueue to the queue. If it is an object, we will stringify it.
            </li>
            <li>
               <b>channel</b><span class="type">string</span>an optional channel name to enqueue it to. Defaults to the configured one.
            </li>
            <li>
               <b>fn</b><span class="type">function</span>an optional function to call once the item was enqueued.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>queueObj.dequeue(count, channel, fn) : Promise</h6>
         <div class="desc">
            Dequeues the given number of items from the queue. By default, it will only dequeue a single item.
         </div>
         <ul class="arguments">
            <li>
               <b>count</b><span class="type">number, 1</span>the number of items to dequeue, defaults to 1.
            </li>
            <li>
               <b>channel</b><span class="type">string</span>if specified, dequeues from the given channel. Otherwise, defaults to the configured channel.
            </li>
            <li>
               <b>fn</b><span class="type">function</span> if specified, use it as the result callback, otherwise return a Promise.
            </li>
         </ul>
      </div>
      <pre><code class="javascript">'use strict';
const queueObj = thorin.plugin('queue');
queueObj.enqueue({myObject: 'right here'});
setTimeout(() => {
   queueObj.dequeue(100, (err, items) => {
      log.info('Items:', items);
   });
}, 1000);
</code></pre>
   </div>
{% endblock %}