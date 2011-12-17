require "./../spec_helper"

describe "simple constraints", ->
  beforeEach ->
    @x = new Cl.Variable 167
    @y = new Cl.Variable 2
    @solver = new Cl.SimplexSolver

  it "should both go to zero with equality constraint", ->
    @eq = new Cl.LinearEquation @x, new Cl.LinearExpression @y
    @solver.addConstraint @eq
    expect(@x.value()).toEqual 0
    expect(@y.value()).toEqual 0

  it "should both stay with stay constraints", ->
    @solver.addStay @x
    @solver.addStay @y
    expect(@x).toApproximate 167
    expect(@y).toApproximate 2

describe "adding and deleting constraints", ->
  beforeEach ->
    @x = new Cl.Variable "x"
    @y = new Cl.Variable "y"
    @c10 = new Cl.LinearInequality @x, CL.LEQ, 10
    @c20 = new Cl.LinearInequality @x, CL.LEQ, 20
    @solver = new Cl.SimplexSolver
      .addConstraint(new Cl.LinearEquation @x, 100, Cl.Strength.weak)
      .addConstraint(@c10)
      .addConstraint(@c20)

#  it "sets x ~ 10", ->

