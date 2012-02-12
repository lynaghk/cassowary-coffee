#!/bin/bash
set -e

COFFEE_IN=src/coffee/
JS_IN=src/js/
JS_OUT=out/js/
PKG_OUT=pkg/ #dir that'll be sucked into JAR
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
rm -rf $JS_OUT

#Compile CoffeeScript
vendor/coffee-script/bin/coffee   \
    --google                      \
    --compile                     \
    --bare                        \
    --output $JS_OUT $COFFEE_IN 

#Copy vendor JS to output path
mkdir -p $JS_OUT/vendor
for f in base.js underscore.js; do
    cp vendor/$f $JS_OUT/vendor/
done

#Run Closure Compiler
#Note that goog base needs to come first since it's needed but not explicitly required by any files
java -jar vendor/closure-compiler.jar          \
    --js_output_file $DEBUG_FILE               \
    --compilation_level WHITESPACE_ONLY        \
    --formatting PRETTY_PRINT                  \
    --manage_closure_dependencies true         \
    --output_manifest manifest.MF              \
    --js out/js/vendor/base.js                 \
    --js $(find $JS_OUT -name '*.js' | grep -v base) \
    --js $JS_IN/requires.js #Requires file makes sure everything is pulled in so we can run tests against the output file.

rm -rf $PKG_OUT
mkdir -p $PKG_OUT
cp -r $JS_OUT $PKG_OUT/cassowaryjs
