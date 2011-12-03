#!/bin/bash

set -xe

vendor/coffee-script/bin/coffee \
  --google       \
  --compile      \
  --output out\
  src/coffee/

   
