# CompiledCoffee

CompiledCoffee marries CoffeeScript with TypeScript's type system via the definition files.

# Features

- merge CoffeeScript classes with types from d.ts files
- output a TypeScript compilation result
- all types in d.ts files are optional and function's inner vars' type is inferred
- optionally output a [browserify](https://github.com/substack/node-browserify) CommonJS module
- watch for changes (both the source and the d.ts files)
- compilation is optional, backward-compatible with regular CoffeeScript
- supports yield with type safety for both params and return values (some d.ts changes needed)

# Installation

```
npm install compiled-coffee
```

# Usage

```
  Usage: ccoffee -i <src> -o <build>

  Options:

    -h, --help                     output usage information
    -V, --version                  output the version number
    -i, --source-dir <dir>         Input directory for the source files (required)
    -o, --build-dir <dir>          Output directory for the built files (required)
    -p, --pack <FILE:MODULE_NAME>  Creates a CJS browserify package
    -w, --watch                    Watch for source files changes
```

# Types status

Right now you can write typed classes and untyped (but compiled) mocha tests
without any headache. Compiler auto-recompiles the code after a file change.

Requires node --harmony (>=0.11) for the yield support.

In the definition file you can type following:

- class attributes
- class methods
- interfaces

Not yet here:

- constructor signature
- default params' types
- enums
- top level functions
- top level variables

Later:

- config files for misc params
- merging JS files with d.ts
- watching referenced definitions
- closure compiler output

# Limitations

There are some limitation you need to take into account. Some of them will 
disappear in the future:

- vars are declared inline (not on the beginning of a function)
  This is tricky for eg loop assignments. Also `a = b = null` wont work.
- only CommonJS d.ts files are supported (which means string module names)
- right now, all the top level elements are exported in TS and duplicated 
  module.exports is needed if one plans also to compile it with as a regular
  CoffeeScript
- the d.ts file needs an indentation of 2 tabs or 4 spaces
- referenced d.ts files has a base dir from BUILD_DIR/dist
- class properties are initialized in the constructor, not in the prototype
- only simple requires are supported eg `foo = require('foo')` 
  not `require('foo').bar` or `{foo} = require('foo')`
- underscore dependency for ranges (need a manual require)
- no down ranges like [9..0]
- double source map (CS -> TS -> JS) and lack of a shift on double d.ts lines

# Issues

- Following will cause a stack overflow
```
a = ->
  b = -> 1
```
- yield in IF statements doesn't work

# Roadmap

- Full support for exports
- Merge currently unsupported d.ts definitions
- Update to CoffeeScript 1.7
- Merge yield support from [coffy-script](https://github.com/loveencounterflow/coffy-script)
- Source maps support
- Compiler speed improvements
- Use Closure Compiler as a proper linker

# The flow

- write pure coffeescript
- write d.ts file for each coffee file
- transpile coffee to ts
- change commonjs require and exports to ts versions
 - TODO selective exports
- merge resulting ts source with d.ts files
 - TODO support more language parts
 - TODO extend existing source map (via https://github.com/mozilla/source-map)
- compile ts with typescript
- TODO using a sourcemap and ts service, provide autocompletion information
 - solution similar to tern.js completion for coffee
- watch for changes and refresh the build result
