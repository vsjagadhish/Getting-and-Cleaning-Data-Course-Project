#Loading required packages
library(dplyr)
#Downloading the required dataset for the assignment
filename <- "getdata_projectfiles_UCI HAR Dataset.zip"
if (!file.exists(filename))
{
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("getdata_projectfiles_UCI HAR Dataset"))
{ 
  unzip(filename) 
}
# Assigning all data frames

features <- read.table("getdata_projectfiles_UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("getdata_projectfiles_UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("getdata_projectfiles_UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("getdata_projectfiles_UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("getdata_projectfiles_UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("getdata_projectfiles_UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("getdata_projectfiles_UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("getdata_projectfiles_UCI HAR Dataset/train/y_train.txt", col.names = "code")

# Creating the data set

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

# Extracting measurements on the mean and standard deviation for each measurement
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#Uses descriptive activity names to label the activities in the data set
TidyData$code <- activities[TidyData$code,2]

# labelling the data set 
names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

FinalTidyData <- TidyData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(FinalData, "FinalTidyData.txt", row.name=FALSE)



