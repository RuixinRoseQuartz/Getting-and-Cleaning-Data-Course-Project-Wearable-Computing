
#####Loading Data Into R
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./Desktop/Data/")

To check if the file is in the Data directory
list.files("./Desktop/Data/")
