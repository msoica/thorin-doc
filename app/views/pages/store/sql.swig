{% extends "../layout.swig" %}
{% set title = "Thorin.js - sql store" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-store-http') }}
         store-sql
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
      <h5 class="padding-top">Store model</h5>
      <p>
         You use a store model to define the fields, indexes, static functions and json representation of your tables.
         Store models are wrapper over Sequelize's models, used for auto-loading dependencies and relations. By default,
         a model's toJSON will return all the fields under the <code>dataValues</code> property of the Sequelize
         model.In most cases, your application's models will be under the <b>app/models</b> folder and export a function that will be called when
         by the thorin store, when loading up and defining your models.
      </p>
      <p>
         The default conventions for when defining your models are:
      </p>
      <ul>
         <li>
            <b>modelCode</b> - the code of your models should <b>always</b> be camelCase
         </li>
         <li>
            <b>table_name</b> - the table name of your models should <b>always</b> be underscored
         </li>
         <li>
            <b>field_name</b> - all the fields of your models should <b>always</b> be underscored.
         </li>
         <li>
            <b>methodName</b> - all your methods and static functions should <b>always</b> be camelCase.
         </li>
      </ul>
      <div class="function">
         <h6>Properties</h6>
         <ul>
            <li>
               <b>tableName</b><span class="type">string</span> che property holds the name of the table associated with the model
            </li>
            <li>
               <b>code</b><span class="type">string</span> the code of your model
            </li>
            <li>
               <b>options.timestamps</b><span class="type">boolean, true</span> use timestamps for time-specific fields.
            </li>
            <li>
               <b>options.createdAt</b><span class="type">string, created_at</span> use a field called <code>created_at</code> that will always hold the creation date of every entry.
            </li>
            <li>
               <b>options.updatedAt</b><span class="type">string, false</span> whenever an instance is updated, use this field to set the current_timestamp.
            </li>
            <li>
               <b>options.deletedAt</b><span class="type">string, false</span> if set, the model will not use DELETE but rather UPDATE with is_active=false and deleted_at field
            </li>
         </ul>
         <div class="desc"></div>
      </div>
      <div class="function">
         <h6>options</h6>
         <div class="desc"></div>
      </div>
      <div class="function">
         <h6>field(name, type, opt)</h6>
         <div class="desc">
            Adds the given field representation to the model object's structure. The field <code>type</code> must be
            a Sequelize type and the <code>opt</code> can contain additional field-specific options.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the field name used in the database
            </li>
            <li>
               <b>type</b><span class="type">Sequelize type</span>field types exported by Sequelize (see more <a href="http://docs.sequelizejs.com/en/latest/docs/models-definition/#data-types" target="_blank">here</a>)
            </li>
            <li>
               <b>opt</b><span class="type">object</span>additional field-specific options.
            </li>
         </ul>
         <div class="notes">
             Custom non-sequelize types can be defined. Currently only <code>Seq.PRIMARY</code>, which proxies
             the <code>Seq.INTEGER</code> field having <code>autoIncrement</code> and <code>primaryKey</code> set to <code>true</code>
         </div>
         <pre class="notes"><code class="javascript">// Field calls can be chained.
modelObj
   .field('id', Seq.PRIMARY)
   .field('name', Seq.STRING(25), {
      defaultValue: 'JohnDow'
   })
   .field('type', Seq.ENUM('one','two'))
   .field('arrow', Seq.STRING, {
      allowNull: true
   });
</code></pre>
      </div>

      <div class="function">
         <h6>json(name, fn)</h6>
         <div class="desc">
            Registers a <code>toJSON</code> function that will be called when the model's toJSON function is called by a
            transport layer, or performing JSON.stringify() A model might contain multiple json functions, differentiated by their name (see below)
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span> if specified, the name of the json function
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the function that will override the default toJSON of an object.
            </li>
         </ul>
         <div class="notes">
            <b>Note</b> If you want to have access to <code>this</code> context, you <b>must not</b> use an arrow function.
         </div>
         <pre class="notes"><code class="javascript">// The JSON representation when calling instanceObj.toJSON()
modelObj.json(function() {
   return {
      id: this.id,
      name: this.name
   };
});
// The JSON representation when calling instanceObj.toJSON('specific');
modelObj.json('specific', function(){
   return {
      id: this.id,
      name: this.name,
      specific: true
   };
});</code></pre>
      </div>
      <div class="function">
         <h6>static(name, val)</h6>
         <div class="desc">
            Attaches a static property or function to the model. They will then be attached to the constructed Sequelize model.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string | function</span>the name of a static key or the static function
            </li>
            <li>
               <b>val</b><span class="type">any</span>when used with name, the value to attach to the static key.
            </li>
         </ul>
         <pre><code class="javascript">// Attach a static function
modelObj.static(function doStatic() {
   log.info('Do static stuff');
});
// Attach a named static function
modelObj.static('doStaticTwo', () => {
   log.info('Do two static stuffs');
});
// Attach an object
modelObj.static('TYPE', {
   SOME_KIND_OF: 'STATIC.VALUES'
});

// Somewhere else in your application
const store = thorin.store('sql'),
   myModel = store.model('myModel');

myModel.doStatic();  //  call or use the static functions
myModel.TYPE;  // contains the object.
</code></pre>
      </div>
      <div class="function">
         <h6>error(err)</h6>
         <div class="desc">Assign a static custom error to the model. This is a utility function that uses <code>static()</code></div>
         <ul class="arguments">
            <li>
               <b>err</b><span class="type">thorin.error</span> A thorin.error() or the equivalent arguments of the thorin.error() call
            </li>
         </ul>
         <div class="desc">
            There are a few ways of attaching errors:<br/>
            <code>modelObj.error('SOME_CODE', 'Some error message', 400);</code><br/>
            <code>modelObj.error(thorin.error('SOME.ERROR', 'Some message', 405);</code>
         </div>
      </div>
      <div class="function">
         <h6>method(name, fn)</h6>
         <div class="desc">Attach the given function to every <code>instance</code> of your model.</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string | function</span>the name of your method or a named function
            </li>
            <li>
               <b>fn</b><span class="type">function</span>when used with name, the callback function.
            </li>
         </ul>
         <pre><code class="javascript">// Attach the function to the instance of a model.
modelObj.method(function doSomething(){
   log.info('Do something for model ' + this.id);  // "this" is the model's instance scope.
});

// Somewhere in your app
const Model = thorin.store('sql').model('myModel');
let iObj = Model.build({id: 2});
iObj.doSomething();  // call the function of the model instance.
</code></pre>
      </div>
      <div class="function">
         <h6>setter(name, fn)</h6>
         <div class="desc">Attach a setter function to the model. See <a target="blank" href="http://docs.sequelizejs.com/en/latest/docs/models-definition/#getters-setters">here</a>.</div>
      </div>
      <div class="function">
         <h6>getter(name, fn)</h6>
         <div class="desc">Attach a getter function to the model. See <a target="blank" href="http://docs.sequelizejs.com/en/latest/docs/models-definition/#getters-setters">here</a>.</div>
      </div>

      <div class="function">
         <h6>index(fields, opt)</h6>
         <div class="desc">Defines a new index for your model.</div>
         <ul class="arguments">
            <li>
               <b>fields</b><span class="type">string | array(string)</span> the field name(s) to use in the index creation
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional index options. See Sequelize docs.
            </li>
         </ul>
         <pre><code class="javascript">modelObj.index('my_field'); // simple index
modelObj.index(['field_one', 'field_two'], { // multiple fields in a unique index.
   unique: true
});
</code></pre>
      </div>
      <div class="function">
         <h6>validate(fn)</h6>
         <div class="desc">Registers a validation function at the model level, called when an instance of the model is saved.</div>
         <ul class="arguments">
            <li>
               <b>fn</b><span class="type">function</span> the callback that handles registration.
            </li>
         </ul>
         <pre><code class="javascript">// Check if we have a name.
   // The validate function is synchronous, and errors thrown here will be returned by the transport.
modelObj.validate(function() {
   if(!this.name || this.name.length < 3) throw thorin.error('INVALID_NAME', 'Please enter a valid name');
});
</code></pre>
      </div>
      <div class="function">
         <h6>hook(type, fn)</h6>
         <div class="desc">Wrapper function to register model-specific hooks. For more information, see Sequelize's documentation</div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the hook type
            </li>
            <li>
               <b>fn</b><span class="type">function</span>the hook callback function
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>getPrimary()</h6>
         <div class="desc">Returns the primary key of the model. We currently only support one primary key per model</div>
      </div>
      <div class="function">
         <h6>isValid()</h6>
         <div class="desc">Checks if the model contains enough information about a table. A valid model
         must have at least one field and the table name.</div>
      </div>

      <p>
         You can define relationships between your models by using the functions below. The store takes care of model loading,
         so you do not have to keep any kind of variable references. We use the model's code as the reference.
      </p>
      <p>
         When an association is created, some default options are created:<br/>
         <code>onDelete: 'CASCADE'</code> - when associated entry is deleted, delete this one as well<br/>
         <code>onUpdate: 'CASCADE'</code> - when associated entry is updated, update the key as well.<br/>
         <code>foreignKey: 'target_model_id'</code> - the model's table_name with the primary key suffix, usually <b>_id</b><br/>
         For a more in-detail view on these associations, see <a target="blank" href="http://docs.sequelizejs.com/en/latest/docs/associations/">docs</a>.
      </p>
      <div class="function">
         <h6>belongsTo(name, opt)</h6>
         <div class="desc">
            Registers a belongsTo association between the current model and the given model.
         </div>
      </div>
      <div class="function">
         <h6>belongsToMany(name, opt)</h6>
         <div class="desc">
            Registers a belongsToMany association between the current model and the given model.
         </div>
      </div>
      <div class="function">
         <h6>hasOne(name, opt)</h6>
         <div class="desc">
            Registers a hasOne association between the current model and the given model.
         </div>
      </div>
      <div class="function">
         <h6>hasMany(name, opt)</h6>
         <div class="desc">
            Registers a hasMany association between the current model and the given model.
         </div>
      </div>
      <p>A full example of a model definition file can be viewed below.</p>
      <pre><code class="javascript">'use strict';
// File: app/models/account.js
module.exports = function(modelObj, Seq) {
   // modelObj is already created by the store, having the code set to account and tableName to account
   modelObj
      .field('id', Seq.PRIMARY)
      .field('name', Seq.STRING(30))
      .field('password', Seq.STRING(200)) // hashed version
      .field('image_url', Seq.STRING(300), {
         defaultValue: null   // this will automatically add allowNull: true
      });
      
   modelObj
      .method(function sayHi() {
         log.info(`${this.name} says hi!`);
      })
      .json(function() {
         let d = {
            id: this.id,
            name: this.name,
            created_at: this.created_at   // auto-generated field.
         };
         if(this.image_url) d.image_url = this.image_url;
         return d;
      })
      .error('NOT_FOUND', 'The account was not found', 404);
      
   modelObj
      .hasMany('application', {
         as: 'applications'
      });
}
</code>
<code class="javascript">'use strict';
// File: app/models/application.js
module.exports = (modelObj, Seq) => {
   modelObj
      .field('id', Seq.PRIMARY)
      .field('name', Seq.STRING)
      
   modelObj
      .belongsTo('account');
};
</code></pre>

      <h5 class="padding-top">Model <i>crudification</i></h5>
      <p>
         The SQL Store offers auto-generated CRUDF functionality in the form of actions. This means that
         in stead of you manually doing a findOne() or findAll() + count() on a model, you can just use
         <code>storeObj.crudify()</code> and an action with input validation based on your model definition 
         will be registered in the dispatcher.
      </p>
      <p>
         The process is simple, you just have to call <code>storeObj.crudify()</code> and it will return a generated
         action that you can extend and inject code in various steps along the way. The best way to inject code <b>before</b>
         the crudify function is to attach an <b>action template</b> to the generated crudify action. Note that filter
         triggering is <b>synchronous</b>, any error thrown inside the filter callback will stop the request.
      </p>
      <p>
         All model instances that are generated or altered by a crudify method will have a <code>fromCrudify=true</code> property 
         attached to them.
      </p>
      <p>
         Each crudify method will trigger specific <code>filters</code> in various points in time, during the lifecycle of the request.
         Using these filters enable you to alter incoming, outgoing or generated model instances.
      </p>
      <div class="function">
         <h6>storeObj.crudify(model, action, opt)</h6>
         <ul class="arguments">
            <li>
               <b>model</b><span class="type">string</span>the model code to use
            </li>
            <li>
               <b>actions</b><span class="type">string</span>the crudify action to use.
            </li>
            <li>
               <b>opt</b><span class="type">object</span>additional options used by the store.
            </li>
         </ul>
         <pre><code class="javascript">'use strict';
const storeObj = thorin.store('sql');         
storeObj
   .crudify('modelName', 'read', {
      namespace: 'some.namespace.to.attach',
      name: 'account'   // will generate an action called: some.namespace.to.attach.account.read
   })
   .filter('read.before', (intentObj, query) => { 
   // alter the read query to show only active modelName
      query.where.is_active = true;
   });
</code></pre>
      </div>
      <h5 class="padding-top"><b>Create</b> crudify</h5>
      <p>
         Handles the <b>CREATE</b> action of a store model. It will look for all the model fields
         and require them via the <code>input()</code> function of the generated action. By default,
         it will also create an alias <code>POST /{namespace}/{modelName}</code>.
      </p>
      <h6>Options</h6>
      <ul class="arguments">
         <li>
            <b>namespace</b> - override the default namespace of the action
         </li>
         <li>
            <b>name</b> - override the default model name used to build the final action name
         </li>
         <li>
            <b>action</b> - manually set the full action name
         </li>
      </ul>
      <h6>Model field options</h6>
      <ul class="arguments">
         <li><b>private</b> - if set to trueon a field, do not accept data associated with the field, coming from the client. (eg: password field should have private: true)</li>
         <li><b>create</b> - same as private.
      </ul>
      <h6>Filters</h6>
      <div class="function plain">
         <h6>create.before(intentObj, newInstanceObj)</h6>
         <div class="desc">
         Triggered when a new instance was built but not yet persisted to the database
         </div>
      </div>
      <div class="function plain">
         <h6>create.after(intentObj, savedInstanceObj)</h6>
         <div class="desc">
         Triggered right after the newly created instance was persisted to the database.
         </div>
      </div>
      <div class="function plain">
         <h6>create.send(intentObj)</h6>
         <div class="desc">
         Triggered right after the newly saved instance was place under the intent's <code>result</code> and ready to finalize the action.
         </div>
      </div>
      <pre><code class="javascript">'use strict';
const store = thorin.store('sql');
store
  .crudify('application', 'create')
  .template('session.account')
  .use('application.canCreate')
  .use((intentObj, next) => {
    if(intentObj.session.account) {
      intentObj.input('account_id', intentObj.session.account);
    }
    log.info(`Creating a new application`);
    next();
  })
  .filter('create.before', (intentObj, appObj) => {
    // override any is_administrative fields in the form.
    appObj.set('is_administrative', false);
  })
  .filter('create.after', (intentObj, appObj) => {
     log.info(`Application ${appObj.id} created`);
  });
</code></pre>


      <h5 class="padding-top"><b>Read</b> crudify</h5>
      <p>
         Handles the <b>READ</b> action of a store model. It essentially builds an action that will perform a <code>SELECT</code> or <code>findOne()</code>
         a model based on the incoming primary key (eg, id) and limit the results to one. By default, it will also
         create an alias <code>GET /{namespace}/{modelName}/:{primaryKey}</code>.
      </p>
      <h6>Options</h6>
      <ul>
         <li><b>namespace</b> override the default namespace of the action</li>
         <li><b>name</b> override the default model name used to build the final action name</li>
         <li><b>action</b> manually set the full action name</li>
      </ul>
      
      <h6>Filters</h6>
      <div class="function plain">
         <h6>read.before(intentObj, findQuery)</h6>
         <div class="desc">
         Triggered when the Sequelize find query object was generated, before sending it to the SQL server. This is where you
         can manually alter the query by adding other query statements.
         </div>
      </div>
      <div class="function plain">
         <h6>read.after(intentObj, instanceObj)</h6>
         <div class="desc">
         Triggered right after the query was executed and a valid entity instance was found.
         </div>
      </div>
      <div class="function plain">
         <h6>create.send(intentObj)</h6>
         <div class="desc">
         Triggered right after the queried instance was place under the intent's <code>result</code> and ready to finalize the action.
         </div>
      </div>
      
      
      <h5 class="padding-top"><b>Find</b> crudify</h5>
      <p>
         Handles the <b>FIND</b> action of a store model. It essentially builds an action that will perform a <code>SELECT</code> or <code>findAll()</code>
         on a model, including <b>filtering</b> by public fields of a model. The default functionality includes <b>sorting</b>, <b>pagination</b> and <b>field filtering</b>
      </p>
      <h6>Options</h6>
      <ul>
         <li><b>namespace</b> override the default namespace of the action</li>
         <li><b>name</b> override the default model name used to build the final action name</li>
         <li><b>action</b> manually set the full action name</li>
         <li><b>maxLimit</b> the maximum value of the <code>LIMIT</code> statement.
      </ul>
      <h6>Special input options</h6>
      <p>
         When the action is generated, specific input fields will be injected by the crudification. These will allow you
         to perform the above mentioned actions. Any public model field will also be placed as an input and can filter the results.
      </p>
      <ul class="arguments">
         <li><b>order</b> - the direction of the <code>ORDER BY</code> statement. Values are: <i>asc, desc</i>, default to <i>asc</i></li>
         <li><b>order_by</b> - the name of the field to order by, defaults to <i>created_at</i> if available.</li>
         <li><b>limit</b> - the number value of the <code>LIMIT</code> statement, defaults to 10</li>
         <li><b>page</b> - useful for pagination, if set, it will change the <code>LIMIT</code> statement to skip x entities and return the next data set.</li>
         <li><b>start_date</b> - if the model has a <i>createdAt</i> field, you can filter by its creation date (GTE)</li>
         <li><b>end_date</b> - same as start_date but applies for the end date (LTE)</li>
      </ul>
      <h6>Model field options</h6>
      <ul class="arguments">
         <li><b>private</b> - if set to true on a field, disables filtering based on the given field.</li>
         <li><b>find</b> - same as private.
      </ul>
      <h6>Associated metadata</h6>
      <p>The find crudified action will also generate some <i>metadata</i> that can be easily used for pagination. The below fields are 
      placed under the <b>meta</b> field in the resulting JSON</p>
      <ul class="arguments">
         <li><b>total_count</b> - total number of entities found</li>
         <li><b>page_count</b> - total number of available pages</li>
         <li><b>current_page</b> - the current page</li>
         <li><b>current_count</b> - the current number of entities</li>
      </ul>
      <h6>Filters</h6>
      <div class="function plain">
         <h6>find.before(intentObj, findQuery)</h6>
         <div class="desc">
         Triggered when the Sequelize find query object was generated, before sending it to the SQL server. This is where you
         can manually alter the query by adding other query statements.
         </div>
      </div>
      <div class="function plain">
         <h6>find.after(intentObj, [instances])</h6>
         <div class="desc">
         Triggered right after the query was executed and an array of model instances resulted.
         </div>
      </div>
      <div class="function plain">
         <h6>find.send(intentObj)</h6>
         <div class="desc">
         Triggered right after the queried instances were place under the intent's <code>result</code> and ready to finalize the action.
         </div>
      </div>
      
      
      
      <h5 class="padding-top"><b>Update</b> crudify</h5>
      <p>
         Handles the <b>UPDATE</b> action of a store model. It essentially builds an action that will perform an <code>UPDATE</code> statement on a model instance.
         This functionality only works for models that have <b>exactly one</b> primary key defined.
      </p>
      <h6>Options</h6>
      <ul>
         <li><b>namespace</b> override the default namespace of the action</li>
         <li><b>name</b> override the default model name used to build the final action name</li>
         <li><b>action</b> manually set the full action name</li>
      </ul>
      <p>
         The action will register all the accessible fields of the model as <i>input requirements</i>, using their associated field type.
      </p>
      <h6>Model field options</h6>
      <ul class="arguments">
         <li><b>private</b> - if set to true on a field, disables updates on the given field.</li>
         <li><b>update</b> - same as private.
      </ul>
      <h6>Associated metadata</h6>
      <ul class="arguments">
         <li><b>changed</b> - did any field of the instance change</li>
      </ul>
      <h6>Filters</h6>
      <div class="function plain">
         <h6>update.before(intentObj, findQuery)</h6>
         <div class="desc">
         Triggered when the Sequelize find query object was generated, before sending it to the SQL server. When we update an instance, we read the entity first. This is where you
         can manually alter the query by adding other query statements.
         </div>
      </div>
      <div class="function plain">
         <h6>update.save(intentObj, entityObj)</h6>
         <div class="desc">
         Triggered right <b>before</b> we persist the changes to the database.
         </div>
      </div>
      <div class="function plain">
         <h6>update.after(intentObj, updatedEntityObj)</h6>
         <div class="desc">
         Triggered right <b>after</b> all changes were persisted to the database.
         </div>
      </div>
      <div class="function plain">
         <h6>find.send(intentObj)</h6>
         <div class="desc">
         Triggered right after the updated instance was place under the intent's <code>result</code> and ready to finalize the action.
         </div>
      </div>
      
      
      
      
      <h5 class="padding-top"><b>Delete</b> crudify</h5>
      <p>
         Handles the <b>DELETE</b> action of a store model. It essentially builds an action that will perform a <code>DELETE</code> statement on a model instance.
         This functionality only works for models that have <b>exactly one</b> primary key defined.
      </p>
      <h6>Options</h6>
      <ul>
         <li><b>namespace</b> override the default namespace of the action</li>
         <li><b>name</b> override the default model name used to build the final action name</li>
         <li><b>action</b> manually set the full action name</li>
      </ul>
      <p>
         The action will register the model's <i>primary key name</i> as a required input with its associated type and use it to search for the entity we want to delete.<br/>
         If the entity instance has a <code>canDelete()</code> method attached, we will call it before destroying the entry. If it returns a falsy value, we will not delete it.
      </p>
      <h6>Associated metadata</h6>
      <ul class="arguments">
         <li><b>deleted</b> - was the instance deleted or not</li>
      </ul>
      <h6>Filters</h6>
      <div class="function plain">
         <h6>delete.before(intentObj, findQuery)</h6>
         <div class="desc">
         Triggered when the Sequelize find query object was generated, before sending it to the SQL server. When we delete an instance, we read the entity first. This is where you
         can manually alter the query by adding other query statements.
         </div>
      </div>
      <div class="function plain">
         <h6>delete.destroy(intentObj, entityObj)</h6>
         <div class="desc">
         Triggered right <b>before</b> we call the destroy() function of the instance.
         </div>
      </div>
      <div class="function plain">
         <h6>delete.after(intentObj, deletedEntityObj)</h6>
         <div class="desc">
         Triggered right <b>after</b> the entity was deleted from the database.
         </div>
      </div>
      <div class="function plain">
         <h6>delete.send(intentObj)</h6>
         <div class="desc">
         Triggered right after the action finalized and is preparing to send an empty result to the client.
         </div>
      </div>
   </div>
{% endblock %}