# CompiledCoffee

CompiledCoffee marries CoffeeScript with TypeScript's type system via the definition files.

# Status

In the definition file you can type following:
- class attributes
- class methods
- interfaces

TODO are:
- modules
- functions
- variables
- constructor signature
- default params' types

# Limitations to CoffeeScript 
- all classes are exported (no `exports =`)
- underscore dependency for ranges
- no down ranges like [9..0]

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
