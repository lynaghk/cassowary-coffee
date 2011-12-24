fOkResult = true
var x = new ClVariable("x");
var y = new ClVariable("y");
var solver = new ClSimplexSolver();

solver.addConstraint(new ClLinearInequality(x, CL.LEQ, y));
solver.addConstraint(new ClLinearEquation(y, CL.Plus(x, 3.0)));
solver.addConstraint(new ClLinearEquation(x, 10.0, ClStrength.weak));
console.log(x.value());
// solver.addConstraint(new ClLinearEquation(y, 10.0, ClStrength.weak));
// console.log(x.value());




// print("x == " + x.value() + ", y == " + y.value());
// console.log(solver.rows().values().map(function(x){return x.constant();}));

// solver.removeConstraint(c10);

// print("x == " + x.value() + ", y == " + y.value());
// console.log(solver.rows().values().map(function(x){return x.constant();}));


// solver.removeConstraint(c20)
// print("x == " + x.value() + ", y == " + y.value());
// console.log(solver.rows().values().map(function(x){return x.constant();}));
