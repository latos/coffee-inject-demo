var tmpl = require('./lib/tpl').tmpl;

exports.handler = function(rq, writer) {
  writer({
      content: tmpl('main', {title:'TestApp'})});
};

