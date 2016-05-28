#####Set Working Directory
setwd("./data")

#####Loading Data Into R
if(!file.exists("./data")){dir.create("./data")}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile="./data/UCI_dataset.zip", method="curl")

unzip(zipfile="./data/UCI_dataset.zip",exdir="./data")

To check if the file is in the Data directory
pathDataset <- file.path("./data" , "UCI_dataset")
list.files(pathDataset, recursive=TRUE)

#####Extract the appropriate files
