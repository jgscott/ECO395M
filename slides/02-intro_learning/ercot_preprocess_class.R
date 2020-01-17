library(tidyverse)
library(lubridate)

ercot = read.csv('ercot.csv')
temp = read.csv('temp_small.csv')
dim(load_khou)

ercot$Time = ymd_hms(ercot$Time, tz="America/Chicago")
temp$Time = mdy_hm(temp$Time, tz="America/Chicago")
head(ercot)
head(temp)


load_khou = merge(temp, ercot)
load_khou = load_khou[,c(1, 6, 10)]
dim(load_khou)
head(load_khou)

load_khou$KHOU = load_khou$KHOU - 273.15

keep = which(hour(load_khou$Time) == 15)
qplot(KHOU, COAST, data=load_khou[keep,])

write.csv(na.omit(load_khou[keep,]), 'loadhou.csv', row.names=FALSE)