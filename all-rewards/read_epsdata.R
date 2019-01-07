require(readr)
require(reshape2)
#
# produce the data for epsilon greedy plots
#

# read the data
eps_data <- as.matrix(read_delim("data/eps_data.csv",
                       " ", escape_double = FALSE, col_names = FALSE,
                       trim_ws = TRUE))

#
# the data was produced with those six epsilons
#
epsilons <- c(c(1,2,4,8,16)/4, 0.4685844)

# extract reward and solution scores from data
rewards <- cbind(eps_data[has_sol == TRUE, c(seq(1, 2*length(epsilons), by=2))], rewardsavg[has_sol == TRUE], d_sol$fixrate)
solutions <- cbind(eps_data[has_sol == TRUE, c(seq(2, 2*length(epsilons), by=2))], solavg[has_sol == TRUE], d_sol$fixrate)
colnames(rewards) <- c(gsub("^", "eps_", epsilons), "avg", "fixrate")
colnames(solutions) <- c(gsub("^", "eps_", epsilons), "avg", "fixrate")

# melt the reward and solution data and use the summarySE function to compute summary statistics
melted_rewards <- melt(data.frame(rewards), value.name = "reward", id.vars = "fixrate", variable.name = "epsilon")
melted_eps_sols <- melt(data.frame(solutions), value.name = "solution", id.vars = "fixrate", variable.name = "epsilon")
mrs <- summarySE(melted_rewards, measurevar = "reward", groupvars = c("fixrate", "epsilon"))
mess <- summarySE(melted_eps_sols, measurevar = "solution", groupvars = c("fixrate", "epsilon"))

# compute the average solution score per call and epsilon value
epssolbycall <- aggregate(solutions~d_sol$call, FUN = mean)
melted_epssbc <- melt(epssolbycall,  id.vars = "d_sol$call", value.name = "solution", variable.name = "epsilon")
colnames(melted_epssbc) <- c("call", "epsilon", "solution")

