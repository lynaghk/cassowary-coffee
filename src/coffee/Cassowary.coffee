#Setup base namespace.
class Cl
  @version: "0.0.1"
  @approx: (a, b) ->
    a = a.value() if a.value?
    b = b.value() if b.value?
    epsilon = 1e-8
    if a == 0
      Math.abs(b) < epsilon
    else if b == 0
      Math.abs(a) < epsilon
    else
      Math.abs(a - b) < Math.abs(a)*epsilon

goog.exportSymbol "Cl", Cl
