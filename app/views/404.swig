<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>Cyber Security Solutions | UNLOQ Systems LTD</title>
   <!--SEO Meta Tags-->
   <meta name="description" content="UNLOQ is a Security system that protects companies against cyber-attacks through Multi-Factor Authentication, Transaction Authorization and Encryption Keys."/>
   <meta name="keywords" content="passwordless, security, authentication, cyber-security, 2fa, multi-factor, multi factor authentication, transaction authorisatin, encryption keys, authorisation, wordpress login, secure passwordless login, strong authentication methods, wordpress site login, one time password, two factor authentication, authentication app, 2 step verification, rsa token, mfa, cyber attacks, wordpress plugin, custom authentication, mobile security, strong multi factor authentication"/>
   <meta name="author" content="UNLOQ Systems LTD"/>
   <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
   <link rel="icon" type="image/png" href="/favicon-32.png" sizes="32x32" />
   <link rel="icon" type="image/png" href="/favicon-16.png" sizes="16x16" />
   <link rel="icon" href="/favicon.ico" type="image/x-icon">
   <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
   <link href="{{ asset('/css/vendor/pixeden.css') }}" rel="stylesheet" media="screen">
   <link href="{{ asset('/css/styles.min.css', true) }}" rel="stylesheet" media="screen">
</head>

<body class="error404 light-skin">
{% include "./_partials/track.swig" %}
<div class="page-wrapper">
   <header class="navbar navbar-light navbar-sticky">
      <div class="container">
         <a href="/" class="site-logo">
            <img src="{{ asset('/img/logo-default.png') }}" class="logo-default" alt="UNLOQ Systems LTD">
            <img src="{{ asset('/img/logo-alt.png') }}" class="logo-alt" alt="UNLOQ Systems LTD">
         </a>
         <div class="nav-toggle"><span></span></div>
         <div class="clearfix">
            <div class="toolbar text-right">
               <a href="mailto:team@unloq.io" class="btn btn-sm btn-ghost btn-default scroll-to" data-offset-top="50">Contact us</a>
            </div>
            <nav class="main-navigation submenu-slideDown">
               <ul class="menu">
                  <li><a href="{{ actionAlias('home.products') }}">Products</a></li>
                  <li><a href="{{ actionAlias('home.services') }}">Services</a></li>
                  <li><a href="tel:+442035145263">+44 20 3514 5263</a></li>
               </ul>
            </nav>
         </div>
      </div>
   </header>
   <!-- 404 Content -->
   <main class="page-404 container padding-bottom-3x">
      <div class="row">
         <div class="col-md-8 col-sm-10 col-md-offset-2 col-sm-offset-1">
            <h1 class="page-404-title">404</h1>
            <h2>Oops, the page you're looking for does not exist.</h2>
            <h4 class="page-404-content">You may want to head back to the homepage. If you think something is broken, please do not hesitate to report a problem.</h4>
            <div class="row space-top-2x">
               <div class="col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
                  <a href="/" class="btn btn-ghost btn-default btn-block">Back to Homepage</a>
               </div>
            </div>
         </div>
      </div>
   </main>
</div>
<script src="{{ asset('/js/vendor/modernizr.custom.js') }}"></script>
<script src="{{ asset('/js/vendor/detectizr.min.js') }}"></script>
<script src="{{ asset('/js/vendor/jquery-2.1.4.min.js') }}"></script>
<script src="{{ asset('/js/vendor/preloader.min.js') }}"></script>
<script src="{{ asset('/js/scripts.min.js', true) }}"></script>
</body>
</html>
