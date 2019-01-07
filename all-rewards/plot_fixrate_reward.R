require(ggplot2)
require(reshape2)

melted_summary <- summarySE(melted_sol,
                            measurevar = "reward",
                            groupvars = c("fixrate", "heuristic")
                            )
pd = position_dodge(.05)
p <- ggplot(data = melted_summary,aes(fixrate, reward, color=heuristic, shape=heuristic))
#p <- p + geom_errorbar(aes(ymin=reward-se, ymax=reward+se),
#                 width=.1, position = pd)
p <- p + geom_line(position = pd)
p <- p + geom_point(position = pd)
p <- p + scale_x_continuous(breaks=seq(.1,.9,.2))
p <- p + scale_shape_manual(name="Neighborhood", values = 1:8)
p <- p + scale_color_discrete(name="Neighborhood")
p <- p + xlab("Fixing rate")
p <- p + ylab("Avg. reward")
ggsave("plots/plot_fixrate_reward.pdf")
print(p)
