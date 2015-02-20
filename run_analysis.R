setwd("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset")

########################################
## Read in files
########################################

features <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/features.txt")

subjecttest <-read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/test/subject_test.txt")
names(subjecttest) <- "subject_id"
xtest <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/test/X_test.txt")
names(xtest) <- features$V2
ytest <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/test/y_test.txt")
names(ytest) <- "activity"

subjecttrain <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
names(subjecttrain) <- "subject_id"
xtrain <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/train/X_train.txt")
names(xtrain) <- features$V2
ytrain <- read.table("~/Dropbox/Data_Science/Getting And Cleaning Data/UCI HAR Dataset/train/y_train.txt")
names(ytrain) <- "activity"


########################################
## Extract "[Mm]ean" and "[Ss]td"
## from xtrain and xtest
########################################

xtrain <- xtrain[,(grepl("[Ss]td|[Mm]ean", names(xtrain)))]
xtest <- xtest[,(grepl("[Ss]td|[Mm]ean", names(xtest)))]


########################################
## Merge data files
########################################

test <- cbind(subjecttest,ytest,xtest)
train <- cbind(subjecttrain,ytrain,xtrain)
all <- rbind(test,train)


########################################
## Label activity variables
########################################

all$activity <- factor(all$activity, levels = c(1,2,3,4,5,6), labels = c("Walking", "Walking_Upstairs", "Walking_Downstairs", "Sitting", "Standing", "Laying"))


########################################
## Average values by subject-activity
########################################

library(dplyr)
final <- aggregate(all, list(all$subject_id, all$activity), mean)


########################################
## Tidy up dataset
########################################

final <- select(final, -(3:4))
final_tidy <- rename(final, subject_id = Group.1, activity = Group.2)
final_tidy <- arrange(final_tidy, subject_id, desc(activity))


########################################
## Write table
########################################

write.table(final_tidy, "final_tidy.txt", row.names = FALSE)