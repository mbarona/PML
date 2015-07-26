dir()
training = read.csv("pml-training.csv")
str(training)
summary(training)

#reloading data
training = read.csv("pml-training.csv", na.strings = c("NA","#DIV/0!",""))
testing = read.csv("pml-testing.csv", na.strings = c("NA","#DIV/0!",""))

#cleaning data - delete columns with missing values
cols = colSums(is.na(training))
table(cols)
cols_nmv <- which(cols==0)

training2 = training[,cols_nmv]
str(training2)
summary(training2)

#clean testing data???

#convert converted timestamp to date format
training2$cvtd_timestamp = strptime(training2$cvtd_timestamp, "%m/%d/%Y %H:%M")
library(lubridate)
training2$AMPM = ifelse(hour(training2$cvtd_timestamp)<12,'AM','PM')
training2$Day = weekdays(training2$cvtd_timestamp)
