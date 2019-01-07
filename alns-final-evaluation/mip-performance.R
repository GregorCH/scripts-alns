#
# this script reads and transforms the MIP performance results
#

require(readr)
require(magrittr)
agg_res <- read_csv("tables/_agg_combined.csv")
#  [1] "Group"                "Settings"             "_abort_"              "_count_"
#  [5] "_dualfail_"           "_fail_"               "_limit_"              "_primfail_"
#  [9] "_solved_"             "_time_"               "_unkn_"               "Time_shmean(1.0)"
# [13] "Nodes_shmean(100.0)"  "PInt_avg"             "Time_shmean(1.0)Q"    "Nodes_shmean(100.0)Q"
# [17] "PInt_avgQ"            "Time_shmean(1.0)p"    "Nodes_shmean(100.0)p"

cols_to_show <- c(1,2,4,10,
                  12,15,
                  #13,16,
                  14,17
                  )
#
# compute percentage deviation
#
agg_res[,15:17] <- 100 * (agg_res[,15:17] - 1)

groups_to_show <- c("All","MIPLIB2010","Diff", "Equal")
group_idx <- agg_res$Group %in% groups_to_show

agg_table <- agg_res[group_idx, cols_to_show]
agg_colnames <- c("Group", "Setting", "Inst.", "Tlim", "Time", "Rel. Time %", "Integral", "Rel. Int. %")
agg_table$Settings <- agg_table$Settings %>% { gsub("_", "", .)}
