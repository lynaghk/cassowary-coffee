(defproject com.keminglabs/cassowary "0.1.1-SNAPSHOT"
  :description "Cassowary linear constraint solver with ClojureScript bindings"
  :license {:name "BSD" :url "http://www.opensource.org/licenses/BSD-3-Clause"}
  
  :dependencies [[org.clojure/clojure "1.4.0"]]
  
  :min-lein-version "2.0.0"

  :plugins [[lein-cljsbuild "0.1.10"]]

  :source-paths ["src/clj" "src/cljs"]
  
  :resource-paths ["pkg"]
  
  :cljsbuild {:builds
              [{:source-path "src/cljs"
                :compiler {:output-to "public/cljs_test.js"
                           :libs ["dev_public/js/Singult.js"]
                           :optimizations :advanced}
                :jar false}]})
