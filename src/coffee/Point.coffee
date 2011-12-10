class Cl.Point
  constructor: (x, y, suffix) ->
    if x instanceof ClVariable
      @x = x
    else
      if suffix?
        @x = new ClVariable("x" + suffix, x)
      else
        @x = new ClVariable(x)
    if y instanceof ClVariable
      @y = y
    else
      if suffix?
        @y = new ClVariable("y" + suffix, y)
      else
        @y = new ClVariable(y)

  SetXY: (x, y) ->
    if x instanceof ClVariable
      @x = x
    else
      @x.set_value x
    if y instanceof ClVariable
      @y = y
    else
      @y.set_value y

  X: -> @x
  Y: -> @y
  Xvalue: -> @x.value()
  Yvalue: -> @y.value()
  toString: -> "(" + @x + ", " + @y + ")"
