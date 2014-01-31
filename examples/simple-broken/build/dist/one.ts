/// <reference path="../../../../d.ts/console.d.ts"/>
"See /examples/simple for the correct version.";

export class One {
    string_attr: string = "abc";

    number_attr: number = null;

    private priv_attr: any = null;

    constructor(string_attr: string, number_attr: number) {
        this.string_attr = number_attr;
        this.number_attr = string_attr;
        this.method2();
    }

    	method(): string {
        return this.string_attr / this.number_attr;
    }
}

export class Two extends One {
    method(str: string): string {
        return this.string_attr * str + this.number_attr;
    }
}

export var one = new One(123, "foo");
export var two = new Two("foo", 123);

one.method().replace(/foo/, /bar/);
console.log(one.priv_attr);
(two.method("bar")).replace(/bar/, "foo");

/*
//@ sourceMappingURL=one.map
*/
