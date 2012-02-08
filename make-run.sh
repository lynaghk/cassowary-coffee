java -jar vendor/closure-compiler.jar          \
    --js_output_file runme.js            \
    --compilation_level ADVANCED_OPTIMIZATIONS        \
    --manage_closure_dependencies true         \
    --js $(find out/js/ -name '*.js') \
    --js vendor/base.js                        \
    --js vendor/underscore.js                  \
    --js vendor/jshashtable.js                 \
    --js vendor/jshashset.js                   \
    --js grr.js
    
