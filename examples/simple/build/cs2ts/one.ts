export class One {
    string_attr = "abc";

    number_attr = null;

    priv_attr = null;

    constructor(string_attr, number_attr) {
        this.string_attr = string_attr;
        this.number_attr = number_attr;
        this.method();
    }

    method() {
        return this.string_attr + this.number_attr;
    }
}

export class Two extends One {
    method(str) {
        return this.string_attr + str + this.number_attr;
    }
}

export var one = new One("foo", 123);
export var two = new Two("foo", 123);

one.method().replace(/foo/, "bar");
(two.method("bar")).replace(/bar/, "foo");

/*
//@ sourceMappingURL=one.map
*/
