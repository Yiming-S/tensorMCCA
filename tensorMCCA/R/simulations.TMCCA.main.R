rm(list = ls())


#######################
###   SIMULATIONS   ###
#######################

## Install modified version of package 'RGCCA'
## (Change file path as needed)


# install.packages("C://Users//Administrator//Documents//GitHub//Data-Analytics-Lab-Prof.Degras\\mCCA\\code\\RGCCA_modified", type = "source", repos = NULL)
library(RGCCA)
# install.packages("RGCCA")
# Install tensorMCCA package from github
library(devtools)
# install_github("https://github.com/ddegras/tensorMCCA", subdir = "tensorMCCA",
               # force = TRUE)
library(tensorMCCA)
## Load required packages 
library(clue)
library(RSpectra)
library(foreach)
library(doParallel)
ncores <- detectCores() - 1L
# registerDoParallel(ncores)

## Source required files 
code.dir <- "C://Users//Administrator//Documents//GitHub//Data-Analytics-Lab-Prof.Degras//mCCA//code//simulations"
# code.dir <- "/Users/xinminchu/Documents/GitHub/Data-Analytics-Lab-Prof.Degras/mCCA/code/simulations"

source(file.path(code.dir, "simulations.functions.R"))
source(file.path(code.dir, "run.simulation.R"))
source(file.path(code.dir, "ctd.R"))


#set.seed(2023)

###################
### DESCRIPTION ###
###################

# factor models (cf. TMCCA paper)
factor.model <- "alldim"

# Parameters to vary
# data dimensions
# n: number of individuals/samples/subjects
n <- c(50, 100, 500) # want to simulate at three levels: small, medium, large

# r: number of canonical components (v_i^(l), l = 1,..., r) extracted from original data
r <- 4 # fixed number of canonical components

nrep <- 1000 # number of replications

# noise.cov: noise level
xi = c(0.05, 0.25, 0.5, 0.75) 
## want to simulate at three levels: low, moderate, high

## MCCA parameters
obj.type <- c("cov", "cor")

paras <- expand.grid(model = factor.model, n = n,
                     noise = xi, obj.type = obj.type, 
                     stringsAsFactors = FALSE)


# p: data structure (1D vector, 2D matrix, 3D or higher tensor)
## simulate two data structure types
p <- list(10, c(5,10), c(6,8,10)) # vector+matrix+tensor


registerDoParallel(ncores)
sim.result <- foreach(i = 1:nrow(paras),.errorhandling = "remove") %dopar% { 
  library(RGCCA)
  library(tensorMCCA)
  ## Source required files 
  code.dir <- "C://Users//Administrator//Documents//GitHub//Data-Analytics-Lab-Prof.Degras//mCCA//code//simulations"
  # code.dir <- "/Users/xinminchu/Documents/GitHub/Data-Analytics-Lab-Prof.Degras/mCCA/code/simulations"
  
  source(file.path(code.dir, "simulations.functions.R"))
  source(file.path(code.dir, "run.simulation.R"))
  source(file.path(code.dir, "ctd.R"))

  run.simulation(factor.model = paras$model[i], n=paras$n[i], 
                  p=p, r=r,
                  xi=paras$noise[i],
                  objective.type =paras$obj.type[i], 
                  nrep=nrep)
}
save(sim.result, file = "C://Users//Administrator//Documents//GitHub//Data-Analytics-Lab-Prof.Degras//mCCA//code//simulations//simulation_result//sim.result_nrep1000.RData")

save.image(file = "C://Users//Administrator//Documents//GitHub//Data-Analytics-Lab-Prof.Degras//mCCA//code//simulations//simulation_result//sim.result_nrep1000.RData")


# for(i in 1:5){
#   if (paras$model[i] == "global") next
#   cat(i,"-----------------------------------","\n")
#   start <- Sys.time()
#   p.low.simu.results[[i]] <-
#     run.simulation(factor.model = paras$model[i],
#                             n=paras$n[i],
#                             p=p.low,
#                             r=r,
#                             xi=paras$noise[i],
#                             objective.type =paras$obj.type[i],
#                             nrep=nrep)
#   cat(i, Sys.time() - start, "\n")
# }
# 
# save(p.low.simu.results, file = "sim.mcca.percent.nrep10.RData")






########################
###   BOOTSTAPPING   ###
########################


