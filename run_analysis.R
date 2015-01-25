# Read data
testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/y_test.txt")
trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/y_train.txt")
usertest <- read.table("./test/subject_test.txt")
usertrain <- read.table("./train/subject_train.txt")
fx <- read.table("./features.txt")

# combine data
data <- rbind(testX, trainX)
activity <- rbind(testY, trainY)
colnames(activity) <- "activity"
user <- rbind(usertest,usertrain)
colnames(user) <- "user"
library(plyr)
library(dplyr)
xx <- data
xx <- cbind(xx,activity)
xx <- cbind(xx,user)

# rename columns
colnames(xx) <- c(as.character(fx$V2),"activity","user")

# remove duplicated columns
yy <- xx[which(!duplicated(colnames(xx)))]
yy2 <- select(yy, contains("mean"))
yy3 <- select(yy, contains("std"))
yy <- cbind(yy2,yy3,activity,user)

# rename the values for "activity"
for (i in 1:10299) {
y <- yy$activity[i]
  if (y==1) {
    yy$activity[i] <- "WALKING"    
  } else if (y==2) {
    yy$activity[i] <- "WALKING_UPSTAIRS"
  } else if (y==3) {
    yy$activity[i] <- "WALKING_DOWNSTAIRS"
  } else if (y==4) {
    yy$activity[i] <- "SITTING"
  } else if (y==5) {
    yy$activity[i] <- "STANDING"
  } else if (y==6) {
    yy$activity[i] <- "LAYING"
  } else {
    print(yy$activity[i])
  }
}


library(reshape2)
dMelt <- melt(yy,id=c("activity","user"))
dMelt1 <- group_by(dMelt,activity,user,variable)
result <- summarize(dMelt1,mean(value))
print(result)
