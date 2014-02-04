///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
///<reference path="../../d.ts/es6-promise.d.ts" />
import es6_promise = require('es6-promise');
export var Promise = es6_promise.Promise;

export class PromiseExample {
    string: string = null;

    number: number = null;

    object = null;

    	constructor(string: string, number: number) {
        this.string = string;
        this.number = number;
    }

    stringPromise(string: string): Promise.Promise<string> {
        return new Promise((resolve) => setTimeout((function() {
                return resolve(this.string + string);
            }), 0));
    }

    numberPromise(string: string): Promise.Promise<number> {
        return new Promise((resolve) => {
            var converted = parseInt(string);
            return setTimeout((function() {
                return resolve(this.number + converted);
            }), 0);
        });
    }

    objectPromise(number: number): Promise.Promise<TestClass> {
        return new Promise(this.objectPromiseResolver.bind(this, number));
    }

    objectPromiseResolver(number: number, resolve: (result: TestClass) => void): void {
        return setTimeout((() => resolve(new TestClass(number))), 0);
    }

    printResult(object: TestClass) {
        return console.log(object.result);
    }
}

export class TestClass {
    result: number = null;

    	constructor(number: number) {
        this.result = number * 2;
    }
}

export var example = new PromiseExample("15", 100);
example.stringPromise("0").then(example.numberPromise).then(example.objectPromise).then(example.printResult);

/*
//@ sourceMappingURL=promises.map
*/
