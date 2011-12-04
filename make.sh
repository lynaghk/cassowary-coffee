#!/bin/bash
set -e

OUT=out
#Clean output folder
rm -rfd $OUT
mkdir $OUT

#Compile CoffeeScript
find src/coffee -name '*.coffee' | xargs cat > out/out.coffee
vendor/coffee-script/bin/coffee   \
    --google                      \
    --compile                     \
    --output $OUT                 \
    $OUT/out.coffee

#Run Closure Compiler
java -jar vendor/closure-compiler.jar                                            \
    --js vendor/base.js                                                          \
    --js $OUT/out.js                                                             \
    --js_output_file $OUT/compiled.js                                            \
    --compilation_level ADVANCED_OPTIMIZATIONS                                   \
