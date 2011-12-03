load("mootools-core-1.3.2-server.js");


var A = new Class({
  toString: function() {
    return "a";
  }
});


var B = new Class({
  Extends: A,
  toString: function() {
    return "b";
  }
});


var C = new Class({
  Extends: A,
  toString: function() {
    return this.parent() + "c";
  }
});

var D = new Class({
  Extends: B,
  toString: function() {
    return this.parent() + "d";
  }
});



a = new A();
b = new B();
c = new C();
d = new D();

print('a='+a);
print('b='+b);
print('c='+c);
print('d='+d);
