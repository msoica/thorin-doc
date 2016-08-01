<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>{{ title }}</title>
   {% block meta %}
      <meta name="description" content="Thorin.js node.js framework for microservice-oriented distributed real-world applications"/>
      <meta name="keywords" content="nodejs node"/>
      <meta name="author" content="UNLOQ Systems LTD"/>
   {% endblock %}

   <!--SEO Meta Tags-->
   <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
   <link rel="icon" type="image/png" href="/favicon-32.png" sizes="32x32" />
   <link rel="icon" type="image/png" href="/favicon-16.png" sizes="16x16" />
   <link rel="icon" href="/favicon.ico" type="image/x-icon">
   <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
   <link href="{{ asset('/css/styles.min.css', true) }}" rel="stylesheet" media="screen">
   <link href="{{ asset('/css/vendor/pixeden.css') }}" rel="stylesheet" media="screen">
   <link href="{{ asset('/css/vendor/highlight.css', true) }}" rel="stylesheet" media="screen">
</head>
<body>
{% include "../_partials/track.swig" %}
{% include "../_partials/header.swig" %}
{% import "../_partials/macro.swig" as macro %}
<div class="page-wrapper">
   <section class="container main-app">
      <div class="row">
         {% include "../_partials/menu.swig" %}
         <div class="col-sm-12 col-md-8 col-lg-9">
            {% block content %}{% endblock %}
            {% include "../_partials/page-footer.swig" %}
         </div>
      </div>
   </section>
   {% include "../_partials/footer.swig" %}

   <script src="{{ asset('/js/vendor/modernizr.custom.js') }}"></script>
   <script src="{{ asset('/js/vendor/detectizr.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/jquery-2.1.4.min.js') }}"></script>
   {% block scripts %}{% endblock %}
   <script src="{{ asset('/js/vendor/preloader.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/placeholder.js') }}"></script>
   <script src="{{ asset('/js/vendor/bootstrap.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/velocity.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/magnific-popup.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/owl.carousel.min.js') }}"></script>
   <script src="{{ asset('/js/vendor/highlight.min.js') }}"></script>
   <script src="{{ asset('/js/scripts.js', true) }}"></script>

</div>
</body>
</html>