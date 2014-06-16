# CompiledCoffee

Do you like the type safety of TypeScript and the concise syntax of 
CoffeeScript? In that case CompiledCoffee is for you! It combines CoffeeScript 
with TypeScript's type system via the definition files. You create a *.coffee 
file and a *.d.ts file with the same name, in which you (optionally) type 
stuff. Rest is handled automatically.

[See it in action](http://www.youtube.com/watch?v=aj4V8TVbjP0) in a <5min 
screencast.

# Features

- merges CoffeeScript classes with types from d.ts files
- outputs a TypeScript compilation results
- all types in d.ts files are optional and function's inner vars' types are
 inferred
- optionally outputs a [browserify](https://github.com/substack/node-browserify) 
 CommonJS module
- watches for changes (both the source and the d.ts files)
- compilation is optional, source is backward-compatible with regular 
 CoffeeScript
- supports yield with type safety for both params and return/callback values 
 (some d.ts changes needed)

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
    -w, --watch                    Watch for the source files changes
    -y, --yield                    Support the yield (generators) syntax (currently doesn't work with --pack)
```

# Status

Right now you can write typed classes and untyped (but compiled) mocha tests
without any headache. Compiler auto re-compiles the code after a file change.

Requires node --harmony (>=0.11) for the yield support.

In the definition file you can type following:

- class attributes
- class methods
- interfaces

Not yet here:

- default params' types
- autoset constructor params
- enums
- top level functions
- top level variables

# Limitations

There are some limitations you need to take into account. Some of them will 
disappear in the future:

- vars are declared inline (not on the beginning of a function)
  This is tricky for eg loop assignments. Also `a = b = null` wont work.
- only CommonJS d.ts files are supported (which means string module names)
- right now, all the top level elements are exported in TS and duplicated 
  module.exports is needed if one plans to compile it with as a regular
  CoffeeScript
- *d.ts files need an indentation of 1 tab or 2 spaces*
- referenced d.ts files have a base dir from BUILD_DIR
- class properties are initialized in the constructor, not in the prototype
- only simple requires are supported eg `foo = require('foo')` 
  not `require('foo').bar` or `{foo} = require('foo')`
- underscore dependency for ranges (needs a manual require)
- no down ranges like [9..0]
- double source map (CS -> TS -> JS) and lack of a shift on >1 line d.ts 
 signatures
- no casting (\`\` syntax won't work, which is sad)

# Issues

- Following will cause a stack overflow
```
a = ->
  b = -> 1
```
- yield in IF statements doesn't work
- error when doing `a = b = null`

# Roadmap

- Full support for exports
- Merge currently unsupported d.ts definition types
  Including definition references
- Update to CoffeeScript 1.7
- Merge yield support from [coffy-script](https://github.com/loveencounterflow/coffy-script)
- Source maps support
- Compiler speed improvements
- Merging d.ts with plain JS files
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
