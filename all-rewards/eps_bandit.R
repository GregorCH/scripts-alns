#
# epsilon-greedy simulation functions
#

#
# produce simulation data for an Epsilon-greedy algorithm on given data frame x
#
# Parameters:
# - epsilon the level of exploration, can be larger than 1
# - reps the number of repetitions
#
eps_greedy <- function(x, epsilon = 0.1, reps = 1) {
  # determine the epsilon_t in each step
  n <- nrow(x)
  K <- 8

  # set seed only once at the beginning for independent repetitions
  set.seed(20180123)

  rewards <- x[,heuristic_names]
  reset <- x$chg
  eps_t <- epsilon * sqrt(K/x$call)
  #
  # pmin is elementwise minimum
  #
  eps_t <- pmin(eps_t, 1.0)

  scores <- matrix(0,n,reps)

  # compute one score column for every repetition
  for (r in 1:reps)
  {
    # draw n random numbers and n random selections of the actions
    randdraw <- runif(n)
    randsamples <- sample(K, n, replace = TRUE)

    for (i in 1:n)
    {
      # initialize a new problem
      if( reset[i] )
      {
        means <- rep(0.0,K)
        sels <- rep(0,K)
      }

      # with probability eps_t (decreasing for each call), a random action is explored,
      # otherwise, action with maximum reward is selected.
      if( randdraw[i] <= eps_t[i] )
        sel <- randsamples[i]
      else
        sel <- which.max(means)
      score <- rewards[i,sel]
      sels[sel] <- sels[sel] + 1
      #
      # update arithmetic mean of reward for the selected action.
      #
      means[sel] <- means[sel] + (score - means[sel])/(sels[sel])
      scores[i,r] <- score
    }
  }

  solutions <- scores > 0.5

  result <- data.frame(reward=rowMeans(scores),
                       solution=rowMeans(solutions)
                       )
  return(result)
}

#
# function to create simulation data for different values of epsilon
#
experiment_with_epsgreedy <- function(x, reps = 1, epsilons = seq(1,20,by = 4))
{
  n <- dim(x)[1]
  result <- matrix(0,n,2 * length(epsilons))
  #
  # do the requested number of repetitions of an epsilon greedy selection
  #
  i <- 0
  for (e in epsilons)
  {
    print(e)
    epsdata <- eps_greedy(x, epsilon = e, reps = reps)

    result[,2 * i + 1] <- epsdata$reward
    result[,2 * i + 2] <- epsdata$solution
    i <- i + 1
  }

  return(result)
}

#
# single parameter function to use eps-greedy inside of the optimize function
#
epsgreedy_function <- function(eps) {
  rewards <- eps_greedy(d, epsilon = eps, reps=100)
  value <- mean(rewards[has_sol == TRUE,1])
  return(value)
}
