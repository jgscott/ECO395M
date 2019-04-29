

################################################################################
## Read in the California Housing data.
## Transform some of the variables.
## Divide data into train,val,test.
################################################################################

#--------------------------------------------------
#read-in data
ca <- read.csv("../data/CAhousing.csv",header=TRUE)
ca$AveBedrms <- ca$totalBedrooms/ca$households
ca$AveRooms <- ca$totalRooms/ca$households
ca$AveOccupancy <- ca$population/ca$households
logMedVal <- log(ca$medianHouseValue)
ca <- ca[,-c(4,5,9)] # lose lmedval and the room totals
ca$logMedVal = logMedVal

#--------------------------------------------------
#train, val, test
set.seed(99)
n=nrow(ca)
n1=floor(n/2)
n2=floor(n/4)
n3=n-n1-n2
ii = sample(1:n,n)
catrain=ca[ii[1:n1],]
caval = ca[ii[n1+1:n2],]
catest = ca[ii[n1+n2+1:n3],]
