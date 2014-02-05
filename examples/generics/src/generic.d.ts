class GenericExample<T> {
	greeting: T;
	constructor(message: T);
	greet(): T;
}

class GenericTest {
	create(): GenericExample<string>;
}