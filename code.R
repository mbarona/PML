#.csv files are stored in the working directory
training = read.csv("pml-training.csv")
str(training)
summary(training)

#reloading data
training = read.csv("pml-training.csv", na.strings = c("NA","#DIV/0!",""))
testing = read.csv("pml-testing.csv", na.strings = c("NA","#DIV/0!",""))


#identifying variables without missing values
cols = colSums(is.na(training))
cols_nmv <- which(cols==0)

#create new data frames containing variables with complete entries
#removing irrelevant variables
training2 = training[,cols_nmv]
training2 = training2[,c(-5:-3,-1)]
testing2 = testing[,cols_nmv]
testing2 = testing2[,c(-5:-3,-1)]

#check dimensions of the data and take a look of the new dataset
dim(training2); dim(testing2)
head(training2); head(testing2)

library(caret)

set.seed(807)
inTrain = createDataPartition(y=training2$classe, p = 0.6, list = FALSE)
subTrain = training2[inTrain,]
subTest = training2[-inTrain,]


dim(subTrain); dim(subTest)


# First algorithm used: 'rpart' or Decision tree. 

set.seed(807)
#loading rpart packages
library(rpart)
library(rpart.plot)
library(caret)

#building the model using the subTrain data
mod1 = train(classe ~ ., method = "rpart", data = subTrain)
#results
mod1
mod1$finalModel
#simple plot
prp(mod1$finalModel)

#running predictions using the mod1 on subTest data  
pred1 = predict(mod1, subTest)

#confusion matrix for evaluation of the model
confusionMatrix(pred1, subTest$classe)


# Second Algorithm used: 'rf' or Random Forest.

set.seed(807)

#load random forest package
library(randomForest)

#building model using the subTrain data
mod2 = train(classe ~ ., method = "rf", data = subTrain)

#results
mod2
mod2$finalModel

#running predictions using mod2 on subTest data
pred2 = predict(mod2, subTest)

#model evaluation
confusionMatrix(pred2, subTest$classe)

#applying the mod2 (random forest model) on our testing set 
pred3 = predict(mod2, testing)
pred3

