Cassowary Coffee
================
A CoffeeScript port of the [Cassowary](http://www.cs.washington.edu/research/constraints/cassowary/) constraint solving toolkit.

Cassowary can be used to write declarative, constraint-based layouts.
See for example OS X Lion's [Autolayout system](http://developer.apple.com/library/mac/#releasenotes/UserExperience/RNAutomaticLayout/_index.html).

The primary design goal of this project is a JavaScript Cassowary implementation compatible with Google's Closure compiler's advanced mode.
We're translating the original Cassowary authors' [JavaScript port](http://badros.blogspot.com/2011/05/cassowary-constraint-solver-in.html) to CoffeeScript and using Michael Bolin's [CoffeeScript fork](http://bolinfest.com/coffee/features.html) to generate Closure-friendly JavaScript.



Using from ClojureScript
========================

Add to your `project.clj`:

    [com.keminglabs/cassowary "0.1.0"]

and add "cassowaryjs" to the ClojureScript compiler `:libs` option so it looks like this:

    (closure/build "my/cljs/src" {:optimizations :advanced
                                  :libs ["cassowaryjs"]})

Using Cassowary from ClojureScript costs about 18KB in advanced mode.

Example usage
=============


```clojure
(ns cassowary-demo
  (:refer-clojure :exclude [+ - * =])
  (:use [cassowary.core :only [+ - = * cvar value constrain! unconstrain! simplex-solver]]))

(defn *print-fn* [x] (.log js/console x))

(let [solver  (simplex-solver)
      vars    (for [_ (range 5)] (cvar 0))]

  ;;Relation between consecutive pairs of variables
  (doseq [[a b] (partition 2 1 vars)]
    (constrain! solver (= b (* 2 a))))
  
  (let [c1 (= 1 (first vars))
        c2 (= -5 (first vars))]
    
    (constrain! solver c1)
    (print (pr-str (map value vars))) ;=> (1 2 4 8 16)
    
    (unconstrain! solver c1)
    (constrain! solver c2)
    (print (pr-str (map value vars))))) ;=> (-5 -10 -20 -40 -80)
```



Install
=======

Development requires node.js for the CoffeeScript compiler and the Jasmine testing library
Assuming you have node installed, get the code via

    git clone https://github.com/lynaghk/cassowary-coffee.git
    git submodule update --init
    npm install jasmine-node


Build
=====

Run the super-simple build script:

    ./make.sh

This will download the Closure compiler to `vendor/closure-compiler.jar` if it's not there already.

After you've built the Cassowary library JavaScript, try the samples:

    vendor/coffee-script/bin/coffee   \
      --google                        \
      --compile                       \
      --output out/samples samples/

and test them out by opening `samples/samples.html` in your browser.


Test
====

    jasmine-node --coffee spec/


TODO
====
+ Multiarity multiplication
+ ClojureScript wrappers for simple editing of variable values.
+ Design ClojureScript protocol for simpler usage (e.g., IPositionable).
+ Moar samples!
