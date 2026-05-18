#!/usr/bin/env bash

exit_code=0

for test in test/*; do
    for testdir in "$test"/*; do
        testname="$(basename "$testdir")"
        testname=${testname//_/-}
        output_dir=$testdir
        if [ -d "$testdir" ]; then
            bin/run.sh "$testname" "$testdir" "$output_dir"

            if ! diff "${output_dir}/results.json" "${output_dir}/expected_results.json"; then
                echo "❌ ${testdir} FAILED"
                exit_code=1
            fi
        fi
    done
done

exit ${exit_code}
