var One = (function () {
    function One(foo, bar) {
        this.bar = "abc";
        this.priv = null;
    }
    One.prototype.foo = function () {
    };

    One.prototype.baz = function (foo) {
    };
    return One;
})();
