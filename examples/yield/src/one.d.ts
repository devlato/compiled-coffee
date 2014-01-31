/// <reference path="../../../../node_modules/typescript-yield/d.ts/suspend.d.ts"/>

class One {
		numeric_attr: number;
		// This function doesn't really returns anything, but we're faking it
		// for yield and the type consistency. Param to the callback is also checked
		// and need to be provided to the generic.
		callback(foo: string, next: suspend.IResume<number>): number;
		// This is how the function above would look like in regular TS.
		// callback(foo: string, next: (err: any, result: number));
		test(foo: string, next: suspend.IResume<void>);
}
