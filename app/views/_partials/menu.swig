{# doc-current for the current item #}
{% macro menuItem(text, actionName) %}
   {% set url = '/' + actionName.split('.').join('/') %}
   <li class="cat-item {{ isAction(actionName, 'doc-current') }}">
      <a href="{{ url }}">{{ text }}</a>
   </li>
{% endmacro %}
{% macro menuHeader(text) %}
   <li>
      <h4 class="sub-header">{{ text | upper}}</h4>
   </li>
{% endmacro %}
{% macro menuTitle(text, actionName = null) %}
   {% if actionName == null %}
      <h3 class="widget-title">{{ text }}</h3>
   {% else %}
      {% set url = '/' + actionName.split('.').join('/') %}
      <h3 class="widget-title {{ isAction(actionName, 'doc-current') }}">
         <a href="{{ url }}">{{ text }}</a>
      </h3>
   {% endif %}
{% endmacro %}
<div class="col-sm-12 col-md-4 col-lg-3">
   <aside class="sidebar">
      <section class="widget widget_categories" style="margin-bottom: 0;">
         <div class="doc-menu {% if intent.action.indexOf('welcome') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Welcome', 'welcome') }}
            <ul class="doc-item">
               {{ menuItem('Features', 'welcome.features') }}
               {{ menuItem('Concepts', 'welcome.concepts') }}
               {{ menuItem('Getting started', 'welcome.getting-started') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('core') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Core') }}
            <ul class="doc-item">
               {{ menuItem('Component lifecycle', 'core.lifecycle') }}
               {{ menuItem('Configuration loading', 'core.config') }}
               {{ menuItem('Component loading', 'core.component-load') }}
               {{ menuItem('Component accessing', 'core.component-access') }}
               {{ menuItem('Loggers', 'core.loggers') }}
               {{ menuItem('The Dispatcher', 'core.dispatcher') }}
               {{ menuItem('The Action', 'core.action') }}
               {{ menuItem('The Intent', 'core.intent') }}
               {{ menuItem('The Middleware', 'core.middleware') }}
               {{ menuItem('The Authorization', 'core.authorization') }}
               {{ menuItem('Utilities', 'core.util') }}
               {{ menuItem('Libraries', 'core.libraries') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('interface') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Interfaces') }}
            <ul class="doc-item">
               {{ menuItem('Sanitizer', 'interface.sanitize') }}
               {{ menuItem('Store', 'interface.store') }}
               {{ menuItem('Transport', 'interface.transport') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('sanitize') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Sanitizers', 'sanitize.index') }}
            <ul class="doc-item">
               {{ menuItem('Alpha-numeric', 'sanitize.alpha') }}
               {{ menuItem('Any', 'sanitize.any') }}
               {{ menuItem('Array', 'sanitize.array') }}
               {{ menuItem('Bool', 'sanitize.bool') }}
               {{ menuItem('Color', 'sanitize.color') }}
               {{ menuItem('Date', 'sanitize.date') }}
               {{ menuItem('Domain', 'sanitize.domain') }}
               {{ menuItem('Email', 'sanitize.email') }}
               {{ menuItem('Enum', 'sanitize.enum') }}
               {{ menuItem('Float', 'sanitize.float') }}
               {{ menuItem('IP', 'sanitize.ip') }}
               {{ menuItem('IP Range', 'sanitize.ip-range') }}
               {{ menuItem('JSON', 'sanitize.json') }}
               {{ menuItem('Number', 'sanitize.number') }}
               {{ menuItem('String', 'sanitize.string') }}
               {{ menuItem('URL', 'sanitize.url') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('transport') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Transports', 'transport.index') }}
            <ul class="doc-item">
               {{ menuItem('HTTP', 'transport.http') }}
               {{ menuItem('Websocket', 'transport.ws') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('store') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Stores', 'store.index') }}
            <ul class="doc-item">
               {{ menuItem('SQL', 'store.sql') }}
               {{ menuItem('Redis', 'store.redis') }}
               {{ menuItem('Elastic Search', 'store.elastic') }}
            </ul>
         </div>
         <div class="doc-menu {% if intent.action.indexOf('plugin') == 0 %}doc-visible{% endif %}">
            {{ menuTitle('Plugins', 'plugin.index') }}
            <ul class="doc-item">
               {{ menuHeader('Authentication') }}
               {{ menuItem('Auth-password', 'plugin.auth-password') }}
               {{ menuItem('Auth-UNLOQ', 'plugin.auth-unloq') }}
               {{ menuItem('Auth history', 'plugin.auth-history') }}

               {{ menuHeader('Rendering') }}
               {{ menuItem('Render', 'plugin.render') }}
               {{ menuItem('SASS', 'plugin.sass') }}
               {{ menuItem('LESS', 'plugin.less') }}
               {{ menuItem('Static HTML generator', 'plugin.static-html') }}

               {{ menuHeader('Integrations') }}
               {{ menuItem('Loglet', 'plugin.loglet') }}
               {{ menuItem('Stripe', 'plugin.stripe') }}
               {{ menuItem('Mailing', 'plugin.mail') }}
               {{ menuItem('Cluster discovery', 'plugin.discovery') }}

               {{ menuHeader('Utilities') }}
               {{ menuItem('Session', 'plugin.session') }}
               {{ menuItem('Upload', 'plugin.upload') }}
               {{ menuItem('Queue', 'plugin.queue') }}
               {{ menuItem('Tasks', 'plugin.tasks') }}
               {{ menuItem('Docs generator', 'plugin.docs') }}
               {{ menuItem('Geo-location', 'plugin.geo') }}
               {{ menuItem('Extended utilities', 'plugin.utils') }}
            </ul>
         </div>
      </section>
   </aside>
</div>