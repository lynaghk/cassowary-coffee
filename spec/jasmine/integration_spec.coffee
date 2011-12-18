require "./../spec_helper"

describe "simple constraints", ->
  beforeEach ->
    @x = new Cl.Variable 167
    @y = new Cl.Variable 2
    @solver = new Cl.SimplexSolver

  it "should both go to zero with equality constraint", ->
    @eq = new Cl.LinearEquation @x, new Cl.LinearExpression @y
    @solver.addConstraint @eq
    expect(@x).toApproximate 0
    expect(@y).toApproximate 0

  it "should both stay with stay constraints", ->
    @solver.addStay @x
    @solver.addStay @y
    expect(@x).toApproximate 167
    expect(@y).toApproximate 2

  it "should go to equals of inequality constraint", ->
    @solver.addConstraint new Cl.LinearInequality @x, CL.LEQ, 10
    expect(@x).toApproximate 10

describe "adding and deleting constraints", ->
  beforeEach ->
    @x = new Cl.Variable "x"
    @y = new Cl.Variable "y"
    @c10 = new Cl.LinearInequality @x, CL.LEQ, 10
    @c20 = new Cl.LinearInequality @x, CL.LEQ, 20
    @solver = new Cl.SimplexSolver
    @solver
      .addConstraint(new Cl.LinearEquation @x, 100, Cl.Strength.weak)
      .addConstraint(@c10)
      .addConstraint(@c20)

  it "sets x to the minimum constraint", ->
    expect(@x).toApproximate 10
  it "sets x to the minimum constraint after one constraint is removed", ->
    @solver.removeConstraint @c10
    expect(@x).toApproximate 20


