{% extends "../layout.swig" %}
{% set title = "Thorin.js" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-stripe') }}
         plugin-stripe
      </h2>
      <p>
         The plugin was designed to work with <a href="https://stripe.com" target="_blank">Stripe</a>, the payment processor.
         For the full Stripe Node.js documentation, visit <a href="https://stripe.com/docs/api/node" target="_blank">the official docs</a>.
         The documentation of this plugin is going to be updated soon.
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash"># install the plugin
npm i --save thorin-plugin-stripe@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-stripe'));   // <-- add this line
thorin.run((err) => {});
</code>
<code class="bash">#update config/app.js with your configuration</code>
<code class="bash"># run to setup the models and module
node app.js --setup=plugin.stripe
</code></pre></pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>publishKey</b><span class="type">process.env.STRIPE_PUBLISH_KEY</span>your account's publishable key
         </li>
         <li>
            <b>secretKey</b><span class="type">process.env.STRIPE_SECRET_KEY</span>your account's secret key
         </li>
         <li>
            <b>appName</b><span class="type">Stripe app</span>the application name that will appear in charge descriptions
         </li>
         <li>
            <b>store</b><span class="type">sql</span>the name of the SQL store to use
         </li>
         <li>
            <b>mode</b><span class="type">[subscription]</span> // the modes we will run the plugin, If no mode is set, we will not setup any db and will only be able to charge.
         </li>
         <li>
            <b>singleSubscription</b><span class="type">true</span>Enables single subscription mode, where an account belongs to a single subscription at once.
         </li>
         <li>
            <b>models.account</b><span class="type">account</span>the account table name that will be altered with Stripe-specific fields
         </li>
         <li>
            <b>models.plan</b><span class="type">stripe_plan</span>the stripe plan table name that will contain all your application's subscription plans
         </li>
         <li>
            <b>models.subscription</b><span class="type">stripe_subscription</span>the stripe subscription table name that will contain account subscriptions
         </li>
         <li>
            <b>models.charge</b><span class="type">stripe_charge</span>the name of the table that will hold up stripe charges.
         </li>
         <li>
            <b>fields.customer</b><span class="type">stripe_customer_key</span>the field an account will have that will store the stripe customer id
         </li>
         <li>
            <b>invoice.prefix</b><span class="type">null</span>the prefix of your application's invoices. This will be {YOURAPP}-102393848
         </li>
         <li>
            <b>invoice.length</b><span class="type">6</span>the max number of digits an invoice ID can have, eg: Eg: YOURAPP-000001
         </li>
         <li>
            <b>defaultPlan</b><span class="type">null</span>if set, the default plan code to set to an account when he downgrades his account (the free plan)
         </li>
         <li>
            <b>webhook.path</b><span class="type">/webhook/stripe</span>the PATH of your stripe's POST webhook. This is where Stripe will call with information about charges and subscriptions.
         </li>
         <li>
            <b>webhook.ips</b><span class="type">[]</span>an array of white-listed source IPs that Stripe uses. When run in setup, this will be populated with latest data.
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.createCharge(accountObj, charge) : Promise</h6>
         <div class="desc">
            Charges the account with the given charge information.
         </div>
         <ul class="arguments">
            <li>
               <b>accountObj</b><span class="type">accountObj</span> an instance of an accountObj that was previously registered as a stripe customer
            </li>
            <li>
               <b>charge.amount</b><span class="type">integer</span>the amount of <strong>cents</strong> to charge (eg: $5 is 500 cents)
            </li>
            <li>
               <b>charge.currency</b><span class="type">string, USD</span> the 3-char code of the currency to use
            </li>
            <li>
               <b>charge.description</b><span class="type">string</span>the description that will appear in the charge statement.
            </li>
            <li>
               <b>{Additional stripe options}</b>
            </li>
         </ul>
      </div>

      <h5 class="padding-top">Authorization middleware</h5>
      <div class="function">
         <h6>stripe#charge.read</h6>
         <div class="desc">
            Reads the stripe charge information, based on the stripe_charge store model. It will also fetch
            the charge information from Stripe.
         </div>
         <div class="desc">The authorization middleware will attach to the intent's data:</div>
         <ul>
            <li>
               <code>charge</code> the store's chargeObj entity
            </li>
            <li>
               <code>stripeCharge</code> the stripe charge entity associated with the local charge
            </li>
         </ul>
         <pre><code class="javascript">'use strict';
thorin.dispatcher.addAction('charge.view')
   .authorize('stripe#charge.read') // this requests charge_id in the input
   .use((intentObj, next) => {
      log.info('Got charge', intentObj.data('stripeCharge'));
      next();
   });
</code></pre>
      </div>

      <div class="function">
         <h6>stripe#charge.find</h6>
         <div class="desc">
            Reads all the database charges and associated stripe charge. Input values below:
         </div>
         <ul class="arguments">
            <li>
               <b>start_date</b><span class="type">date</span>the start date to filter
            </li>
            <li>
               <b>end_date</b><span class="type">date</span>the end date to filter
            </li>
            <li>
               <b>limit</b><span class="type">number</span>the number of charges per page
            </li>
            <li>
               <b>next_charge</b><span class="type">string</span>the next charge id, useful for pagination.
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>stripe#customer.create</h6>
         <div class="desc">
            Creates a new stripe customer and attach it to the intent's account object.
            This will not attach anything to the intent data, however it will update the account instance.
            Requires an <b>accountObj</b> under the intent's <b>account</b> data object.
         </div>
         <div class="notes">
            The following input data is required
         </div>
         <ul>
            <li><code>email</code>used if the accountObj does not have an email.</li>
            <li><code>stripe_token</code>the stripe payment token to use</li>
            <li><code>stripe_coupon</code>an optional stripe coupon to use</li>
         </ul>
      </div>
      <div class="function">
         <h6>stripe#plan.find</h6>
         <div class="desc">Returns all your active stripe plans</div>
      </div>
      <div class="function">
         <h6>stripe#plan.read</h6>
         <div class="desc">
            Reads a stripe plan by its id. Requires <code>plan_id</code> in the input as a number.
            The resulting planObj will be placed in the intent's <code>plan</code> data.
         </div>
      </div>
      <div class="function">
         <h6>stripe#subscription.read</h6>
         <div class="desc">Reads the current account's subscription and plan, placing it under
         <code>currentPlan</code> and <code>currentSubscription</code> in the intent's data<br/>
         Requires an <b>accountObj</b> in the intent's <code>account</code> data field.
         </div>
      </div>

      <div class="function">
         <h6>stripe#subscription.create</h6>
         <div class="desc">
            This will subscribe the given account to the given plan using the given
            stripe token. Essentially, this will create a stripe customer,
            using the given plan and subscription
         </div>
         <div class="notes">
            This middleware uses stripe.plan.read to read the target plan.<br/>
            It also requires the account model to be present in the intent's <code>account</code> data field.
         </div>
         <ul class="arguments">
            <li>
               <b>stripe_token</b><span class="type">string</span>the stripe payment token to use
            </li>
            <li>
               <b>quantity</b><span class="type">number</span>the number of times to subscribe the user. Defaults to 1
            </li>
            <li>
               <b>stripe_coupon</b><span class="type">string</span>the stripe coupon to use
            </li>
         </ul>
      </div>

      <div class="function">
         <h6>stripe#subscription.cancel</h6>
         <div class="desc">
            This will perform a downgrade on the current account.
            The downgrade will cancel the current active subscription of the account,
            proactive (at the end of the current billing cycle.<br/>
            This middleware requires the account model to be present in the intent's <code>account</code> data field.
         </div>
      </div>
   </div>
{% endblock %}