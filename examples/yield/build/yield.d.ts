/// <reference path="../../../d.ts/console.d.ts" />
/// <reference path="../../../d.ts/node.d.ts" />
/// <reference path="../../../node_modules/typescript-yield/example/d.ts/suspend.d.ts" />
export declare var wrapAsync: typeof suspend.async;
export declare var resume: typeof suspend.resume;
export declare class One {
    public numeric_attr: number;
    public string_attr: string;
    public test(foo: string, next: suspend.IResume<void>): number;
    public callback(foo: string, next: suspend.IResume<number>): number;
}
