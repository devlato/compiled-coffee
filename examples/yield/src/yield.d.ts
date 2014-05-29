/// <reference path="../../../node_modules/typescript-yield/example/d.ts/suspend.d.ts"/>
/// <reference path="../../../d.ts/node.d.ts"/>
/// <reference path="../../../d.ts/console.d.ts"/>

class One {
	numeric_attr: number;
	string_attr: string;
	// This function doesn't really returns anything, but we're faking it
	// for yield and the type consistency. Param to the callback is also checked
	// and need to be provided to the generic.
	callback(foo: string, next: suspend.IResume<number>): number;
	// This is how the function above would look like in regular TS.
	// callback(foo: string, next: (err: any, result: number));
	test(foo: string, next: suspend.IResume<void>);
}


// /usr/local/google/home/tcudnik/workspace/compiled-coffee/node_modules/typescript-yield/example/d.ts