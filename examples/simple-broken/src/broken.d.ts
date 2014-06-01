/// <reference path="../../../d.ts/console.d.ts"/>
 
class One {
	string_attr: string;
	number_attr: number;
	private priv_attr: any;

	constructor(string_attr: string, number_attr: number);
	
	method(): string;
}

class Two {
	method(str: string): string;
}
