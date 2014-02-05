var GenericExample = (function () {
    function GenericExample(message) {
        this.greeting = null;
        this.greeting = message;
    }
    GenericExample.prototype.greet = function () {
        return this.greeting;
    };
    return GenericExample;
})();
exports.GenericExample = GenericExample;

var GenericTest = (function () {
    function GenericTest() {
        this.create().greet();
    }
    GenericTest.prototype.create = function () {
        return new GenericExample("foo");
    };
    return GenericTest;
})();
exports.GenericTest = GenericTest;
//# sourceMappingURL=generic.js.map
