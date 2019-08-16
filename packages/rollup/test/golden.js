(function(global, factory) {
typeof exports === 'object' && typeof module !== 'undefined' ?
    factory(exports, require('fumlib'), require('hello'), require('some_global_var')) :
    typeof define === 'function' && define.amd ?
    define(['exports', 'fumlib', 'hello', 'some_global_var'], factory) :
    (global = global || self,
     factory(global.bundle = {}, global.fumlib, global.hello, global.runtime_name_of_global_var));
}(this, function(exports, fumlib, hello, some_global_var) {
'use strict';

hello = hello && hello.hasOwnProperty('default') ? hello['default'] : hello;

const name = 'Alice';

console.log(`${hello}, ${name} in ${fumlib.fum}`);

// Tests for @PURE annotations
/*@__PURE__*/
console.log('side-effect');

class Impure {
  constructor() {
    console.log('side-effect');
  }
}

/*@__PURE__*/ new Impure();

// Test for sequences = false
class A {
  a() {
    return document.a;
  }
}
function inline_me() {
  return 'abc';
}
console.error(new A().a(), inline_me(), some_global_var.thing, ngDevMode, ngI18nClosureMode);
ngDevMode && console.log('ngDevMode is truthy');
ngI18nClosureMode && console.log('ngI18nClosureMode is truthy');

exports.A = A;

Object.defineProperty(exports, '__esModule', {value: true});
}));
