/// <reference path="../../../../d.ts/console.d.ts" />
/// <reference path="../../../../d.ts/node.d.ts" />
/// <reference path="../../d.ts/es6-promise.d.ts" />
export declare var Promise: typeof es6_promise.Promise;
export declare class PromiseExample {
    public string: string;
    public number: number;
    public object: any;
    constructor(string: string, number: number);
    public createPromise(number: number): es6_promise.Promise<TestClass>;
    public promiseResolver(number: number, resolve: (result: TestClass) => void): void;
    public printResult(object: TestClass): void;
}
export declare class TestClass {
    public result: number;
    constructor(number: number);
}
export declare var example: PromiseExample;
