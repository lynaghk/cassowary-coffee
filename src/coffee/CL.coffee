#Global Cassowary functions

class Cl.CL
  Plus: (e1, e2) ->
    e1 = new Cl.LinearExpression(e1) unless e1 instanceOf Cl.LinearExpression
    e2 = new Cl.LinearExpression(e2) unless e2 instanceOf Cl.LinearExpression
    e1.plus e2

