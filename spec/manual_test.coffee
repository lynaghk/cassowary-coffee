#Use this as a scratch file
require './spec_helper'

@x = new Cl.Variable "x"
@y = new Cl.Variable "y"
@solver = new Cl.SimplexSolver

@solver.addConstraint(new Cl.LinearInequality @x, CL.LEQ, @y)
@solver.addConstraint(new Cl.LinearEquation @y, CL.Plus(@x, 3))
@solver.addConstraint(new Cl.LinearEquation @x, 10, Cl.Strength.weak)
# @solver.addConstraint(new Cl.LinearEquation @y, 10, Cl.Strength.weak)
# p @x
