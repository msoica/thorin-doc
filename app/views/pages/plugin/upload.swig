{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-upload') }}
         plugin-upload
      </h2>
      <p>
         The upload plugin empowers your thorin application to handle file uploads. In order for it to work,
         your application must use a <b>http</b> transport. Behind the scenes, the plugin uses <a href="https://npmjs.com/package/busboy" target="_blank">busboy</a> to handle file uploading.
         You also must specify the store solution to use for uploads. We currently only offer the AWS S3 one.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the upload plugin
npm i --save thorin-plugin-upload@1.x
# install the aws upload storage
npm i --save thorin-plugin-upload-aws@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');
// Register the plugins
thorin
   .addPlugin(require('thorin-plugin-upload'))
   .addPlugin(require('thorin.plugin-upload-aws'));

// Make the upload plugin use the upload-aws for storage.
thorin.on(thorin.EVENT.RUN, 'plugin.upload', (pluginObj) => {
   pluginObj.registerStorage('aws', thorin.config('aws'));
});
thorin.run((err) => {});
</code>
<code class="bash"># update config/app.js with your configuration</code></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>transport</b><span class="type">http</span>the name of the http transport
         </li>
         <li>
            <b>limits.fieldNameSize</b><span class="type">120</span>the maximum field name size in bytes
         </li>
         <li>
            <b>limits.fieldSize</b><span class="type">512000</span> the maximum field size.
         </li>
         <li>
            <b>limits.fileSize</b><span class="type">20 * 1000000</span>the maximum file size, defaults to 20MB
         </li>
         <li>
            <b>limits.files</b><span class="type">1</span>the maximum number of files allowed to be uploaded at once. We recommend only one.
         </li>
         <li>
            <b>limits.headerPairs</b><span class="type">120</span>the maximum number of HTTP headers
         </li>
      </ul>
      <h5>Default storage configuration</h5>
      <p>The upload storage configuration for AWS should be placed under the <b>aws</b> config key in your application configuration.</p>
      <ul class="arguments">
         <li>
            <b>key</b><span class="type">string</span>the Amazon accessKeyId
         </li>
         <li>
            <b>secret</b><span class="type">string</span>the Amazon secretAccessKey
         </li>
         <li>
            <b>signatureVersion</b><span class="type">v4</span>the signature version to use
         </li>
         <li>
            <b>bucket</b><span class="type">string</span>the bucket name to use
         </li>
         <li>
            <b>region</b><span class="type">string</span>the region name to use
         </li>
      </ul>
      <pre><code class="javascript">'use strict';
// File: config/app.js
module.exports = {
   "plugin.upload": {
      "limits": {
         fileSize: 30 * 1000000  // make it 30MB
      }
   },
   "aws": {
      accessKeyId: 'YOUR_ACCESS_KEY_ID',
      secretAccessKey: 'YOUR_SECRET_ACCESS_KEY',
      bucket: 'YOUR_BUCKET',
      region: 'eu-central-1'
   }
};
</code></pre>
      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.File</h6>
         <div class="desc">
            The <code>FileUpload</code> class used while uploading a file
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.IStorage</h6>
         <div class="desc">
            The storage interface exposed by the plugin. If you want to work with your own storage solution, make sure to
            implement this interface.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.addHandler(name, uploadPath)</h6>
         <div class="desc">
            Registers a new upload handler that works almost as a <code>thorin.Action</code>
            but with a few other functionalities. This will return a <code>UploadHandler</code> instance.
         </div>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the name of the upload action.
            </li>
            <li>
               <b>uploadPath</b><span class="type">string</span>the HTTP POST alias for the upload path
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.registerStorageClass(type, StorageClass)</h6>
         <div class="desc">
            Registers a new storage class that can then later be used as the storage solution of a file upload.
         </div>
         <ul class="arguments">
            <li>
               <b>type</b><span class="type">string</span>the type of the storage solution, eg. aws
            </li>
            <li>
               <b>StorageClass</b><span class="type">implements pluginObj.IStorage</span>the storage class that implements the upload functionality
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.registerStorage(type, name, config)</h6>
         <div class="desc">Creates and caches an instance of the given storage class type. Ways of calling:</div>
         <ul>
            <li>
               <code>registerStorage(type, instanceName, config)</code>
            </li>
            <li>
               <code>registerStorage(type, config)</code>
            </li>
            <li>
               <code>registerStorage(storageInstanceObj)</code>
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>pluginObj.getStorage(name)</h6>
         <div class="desc">
            Returns a previously registered storage instance by its name.
         </div>
      </div>

      <h5 class="padding-top">The <code>UploadHandler</code> class</h5>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>path</b><span class="type">string</span>the upload path as the alias of the action
            </li>
            <li>
               <b>fieldName</b><span class="type">string, asset</span>the name of the form field that will contain the upload file
            </li>
            <li>
               <b>mimeTypes</b><span class="type">array(string)</span>an array of allowed file mimeTypes
            </li>
            <li>
               <b>extensions</b><span class="type">array(string)</span>an array of allowed file extensions
            </li>
            <li>
               <b>limits</b><span class="type">object</span>action-specific limits to apply to file uploads. See <code>limits</code> options above.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>handlerObj.mimeType(type)</h6>
         <div class="desc">
            Adds the given mime type as an allowed mimeType
         </div>
      </div>
      <div class="function">
         <h6>handlerObj.field(name)</h6>
         <div class="desc">
            Manually set the field name that will contain the file (by default, asset)
         </div>
      </div>
      <div class="function">
         <h6>handlerObj.limit(key, val)</h6>
         <div class="desc">
            Manually update the default limitations.
         </div>
      </div>
      <div class="function">
         <h6>handlerObj.storage(val)</h6>
         <div class="desc">
            Set the default storage provider to use for the actual file uploading.
         </div>
         <ul>
            <li>
               <code>storage(storageInstanceName=string)</code>
            </li>
            <li>
               <code>storage(fn) => storageInstanceName = fn(intentObj, fileObj)</code>
            </li>
            <li>
               <code>storage(fn) => storageInstanceObj = fn(intentObj, fileObj);</code>
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>handlerObj.upload(fn)</h6>
         <div class="desc">
            Registers the callback function that will be called when a file is being processed by busboy. The handler
            will be called with <code>fn(fileObj, next)</code>
         </div>
      </div>


      <h5 class="padding-top">The <code>FileUpload</code> class</h5>
      <div class="function">
         <h6>Properties</h6>
         <ul class="arguments">
            <li>
               <b>name</b><span class="type">string</span>the name of the file that will be uploaded
            </li>
            <li>
               <b>size</b><span class="type">number</span>the size of the file that is being uploaded. It is set once the upload is complete.
            </li>
            <li>
               <b>mimeType</b><span class="type">string</span>the mimeType of the file.
            </li>
            <li>
               <b>encoding</b><span class="type">string</span>the file encoding
            </li>
            <li>
               <b>key</b><span class="type">string, random</span>the unique upload key that will be used as the file's key
            </li>
            <li>
               <b>folder</b><span class="type">string</span>the name of the folder that the file will be placed in.
            </li>
            <li>
               <b>options</b><span class="type">object</span>additional storage-specific options.
            </li>
         </ul>
      </div>
      <div class="function">
         <h6>fileObj.getStream()</h6>
         <div class="desc">Returns the ReadableStream of the incoming file upload</div>
      </div>
      <div class="function">
         <h6>fileObj.toJSON()</h6>
         <div class="desc">
            Returns the JSON representation of the file. Default object contains <code>url, size</code> properties.
         </div>
      </div>
      <div class="function">
         <h6>fileObj.fileTooLarge()</h6>
         <div class="desc">
            Marks the file as being too large and stops its processing.
         </div>
      </div>
      <div class="function">
         <h6>fileObj.setFolder(path)</h6>
         <div class="desc">
            Sets the folder hierarchy of the file.
         </div>
      </div>
      
      <div class="function">
         <h6>fileObj.setOptions()</h6>
         <div class="desc">
            Sets additional options that will be read by the storage class.
         </div>
      </div>
      <div class="function">
         <h6>fileObj.getKey()</h6>
         <div class="desc">
            Constructs the entire file key, used by the storage class.
         </div>
      </div>
      
      <h5 class="padding-top">The <code>pluginObj.IStorage</code> storage interface</h5>
      <p>This is the storage interface that has to be implemented for custom storage options.</p>
      <div class="function">
         <h6>constructor(name)</h6>
      </div>
      <div class="function">
         <h6>save(fileObj, opt) : Promise</h6>
         <div class="desc">
            This will be called with a <code>UploadFile</code> object, that contains a stream.
            It is supposed to return a promise that will attach the full URL to the
            UploadFile instance and the file size if possible.
         </div>
      </div>
      <div class="function">
         <h6>canRemove(fileUrl) : Boolean</h6>
         <div class="desc">
            This will check if the current storage option was saved to store the given
            file. For example. my-bucket.s3.amazonaws.com/1.jpg would return true
            for storages that use my-bucket and false otherwise.
         </div>
      </div>
      <div class="function">
      <h6>remove(fileUrl) : Promise</h6>
      <div class="desc">
         This will remove the actual fileUrl from the server, returning a promise.
      </div>
      
      <h5 class="padding-top">Full example handler</h5>
<pre><code class="javascript">'use strict';

const uploadObj = thorin.plugin('upload'),
  logger = thorin.logger('upload');

uploadObj
  .addHandler('upload.image', '/upload/image')   // the POST /upload/image alias
  .template('session.account')   // inherit authorization from a session.account action template
  .enableCors()                  // enable CORS for the file uploading
  .limit('fileSize', '2mb')      // limit to 2MB
  .mimeType('image/*')           // accept only images
  .extension('jpg', 'jpeg', 'png')  // of type jpeg and png
  .storage('aws')                   // use the AWS storage class
  .upload((intentObj, fileObj, next) => {
    const account = intentObj.session.account;
    fileObj.setFolder(`account/${account.id}`); // change the folder of the image
    next();
  })
  .use((intentObj) => {
    const fileObj = intentObj.data('file');
    intentObj.result(fileObj).send();  // return the url of the file.
    logger.trace('Uploaded image for account ' + intentObj.session.account.id);
  });
  // The final URL of the image would be https://bucket.eu-west-1.amazonaws.com/account/2/randomKeyRightH3r3.jpg

</code></pre>

   </div>
{% endblock %}