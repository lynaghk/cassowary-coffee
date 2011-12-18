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

  it "sets x to the single constraint after the others are removed", ->
    @solver
      .removeConstraint(@c10)
      .removeConstraint(@c20)
    expect(@x).toApproximate 100

  describe "with duplicate constraints", ->
    beforeEach ->
      @dup10 = new Cl.LinearInequality @x, CL.LEQ, 10
      @solver.addConstraint @dup10

    it "sets x to the duplicate minimum constraint", ->
      expect(@x).toApproximate 10
    it "keeps x at the minimum constraint after one duplicate is removed", ->
      @solver.removeConstraint @c10
      expect(@x).toApproximate 10

    it "keeps x at the next minimum constraint after both duplicates are removed", ->
      @solver
        .removeConstraint(@c10)
        .removeConstraint(@dup10)
      expect(@x).toApproximate 20

  describe "with constraints on two variables", ->
    beforeEach ->
      @y = new Cl.Variable "y"

      @solver.addConstraint new Cl.LinearEquation @y, 120, Cl.Strength.strong
    it "sets both to their minimum values", ->
      expect(@x).toApproximate 10
      expect(@y).toApproximate 120
    it "sets both to their minimum values after a constraint is removed", ->
      @solver.removeConstraint @c10
      expect(@x).toApproximate 20
      expect(@y).toApproximate 120

    describe "with a constraint between the variables", ->
      beforeEach ->
        @cxy = new Cl.LinearEquation CL.Times(2, @x), @y
        @solver.addConstraint @cxy

      it "satisfies the constraint", ->
        expect(@x).toApproximate 10
        expect(@y).toApproximate 20

      it "satisfies the constraint after x changes", ->
        @solver.removeConstraint @c10

        expect(@x).toApproximate 20
        expect(@y).toApproximate 40




