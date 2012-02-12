(ns cassowary.core
  (:refer-clojure :exclude [+ - * =])
  (:require [Cl :as Cl] ;;Not strictly necessary, but makes me feel better about writing "Cl/" all the time.
            [Cl.CL :as CL]
            [Cl.Variable :as Variable]
            [Cl.Constraint :as Constraint]
            [Cl.SimplexSolver :as SimplexSolver]
            [Cl.LinearEquation :as LinearEquation]))

(defn cvar
  ([] (cvar 0))
  ([val] (Cl/Variable. (js/parseFloat val))))
(defn value [cvar] (.value cvar))
(defn simplex-solver [] (Cl/SimplexSolver.))

(defn constrain! [solver constraint]
  (if (instance? Cl/Constraint constraint)
    (.addConstraint solver constraint)
    (throw (js/Error. "Called constrain! with something not derived from Cl.Constraint; perhaps you forgot (:refer-clojure :exclude [+ - =]) ?"))))

;;TODO remove constraint by value, not object identity.
(defn unconstrain! [solver constraint]
  (if (instance? Cl/Constraint constraint)
    (.removeConstraint solver constraint)
    (throw (js/Error. "Called unconstrain! with something not derived from Cl.Constraint; perhaps you forgot (:refer-clojure :exclude [+ - =]) ?"))))

(defn stay! [solver cvar] (.addStay solver cvar))

(defn- contains-cassowary? [& args]
  (if (some #(or (instance? Cl/Variable %)
                 (instance? Cl/LinearExpression %)) args)
    :cassowary-var
    :number))

(defmulti + contains-cassowary?)
(defmulti - contains-cassowary?)
(defmulti * contains-cassowary?)
(defmulti = contains-cassowary?)


(defmethod + :number [& args] (apply clojure.core/+ args))
(defmethod = :number [& args] (apply clojure.core/= args))
(defmethod * :number [& args] (apply clojure.core/* args))
(defmethod - :number [& args] (apply clojure.core/- args))


(defmethod + :cassowary-var [& args] (apply CL/Plus args))
(defmethod - :cassowary-var [& args] (apply CL/Minus args))
(defmethod * :cassowary-var [a b] (CL/Times a b))
(defmethod = :cassowary-var [a b] (Cl/LinearEquation. a b))

