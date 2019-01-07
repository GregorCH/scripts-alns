require(readr)
require(reshape2)

#
# read the data computed for the Exp.3 simulation
#
exp3_data <- as.matrix(read_delim("data/exp3_data.csv",
                        " ", escape_double = FALSE, col_names = FALSE,
                        trim_ws = TRUE)
)
gammas <- c(seq(0.05,0.95, 0.1), 0.07041455)

#
# get individual rewards and solution counts for each gamma
#
rewardsexp3 <- cbind(exp3_data[,seq(1, 3 * length(gammas), by = 3)], rewardsavg, d$fixrate, d$call)
solexp3 <- cbind(exp3_data[, seq(3, 3 * length(gammas), by=3)], solavg, d$fixrate, d$call)

colnames(rewardsexp3) <- c(gsub("^", "gamma_", gammas), "avg", "fixrate", "call")
colnames(solexp3) <- c(gsub("^", "gamma_", gammas), "avg", "fixrate", "call")

# melt the data to process it easier
melted_exp3_rewards <- melt(data.frame(rewardsexp3[has_sol == TRUE,]),
                            id.vars=c("call", "fixrate"), variable.name = "method", value.name = "reward"
                            )

melted_exp3_sols <- melt(data.frame(solexp3[has_sol == TRUE,]),
                         id.vars = c("call", "fixrate"), variable.name="method", value.name = "solution"
                         )

# create a reward and solution summary per fixing rate and gamma value, but also per call
mexp3rs <- summarySE(melted_exp3_rewards, measurevar = "reward", groupvars = c("fixrate", "method"))
mexp3ss <- summarySE(melted_exp3_sols, measurevar = "solution", groupvars = c("fixrate", "method"))
mexp3sbycall <- summarySE(melted_exp3_sols, measurevar = "solution", groupvars = c("call", "method"))


