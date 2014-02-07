///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
///<reference path="../../d.ts/es6-promise.d.ts" />
import es6_promise = require('es6-promise');
export var Promise = es6_promise.Promise;

export class PromiseExample  {
    string: string = null;

    number: number = null;

    object = null;

    constructor(string: string, number: number) {
        this.string = string;
        this.number = number;
    }

    createPromise(number: number): Promise.Promise<TestClass> {
        return new Promise(this.promiseResolver.bind(this, number));
    }

    promiseResolver(number: number, resolve:
		(result: TestClass) => void): void {
        return setTimeout((() => resolve(new TestClass(number))), 0);
    }

    printResult(object: TestClass) {
        return console.log(object.result);
    }
}

export class TestClass  {
    result: number = null;

    constructor(number: number) {
        this.result = number * 2;
    }
}

export var example = new PromiseExample("15", 100);
(example.createPromise(100)).then(example.printResult);

/*
//@ sourceMappingURL=promises.map
*/
