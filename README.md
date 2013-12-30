# CompiledCoffee

CompiledCoffee marries CoffeeScript with TypeScript's type system via the definition files.

# Feautures
- merges coffeescript classes with types from d.ts files
- compiles with typescript
- outputs compiled source and optionally a browserify commonjs module
- watch for changes

# Status

Right now you can write typed classes and untyped (but compiled) mocha tests
without any headache. Compiler auto-recompiles the code after file change.

In the definition file you can type following:
- class attributes
- class methods
- interfaces

Not yet here:

- modules
- functions
- variables
- constructor signature
- default params' types

Later:

- config files for misc params
- typing JS files
- watching referenced definitions

# Limitations to CoffeeScript 

- all classes are exported (no `exports =`)
- underscore dependency for ranges
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
