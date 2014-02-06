# each external import (without TS source, defined in by a definition file)
# needs to have a `declare module` directive with a STRING name

#/ <reference path="../../d.ts/underscore.d.ts"/>

_ = require 'underscore'

_.range 0, 5
  
#`
#var a: Array<string> = ['file1','file2','file3'];
#_.map<string, void>(a, function(str) {
#  str.replace(/file/, 'dir')
#})
#`