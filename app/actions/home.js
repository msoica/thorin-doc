'use strict';
const dispatcher = thorin.dispatcher,
  path = require('path');

dispatcher
  .addAction('welcome.index')
  .alias('GET', '/')
  .render('pages/welcome/index.swig');

function checkView(intentObj, next) {
  let context = intentObj.input('context'),
    type = intentObj.input('type'),
    viewPath = 'pages/' + context + '/' + type;
  viewPath = path.normalize(viewPath.replace(/\./g, '')) + '.swig';
  if (!thorin.util.isFile(thorin.root + '/app/views/' + viewPath)) {
    return next(thorin.error('NOT_FOUND', 'The requested resource does not exist.', 404));
  }
  intentObj.action = context + '.' + type;
  intentObj.data('view_path', viewPath);
  next();
}

/*
 * Route everything we have to the assigned pages/ template.
 * */
dispatcher
  .addAction('home.router')
  .alias('GET', '/:context/:type')
  .input({
    context: dispatcher.validate('string'),
    type: dispatcher.validate('string')
  })
  .use(checkView)
  .render((intentObj) => intentObj.data('view_path'))
  .render('404.swig', 'error');

/* Route the :context/index paths */
dispatcher
  .addAction('home.sub-router')
  .alias('GET', '/:context')
  .input({
    context: dispatcher.validate('string'),
    type: dispatcher.validate('string').default('index')
  })
  .use(checkView)
  .render((intentObj) => intentObj.data('view_path'))
  .render('404.swig', 'error');