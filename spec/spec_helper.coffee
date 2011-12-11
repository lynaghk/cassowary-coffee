#Vows spec helper; loads Closure compiled code and adds it to global NS.
for k,v of require("../out/cassowary-coffee.min.js")
  global[k] = v
