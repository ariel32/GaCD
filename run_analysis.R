library(dplyr)

# Check for data and download/unzip if necessary
if (!file.exists("./data")) { dir.create("./data") }
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "./data/dataset.zip",mode="wb")
unzip(zipfile = "./data/dataset.zip",exdir = "./data")

# 1. Merges the training and the test sets to create one data set
# load test data
test.data     <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test.labels   <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
test.subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# load training data
train.data     <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train.labels   <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
train.subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# combine test and training data
combine.data     <- rbind(test.data, train.data)
combine.labels   <- rbind(test.labels, train.labels)
combine.subjects <- rbind(test.subjects, train.subjects)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
features    <- read.table("./data/UCI HAR Dataset/features.txt")
meanstdcols <- grep("(.*)mean[^F]|std(.*)",features[,2])
dataMeanStd <- combine.data[,meanstdcols]

# 3. Uses descriptive activity names to name the activities in the data set
activitynames <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activies      <- right_join(activitynames, combine.labels, by = "V1")
activies      <- select(activies, activity = V2)

# 4. Appropriately labels the data set with descriptive variable names.
dataLabels              <- as.vector(features[meanstdcols, 2])
dataLabels              <- sub("mean\\(\\)","Mean",dataLabels)
dataLabels              <- sub("std\\(\\)","SD",dataLabels)
names(dataMeanStd)      <- dataLabels
combine.subjects$V1     <- as.factor(combine.subjects$V1)
names(combine.subjects) <- "subject"
combineall              <- bind_cols(combine.subjects, activies, dataMeanStd)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meansummary <- combineall %>%
  arrange(subject, activity) %>%
  group_by(subject, activity) %>%
  summarize_all(funs(mean))

summaryLabels <- c("Subject", "Activity", paste("Mean", dataLabels, sep = "_"))
names(meansummary) <- summaryLabels

# save final tidy data for submission
write.table(meansummary, file = "final.txt", row.name=FALSE)
