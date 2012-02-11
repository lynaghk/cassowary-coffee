# Spec Helper
# Loads Closure compiled code and adds it to global NS.
# Automatically loaded before specs by Jasmine-node.

#LIB_PATH = "../out/cassowary-coffee.min.js"
LIB_PATH = "../out/cassowary-debug.js"

for k,v of require(LIB_PATH)
  global[k] = v

global.CL = Cl.CL

global.p = (x) ->
  console.log x
  x

if global.jasmine?
  beforeEach ->
    jasmine.Matchers::toApproximate = (expected) ->
      expect(Cl.approx(@actual, expected)).toBeTruthy()

