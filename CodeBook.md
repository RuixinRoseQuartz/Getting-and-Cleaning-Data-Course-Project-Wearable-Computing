Raw data provided in various texts files in a zip folder that can be downloaded from  "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
There are files with just data and files with just variable names etc.

Here are my steps for this project.

#####Load Data Into R
    if(!file.exists("./data")){dir.create("./data")}
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile="./data/UCI_Dataset.zip", method="curl")
    unzip(zipfile="./data/UCI_Dataset.zip",exdir="./data")

To check if the file is in the Data directory
    pathDataset <- file.path("./data", "UCI HAR Dataset")

To view the files in the downloaded dataset
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

#####Extract Only The Measurements on the mean and standard deviation for each meausrement
subsetDataNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subsetDataNames), "subject", "activity" )
Data2<-subset(Data,select=selectedNames)

#####Activity Labels
activityLabels <- read.table(file.path(pathDataset, "activity_labels.txt"),header = FALSE)

names(Data2)<-gsub("^t", "time", names(Data2))
names(Data2)<-gsub("^f", "frequency", names(Data2))
names(Data2)<-gsub("Acc", "Accelerometer", names(Data2))
names(Data2)<-gsub("Gyro", "Gyroscope", names(Data2))
names(Data2)<-gsub("Mag", "Magnitude", names(Data2))
names(Data2)<-gsub("BodyBody", "Body", names(Data2))

#####2nd tidy data
library(dplyr)
groupData <- Data2 %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))
write.table(avgTidyData, file = "tidydata.txt",row.name=FALSE)
