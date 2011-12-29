Cassowary Coffee
================
A CoffeeScript port of the [Cassowary](http://www.cs.washington.edu/research/constraints/cassowary/) constraint solving toolkit.

Cassowary can be used to write declarative, constraint-based layouts.
See for example OS X Lion's [Autolayout system](http://developer.apple.com/library/mac/#releasenotes/UserExperience/RNAutomaticLayout/_index.html).

The primary design goal of this project is a JavaScript Cassowary implementation compatible with Google's Closure compiler's advanced mode.
We're translating the original Cassowary authors' [JavaScript port](http://badros.blogspot.com/2011/05/cassowary-constraint-solver-in.html) to CoffeeScript and using Michael Bolin's [CoffeeScript fork](http://bolinfest.com/coffee/features.html) to generate Closure-friendly JavaScript.


Install
=======

Development requires node.js for the CoffeeScript compiler and the Jasmine testing library
Assuming you have node installed, get the code via

    git clone https://github.com/lynaghk/cassowary-coffee.git
    git submodule update --init
    npm install jasmine-node


Build & Test
============

Run the super-simple build script:

    ./make.sh

Run tests:

    jasmine-node --coffee spec/


TODO
====

+ Write exports for the public API so it's possible to compile with Closure's advanced optimizations.
+ Rewrite arithmetic functions to have arity > 2.
+ Design ClojureScript protocol for simpler usage (e.g., IPositionable).
+ Moar samples!

