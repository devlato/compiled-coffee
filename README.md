# CompiledCoffee

CompiledCoffee marries CoffeeScript with TypeScript's type system via the definition files.

# Features

- merges coffeescript classes with types from d.ts files
- compiles with typescript
- all typed in d.ts files are optional and function inner vars' type is inferred
- outputs compiled source and optionally a browserify commonjs module
- watch for changes

# Status

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
- modules
- enums
- top level functions
- top level variables

Later:

- config files for misc params
- merging JS files with d.ts
- watching referenced definitions
- closure compiler output

# Limitations to CoffeeScript 

- vars are declared inline (not on the beginning of a function)
  this is tricky for eg loop assignments
- all classes are exported (no `exports =`)
- only simple requires are supported eg `foo = require('foo')` 
  not `require('foo').bar` or `{foo} = require('foo')`
- underscore dependency for ranges (need a manual require)
- no down ranges like [9..0]
- details [at palantir/coffeescript-to-typescript]( https://github.com/palantir/coffeescript-to-typescript)

# Install

```
npm install compiled-coffee
```

# Usage

```
  Usage: ccoffee -i <src> -o <build>

  Options:

    -h, --help                     output usage information
    -V, --version                  output the version number
    -i, --source-dir <dir>         Input directory for source files
    -o, --build-dir <dir>          Output directory for built files
    -p, --pack <FILE:MODULE_NAME>  Creates a CJS browserify package
    -w, --watch                    Watch for source files changes
```

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
