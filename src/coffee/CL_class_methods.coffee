#Mixin CL singleton functions that rely on LinearExpression
include Cl.LinearExpression as LinearExpression
include Cl.Variable as Variable

CL["Times"] = (e1, e2) ->
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

CL["Linify"] = (x) ->
  if x instanceof LinearExpression
    x
  else
    new LinearExpression(x)

CL["Plus"] = ->
  if arguments.length == 0
    new LinearExpression(0)
  else
    _(arguments).chain()
      .map(CL["Linify"])
      .reduce((sum, v) -> sum.plus v)
      .value()

CL["Minus"] = ->
  switch(arguments.length)
    when 0 then new LinearExpression 0
    when 1 then CL["Linify"](arguments[0]).times -1
    else
      CL["Linify"](arguments[0]).minus CL["Plus"].apply null, _.rest arguments
