# MIP performance results

This directory contains the necessary code to compare the
MIP performance of SCIP with and without the
proposed Adaptive Large Neighborhood Search.
The log files have been created with the cluster scripts in the SCIP subdirectory check, that are traditionally invoked using `make testcluster ...` from the main
SCIP directory.


1. The log files of the run reside in the directory `alns-final-tests`. Generally, there are 4 files associated with each run. Files with same basename, but different extensions belong to the same group of log files for one setting.
    - The actual log file check.*.out contains the entire standard output produced by SCIP and some markers at the beginning and end that denote the date time,
    time limit, memory limit, etc.
    - the files *.meta contain human readable meta information about how the runs were submitted to the cluster.
    - the *.err and *.set files contain the standard error output and the SCIP parameter settings used.
2. We use IPET (https://github.com/gregorCH/ipet) to create intermediate tables from the raw log files. Please refer to `preprocess_data.sh` for details. The IPET evaluation in XML format is in the `evaluations/` subdirectory.
3. The file `mip-performance.R` parses the generated csv tables for further analysis.
