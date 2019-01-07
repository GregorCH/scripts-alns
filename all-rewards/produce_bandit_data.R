#! /usr/bin/Rscript
#
# produce bandit simulation data by computing average rewards over many repetitions on the reward data
#
# NOTE: only run this script manually. It takes a while to complete
#

require(MASS)

source("./readdata.R")
source("./bandits.R")

if( !dir.exists("compare_data") )
{
  dir.create("compare_data")
}
#
# produce the data for the epsilon greedy experiment.
#
# the optimal value 0.4685844 for epsilon was found with the following command:
# optimize(epsgreedy_function, interval = c(0,2), maximum = TRUE)

eps_data <- experiment_with_epsgreedy(d, reps=100, epsilons = c(c(1,2,4,8,16)/4, 0.4685844))

write.matrix(eps_data, file = "compare_data/eps_data.csv")

# the optimal value for gamma was determined by calling
#
# optimize(exp_function, interval = c(0.001, 1), maximum = TRUE)
#
exp3_data <- experiment_with_expThree(d, reps = 100, gammas = c(seq(0.05,0.95, 0.1), 0.07041455))
write.matrix(exp3_data, "compare_data/exp3_data.csv")

#
# the special value for alpha was found through the optimize function
# optimize(ucb_function, interval = c(0,1), maximum = TRUE)
#
ucb_data <- experiment_with_ucb(d, alphas = c(seq(0,1, by=0.2), 0.0016), reps = 100)
write.matrix(ucb_data, "compare_data/ucb_data.csv")
