Plus = Cl.CL.Plus
Minus = Cl.CL.Minus
Times = Cl.CL.Times
Divide = Cl.CL.Divide



describe "CL arithmetic", ->
  beforeEach ->
    @one = new Cl.Variable 1
    @two = new Cl.Variable 2
    @six = new Cl.Variable 6

    @solver = new Cl.SimplexSolver()
    @solver
      .addStay(@one)
      .addStay(@two)
      .addStay(@six)

    #helper function to evaluate an expression and return concrete value
    @solve = (expr) ->
      val = new Cl.Variable()
      @solver.addConstraint new Cl.LinearEquation val, expr
      val.value()

  ##############################
  describe "Plus", ->

    describe "with no arguments", ->
      beforeEach -> @res = Plus()

      it "returns a LinearExpression", -> expect(@res instanceof Cl.LinearExpression).toBeTruthy()
      it "with the constant additive identity", -> expect(@res.constant()).toApproximate 0

    describe "with arguments", ->
      it "handles Cl.Variables", ->
        expect(@solve Plus(@one, @two)).toApproximate 3
        expect(@solve Plus(@one, @two, @six)).toApproximate 9

      it "handles numbers ", ->
        expect(@solve Plus(1, 2)).toApproximate 3
        expect(@solve Plus(1, 2, 6)).toApproximate 9

      it "handles Cl.Variables with numbers", ->
        expect(@solve Plus(@one, 2)).toApproximate 3
        expect(@solve Plus(@one, 2, @six)).toApproximate 9


  ##############################
  describe "Minus", ->

    describe "with no arguments", ->
      beforeEach -> @res = Minus()

      it "returns a LinearExpression", -> expect(@res instanceof Cl.LinearExpression).toBeTruthy()
      it "with the constant additive identity", -> expect(@res.constant()).toApproximate 0

    describe "with arguments", ->
      it "handles Cl.Variables", ->
        expect(@solve Minus(@one, @two)).toApproximate -1
        expect(@solve Minus(@one, @two, @six)).toApproximate -7

      it "handles numbers ", ->
        expect(@solve Minus(1, 2)).toApproximate -1
        expect(@solve Minus(1, 2, 6)).toApproximate -7

      it "handles Cl.Variables with numbers", ->
        expect(@solve Minus(@one, 2)).toApproximate -1
        expect(@solve Minus(@one, 2, @six)).toApproximate -7
