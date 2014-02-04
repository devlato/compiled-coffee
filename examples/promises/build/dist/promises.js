///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
///<reference path="../../d.ts/es6-promise.d.ts" />
var es6_promise = require('es6-promise');
exports.Promise = es6_promise.Promise;

var PromiseExample = (function () {
    function PromiseExample(string, number) {
        this.string = null;
        this.number = null;
        this.object = null;
        this.string = string;
        this.number = number;
    }
    PromiseExample.prototype.stringPromise = function (string) {
        return new exports.Promise(function (resolve) {
            return setTimeout((function () {
                return resolve(this.string + string);
            }), 0);
        });
    };

    PromiseExample.prototype.numberPromise = function (string) {
        return new exports.Promise(function (resolve) {
            var converted = parseInt(string);
            return setTimeout((function () {
                return resolve(this.number + converted);
            }), 0);
        });
    };

    PromiseExample.prototype.objectPromise = function (number) {
        return new exports.Promise(this.objectPromiseResolver.bind(this, number));
    };

    PromiseExample.prototype.objectPromiseResolver = function (number, resolve) {
        return setTimeout((function () {
            return resolve(new TestClass(number));
        }), 0);
    };

    PromiseExample.prototype.printResult = function (object) {
        return console.log(object.result);
    };
    return PromiseExample;
})();
exports.PromiseExample = PromiseExample;

var TestClass = (function () {
    function TestClass(number) {
        this.result = null;
        this.result = number * 2;
    }
    return TestClass;
})();
exports.TestClass = TestClass;

exports.example = new PromiseExample("15", 100);
exports.example.stringPromise("0").then(exports.example.numberPromise).then(exports.example.objectPromise).then(exports.example.printResult);
//# sourceMappingURL=promises.js.map
