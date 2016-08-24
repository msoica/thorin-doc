{% extends "../layout.swig" %}
{% set title = "Thorin.js - mail plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-mail') }}
         plugin-mail
      </h2>
      <p>
         The mail plugin wraps itself over the <a href="https://npmjs.com/package/nodemailer">nodemailer</a> module to
         send out HTML templates. For the best experience, it should be used with the <b>render-plugin</b>,
         in order to define SWIG templates, render them dynamically and apply inline styling to them.
      </p>
      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the plugin
npm i --save thorin-plugin-mail@1.x
# install your preferred nodemailer transport, eg. mailgun
npm i --save nodemailer-mailgun-transport@1.x
</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-mail'));   // <-- add this line
thorin.run((err) => {});
</code>
<code class="bash"># run to setup folder structure
node app.js --setup=plugin.email
</code></pre>


      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>transport</b><span class="type">array(string)</span>an array of transport names to use. If sent as strings,
            we will do a require() for the modules, otherwise, we will consider the actual object as the transport.
         </li>
         <li>
            <b>options</b><span class="type">object</span> an object of {transportKey:{transportOptions}}. If you use only <strong>one</strong> transport, it will use the direct options object.
         </li>
         <li>
            <b>from</b><span class="type">string</span>generic <i>from</i> e-mail address
         </li>
         <li>
            <b>templates</b><span class="type">string, app/emails</span>the swig e-mail template path, relative to thorin.root
         </li>
         <li>
            <b>render</b><span class="type">string, render</span>the name of the thorin render plugin.
         </li>
         <li>
            <b>enabled</b><span class="type">boolean, true</span>setting this to false will disable e-mail sending and just mock send.
         </li>
      </ul>
      <pre><code class="javascript">'use strict';
// File: config/app.js
module.exports = {
   "plugin.email": {
      "transport": "mailgun",
         "options": {
         "from": "John Doe &lt;no-reply@john-doc.com&gt;",
         "auth": {
            "domain": "mydomain.com",
            "api_key": "YOUR_API_KEY"
         }
      }
   }
};
</code></pre>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.prepare(opt, vars) : Promise</h6>
         <div class="desc">
            Prepares the given HTML or template, to be rendered, styled and parsed.
         </div>
         <ul class="arguments">
            <li>
               <b>opt</b><span class="type">string</span> if a string, the plain HTML to be prepared
            </li>
            <li>
               <b>opt</b><span class="type">object</span> if an object, should contain <code>html</code> or <code>template</code> keys.
            </li>
            <li>
               <b>vars</b><span class="type">object</span>additional variables to send when using with template
            </li>
         </ul>
         <pre><code class="javascript">'use strict';
const pluginObj = thorin.plugin('mail');
thorin.dispatcher
   .addAction('mail.preview')
   .alias('GET', '/preview/:template')
   .input({
      template: dispatcher.validate('STRING')
   })
   .use((intentObj, next) => {
      pluginObj
         .prepare(intentObj.input('template'), intentObj.rawInput)
         .then((html) => {
            intentObj.rawResult(html);
            next();
         }).catch(next);
   });
</code></pre>
      </div>

      <div class="function">
         <h6>pluginObj.send(opt, vars) : Promise</h6>
         <div class="desc">
            Send out custom e-mails to the given user. It will use the <code>prepare()</code> function to prepare the HTML,
            and use the specified transport to send out the e-mail.
         </div>
         <ul class="arguments">
            <li>
               <b>opt.to</b><span class="type">email</span> the email to send to
            </li>
            <li>
               <b>opt.from</b><span class="type">email</span>the from e-mail, defaults to the configured one.
            </li>
            <li>
               <b>opt.from_name</b><span class="type">string</span>the name in the from e-mail, default to the configured one.
            </li>
            <li>
               <b>opt.subject</b><span class="type">string</span>the email subject
            </li>
            <li>
               <b>opt.html</b><span class="type">string</span>the HTML text to send <strong>OR</strong>
            </li>
            <li>
               <b>opt.template</b><span class="type">string</span>the template path to render and use the output as the send html.
            </li>
            <li>
               <b>opt.text</b><span class="type">boolean, true</span>should we generate a text version of the email.
            </li>
            <li>
               <b>replyTo</b><span class="type">email</span>the reply-to e-mail
            </li>
            <li>
               <b>transport</b><span class="type">string</span>the transport to use, defaults to the first one available.
            </li>
         </ul>
         <pre><code class="javascript">'use strict';
const mailObj = thorin.plugin('mail');
thorin.dispatcher
  .addAction('mail.send')
  .input({
    to: dispatcher.validate('EMAIL').error('INVALID_EMAIL', 'Invalid to e-mail address'),
    subject: dispatcher.validate('STRING').default(null),
    template: dispatcher.validate('STRING').error('INVALID_TEMPLATE', 'Missing template'),
    params: dispatcher.validate('JSON').default({})
  })
  .use((intentObj, next) => {
    let data = intentObj.input();
    mailObj
      .send({
        to: data.to,
        subject: data.subject,
        template: data.template
      }, data.params)
      .then(() => {
        log.info(`Sent e-mail [${data.template}] to [${data.to}]`);
        next();
      })
      .catch((e) => {
        log.warn(`Failed to send e-mail [${data.template}] to [${data.to}]`);
        log.debug(e);
        next(e);
      });
  });

</code></pre>
      </div>
      <p>
         The plugin also registeres a custom middleware <b>mail#preview</b> which you can use
         to preview your e-mail templates in a development environment.
      </p>
      <pre><code class="javascript">'use strict';
if (thorin.env === 'development') {
thorin.dispatcher
   .addAction('email.template.preview')
   .alias('GET', '/mail/preview')
   .use('mail#preview');
   // access /mail/preview?template=your/template.swig
}
</code></pre>

   </div>
{% endblock %}