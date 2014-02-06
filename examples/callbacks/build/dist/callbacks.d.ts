/// <reference path="../../../../d.ts/console.d.ts" />
/// <reference path="../../../../d.ts/node.d.ts" />
export declare class CallbacksConsumer {
    static asyncMethod(param: string, callback: (param: string) => void): any;
}
export declare class CallbacksProducer {
    static callback(param: string): void;
}
