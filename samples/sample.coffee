# Sample usage of Cassowary-coffee; distribute three circles across one dimension.

window.p = (x) ->
  console.log x
  x

width = 600
height = 200

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
  #Vertical constraint
  solver.addConstraint new Cl.LinearEquation d.y, height/2

#The space between circles and edges
c = new Cl.Variable(0)

#Horizontal constraints
twoR = new Cl.LinearExpression(r).times(2)
solver
  .addConstraint(new Cl.LinearEquation 0, Cl.CL.Minus circles[0].x, Cl.CL.Plus(r, c))
  .addConstraint(new Cl.LinearEquation circles[0].x, Cl.CL.Minus circles[1].x, Cl.CL.Plus(twoR, c))
  .addConstraint(new Cl.LinearEquation circles[2].x, Cl.CL.Plus circles[1].x, Cl.CL.Plus(twoR, c))
  .addConstraint(new Cl.LinearEquation width, Cl.CL.Plus circles[2].x, Cl.CL.Plus(r,c))

#Draw it on a <canvas>
$canvas = $("<canvas>")
  .appendTo($('body'))
  .attr
    width: width
    height: height
  .css
    border: "1px solid black"

ctx = $canvas[0].getContext "2d"
ctx.strokeStyle = "black"
for d in circles
  ctx.beginPath()
  ctx.arc d.x.value(), d.y.value(), d.r.value(), 0, 2*Math.PI
  ctx.closePath()
  ctx.stroke()

