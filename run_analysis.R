## Here are the data for the project:
        
##        https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## You should create one R script called run_analysis.R that does the following.

## 1 - Merges the training and the test sets to create one data set.

#### Download and unzip dataset

url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="dataset.zip")
unzip("dataset.zip")

#### Load libraries

library(dplyr)

#### Set variable names

setwd("UCI HAR Dataset")
headings<-read.table("features.txt") 
headings<-headings[,2]
col_headings<-c("subject",as.character(headings),"activity")

#### Create Test dataframe

setwd("test")
test_txt<-list.files(pattern="*.txt")
txt_files_df<-lapply(test_txt, read.table, header = FALSE, sep ="")
test_df<-do.call("cbind", lapply(txt_files_df, as.data.frame)) 
colnames(test_df) <- col_headings
test_df <- test_df[, !duplicated(colnames(test_df))]

#### Create Training dataframe

setwd("..")
setwd("train")
train_txt<-list.files(pattern="*.txt")
train_files_df<-lapply(train_txt, read.table, header = FALSE, sep ="")
train_df<-do.call("cbind", lapply(train_files_df, as.data.frame)) 
colnames(train_df) <- col_headings
train_df <- train_df[, !duplicated(colnames(train_df))]

#### Merge Test and Training dataframes and label columns

df<-bind_rows(test_df,train_df)

## 2 - Extracts only the measurements on the mean and standard deviation 
##      for each measurement.

df2<-select(df,contains("subject")|contains("activity")|contains("mean")|contains("std"))

## 3 - Uses descriptive activity names to name the activities in the data set

df2$activity[df$activity == "1"] <-"walking"
df2$activity[df$activity == "2"] <-"walking_upstairs"
df2$activity[df$activity == "3"] <-"walking_downstairs"
df2$activity[df$activity == "4"] <-"sitting"
df2$activity[df$activity == "5"] <-"standing"
df2$activity[df$activity == "6"] <-"laying"

## 4 - Appropriately labels the data set with descriptive variable names.

#### Completed above at "set variable names"

## 5 - From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.

tidy_data<-group_by(df2,subject,activity) %>%
        summarise_each(funs(mean))

## Good luck!