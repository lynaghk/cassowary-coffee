#Use this as a scratch file
require './spec_helper'

p = (x) ->
  console.log x
  x

x = new Cl.Variable 5
y = new Cl.Variable 145
solver = new Cl.SimplexSolver()

eq = new Cl.LinearEquation(x, new Cl.LinearExpression(y))
solver.addConstraint eq

p x.value() == y.value()
p x.value()
