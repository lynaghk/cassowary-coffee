#Vows spec helper; loads Closure compiled code and adds it to global NS.
for k,v of require("../out/compiled.js")
  global[k] = v
