export declare class GenericExample<T> {
    public greeting: T;
    constructor(message: T);
    public greet(): T;
}
export declare class GenericTest {
    constructor();
    public create(): GenericExample<string>;
}
