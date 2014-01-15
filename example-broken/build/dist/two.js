var __extends = this.__extends || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    __.prototype = b.prototype;
    d.prototype = new __();
};
var foo;

var one = require("./one");
var Two = (function (_super) {
    __extends(Two, _super);
    function Two(foo, bar) {
        _super.call(this);
        this.bar = 123;
        console.log(this.bar.toPrecision());
    }
    Two.prototype.twoFoo = function () {
        return this.baz(123);
    };
    return Two;
})(one.One);
exports.Two = Two;

foo = new Two(123, 123);
