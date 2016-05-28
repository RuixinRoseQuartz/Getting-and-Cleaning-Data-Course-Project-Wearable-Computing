##Load Data Into R
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/UCI_Dataset.zip", method="curl")
unzip(zipfile="./data/UCI_Dataset.zip",exdir="./data")

##Check if the file is in the Data directory and to view the files in the downloaded dataset
pathDataset <- file.path("./data", "UCI HAR Dataset")
list.files(pathDataset, recursive=TRUE)

##Extract Appropriate Files For Test & Train
testActivity  <- read.table(file.path(pathDataset, "test" , "y_test.txt" ), header = FALSE)
testSubject  <- read.table(file.path(pathDataset, "test" , "subject_test.txt"), header = FALSE)
testFeatures  <- read.table(file.path(pathDataset, "test" , "X_test.txt" ), header = FALSE)

trainActiviy <- read.table(file.path(pathDataset, "train", "y_train.txt"), header = FALSE)
trainSubject <- read.table(file.path(pathDataset, "train", "subject_train.txt"), header = FALSE)
trainFeatures <- read.table(file.path(pathDataset, "train", "X_train.txt"), header = FALSE)

##Join Similar Data From Test & Train
Activity <- rbind(trainActiviy, testActivity)
Subject <- rbind(trainSubject, testSubject)
Features <- rbind(trainFeatures, testFeatures)

##Give Variable Names
names(Subject) <- c("subject")
names(Activity) <- c("activity")
dataFeaturesNames <- read.table(file.path(pathDataset, "features.txt"),head=FALSE)
names(Features) <- dataFeaturesNames$V2

##Merging The Test & Train Datasets
Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

##Extract The Measurements On Mean & Standard Deviation
subsetDataNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subsetDataNames), "subject", "activity" )
Data2<-subset(Data,select=selectedNames)

##Activity Labels
activityLabels <- read.table(file.path(pathDataset, "activity_labels.txt"),header = FALSE)

names(Data2) <- gsub("^t", "time", names(Data2))
names(Data2) <- gsub("^f", "frequency", names(Data2))
names(Data2) <- gsub("Acc", "Accelerometer", names(Data2))
names(Data2) <- gsub("Gyro", "Gyroscope", names(Data2))
names(Data2) <- gsub("Mag", "Magnitude", names(Data2))
names(Data2) <- gsub("BodyBody", "Body", names(Data2))

##Second Tidy Data
library(dplyr)
groupData <- Data2 %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
write.table(avgTidyData, file = "tidydata.txt",row.name=FALSE)