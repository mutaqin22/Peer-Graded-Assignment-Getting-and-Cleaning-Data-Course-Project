# Set directory path
setwd("D:\\Coursera\\Getting and Cleaning Data")

# load package
library(dplyr)

# Read data and add column names
features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("subject_test.txt", col.names = "subject")
x_test <- read.table("X_test.txt", col.names = features$functions)
y_test <- read.table("y_test.txt", col.names = "code")
subject_train <- read.table("subject_train.txt", col.names = "subject")
x_train <- read.table("X_train.txt", col.names = features$functions)
y_train <- read.table("y_train.txt", col.names = "code")

# Cek str several properties value
str(features)
str(activities)
str(subject_test)
str(x_test)
str(y_test)
str(subject_train)
str(x_train)
str(y_train)

# Merge the data by row
df1 <- rbind(x_train, x_test)
df2 <- rbind(y_train, y_test)
df3 <- rbind(subject_train, subject_test)

# Merge the data to create one datasets
Data_final <- cbind(df3, df2, df1)

# Extracts only the measurements on the mean and standard deviation for each measurement
TidyData <- Data_final %>% select(subject, code, contains("mean"), contains("std"))

# add descriptive activity names to name the activities in the data set.
TidyData$code <- activities[TidyData$code, 2]

# Appropriately labels the data set with descriptive variable names.
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

# Creates a second,independent tidy data set and ouput it
FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

# Fincal Cek
str(FinalData)
