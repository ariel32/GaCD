# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Create directory if it does not already exist.
2. Download data and unpack it.
3. Load the data, activity, feature for test and training dataset.
4. Joining test and training data.
5. Extracts only the measurements on the mean and standard deviation for each measurement.
6. Uses descriptive activity names to name the activities in the data set.
7. Appropriately labels the data set with descriptive variable names.
8. Create tidy data set with the average of each variable for each activity and each subject.

Finaly, results saved in text file `final.txt` with command `write.table(..., row.name=FALSE)`.