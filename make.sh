#!/bin/bash
set -e

COFFEE_IN=src/coffee/
JS_OUT=out/js/
COMPILED_FILE=out/complied.js
#Clean output folder
rm -rf $COMPILED_FILE $JS_OUT

#Compile CoffeeScript
vendor/coffee-script/bin/coffee   \
    --google                      \
    --compile                     \
    --output $JS_OUT $COFFEE_IN 

#Run Closure Compiler
java -jar vendor/closure-compiler.jar                                            \
    --js_output_file $COMPILED_FILE                                              \
    --compilation_level ADVANCED_OPTIMIZATIONS                                   \
    --js vendor/base.js                                                          \
    --js vendor/jshashtable.js                                                   \
    --js $(find $JS_OUT -name '*.js')

