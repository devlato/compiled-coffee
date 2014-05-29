export class One  {
    string_attr: string = "abc";

    number_attr: number = null;

    private priv_attr: any = null;

    constructor(string_attr: string, number_attr: number) {
        this.string_attr = string_attr;
        this.number_attr = number_attr;
        this.method();
    }

    	method(): string {
        return this.string_attr + this.number_attr;
    }
}

export class Two  extends One {
    method(str?: string): string {
        return this.string_attr + str + this.number_attr;
    }
}

export var one = new One("foo", 123);
export var two = new Two("foo", 123);

one.method().replace(/foo/, "bar");
(two.method("bar")).replace(/bar/, "foo");
