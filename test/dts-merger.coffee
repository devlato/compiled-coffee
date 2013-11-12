merger = require '../src/dts-merger/merger'
expect = require 'expect.js'

describe 'd.ts merger', ->
	describe 'for class signature', ->
		output = ''

		before ->
			source = """
				class Foo extends Bar {
				}
			"""
			definition = """
				class Foo extends Bar implements Baz1,
					Baz2 {
				}
			"""
			output = merger.merge source, definition

		it 'should merge interfaces', ->
			expect(output).to.contain "implements Baz1,\n\tBaz2"

		it 'should output inherited classes', ->
			expect(output).to.contain "extends Bar"

		it 'should output the class keyword and name', ->
			expect(output).to.contain "class Foo"

	describe 'for class methods', ->
		output = ''

		before ->
			source = """
				class Foo {
					constructor(foo, bar) {
					}
					public foo(foo, bar): number {
					}
				}
			"""
			definition = """
				class Foo {
					constructor(foo: number, bar: string);
					private foo(foo: number, bar: string): number;
				}
			"""
			output = merger.merge source, definition

		it 'should merge method params', ->
			expect(output).to.contain "constructor(foo: number, bar: string) {"
			expect(output).to.contain "foo(foo: number, bar: string)"

		it 'should merge the return type', ->
			expect(output).to.contain "constructor(foo: number, bar: string) {"
			expect(output).to.contain ": number {"

		it 'should merge the visibility', ->
			expect(output).to.contain "private foo("


	describe 'for class attributes', ->
		output = ''

		before ->
			source = """
				class Foo {
					public foo = 'foo';
				}
			"""
			definition = """
				class Foo {
					private foo: string;
				}
			"""
			output = merger.merge source, definition

		it 'should merge the type', ->
			expect(output).to.contain "foo: string"

		it 'should preserve the value', ->
			expect(output).to.contain "= 'foo';"

		it 'should merge the visibility', ->
			expect(output).to.contain "private foo"
