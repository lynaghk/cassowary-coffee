#Use this as a scratch file
require './spec_helper'
@x = new Cl.Variable "x"
@y = new Cl.Variable "y"

@c10 = new Cl.LinearInequality @x, CL.LEQ, 10
@c20 = new Cl.LinearInequality @x, CL.LEQ, 20
@cxy = new Cl.LinearEquation CL.Times(2, @x), @y
@solver = new Cl.SimplexSolver
@solver
  .addConstraint(new Cl.LinearEquation @x, 100, Cl.Strength.weak)
  .addConstraint(new Cl.LinearEquation @y, 120, Cl.Strength.strong)
  .addConstraint(@c10)
  .addConstraint(@c20)
  .addConstraint(@cxy)
grr = =>
  p "x == #{@x.value()}, y == #{@y.value()}"
  p @solver.rows().values().map (x) -> x.constant()

grr()

@solver.removeConstraint @c10
grr()

@solver.removeConstraint @c20
grr()


# x = new Cl.Variable 5
# y = new Cl.Variable 145
# solver = new Cl.SimplexSolver()

# eq = new Cl.LinearEquation(x, new Cl.LinearExpression(y))
# solver.addConstraint eq

# p x.value() == y.value()
# p x.value()
