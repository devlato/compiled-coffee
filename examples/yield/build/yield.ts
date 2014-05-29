/// <reference path="../../../d.ts/console.d.ts"/>
/// <reference path="../../../d.ts/node.d.ts"/>
/// <reference path="../../../node_modules/typescript-yield/example/d.ts/suspend.d.ts"/>
import suspend = require('suspend');

export var wrapAsync = suspend.async;
export var resume = suspend.resume;

export class One  {
    numeric_attr: number = null;

    string_attr: string = null;

    test(foo: string, next: suspend.IResume<void>) {
        return this.numeric_attr = yield(this.callback(foo, resume()));
    }

    callback(foo: string, next: suspend.IResume<number>): number {
        return setTimeout((() => next(null, 10)), 0);
    }
}
One.prototype.callback = wrapAsync(One.prototype.callback);
One.prototype.test = wrapAsync(One.prototype.test);

suspend.run(() => {
    var one = new One;
    yield(one.test("foo", resume()));
    return console.log(one.numeric_attr);
});
