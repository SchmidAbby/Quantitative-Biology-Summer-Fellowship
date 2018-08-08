# Nonlinear Markov Model for Chlamydia spread in Chicago


############ Basic model #################
# One neighborhood 
# Assumptions:
# everyone is having sex every week 
# Time step is a week 

nstates <- 3 # Suseptible, infected, treated
nstep <- 52 # number of time steps to propagate

# initial condition
pS = 0.99
pI = 0.01
pT = 0 

ProbVec <- matrix(0,nrow=nstates, ncol=nstep+1) # initialize the probability array
ProbVec[,1] <- c(pS, pI, pT) # set the initial probability vector

# define the transition matrix for the Markov model
Tmatrix <- matrix(c(1-pI*.65, pI*.65, pT, .02, .48, .5, 1, 0, 0),nrow=nstates,ncol=nstates) 

for (i in 1:nstep) {
  pI <- ProbVec[2, i]
  pS <- ProbVec[1, i]
  Tmatrix[1, 1] <- (1-(pI*0.65))
  Tmatrix[2, 1] <- (pI*0.65)
  ProbVec[,i+1] <- Tmatrix %*% ProbVec[,i]
}

ndisp <- 52 # number of timepoints to display
# select exactly ndisp timepoints to display within dstep times
tpoints <- 1+nstep%/%ndisp*0:(ndisp-1)

# plot the probability distribution at ndisp time points
barplot(ProbVec[,tpoints],axes=TRUE,names.arg=tpoints,col=c('medium sea green','firebrick2','darkorchid1'), 
        main = "Probability Distribution SIT Model", legend.text = c("Susceptible", "Infected", "Treated"), args.legend = list(x = "right"))



########### Adding "inactive" state ################
# Assumptions:
# Time step is a month
# Adding inactive state to account for fact that not everyone is having sex

nstates <- 4 # Suseptible, infected, treated, inactive
nstep <- 10 # number of time steps to propagate


# initial conditions
pS = 0.39
pI = 0.01
pT = 0 
pN = 0.6


ProbVec <- matrix(0,nrow=nstates, ncol=nstep+1) # initialize the probability array
ProbVec[,1] <- c(pS, pI, pT, pN) # set the initial probability vector

# define the transition matrix for the Markov model
Tmatrix <- matrix(c((1-(pI*.65)-.26), (pI*.65), pT, .26, .06, .69, .25, 0, 1, 0, 0, 0, .26, 0, 0, .74)
                  ,nrow=nstates,ncol=nstates) 

for (i in 1:nstep) {
  pI <- ProbVec[2, i]
  pS <- ProbVec[1, i]
  Tmatrix[1, 1] <- (1-(pI*0.65)-.26)
  Tmatrix[2, 1] <- (pI*0.65)
  ProbVec[,i+1] <- Tmatrix %*% ProbVec[,i]
}

ndisp <- 10 # number of timepoints to display
# select exactly ndisp timepoints to display within dstep times
tpoints <- 1+nstep %/% ndisp*0:(ndisp-1)

# plot the probability distribution at ndisp time points
barplot(ProbVec[,tpoints],axes=TRUE,names.arg=tpoints,col=c('medium sea green','firebrick2','darkorchid1', 'orange'), 
        main = "Probability Distribution SITN Model", 
        legend.text = c("Susceptible", "Infected", "Treated", "Inactive"), args.legend = list(x = "bottomright"))
