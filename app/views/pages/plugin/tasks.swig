{% extends "../layout.swig" %}
{% set title = "Thorin.js - tasks plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-tasks') }}
         plugin-tasks
      </h2>
      <p>
         The tasks plugin is used to register functionality to be executed at specific points in time,
         recurring or not. This plugin is useful for a worker-like microservice that can process items in the background.
      </p>
      <p>
         By default, the plugin will create the folder <b>app/tasks</b> where you should save all your task definitions.
         They will be automatically loaded and registered by the application.
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-tasks@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-tasks'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash">#update config/app.js with your configuration</code>
<code class="bash"># run to setup the plugin
node app.js --setup=plugin.tasks
</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>enabled</b><span class="type">boolean, true</span> setting this to false will disable any scheduled tasks to execute.
         </li>
         <li>
            <b>debug</b><span class="type">boolean, true</span> enable task debugging and logging
         </li>
         <li>
            <b>persist</b><span class="type">string, thorin.root + config/.task_dump</span>the file used to persist task entry timers.
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.Task : TaskEntry</h6>
         <div class="desc">
            The task entry definition class, see below.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.addTask(taskName, opt) : TaskEntry instance</h6>
         <div class="desc">
            Registers a new task entry to the system.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getTask(name) : TaskEntry instance</h6>
         <div class="desc">
            Returns the task entry instance by its name.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.stopTasks(fn)</h6>
         <div class="desc">
            Stops all the registered task entries from execution.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.stopTask(name, fn)</h6>
         <div class="desc">
            Stops a single task entry from execution.
         </div>
      </div>

      <h5 class="padding-top">The <code>TaskEntry</code> class</h5>
      <p>
         You use the task entry to define what and when gets executed.
      </p>
      <div class="function">
         <h6>entryObj.prepare(fn)</h6>
         <div class="desc">
            Registers a callback function that will be called right before the entry starts executing.
            Your callback will have access to the current context and should prepare all the required
            information.
         </div>
      </div>
      <div class="function">
         <h6>entryObj.action(name, fn)</h6>
         <div class="desc">
            Registers a new action that can be later scheduled to run with the given context.
            A task action should encapsulate specific functionality that other actions might use.
         </div>
      </div>
      <div class="function">
         <h6>entryObj.schedule(actions, opt)</h6>
         <div class="desc">
            Given an array of actions, it will schedule their execution in the specified order.
            This will defined <i>what</i> and <i>when</i> gets executed.
         </div>
         <ul class="arguments">
            <li>
               <b>actions</b><span class="type">array(string)</span> an array of action names that were previously registered, to be executed in the specific order
            </li>
            <li>
               <b>opt.delay</b><span class="type">string</span> the amount of time to delay the execution of the task since the application boot.
            </li>
            <li>
               <b>opt.timer</b><span class="type">string</span>the amount of time between task re-execution. This essentially marks the task as recurring.
            </li>
            <li>
               <b>opt.at</b><span class="type">string</span>the fixed point in time when the action should be executed. (hh:mm:ss)
            </li>
            <li>
               <b>opt.on</b><span class="type">string, month-start, month-end</span>the date when the task should be executed. Currently only month-start and month-end.
            </li>
            <li>
               <b>opt.timeout</b><span class="type">string</span>how much time to pass before we consider the action timed out and failed
            </li>
         </ul>
         <div class="notes">
            Time representation has the <code>hh:mm:ss</code> format or <code>{days}d {hours}h {minutes}m {seconds}s</code> and can be found below:<br/>
            <code>delay: '2m'</code> delays next execution by 2 minutes<br/>
            <code>timer: '10s'</code> executes the task every 10 seconds<br/>
            <code>at: '10:30'</code> executes the task every day at 10:30<br/>
            <code>timer: '2h30m'</code> executes the task every 2 hours and 10 minutes
         </div>
      </div>
      <div class="function">
         <h6>entryObj.handle(event, fn)</h6>
         <div class="desc">
            Registers a callback handler for the given task event. Task events ara explained bellow
         </div>
         <ul class="arguments">
            <li>
               <code>failed</code> - triggered when the task has encountered an error.
            </li>
            <li>
               <code>completed</code> - triggered when the task has completed all its scheduled actions.
            </li>
            <li>
               <code>timeout</code> - triggered when the action failed to complete before the given timeout period
            </li>
            <li>
               <code>stop</code> - triggered when the action was programatically stopped from the context.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>entryObj.start(delay)</h6>
         <div class="desc">
            Manually start the task's scheduled actions.
         </div>
      </div>
      <div class="function">
         <h6>entryObj.stop()</h6>
         <div class="desc">
            Stops the task from executing any further.
         </div>
      </div>
      <div class="function">
         <h6>entryObj.runAction(name)</h6>
         <div class="desc">
            Manually runs the given action name with an empty context, internal function.
         </div>
      </div>
      <div class="function">
         <h6>entryObj.createContext(names, opt)</h6>
         <div class="desc">
            Creates a new context and runs it through the specified actions, internal function.
         </div>
      </div>


      <h5 class="padding-top">The <code>TaskContext</code> class</h5>
      <p>
         You use the task context to attach context-specific information about your
         currently running task.
      </p>
      <div class="function">
         <h6>contextObj.took() : Number</h6>
         <div class="desc">
            Returns the number of milliseconds the context was active
         </div>
      </div>
      <div class="function">
         <h6>contextObj.stop()</h6>
         <div class="desc">
            Stops the context from running further. Any action that was scheduled to run after this, will no longer do so.
         </div>
      </div>
      <div class="function">
         <h6>contextObj.delay(sec)</h6>
         <div class="desc">
            Delays the next execution of the task with the given number of seconds.
         </div>
      </div>

      <h5 class="padding-top">Example</h5>
      <pre>
<code class="javascript">'use strict';
const taskPlugin = thorin.plugin('tasks');
const myTask = taskPlugin.addTask('my.task.right.here');

myTask
   .prepare((context) => {
      // Set any context information.
      context.items = [];
      context.processed = 0;
   })
   .action('dequeue', (context) => {   // Return a promise to signal the action completion.
      return new Promise((resolve, reject) => {
         log.info('Should dequeue');
         context.items.push("myItem");
         resolve();
      });
   })
   .action('process', (context) => {   // If returns undefined, go to next action automatically.
      if(context.items.length === 0) return;
      context.items.forEach((item) => {
         log.info('Processing item ', item);
         context.processed++;
      });
   })
   .action('release', (context) => {
      if(context.processed === 0) return;
      log.info('Releasing items');
      context.items = [];
   });
// Schedule the way our actions will be executed and when
myTask.schedule([
   'dequeue',
   'process',
   'release'
], {
   delay: '2s',
   timer: '40s',
   timeout: '30s'
});
// Listen for any events.
myTask
   .handle('completed', (context) => {
      log.info('Processed: ', context.processed);
   })
   .handle('failed', (context, err) => {
      log.warn(`Failed to finalize task`, err);
   });
</code></pre>
   </div>
{% endblock %}