export class GenericExample {
    greeting = null;

    constructor(message) {
        this.greeting = message;
    }

    greet() {
        return this.greeting;
    }
}

export class GenericTest {
    constructor() {
        this.create().greet();
    }

    create() {
        return new GenericExample("foo");
    }
}

/*
//@ sourceMappingURL=generic.map
*/
