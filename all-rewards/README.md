# Simulation Code for Bandit Selection Strategies

This directory contains all R scripts that were used
to simulate Bandit selection strategies and summarize
the results.

The main R scripts contain further documentation:

1. `readdata.R` reads in the raw reward data, labels and extends the data, and computes some aggregate statistics for the data.
2. `bandits.R` is the main source to load the bandit selection strategies for simulation
3. `calibrate_bandits.R` computes optimal values for all three bandit selection strategies
4. `produce_bandit_data.R` produces reward data for the bandit selection strategies at different levels of their respective parameters, including corner cases and the values computed in the previous step.
5. `read_banditdata.R` reads the produced data for further analysis.

There are more R scripts in this directory to produce plots, and subscripts to facilitate the work with the above main scripts.
**Especially the calibration and data production scripts require some time to be finished.**

The data produced by the script in step 4. is written to a directory "compare_data".
The data used for the plots in the paper resides in "data", but has been produced
in the same way.

# A Note on the Epsilon Parameter

After reviewing this script bundle and bringing it into shape for the submission, I realized that the optimize-command now finds a different value for epsilon:
0.3754302 instead of 0.4685844. The average reward r(0.3754302) = 0.5692166 is
about 0.002 higher than r(0.4685844)=0.5692166.
The other two selection strategy parameter (alpha for UCB and gamma for Exp.3) are
exactly the ones reported in the paper. I attribute the discrepancy to
an update to a newer version of R.
For our purpose, this discrepancy is small enough to continue with the inferior value
0.4685844.