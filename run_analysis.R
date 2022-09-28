download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "samsung.zip")
unzip("samsung.zip",exdir ="samsung")
library(tidyverse)

#1. Merge the training and the test sets to create one data set.

#a. train data
dataset_train <- read_fwf('samsung/UCI HAR Dataset/train/X_train.txt')
train_label <- read_fwf('samsung/UCI HAR Dataset/train/y_train.txt')
train_subject <- read_fwf('samsung/UCI HAR Dataset/train/subject_train.txt')

dataset_train <- cbind(train_label,train_subject,dataset_train)

#b. test data

dataset_test <- read_fwf('samsung/UCI HAR Dataset/test/X_test.txt')
test_label <- read_fwf('samsung/UCI HAR Dataset/test/y_test.txt')
test_subject <- read_fwf('samsung/UCI HAR Dataset/test/subject_test.txt')

dataset_test <- cbind(test_label,test_subject,dataset_test)

#c. merge

dataset <- rbind(dataset_train,dataset_test)

# 4. Appropriately label the data set with descriptive variable names. 
features <- read_delim('samsung/UCI HAR Dataset/features.txt', delim=" ", col_names=F)
#some columns have duplicated names, therefore to make ut unique I use make.unique
features <- make.unique(features$X2)
names <- c("activity", "subject", features)

colnames(dataset) <- names

# 3. Use descriptive activity names to name the activities in the data set

dataset$activity <- factor(dataset$activity, labels =c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))


# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

subset <- dataset %>%
  select(contains(c("mean","std")))


# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for 
# each activity and each subject.

dataset$subject <- as.factor(dataset$subject)
average <- dataset %>%
  group_by(activity,subject) %>%
  summarise(across(.fns=mean))

# saving objects to RDS files
saveRDS(dataset,file="clean_data.RDS")
saveRDS(average,file="mean_grouped.RDS")
saveRDS(subset,file="mean_std.RDS")


