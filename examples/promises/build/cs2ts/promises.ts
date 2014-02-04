///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
///<reference path="../../d.ts/es6-promise.d.ts" />
import es6_promise = require('es6-promise');
export var Promise = es6_promise.Promise;

export class PromiseExample {
    string = null;

    number = null;

    object = null;

    constructor(string, number) {
        this.string = string;
        this.number = number;
    }

    stringPromise(string) {
        return new Promise((resolve) => setTimeout((function() {
                return resolve(this.string + string);
            }), 0));
    }

    numberPromise(string) {
        return new Promise((resolve) => {
            var converted = parseInt(string);
            return setTimeout((function() {
                return resolve(this.number + converted);
            }), 0);
        });
    }

    objectPromise(number) {
        return new Promise(this.objectPromiseResolver.bind(this, number));
    }

    objectPromiseResolver(number, resolve) {
        return setTimeout((() => resolve(new TestClass(number))), 0);
    }

    printResult(object) {
        return console.log(object.result);
    }
}

export class TestClass {
    result = null;

    constructor(number) {
        this.result = number * 2;
    }
}

export var example = new PromiseExample("15", 100);
example.stringPromise("0").then(example.numberPromise).then(example.objectPromise).then(example.printResult);

/*
//@ sourceMappingURL=promises.map
*/
