# #! /bin/sh
# set -e

# SLUG="$1"
# INPUT_DIR="$2"
# OUTPUT_DIR="$3"

# echo "$SLUG: testing..."
# # PLACEHOLDER - Insert call to run your language tests here

# echo "$SLUG: processing test output in $INPUT_DIR..."
# # PLACEHOLDER - OPTIONAL: Your language may support outputting results
# #   in the correct format

# # Create $OUTPUT_DIR if it doesn't exist
# [ -d "$OUTPUT_DIR" ] || mkdir -p "$OUTPUT_DIR"

# echo "$SLUG: copying processed results to $OUTPUT_DIR..."
# # PLACEHOLDER - OPTIONAL: Your language may support placing results
# #   directly in $OUTPUT_DIR
# cp "${INPUT_DIR}/results.json" "$OUTPUT_DIR"

# echo "$SLUG: comparing ${OUTPUT_DIR}/results"
# diff "${INPUT_DIR}/results.json" "${OUTPUT_DIR}/results.json"

# echo "$SLUG: OK"

# haxe -cp ./test -cp ./src -L buddy --run RunnerTests -testsPath ./test

#!/usr/bin/env sh

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: path to solution folder
# $3: path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer path/to/solution/folder/ path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug path/to/solution/folder/ path/to/output/directory/"
    exit 1
fi

slug="$1"
# solution_dir=$(realpath "${2%/}")
solution_dir="${2%/}"
echo $(realpath $3)
# output_dir=$(realpath "${3%/}")
output_dir="${3%/}"
results_file="${output_dir}/results.json"

# Create the output directory if it doesn't exist
# mkdir -p $(realpath ${output_dir})
# echo $(realpath ${3%/})

echo "${slug}: testing..."

# # Run the tests for the provided implementation file and redirect stdout and
# # stderr to capture it
# # TODO: Replace 'RUN_TESTS_COMMAND' with the command to run the tests
neko bin/runner.n $slug $solution_dir/ $output_dir/

echo "${slug}: done"
