var foo;

import one = require("./one");
export class Two extends one.One {
    public bar: number = 123;

    constructor(foo: number, bar: number) {
        super();
        console.log(this.bar.toPrecision());
    }

    public twoFoo(): number {
        return this.baz(123);
    }
}

foo = new Two(123, 123);

//exports.Two = Two
