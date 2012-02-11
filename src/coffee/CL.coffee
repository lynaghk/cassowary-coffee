#Global Cassowary functions
include Cl
include Cl.LinearExpression as LinearExpression
include Cl.Variable as Variable

include Hashtable
include HashSet

#Times, Plus, and Minus functions from the original Cassowary JavaScript port are mixed into the Cl.CL object after LinearExpression is defined.
class Cl.CL
  @GEQ: 1
  @LEQ: 2
  @Assert: (bool) -> throw "Nope." unless bool

  @hashToString: (h) ->
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

  @setToString: (s) ->
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

  @Times = (e1, e2) ->
    if e1 instanceof LinearExpression and
       e2 instanceof LinearExpression
         e1.times e2
    else if e1 instanceof LinearExpression and
            e2 instanceof Variable
              e1.times new LinearExpression(e2)
    else if e1 instanceof Variable and
            e2 instanceof LinearExpression
              (new LinearExpression(e1)).times e2
    else if e1 instanceof LinearExpression and
            typeof (e2) is "number"
              e1.times new LinearExpression(e2)
    else if typeof (e1) is "number" and
            e2 instanceof LinearExpression
              (new LinearExpression(e1)).times e2
    else if typeof (e1) is "number" and
            e2 instanceof Variable
              new LinearExpression(e2, e1)
    else if e1 instanceof Variable and
            typeof (e2) is "number"
              new LinearExpression(e1, e2)
    else if e1 instanceof Variable and
            e2 instanceof LinearExpression
              new LinearExpression(e2, n)

  @Linify = (x) ->
    if x instanceof LinearExpression
      x
    else
      new LinearExpression(x)

  @Plus = ->
    if arguments.length == 0
      new LinearExpression(0)
    else
      _(arguments).chain()
        .map(Cl.CL.Linify)
        .reduce((sum, v) -> sum.plus v)
        .value()

  @Minus = ->
    switch(arguments.length)
      when 0 then new LinearExpression 0
      when 1 then Cl.CL.Linify(arguments[0]).times -1
      else
        Cl.CL.Linify(arguments[0]).minus Cl.CL.Plus.apply null, _.rest arguments

