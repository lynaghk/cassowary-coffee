#Vows spec helper; loads Closure compiled code and adds it to global NS.


#LIB_PATH = "../out/cassowary-coffee.min.js"
LIB_PATH = "../out/cassowary-debug.js"

for k,v of require(LIB_PATH)
  global[k] = v

global.CL = Cl.CL

if jasmine?
  jasmine.Matchers::toApproximate = (expected) ->
    expect(CL.approx(@actual, expected)).toBeTruthy()

