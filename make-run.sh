java -jar vendor/closure-compiler.jar          \
    --js_output_file runme.js            \
    --compilation_level ADVANCED_OPTIMIZATIONS        \
    --manage_closure_dependencies true         \
    --js $(find out/js/ -name '*.js') \
    --js grr.js
    
