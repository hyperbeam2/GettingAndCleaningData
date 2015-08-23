# Codebook

This is a code book that describes the variables, the data, and any transformations or work that is performed to clean up the data

## Dataset

### Collection of the raw data

This data is obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Dataset information

Full description on the data is at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Files used

1. Training Datasets
  * train/subject_train.txt
  * train/X_train.txt
  * train/y_train.txt
2. Test Datasets
  * test/subject_test.txt
  * test/X_test.txt
  * test/y_test.txt
3.  features.txt - List of all features
4.  activity_labels.txt - Connects the labels with their activity name.

## Transformation Steps

### Overall transformation steps

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Implementation in run_analysis.R

Prerequisite: Download the raw data and unzip to your working directory

Steps in run_analysis.R:
1. Load all the raw training and test datasets
2. Read features and activity_labels file
3. Merge training and test datasets respectively
4. Create one combined dataset by merging the training and test dataset
5. Determine only measurements on the mean and standard deviation to be extracted
6. Label the dataset as it is
7. Convert "Activity" and "Subject" column into factor variables
8. Create a tidy dataset with average of each variable for each activity and each subject
9. Write the tidy dataset into file named "Tidy.txt"
