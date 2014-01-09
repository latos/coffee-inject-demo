// Original from http://ejohn.org/blog/javascript-micro-templating/
// Simple JavaScript Templating
// John Resig - http://ejohn.org/ - MIT Licensed
// Modified locally.

var fs = require('fs')
var cache = {};

// Set to false to cache templates, so code is only generated once.
var DEBUG = true;

function init_tmpl(tpl_fetcher) {
  return function tmpl(str, data){
    // Figure out if we're getting a template, or if we need to
    // load the template - and be sure to cache the result.
    var inner = !/\W/.test(str) ?
      cache[str] = (!DEBUG && cache[str]) ||
        tmpl(tpl_fetcher(str)) :
        new Function("obj, tmpl",
      
      // Generate a reusable function that will serve as a template
      // generator (and which will be cached).
        "console.log(obj);var p=[],print=function(){p.push.apply(p,arguments);};" +
        
        // Introduce the data as local variables using with(){}
        "with(obj){p.push('" +
        
        // Convert the template into pure JavaScript
        str
          .replace(/[\r\t\n]/g, " ")
          .replace(/'/g, "\\'")
          .split("<%").join("\t")
          .replace(/((^|%>)[^\t]*)/g, "$1\r")
          .replace(/\t=(.*?)%>/g, "',$1,'")
          .split("\t").join("');")
          .split("%>").join("p.push('")
          //.split("\r").join("\\'")
          .split("\r").join("")
      + "');}return p.join('');");

    var fn = function(obj) { return inner(obj, tmpl); };
    
    // Provide some basic currying to the user
    return data ? fn( data ) : fn;
  };
}
// on client would use something like document.getElementById(str).innerHTML
function fetch_tpl(name) {
  console.log('Reading template: ' + name);
  return fs.readFileSync('tpl/' + name + '.html').toString('utf8');
}

exports.tmpl = init_tmpl(fetch_tpl);
