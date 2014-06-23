## NOW
- interface generics are not merged in
- interfaces are not public

# DTS Merger
- exported .d.ts files wrapping in string modules (commonjs)
 - adding "export import" to all imports
- support rest of the TS language parts
- extract to a separate module
- copy referenced definitions
- fix CS->TS source map
- switch the compiler to coffy-script (better yield) once it supports CS 1.7
- exlude commented out code
- use a *fucking* AST finally

# COMPILER
- global definition inclusion (CLI level)

# ALL
- ability to turn off specific typescruipt errors
  eg "TS2065: Return type of public method from exported class is using inaccessible module"
  error TS2027: Exported variable 'exported' has or is using private type 'IExport'
- watch d.ts files recursively
- dont pollute global namespace!
- resurect tests
- rewrite to compiled-coffee