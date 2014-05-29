///<reference path="../d.ts/es6-promise.d.ts" />
///<reference path="../../../d.ts/node.d.ts" />
///<reference path="../../../d.ts/console.d.ts" />
 

class PromiseExample {
	string: string;
	number: number;
		
	constructor(string: string, number: number);
	createPromise(number: number): Promise.Promise<TestClass>;
	promiseResolver(number: number, resolve:
		(result: TestClass) => void): void;
	printResult(object: TestClass);
}

class TestClass {
	result: number;
		
	constructor(number: number);
}
