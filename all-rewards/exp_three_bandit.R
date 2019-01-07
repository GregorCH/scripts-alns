#
# functions for simulation of Exp.3
#

#
# produce simulation data for Exp.3 at a given level of gamma for the specified number of repetitions
# on the data x
#
# Parameters
# - gamma Exp.3 parameter to increase probability of selecting an action uniformly at random
# - reps the number of repetitions
#
exp_three <- function(x, gamma = 0.5, reps = 1) {
  # exp_three bandit samples from a weighted probability distribution
  n <- nrow(x) #number of observations
  K <- 8 #number of actions


  rewards <- x[,heuristic_names]
  reset <- x[, "chg"]

  # set seed only at the beginning to make repetitions independent
  set.seed(12345)

  scorebyrep <- matrix(-1, n, reps)

  # create a reward column for every repetitions
  for( r in 1:reps )
  {
    for( i in 1:n )
    {
      # reset weights for new problem
      if( reset[i] )
      {
        weights <- rep(1.0, K)
        weightsum <- K
      }

      # compute the selection probabilities for each action
      probas <- (1 - gamma) * weights / weightsum + gamma / K
      #
      # sample from the probability distribution to select the next action
      #
      sel <- sample(K, 1, prob = probas)

      # determine the reward and update the weights
      score <- rewards[i, sel]
      learningrate <- 1 / K
      gain <- score / probas[sel]

      oldweight <- weights[sel]
      weights[sel] <- weights[sel] * exp(learningrate * gain)
      weightsum <- weightsum - oldweight + weights[sel]
      scorebyrep[i,r] <- score
    }
  }

  # compute the solution score from the simulated rewards
  solsbyrep <- scorebyrep > 0.5
  df <- data.frame(
    exp_mean = rowMeans(scorebyrep),
    exp_se = sqrt(apply(scorebyrep, 1, var)/reps),
    exp_sol = rowMeans(solsbyrep)
    )
  return(df)
}


#
# create experimental data for Exp.3 at different levels of gamma
#
experiment_with_expThree <- function (x, reps = 2, gammas=seq(0,1,length.out = 5))
{
  returng <- matrix(0, nrow = dim(x)[1], ncols <- 3 * length(gammas))
  i <- 1
  for (g in gammas)
  {
    print(g)
    tmpdata <- exp_three(x, reps = reps, gamma = g)

    returng[,3*(i-1)+1] <- tmpdata[,1]
    returng[,3*(i-1)+2] <- tmpdata[,2]
    returng[,3*(i-1)+3] <- tmpdata[,3]
    i <- i + 1
  }
  return(returng)
}

#
# Exp.3 reward as a single parameter function to be used as argument of optimize().
#
exp_function <- function(gamma) {
  rewards <- exp_three(d, gamma = gamma, reps = 100)
  value <- mean(rewards[has_sol == TRUE, 1])
  return(value)
}
