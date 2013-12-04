var One = (function () {
    function One(foo, bar) {
        this.bar = "abc";
        this.priv = null;
    }
    One.prototype.foo = function () {
    };
    return One;
})();
exports.One = One;

