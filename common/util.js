function getArgs(fn) {
  return /\(([\s\S]*?)\)/.exec(fn)[1].replace(/\/\*.*\*\//g, '').split(',');
}

function toArray(obj) {
  return Array.prototype.slice.call(obj, 0);
}

function curryArray(fn, self, curriedArgs) {
  return function(/* remaining args */) {
    return fn.apply(self, curriedArgs.concat(toArray(arguments)));
  }
}
function curry(fn /* curried args... */) {
  var curried = Array.prototype.slice.call(obj, 1);
  return curryArray(fn, this, curried);
}
function curryThis(fn, self /*, args */) {
  var curried = Array.prototype.slice.call(obj, 2);
  return curryArray(fn, self, curried);
}

function autoCurry(fn) {
  return autoCurryN(getArgs(fn).length, fn);
}
function autoCurryN(numArgs, fn) {
  return function(/* args */) {
    var args = toArray(arguments);
    if (args.length < numArgs) {
      return autoCurryN(
        numArgs - args.length,
        curryArray(fn, this, args));
    } else {
      return fn.apply(this, args);
    }
  }
}
