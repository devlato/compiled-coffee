var foo, one;

one = require("./one");

class Two extends one.One {
    public bar = 123;

    constructor(foo, bar) {
        super();
        console.log(this.bar.toPrecision());
    }

    public twoFoo() {
        return this.baz(123);
    }
}

foo = new Two(123, 123);

//exports.Two = Two
