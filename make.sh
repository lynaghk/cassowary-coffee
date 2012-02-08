#!/bin/bash
set -e

COFFEE_IN=src/coffee/
JS_OUT=out/js/
COMPILED_FILE=out/cassowary-coffee.min.js
DEBUG_FILE=out/cassowary-debug.js
CLOSURE_COMPILER=vendor/closure-compiler.jar

#Get Closure compiler, if it doesn't exist.
if [ ! -f $CLOSURE_COMPILER ]; then
    echo "Fetching Google Closure compiler..."
    mkdir -p vendor
    cd vendor
    #This -4 forces cURL to use IP4. Without it, cURL gets confused...
    curl -4 -O http://closure-compiler.googlecode.com/files/compiler-latest.zip
    unzip -q compiler-latest.zip
    mv compiler.jar closure-compiler.jar
    rm -f COPYING README compiler-latest.zip
    cd ../
    echo "Closure compiler retrieved successfully."
fi

#Clean output folder
rm -rf $COMPILED_FILE $JS_OUT

#Compile CoffeeScript
vendor/coffee-script/bin/coffee   \
    --google                      \
    --compile                     \
    --bare                        \
    --output $JS_OUT $COFFEE_IN 

#Run Closure Compiler
java -jar vendor/closure-compiler.jar          \
    --js_output_file $DEBUG_FILE            \
    --compilation_level WHITESPACE_ONLY        \
    --formatting PRETTY_PRINT                  \
    --manage_closure_dependencies true         \
    --output_manifest manifest.MF \
    --js vendor/base.js                        \
    --js vendor/underscore.js                  \
    --js vendor/jshashtable.js                 \
    --js vendor/jshashset.js                   \
    --js $(find $JS_OUT -name '*.js')
