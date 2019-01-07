library(readr)
library(ggplot2)
library(reshape2)

#
# read the raw csv data. The column names can be inferred
# from the SCIP code in src/scip/heur_alns.c, method
# heurExecAlns at the very end. Data has been filtered
# beforehand to exclude all instances where some of the
# neighborhoods are not active.
#
d <- read_csv("data/fulllines.csv",
                      col_names = FALSE)

# order of the heuristics is the inclusion order in heur_alns.c:includeNeighborhoods
heuristic_names <- c(
  "rens",
  "rins",
  "mutation",
  "localbranching",
  "crossover",
  "proximity",
  "zeroobjective",
  "dins"
)

# assign column headers
colnames(d) <- c(
  c("problem"),
  heuristic_names,
  c("bandit", "fixrate")
)


#
# check where the problem changes. This is sufficient
# because the data layout lists all problems
# for one fixing rate consecutively.
#
n <- dim(d)[1]
dchg <- rep(TRUE, n)

dchg[2:n] <- d$problem[2:n] != d$problem[1:n-1]

dcall <- rep(0, n)
for ( i in 1:n )
{
  if( dchg[i] )
    dcall[i] <- 1
  else
    dcall[i] <- dcall[i-1] + 1
}

#
# enlarge data by
#
d <- cbind(d,
           d[,heuristic_names] > 0.5, # indicator whether a solution was found or not
           dchg,                      # the change indicator
           dcall                      # the call index
           )

# extend also column names
solnames <- gsub("$", "_sol", heuristic_names, perl = TRUE)
colnames(d) <- c('problem',
                 heuristic_names,
                 "bandit", "fixrate",
                 solnames,
                 "chg",
                 "call"
                 )

#
# create a second data frame that lists only calls where
# at least one heuristic was successful. This is the main
# data frame for most of the analysis
#
has_sol <- as.data.frame(apply(d[,solnames], 1, FUN=any))
d_sol <- d[has_sol == TRUE,]

# by using the reshape2::melt function, each record in the original data is
# split into eight records, one for each individual heuristic

# contains rewards
melted_sol <- melt(d_sol,
                   measure.vars = heuristic_names,
                   value.name = "reward", variable.name = "heuristic", id.vars = "fixrate")
# contains binary indicator whether solution was found
melted_sol_solutions <- melt(d_sol,
                             measure.vars = solnames,
                             value.name = "solution", variable.name = "heuristic", id.vars = "fixrate")


### first statistics

# number of calls (ie, records) per problem instance
call_freqs <- as.data.frame(table(d$fixrate, d$problem))
colnames(call_freqs) <- c("fixrate", "problem", "freq")

# average number of calls per fixing rate to be reported
mean_freqs <- aggregate(freq ~ fixrate, data = call_freqs, FUN=mean)

# the average reward or solution for each record
rewardsavg <- rowMeans(d[,heuristic_names])
solavg <- rowMeans(d[, solnames])


# compute the success rate per fixing rate that is reported in the paper
virt_successrate <- table(d_sol$fixrate) / table(d$fixrate)

## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)

  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }

  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )

  # Rename the "mean" column
  datac <- rename(datac, c("mean" = measurevar))

  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval:
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult

  return(datac)
}
