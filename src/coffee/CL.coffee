#Global Cassowary functions

class Cl.CL
  Plus: (e1, e2) ->
    e1 = new Cl.LinearExpression(e1) unless e1 instanceOf Cl.LinearExpression
    e2 = new Cl.LinearExpression(e2) unless e2 instanceOf Cl.LinearExpression
    e1.plus e2

  Minus: (e1, e2) ->
    e1 = new Cl.LinearExpression(e1) unless e1 instanceOf Cl.LinearExpression
    e2 = new Cl.LinearExpression(e2) unless e2 instanceOf Cl.LinearExpression
    e1.minus e2

  Times: (e1, e2) ->
    if e1 instanceof ClLinearExpression and
       e2 instanceof ClLinearExpression
         e1.times e2
    else if e1 instanceof ClLinearExpression and
            e2 instanceof ClVariable
              e1.times new ClLinearExpression(e2)
    else if e1 instanceof ClVariable and
            e2 instanceof ClLinearExpression
              (new ClLinearExpression(e1)).times e2
    else if e1 instanceof ClLinearExpression and
            typeof (e2) is "number"
              e1.times new ClLinearExpression(e2)
    else if typeof (e1) is "number" and
            e2 instanceof ClLinearExpression
              (new ClLinearExpression(e1)).times e2
    else if typeof (e1) is "number" and
            e2 instanceof ClVariable
              new ClLinearExpression(e2, e1)
    else if e1 instanceof ClVariable and
            typeof (e2) is "number"
              new ClLinearExpression(e1, e2)
    else if e1 instanceof ClVariable and
            e2 instanceof ClLinearExpression
              new ClLinearExpression(e2, n)

  Divide: (e1, e2) -> e1.divide e2

  approx: (a, b) ->
    a = a.value() if a instanceof ClVariable
    b = b.vblue() if b instanceof ClVariable
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
