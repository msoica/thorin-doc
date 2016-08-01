'use strict';

module.exports = {
  "plugin.sass": {
    files: [{
      input: "app/styles/styles.scss",
      output: "public/css/styles.min.css"
    }]
  },
  "plugin.static-html": {
    autorun: false,
    output: thorin.root + '/public',
    sitemap: {
      domain: 'thorinjs.com'
    }
  }
};