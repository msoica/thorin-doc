'use strict';
/**
 * Created by Adrian on 12-Apr-16.
 */
const thorin = require('thorin'),
  path = require('path');

thorin
  .addTransport(require('thorin-transport-http'))
  .addPlugin(require('thorin-plugin-sass'))
  .addPlugin(require('thorin-plugin-render'));

let isCompiling = thorin.argv('compile');
if (isCompiling) {
  thorin.addPlugin(require('thorin-plugin-static-html'));
}
if (thorin.env === 'production') thorin.logger.disableConsole();

thorin.run((err) => {
  if (err) {
    log.error(err);
    return process.exit(1);
  }
  if (isCompiling) {
    // Since we're using dynamic routes, generate action codes based on the views folder.
    let views = thorin.util.readDirectory(thorin.root + '/app/views/pages', 'swig'),
      rootPath = path.normalize(thorin.root + '/app/views/pages'),
      paths = ['/'];
    views.forEach((viewPath) => {
      let subPath = viewPath.replace(rootPath, '').replace(/\.swig/g,'');
      if(subPath.substr(1) === 'layout') return;
      paths.push(subPath);
    });
    const staticObj = thorin.plugin('static-html');
    return staticObj.generatePaths(paths, (err) => {
      thorin.logger.enableConsole();
      if(err) {
        log.fatal(`Failed to generate static HTML from paths`, err);
        return process.exit(1);
      }
      log.info('HTML generated.');
      return process.exit(0);
    });
  }
  thorin.logger.enableConsole();
  var a = thorin.sanitize('ARRAY', "{q},{},3", {
    parse: true
  });
  console.log(a);
  log.info(`Thorin.js documentation server listening on http://localhost:${thorin.config('transport.http.port')}`);
});