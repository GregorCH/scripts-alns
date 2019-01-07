#! /usr/bin/Rscript

#
# this script calibrates the parameters of all bandit selection strategies
#
source("./readdata.R")
source("./bandits.R")

print("Optimizing Epsilon greedy parameter eps.")
opt_eps <- optimize(epsgreedy_function, interval = c(0,2), maximum = TRUE)
print(opt_eps)

print("Optimizing Exp.3 parameter gamma.")
opt_exp <- optimize(exp_function, interval = c(0.001, 1), maximum = TRUE)
print(opt_exp)

print("Optimizing UCB parameter alpha.")
opt_ucb <- optimize(ucb_function, interval = c(0,1), maximum = TRUE)
print(opt_ucb)
