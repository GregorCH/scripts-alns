require(readr)
require(reshape2)

#
# read the data of the UCB simulation
#
ucb_data <- read_delim("data/ucb_data.csv",
                       " ", escape_double = FALSE, col_names = FALSE,
                       trim_ws = TRUE)

alphas = c(seq(0,1, by=0.2), 0.0016)

#
# compute the reward and solution score statistics
#
ucb_rewards <- cbind(ucb_data[,seq(1,2*length(alphas), by = 2)], rewardsavg, d$fixrate, d$call)
ucb_rewards <- ucb_rewards[has_sol == TRUE,]
colnames(ucb_rewards) <- c(gsub("^", "alpha_", alphas), "avg", "fixrate", "call")
ucb_solutions <- cbind(ucb_data[,seq(2,2*length(alphas), by = 2)], solavg, d$fixrate, d$call)
ucb_solutions <- ucb_solutions[has_sol == TRUE, ]
colnames(ucb_solutions) <- c(gsub("^", "alpha_", alphas), "avg", "fixrate", "call")

# melt and summarize the data to produce the data for the analysis
melted_ucb_rewards <- melt(data.frame(ucb_rewards), id.vars = c("fixrate", "call"), variable.name = "method", value.name = "reward")
melted_ucb_solutions <- melt(data.frame(ucb_solutions), id.vars = c("fixrate", "call"), variable.name = "method", value.name = "solution")

murs <- summarySE(melted_ucb_rewards, measurevar = "reward", groupvars = c("fixrate", "method"))
muss <- summarySE(melted_ucb_solutions, measurevar = "solution", groupvars = c("fixrate", "method"))
mussbycall <- summarySE(melted_ucb_solutions, measurevar = "solution", groupvars = c("call", "method"))
