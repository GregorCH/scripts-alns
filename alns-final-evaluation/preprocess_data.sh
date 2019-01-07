#! /bin/bash

# this script preprocess the raw log data with IPET. Ensure that the IPET virtual environment is active

# Step 1: Parse the raw log files using ipet-parse (creates .trn (TestRun) files)
ipet-parse -l alns-final-tests/check*.out

mkdir -p test-tables
# Step 2: Create intermediate csv-tables using the evaluation file and the trn files
ipet-evaluate -t alns-final-tests/*.trn -e evaluations/evaluation_paper.xml -d no-alns -f csv -p test-tables/
