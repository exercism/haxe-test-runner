#!/usr/bin/env bash

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

slug="$1"
solution_dir="${2%/}"
output_dir="${3%/}"
results_file="${output_dir}/results.json"

echo "${slug}: testing..."

neko bin/runner.n $slug $solution_dir/ $output_dir/

echo "${slug}: done"

cat solution/success_single/results.json