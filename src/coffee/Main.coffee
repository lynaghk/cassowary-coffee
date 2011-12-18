include Cl.CL as CL
include Cl.LinearExpression
include Cl.LinearEquation
include Cl.LinearInequality
include Cl.Variable
include Cl.SimplexSolver


x = new Cl.Variable "x"
y = new Cl.Variable "y"
c10 = new Cl.LinearInequality x, CL.LEQ, 10
c20 = new Cl.LinearInequality x, CL.LEQ, 20
solver = new Cl.SimplexSolver
solver
  .addConstraint(new Cl.LinearEquation x, 100, Cl.Strength.weak)
  .addConstraint c10
