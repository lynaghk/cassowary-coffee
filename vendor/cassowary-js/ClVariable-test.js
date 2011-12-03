/* TEST */

ClVariable.setVarMap([]);
x = new ClVariable("x");
y = new ClVariable("y", 2);
print ((ClVariable.getVarMap())['x'])

d = new ClDummyVariable("foo");
print(d);

o = new ClObjectiveVariable("obj");
print(o);
