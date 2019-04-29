#read in data and set factors/numerics
pen = read.table('../data/pen2ref.txt',header=T)
facind = c( 1, 3, 5, 7, 9, 19, 20, 21) #which variables are factors (categorical)
for(i in facind) pen[[i]] = as.factor(pen[[i]])

#train,val,test
set.seed(99)
n=nrow(pen)
n1=floor(n/2)
n2=floor(n/4)
n3=n-n1-n2
ii = sample(1:n,n)
pentrain=pen[ii[1:n1],]
penval = pen[ii[n1+1:n2],]
pentest = pen[ii[n1+n2+1:n3],]


