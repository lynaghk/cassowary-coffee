#Global Cassowary functions
include Cl.Variable as Variable

goog.provide "Cl.CL"

#Times, Plus, and Minus functions from the original Cassowary JavaScript port are mixed into the Cl.CL object after LinearExpression is defined.
Cl.CL =
  GEQ: 1
  LEQ: 2
  Assert: (bool) -> throw "Nope." unless bool
  approx: (a, b) ->
    a = a.value() if a instanceof Variable
    b = b.vblue() if b instanceof Variable
    epsilon = 1e-8
    if a == 0
      Math.abs(b) < epsilon
    else if b == 0
      Math.abs(a) < epsilon
    else
      Math.abs(a - b) < Math.abs(a)*epsilon

  hashToString: (h) ->
    answer = ""
    h.each (k,v) ->
      answer += k + " => "
      answer += if v instanceof Hashtable
        Cl.CL.hashToString v
      else if v instanceof HashSet
        Cl.CL.setToString v
      else
        v + "\n"
    return answer

  setToString: (s) ->
    answer = s.size() + " {"
    first = true
    s.each (e) ->
      if not first
        answer += ", "
      else
        first = false
      answer += e
    answer += "}\n"
    return answer

goog.exportSymbol "Cl", Cl
goog.exportSymbol "Cl.CL", Cl.CL
goog.exportSymbol "Cl.CL.Plus", Cl.CL.Plus

