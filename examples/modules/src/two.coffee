# Right now, everything is exported and only simple assignments are allowed
# on the import line (eg `{ One } = require './one'` wont work for now)
one = require './one'

# one.One is needed and simple alias One = one.One wont work until complex 
# imports are fixed
class Two extends one.One
  