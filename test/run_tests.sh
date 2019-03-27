#!/bin/bash

tests=$(ls -d)

for directory in $tests; do
	./emperor "$directory/test.emp"
done	