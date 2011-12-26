CL = Cl.CL

window.p = (x) ->
  console.log x
  x

width = 600
height = 200

$canvas = $("<canvas>")
  .appendTo($('body'))
  .attr(
    width: width
    height: height)
  .css
    border: "1px solid black"

#Shared radius variable
r = new Cl.Variable 40

circles = [0..2].map ->
  x: new Cl.Variable
  y: new Cl.Variable
  r: r

solver = new Cl.SimplexSolver()
solver
  .addStay(r)

for d in circles
  solver.addConstraint new Cl.LinearInequality d.x, Cl.CL.GEQ, 0

  #Vertical constraint
  solver.addConstraint new Cl.LinearEquation d.y, height/2

#The space between circles and edges
c = new Cl.Variable(0)
solver.addConstraint new Cl.LinearInequality c, Cl.CL.GEQ, 0


#Horizontal constraints
twoR = new Cl.LinearExpression(r).times(2)
solver
  .addConstraint(new Cl.LinearEquation 0, Cl.CL.Minus circles[0].x, Cl.CL.Plus(r, c))
  .addConstraint(new Cl.LinearEquation circles[0].x, Cl.CL.Minus circles[1].x, Cl.CL.Plus(twoR, c))
  .addConstraint(new Cl.LinearEquation circles[2].x, Cl.CL.Plus circles[1].x, Cl.CL.Plus(twoR, c))
  .addConstraint(new Cl.LinearEquation width, Cl.CL.Plus circles[2].x, Cl.CL.Plus(r,c))


#Draw it
c = $canvas[0].getContext "2d"
c.strokeStyle = "black"
for d in circles
  c.beginPath()
  c.arc d.x.value(), d.y.value(), d.r.value(), 0, 2*Math.PI
  c.closePath()
  c.stroke()
