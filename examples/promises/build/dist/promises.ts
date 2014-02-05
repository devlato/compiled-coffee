///<reference path="../../../../d.ts/console.d.ts" />
///<reference path="../../../../d.ts/node.d.ts" />
///<reference path="../../d.ts/es6-promise.d.ts" />
import es6_promise = require('es6-promise');
export var Promise = es6_promise.Promise;

export 

export 

export var example = new PromiseExample("15", 100);
example.stringPromise("0").then(example.numberPromise).then(example.objectPromise).then(example.printResult);

/*
//@ sourceMappingURL=promises.map
*/
