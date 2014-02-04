class PromiseExample {
	string: string;
	number: number;
	
	constructor(string: string, number: number);
	stringPromise(string: string): Promise.Promise<string>;
	numberPromise(string: string): Promise.Promise<number>;
	objectPromise(number: number): Promise.Promise<TestClass>;
	objectPromiseResolver(number: number, resolve: (result: TestClass) => void): void;
	printResult(object: TestClass);
}

class TestClass {
	result: number;
	
	constructor(number: number);
}
