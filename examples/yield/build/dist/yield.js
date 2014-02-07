/// <reference path="../../../../d.ts/console.d.ts"/>
/// <reference path="../../../../d.ts/node.d.ts"/>
/// <reference path="../../../../node_modules/typescript-yield/d.ts/suspend.d.ts"/>
var suspend = require('suspend');

exports.wrapAsync = suspend.async;
exports.resume = suspend.resume;

var One = (function () {
    function One() {
        this.numeric_attr = null;
    }
    One.prototype.test = function (foo) {
        return this.numeric_attr = yield(this.callback(foo, exports.resume()));
    };

    One.prototype.callback = function (foo, next) {
        return setTimeout((function () {
            return next(null, 10);
        }), 0);
    };
    return One;
})();
exports.One = One;
One.prototype.callback = exports.wrapAsync(One.prototype.callback);
One.prototype.test = exports.wrapAsync(One.prototype.test);

suspend.run(function () {
    var one = new One;
    yield(one.test("foo", exports.resume()));
    return console.log(one.numeric_attr);
});
//# sourceMappingURL=yield.js.map
