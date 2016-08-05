{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-store-elastic') }}
         store-elastic
      </h2>
      <p>
         The ElasticSearch store is a wrapper over <a href="https://www.npmjs.com/package/elasticsearch" target="_blank">elasticsearch</a>
         that provides a small abstraction layer between your application and ElasticSearch. It is currently under development
         and features will be added in the future. For the full API documentation, visit <a href="https://www.elastic.co/guide/en/elasticsearch/client/javascript-api/current/api-reference.html" target="_blank">the official docs</a>
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-store-elastic@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addStore(require('thorin-store-elastic'));   // <- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run to setup the database and module
node app.js --setup=store.elastic
</code></pre>
      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>debug</b><span class="type">true</span>if set to false, disables debugging completely. Can also be an object (see below)
         </li>
         <li>
            <b>debug.create</b><span class="type">true</span> enable debugging for document creation
         </li>
         <li>
            <b>debug.read</b><span class="type">true</span> enables debugging for document retrievals
         </li>
         <li>
            <b>debug.update</b><span class="type">true</span> enables debugging for document updates
         </li>
         <li>
            <b>debug.delete</b><span class="type">true</span> enables debugging for document removals
         </li>
         <li>
            <b>clients</b><span class="type">['http://localhost:9200']</span> an array of ElasticSearch clients to connect to. Can also use array of client objects (see docs)
         </li>
         <li>
            <b>headers</b><span class="type">null</span>an object containing key-value HTTP Headers to send on each request.
         </li>
         <li>
            <b>username</b><span class="type">null</span>the store username to use together with password, for basic auth
         </li>
         <li>
            <b>password</b><span class="type">null</span>the store password used for basic auth
         </li>
         <li>
            <b>options</b><span class="type"><i>default options</i></span> additional ElasticSearch options.
         </li>
      </ul>

      <h5 class="padding-top">Store functionality</h5>
      <div class="function">
         <h6>storeObj.client</h6>
         <div class="desc">
            Expose the actual ElasticSearch client connection for manual querying.
         </div>
      </div>
      <div class="function">
         <h6>storeObj.createIndex(name, opt) : Promise</h6>
         <div class="desc">Creates a new index with the given name and options.</div>
      </div>
      <div class="function">
         <h6>storeObj.deleteIndex(name) : Promise</h6>
         <div class="desc">Deletes the given index by its name.</div>
      </div>
      <div class="function">
         <h6>storeObj.existsIndex(name, opt)</h6>
         <div class="desc">Verifies if the given index name exists</div>
      </div>
      <div class="function">
         <h6>storeObj.getIndexes(opt) : array(string)</h6>
         <div class="desc">Returns an array of index names that exist in the store.</div>
      </div>
      <div class="function">
         <h6>storeObj.getIndex(name) : ESIndex</h6>
         <div class="desc">
            Returns the information of an index, wrapped inside an <code>ESIndex</code> object
         </div>
      </div>

      <h5 class="padding-top">ESIndex class</h5>
      <p>
         The <code>ESIndex</code> class is offers specific functionality to manage index-specific actions.
      </p>
      <div class="function">
         <h6>create(type, data, opt) : Promise</h6>
         <div class="desc">
            Creates a new document inside the current index, giving it the specified type and associated data.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>data</b><span class="type">object</span> the associated document data
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional create options found in the ES docs.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>createBulk(type, items, opt) : Promise</h6>
         <div class="desc">
            Performs a bulk insert of documents with the given type. <code>Items</code> is an array of data objects associated
            for each document that should be created.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document types
            </li>
            <li>
               <b>items</b><span class="type">array(object)</span> an array with objects containing the data we want to insert.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional create options found in the ES docs.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>find(type, query, raw) : Promise</h6>
         <div class="desc">
            Finds a single document filtered by its type and search query
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>query</b><span class="type">object</span>the query to apply
            </li>
            <li>
               <b>raw</b><span class="type">boolean, false</span>use raw ElasticSearch query and not store-processed query
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>count(type, query, raw) : Promise</h6>
         <div class="desc">
            Returns the number of documents matching the given type and query
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>query</b><span class="type">object</span>the query to apply
            </li>
            <li>
               <b>raw</b><span class="type">boolean, false</span>use raw ElasticSearch query and not store-processed query
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>findAll(type, query, raw) : Promise</h6>
         <div class="desc">
            Returns all the documents that match the given type and search query.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>query</b><span class="type">object</span>the query to apply
            </li>
            <li>
               <b>raw</b><span class="type">boolean, false</span>use raw ElasticSearch query and not store-processed query
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>update(type, id, data, opt) : Promise</h6>
         <div class="desc">
            Updates the document of the given type and id, with the given data.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>id</b><span class="type">string</span>the document id
            </li>
            <li>
               <b>data</b><span class="type">object</span>object containing the fields we want to update.
            </li>
            <li>
               <b>opt</b><span class="type">object</span> additional ES options, see docs.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>destroy(type, id) : Promise</h6>
         <div class="desc">Destroys the document of the given type and id</div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span> the document type
            </li>
            <li>
               <b>id</b><span class="type">string</span>the document id
            </li>
         </ul>
      </div>
   </div>
{% endblock %}