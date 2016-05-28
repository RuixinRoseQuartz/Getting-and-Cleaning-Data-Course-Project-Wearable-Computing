#####Set Working Directory
setwd("./data")

#####Loading Data Into R
if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile="./data/UCI_dataset.zip", method="curl")

unzip(zipfile="./data/UCI_dataset.zip",exdir="./data")

To check if the file is in the Data directory
pathDataset <- file.path("./data", "UCI HAR Dataset")
list.files(pathDataset, recursive=TRUE)

#####Extract the appropriate files for Test
testActivity  <- read.table(file.path(pathDataset, "test" , "y_test.txt" ), header = FALSE)
testSubject  <- read.table(file.path(pathDataset, "test" , "subject_test.txt"), header = FALSE)
testFeatures  <- read.table(file.path(pathDataset, "test" , "X_test.txt" ), header = FALSE)


#####Extract the appropriate files for Train
trainActiviy <- read.table(file.path(pathDataset, "train", "y_train.txt"), header = FALSE)
trainSubject <- read.table(file.path(pathDataset, "train", "subject_train.txt"), header = FALSE)
trainFeatures <- read.table(file.path(pathDataset, "train", "X_train.txt"), header = FALSE)

###Merging the test and the train datasets
Activity <- rbind(trainActiviy, testActivity)
Subject <- rbind(trainSubject, testSubject)
Features <- rbind(trainFeatures, testFeatures)

#####Give the variable names
names(Subject) <- c("subject")
names(Activity) <- c("activity")
dataFeaturesNames <- read.table(file.path(pathDataset, "features.txt"),head=FALSE)
names(Features) <- dataFeaturesNames$V2

Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)
