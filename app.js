'use strict';
/**
 * Created by Adrian on 12-Apr-16.
 */
const thorin = require('thorin');

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
    return thorin.plugin('static-html').on('compile', () => {
      thorin.logger.enableConsole();
      log.info('HTML generated.');
      return process.exit(0);
    });
  }
  thorin.logger.enableConsole();
  log.info(`Thorin.js documentation server listening on http://localhost:${thorin.config('transport.http.port')}`);
  const pLogger = thorin.logger('payment');
  pLogger.info(`This is my payment logger`);   // outputs
});