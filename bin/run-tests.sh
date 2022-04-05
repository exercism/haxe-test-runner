#!/usr/bin/env bash

for test in test/*; do
    for testdir in $test/*; do
        testname="$(basename $testdir)"
        testname=${testname//_/-}
        output_dir=$testdir
        if [ -d $testdir ]; then
            bin/run.sh $testname $testdir $output_dir
        fi
    done
done
