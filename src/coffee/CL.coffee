#Global Cassowary functions
# include Cl.LinearExpression as LinearExpression
include Cl.Variable as Variable
Cl.CL =
  # Plus: (e1, e2) ->
  #   e1 = new LinearExpression(e1) unless e1 instanceof LinearExpression
  #   e2 = new LinearExpression(e2) unless e2 instanceof LinearExpression
  #   e1.plus e2

  # Minus: (e1, e2) ->
  #   e1 = new LinearExpression(e1) unless e1 instanceof LinearExpression
  #   e2 = new LinearExpression(e2) unless e2 instanceof LinearExpression
  #   e1.minus e2

  # Times: (e1, e2) ->
  #   if e1 instanceof LinearExpression and
  #      e2 instanceof LinearExpression
  #        e1.times e2
  #   else if e1 instanceof LinearExpression and
  #           e2 instanceof Variable
  #             e1.times new LinearExpression(e2)
  #   else if e1 instanceof Variable and
  #           e2 instanceof LinearExpression
  #             (new LinearExpression(e1)).times e2
  #   else if e1 instanceof LinearExpression and
  #           typeof (e2) is "number"
  #             e1.times new LinearExpression(e2)
  #   else if typeof (e1) is "number" and
  #           e2 instanceof LinearExpression
  #             (new LinearExpression(e1)).times e2
  #   else if typeof (e1) is "number" and
  #           e2 instanceof Variable
  #             new LinearExpression(e2, e1)
  #   else if e1 instanceof Variable and
  #           typeof (e2) is "number"
  #             new LinearExpression(e1, e2)
  #   else if e1 instanceof Variable and
  #           e2 instanceof LinearExpression
  #             new LinearExpression(e2, n)

  # Divide: (e1, e2) -> e1.divide e2

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
        Cl.hashToString v
      else if v instanceof HashSet
        Cl.setToString v
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
