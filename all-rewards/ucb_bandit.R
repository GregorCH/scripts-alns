#
# simulation code for UCB bandit
#

#
# simulate UCB bandit algorithm on the data x and return the average reward and solution rate
#
# Parameters:
# - alpha the confidence width of the bandit algorithm
# - reps the number of repetitions
ucb_bandit <- function(x, alpha = 0.5, reps = 1) {

  # initialize weights on the first eight experiments
  n <- dim(x)[1]
  K <- 8

  # seed is set only once at the beginning, to make repetitions independent
  set.seed(14081986)

  reset <- x$chg
  callnr <- x$call
  rewards <- x[,heuristic_names]

  scores <- matrix(0, n,reps)
  for( r in 1:reps )
  {
    for( i in 1:n )
    {
      # reset the bandit for a new problem
      if( reset[i] )
      {
        perm <- sample(K, K)
        means <- rep(0, K)
        sels <- rep(1, K)
      }

      # the first K calls are used for initialization
      if( callnr[i] <= K )
      {
        score <- rewards[i, perm[callnr[i]]]
        scores[i,r] <- score
        means[perm[callnr[i]]] <- score
      }
      else
      {
        # choose and score the action (neighborhood) with maximum UCB score
        ucbs <- means + sqrt(alpha *log(i)/sels)
        sel <- which.max(ucbs)
        score <- rewards[i, sel]
        scores[i,r] <- score
        sels[sel] <- sels[sel] + 1
        means[sel] <- means[sel] + (score - means[sel]) / sels[sel]
      }
    }
  }

  solutions <- scores > 0.5
  result <- data.frame(reward=rowMeans(scores),
                       solution=rowMeans(solutions)
                       )
  return(result)
}

#
# produce data for UCB at different levels of alpha
#
experiment_with_ucb <- function(x, alphas=seq(0, 1, by=0.2), reps = 1)
{
  n <- dim(x)[1]
  result <- matrix(0, nrow = n, ncol = 2 * length(alphas))

  i <- 1
  for ( a in alphas )
  {
    print(a)
    ucb_data <- ucb_bandit(x, alpha = a, reps = reps)
    result[,2 * i - 1] <- ucb_data[,1]
    result[,2 * i] <- ucb_data[,2]
    i <- i + 1
  }

  return(result)
}

#
# UCB as single-parameter function for the optimize command
#
ucb_function <- function(alpha) {
  #
  # 100 repetitions on the large data set, evaluating the mean performance
  # of ucb for the given parameter value of alpha.
  #
  ucb_data <- ucb_bandit(d, alpha = alpha, reps = 100)
  rewards <- ucb_data[has_sol == TRUE, 1]
  return(mean(rewards))
}
