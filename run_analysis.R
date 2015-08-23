##this script is to be run in a folder that contains "UCI HAR Dataset"

##using
library(dplyr)
library(data.table)
library(tidyr)

filesPath <- "UCI HAR Dataset"
#Read required datasets
dSubjectTrain <- tbl_df(read.table(file.path(filesPath, "train", "subject_train.txt")))
dSubjectTest  <- tbl_df(read.table(file.path(filesPath, "test" , "subject_test.txt" )))
dActivityTrain <- tbl_df(read.table(file.path(filesPath, "train", "Y_train.txt")))
dActivityTest  <- tbl_df(read.table(file.path(filesPath, "test" , "Y_test.txt" )))
dTrain <- tbl_df(read.table(file.path(filesPath, "train", "X_train.txt" )))
dTest  <- tbl_df(read.table(file.path(filesPath, "test" , "X_test.txt" )))

### 1.Merges the training and the test sets to create one data set
# merge subject and activitiy and rename variables "subject" and "activityNum"
alldataSubject <- rbind(dSubjectTrain, dSubjectTest)
setnames(alldataSubject, "V1", "subject")
alldataActivity<- rbind(dActivityTrain, dActivityTest)
setnames(alldataActivity, "V1", "Activity")

#combine the DATA training and test files
dataTable <- rbind(dTrain, dTest)

# name variables according to feature e.g.(V1 = "tBodyAcc-mean()-X")
dataFeatures <- tbl_df(read.table(file.path(filesPath, "features.txt")))
setnames(dataFeatures, names(dataFeatures), c("featureNum", "featureName"))
colnames(dataTable) <- dataFeatures$featureName

#column names for activity labels
activityLabels<- tbl_df(read.table(file.path(filesPath, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("Activity","activityName"))

# Merge columns
alldataSubjAct<- cbind(alldataSubject, alldataActivity)
dataTable <- cbind(alldataSubjAct, dataTable)

### 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# Reading "features.txt" and extracting only the mean and standard deviation
# by using RegEx
dataFeaturesMeanStd <- grep("mean\\(\\)|std\\(\\)",dataFeatures$featureName,value=TRUE) 

# Taking only measurements for the mean and standard deviation 
# add "subject","activityNum"
dataFeaturesMeanStd <- union(c("subject","Activity"), dataFeaturesMeanStd)
dataTable<- subset(dataTable,select=dataFeaturesMeanStd) 


### 3.Uses descriptive activity names to name the activities in the data set
##enter name of activity into dataTable
dataTable <- merge(activityLabels, dataTable , by="Activity", all.x=TRUE)
dataTable$activityName <- as.character(dataTable$activityName)

## create dataTable with variable means sorted by subject and Activity
dataTable$activityName <- as.character(dataTable$activityName)
dataAggr<- aggregate(. ~ subject - activityName, data = dataTable, mean) 
dataTable<- tbl_df(arrange(dataAggr,subject,activityName))

### 4. Appropriately labels the data set with descriptive variable names.
names(dataTable)<-gsub("std()", "SD", names(dataTable))
names(dataTable)<-gsub("mean()", "MEAN", names(dataTable))
names(dataTable)<-gsub("^t", "time", names(dataTable))
names(dataTable)<-gsub("^f", "frequency", names(dataTable))
names(dataTable)<-gsub("Acc", "Accelerometer", names(dataTable))
names(dataTable)<-gsub("Gyro", "Gyroscope", names(dataTable))
names(dataTable)<-gsub("Mag", "Magnitude", names(dataTable))
names(dataTable)<-gsub("BodyBody", "Body", names(dataTable))

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(dataTable, "Tidy.txt", row.name=FALSE)

