{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         thorin-store-sql
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-store-http') }}
      </h2>
      <p>
         The SQL store is a wrapper over <a href="http://docs.sequelizejs.com/en/latest/" target="_blank">sequelize</a> that
         provides a more user friendly interface of defining entity models, automatically
         handling CRUD actions on an entity, with paginated find.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-store-sql@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addStore(require('thorin-store-sql'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run to setup the database and module
node app.js --setup=store.sql
# On each database reset, use the above command</code></pre>
   
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>debug</b><span class="type">true</span>if set to false, disables debugging completely. Can also be an object (see below)
         </li>
         <li>
            <b>debug.create</b><span class="type">true</span> enable debugging for INSERT statements
         </li>
         <li>
            <b>debug.read</b><span class="type">true</span> enables debugging for SELECT statements
         </li>
         <li>
            <b>debug.update</b><span class="type">true</span> enables debugging for UPDATE statements
         </li>
         <li>
            <b>debug.delete</b><span class="type">true</span> enables debugging for DELETE statements
         </li>
         <li>
            <b>debug.restify</b><span class="type">true</span> enables debugging for restified entities (see below)
         </li>
         <li>
            <b>host</b><span class="type">localhost</span> the SQL hostname
         </li>
         <li>
            <b>user</b><span class="type">null</span> the SQL username
         </li>
         <li>
            <b>password</b><span class="type">null</span>the SQL password
         </li>
         <li>
            <b>database</b><span class="type">null</span>the SQL database
         </li>
         <li>
            <b>path.models</b><span class="type">thorin.root + app/models</span> the location of the store model definitions that will be auto-loaded
         </li>
         <li>
            <b>path.patch</b><span class="type">thorin.root + app/models/patch</span> the location of <i>.sql</i> patch files that will be executed on setup
         </li>
         <li>
            <b>options</b><span class="type">object</span> sequelize specific options
         </li>
         <li>
            <b>options.dialect</b><span class="type">mysql</span>the default dialect that we use is MySQL
         </li>
         <li>
            <b>options.timezone</b><span class="type">+00:00</span>the default timezone is UTC
         </li>
         <li>
            <b>options.pool.maxIdleTime</b><span class="type">12000</span>the maximum idle time of a connection set to 12 seconds
         </li>
      </ul>
      <div class="desc">
         For a complete set of options you can pass to Sequelize, visit <a href="http://docs.sequelizejs.com/en/latest/api/sequelize/#class-sequelize" target="blank"> the official docs</a>
      </div>
      
      <h5 class="padding-top">Store functionality</h5>
      <div class="function">
         <h6>storeObj.getSequelize() : Sequelize</h6>
         <div class="desc">
            Returns the Sequelize module. This is useful when your queries include specific sequelize statements or require access
            to the Sequelize module.
         </div>
         <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql'),
   Sequelize = storeObj.getSequelize();   // returns the exported object from require('sequelize');
</code></pre>
      </div>
      <div class="function">
         <h6>storeObj.getInstance() : seqObj</h6>
         <div class="desc">
            Returns the Sequelize instance containing connection details and other information. This should be
            used when access to the raw Sequelize instance is necessray.
         </div>
         <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql'),
   seqObj = storeObj.getInstance(); // returns the equivallent of new (require('sequelize'))()</code></pre>
      </div>
      <div class="function">
         <h6>storeObj.query() : Promise</h6>
         <div class="desc">
            Manually execute an SQL query using sequelize's native query() function.
         </div>
      </div>
      <div class="function">
         <h6>storeObj.setup() : Promise</h6>
         <div class="desc">
            When your application is started with <code>--setup=store.sql</code> or <code>--setup=all</code>, the SQL store will
            reset the database structure, essentially performing a DROP CREATE on all your models. <br/>
            <b>DO NOT USE ON A PRODUCTION SERVER</b> as it will wipe out all the database. Useful in development however.<br/>
            The way it initializes the setup process is described below
         </div>
         <ul class="numbered">
            <li>Connect to the database</li>
            <li>Sets foreign key check to false</li>
            <li>Extracts all tables that exist in the database</li>
            <li>Performs a drop on every table</li>
            <li>Calls Sequelize's <code>sync()</code> function to re-create tables</li>
            <li>Reads any <i>.sql</i> file from the patch folder if any.</li>
            <li>For each patch file, execute the statements (note: statements are delimited by a <b>new line</b>)</li>
            <li>Sets foreign key check to true</li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.sync(model, opt)</h6>
         <div class="desc">Manually execute the sequelize sync() operation on the model or the entire database.</div>
         <ul class="arguments">
            <li>
               <b>model</b><span class="type">string</span>if specified, synchronise only the given model name
            </li>
            <li>
               <b>opt</b><span class="type">object</span>additional sync options (see Sequelize documentation)
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.addModel(item)</h6>
         <div class="desc">
            Registers a new store model. This function should be done <b>before</b> the <code>run()</code> 
            function of the store is called.
         </div>
         <ul class="arguments">
            <li>
               <b>item</b><span class="type">string</span> when used as string, we will use it as the absolute path of the model file.
            </li>
            <li>
               <b>item</b><span class="type">function</span> when used as a function, we will consider the function as the exported model function (see below).
            </li>
         </ul>
         <div class="notes">
            Ways of calling addModel:
            <ul>
               <li><code>storeObj.addModel('/path/to/my/model.js')</code> the store will require() the path and load it up (see below the loading procedure)</li>
               <li><code>storeObj.addModel({name, code, fullPath})</code> use the name and code as the model's properties, and use the fullPath as the model's absolute path</li>
            </ul>
            The store will automatically load all the models of your application, so you do not have to handle manual model loading. However,
            if you are writing a thorin component, the standard way of adding a model is<br/>
            <pre><code class="javascript">'use strinct';
function buildModel(modelObj, Seq) {
   modelObj
      .field('id', Seq.PRIMARY);
   // other model settings
}
thorin.store('sql').addModel(buildModel, {
   code: 'myModelCode',    // the model code
   name: 'my_model_code'   // the table name
});
</code></pre>
         </div>
      </div>
      <div class="function">
         <h6>storeObj.setPatchPath(path)</h6>
         <div class="desc">Manually set the absolute location of your patch files</div>
         <ul class="arguments">
            <li>
               <b>path</b><span class="type">string</span>the absolute path of your patch folder. All <b>.sql</b> files will be loaded and executed
               as patches.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.transaction(fn, opt)</h6>
         <div class="desc">
            Initialize an SQL transaction that can be committed or rolled back (see <a href="see http://docs.sequelizejs.com/en/latest/docs/transactions" target="blank">more details here</a>)
         </div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span>the callback function that will be called with the <code>transaction</code> object.
            </li>
            <li>
               <b>opt</b><span class="type">object</span>additional options to pass to sequelize's transaction.
            </li>
         </ul>
         <div class="notes">
            The transaction callback works with promises and promise chains. The moment a promise is rejected, the transaction automatically rolls back. An example can be viewed below.
            <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql');
storeObj.transaction((t) => {
   const calls = [];
   let accObj;
   calls.push(() => {
      return storeObj.model('account').find({
         where: {id: 1},
         transaction: t
      }).then((aObj) => {accObj = aObj});
   });
   calls.push((stop) => {
      if(!accObj) return stop(thorin.error('ACCOUNT.NOT_FOUND');
      return accObj.update({is_active: true}, { transaction: t })
   });
   return thorin.series(calls);  // returns a promise
}).then((res) => {
   // transaction committed.
}).catch((err) => {
   // transaction rolled back.
});
</code></pre>
               
         </div>
      </div>
      <div class="function">
         <h6>storeObj.decamelize(str)</h6>
         <div class="desc">helper function that converts camelCase to camel_case</div>
         <ul class="arguments">
            <li>
               <b>str</b><span class="type">string</span>the string to de-camelize
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>storeObj.camelize(str)</h6>
         <div class="desc">helper function that converts camel_case to camelCase</div>
         <ul class="arguments">
            <li>
               <b>str</b><span class="type">string</span>the string to camelize
            </li>
         </ul>
      </div>
      
      <h5 class="padding-top">Model restification</h5>
      <p>
         TODO
      </p>
   </div>
{% endblock %}