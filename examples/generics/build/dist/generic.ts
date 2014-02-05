export class GenericExample<T>  {
    greeting: T = null;

    constructor(message: T) {
        this.greeting = message;
    }

    greet(): T {
        return this.greeting;
    }
}

export class GenericTest  {
    constructor() {
        this.create().greet();
    }

    create(): GenericExample<string> {
        return new GenericExample("foo");
    }
}

/*
//@ sourceMappingURL=generic.map
*/
