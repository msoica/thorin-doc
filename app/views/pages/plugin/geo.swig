{% extends "../layout.swig" %}
{% set title = "Thorin.js - geo plugin" %}

{% block content %}
   <div class="post-item">
      <h2 class="post-title">
         {{ macro.gitIcon('https://github.com/Thorinjs/Thorin-plugin-geo') }}
         plugin-geo
      </h2>
      <p>
         The plugin contains geo-location functionality and geo-ip matching. Behind the scenes, it uses <code>geoip-lite</code>
         and <code>geoip-ultralight</code> as data sources. Since all geo-location data is loaded in-memory, the plugin will add
         roughly <code>70MB</code> of RAM and 2-3 second delay to your application.
      </p>
      <p>
         By default, the plugin will auto-load <code>geoip-ultralight</code> at boot time, and auto-load <code>geoip-light</code> at the time
         of the first IP lookup.
      </p>

      <h5>Installation and usage</h5>
      <pre><code class="bash">npm i --save thorin-plugin-geo@1.x</code>
<code class="javascript">'use strict';
// app.js entry file
const thorin = require('thorin');

thorin.addPlugin(require('thorin-plugin-geo'));   // <- add this line
thorin.run((err) => {});
</code>
</pre>

      <h5 class="padding-top">Default configuration</h5>
      <ul class="arguments">
         <li>
            <b>regional</b><span class="type">boolean, true</span> should we load the regional information that gives us countries and region lookup
         </li>
         <li>
            <b>autoload</b><span class="type">boolean, false</span> if set to true, it will auto-load geoip-light
         </li>
      </ul>

      <h5 class="padding-top">Plugin functionality</h5>
      <div class="function">
         <h6>pluginObj.getCountries()</h6>
         <div class="desc">
            Returns an array of <code>code,name</code> containing every country on Earth.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getCountry(code)</h6>
         <div class="desc">
            Returns information about a country given its code
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getCountryName(code)</h6>
         <div class="desc">
            Returns the name of a country by its code.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getCountryTel(code)</h6>
         <div class="desc">
            Returns an array of country phone prefixes.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getCountryContinent(code)</h6>
         <div class="desc">
            Returns the continent of a country by its code.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getCountryRegions(code)</h6>
         <div class="desc">
            Returns an array of <code>code,name</code> representing all the regions of a country.
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.getRegionName(countryCode, regionCode)</h6>
         <div class="desc">
            Returns the name of the given region code, from a country
         </div>
      </div>

      <div class="function">
         <h6>pluginObj.lookup(ip, fn) : Promise</h6>
         <div class="desc">
            Synchronously perform a country lookup for the given IP address.
            If a callback function is specified, use it, otherwise return a Promise
         </div>
         <div class="notes">
            The full information may contain:<br/>
            <ul>
               <li><code>code</code> the 2-letter country code</li>
               <li><code>name</code> the country name</li>
               <li><code>lat</code> the country latitude</li>
               <li><code>lon</code> the country longitude</li>
               <li><code>region</code> a <code>code,name</code> entry of the region</li>
               <li><code>city</code> the name of the city</li>
               <li><code>full</code> the full geo representation (city, region, country)</li>
            </ul>
         </div>
      </div>
      <div class="function">
         <h6>pluginObj.lookupCountry(ip)</h6>
         <div class="desc">
            Synchronously returns country-only information about the given IP.
         </div>
         <div class="notes">
            <ul>
               <li><code>code</code> the 2-letter country code</li>
               <li><code>iso</code> the 3-letter country code</li>
               <li><code>continent</code> the 2-letter continent code</li>
               <li><code>name</code> the country name</li>
            </ul>
         </div>
      </div>

      <h5 class="padding-top">Extended Thorin.Intent</h5>
      <div class="function">
         <h6>intentObj.geoData(fn) : Promise</h6>
         <div class="desc">
            Small wrapper over <code>pluginObj.lookup</code> that will fetch information about the intent's client IP address.
            If a callback function is provided, it will use it, otherwise returns a promise.
         </div>
      </div>

      <div class="function">
         <h6>intentObj.getCountry() : Object</h6>
         <div class="desc">
            Small wrapper over <code>pluginObj.lookupCountry</code> that will return country information about the intent's client IP address
         </div>
      </div>

   </div>
{% endblock %}