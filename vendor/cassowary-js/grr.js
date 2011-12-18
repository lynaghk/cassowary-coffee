fOkResult = true
var x = new ClVariable("x");
var y = new ClVariable("y");
var solver = new ClSimplexSolver();

var c10 = new ClLinearInequality(x, CL.LEQ, 10.0);
var c20 = new ClLinearInequality(x, CL.LEQ, 20.0);
var cxy = new ClLinearEquation(CL.Times(2.0, x), y);

solver
  .addConstraint(new ClLinearEquation(x, 100.0, ClStrength.weak))
  .addConstraint(new ClLinearEquation(y, 120.0, ClStrength.strong))
  .addConstraint(c10)
  .addConstraint(c20)
  .addConstraint(cxy);

print("x == " + x.value() + ", y == " + y.value());
console.log(solver.rows().values().map(function(x){return x.constant();}));

solver.removeConstraint(c10);
print("x == " + x.value() + ", y == " + y.value());
console.log(solver.rows().values().map(function(x){return x.constant();}));


solver.removeConstraint(c20)
print("x == " + x.value() + ", y == " + y.value());
console.log(solver.rows().values().map(function(x){return x.constant();}));
