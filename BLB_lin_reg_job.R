
mini <- FALSE

#============================== Setup for running on Gauss... ==============================#

args <- commandArgs(TRUE)

cat("Command-line arguments:\n")
print(args)

####
# sim_start ==> Lowest possible dataset number
###

###################
sim_start <- 1000
###################

####
# set parameters r and gamma
####
r = 50
gamma = 0.7



if (length(args)==0){
  sim_num <- sim_start + 1
  set.seed(121231)
} else {
  # SLURM can use either 0- or 1-indexing...
  # Lets use 1-indexing here...
  sim_num <- sim_start + as.numeric(args[1])
  # In order to set the appropriate random seeds we create an index for
  # r and s.  Every 50th run, s will iterate and r will reset.
  s_index = floor((sim_num-1001)/r) + 1
  r_index = sim_num %% r + 1
  sim_seed <- (762*s_index + 121231)
  set.seed(sim_seed)
}

cat(paste("\nAnalyzing dataset number ",sim_num,"...\n\n",sep=""))

# Find r and s indices:

#============================== Run the simulation study ==============================#

# Load packages:
library(BH)
library(bigmemory.sri)
library(bigmemory)
library(biganalytics)

# I/O specifications:
datapath <- "/home/pdbaines/data"
outpath <- "output/"

# mini or full?
if(mini){
	rootfilename <- "blb_lin_reg_mini"
} 
if(!mini){
	rootfilename <- "blb_lin_reg_data"
}

# Filenames:
filenames = list.files("/home/pdbaines/data/")

# Attach big.matrix :
if(!mini){
  bigdata = attach.big.matrix(paste("/home/pdbaines/data/", filenames[2], sep = ""))
}
if(mini){
  bigdata = attach.big.matrix(paste("/home/pdbaines/data/", filenames[8], sep = ""))
}

# Remaining BLB specs:
n = nrow(bigdata)

b = round(n^gamma)

p = ncol(bigdata)


# Extract the subset:
data.sample = bigdata[sample(1:n, b),]


# Reset simulation seed:
set.seed(762*sim_num-1 + 121231)

# Bootstrap dataset:
bs.weights = as.numeric(table(sample(1:b, n, replace = TRUE))) / n

# Fit lm:
model = lm(data.sample[,p] ~ data.sample[,-p], weights = bs.weights)

# Output file:
coefs = model$coefficients


# Save estimates to file:
outfile = paste0("output/","coef_",sprintf("%02d",s_index),"_",
                 sprintf("%02d",r_index),".txt")
write(coefs, file = paste("~/HW2/BLB/",outfile, sep = ""), ncolumns = 1)









