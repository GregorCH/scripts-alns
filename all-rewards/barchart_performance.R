ggplot(agg_table, aes(Group, `Time_shmean(1.0)Q`, fill=Settings)) +
  geom_col(alpha=0.6, position="dodge") +
  scale_fill_manual(values=brewer.pal(4, "Set3")) +
  geom_text(aes(label=agg_table$`Time_shmean(1.0)Q` %>% format.default(digits=1))
            , position=position_dodge(width = 1), vjust=+0.7
            ) +
  xlab("Instance Group") + ylab("Rel. Time %")
ggsave("plots/barchart_performance.pdf")
