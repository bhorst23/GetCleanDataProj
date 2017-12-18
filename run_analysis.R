# Getting and Cleaning Data Course Project
## Author: Brian Horst
## Date: 2017-12-16

## This script downloads the University of California, Irvine (UCI), Human 
## Activity Recognition (HAR) Using Smartphones Data Set and prepares a tidy 
## summary table from the raw data.

## Load the library(ies) used in the script
library(dplyr)


# Let's create a new directory to work in (if it doesn't already exist). 
## First save the current working so we can go back to it at the end.
## NOTE: This code will only work for Mac/Linux users. Windows users will  
##       need to adjust for Windows folder reference methodology.

orig_dir <- getwd()
new_dir <- "./GetCleanDataCourseProj"
if (!file.exists(new_dir)) {dir.create(new_dir)}
setwd(new_dir)


# Now let's download the file and unzip it. We won't redownload the .zip file 
# if we already have a copy of it in the folder if we rerun this script.

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "UCI HAR Dataset.zip"
if (!file.exists(file_name))
{download.file(file_url,  destfile = file_name, method = "curl")}
unzip(file_name)    ## we'll unzip again to ensure we're using the original data


# 1. Merge the training and the test sets to create one data set.
labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                     col.names = c("activityID", "activityName"))
features <- read.table("UCI HAR Dataset/features.txt", 
                       col.names = c("featureID", "featureName"))


##  Read in the test set
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", 
                     col.names = "activityID")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                     col.names = features$featureName)
test <- cbind(subject_test, y_test, set="test", x_test)

rm(subject_test, y_test, x_test)     ### tidying up to clear up memory


##  Read in the training set
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", 
                      col.names = "activityID")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                      col.names = features$featureName)
train <- cbind(subject_train, y_train, set="train", x_train)

rm(subject_train, y_train, x_train)     ### tidying up to clear up memory

##  Combine into one data set
mydataset <- rbind(test, train)

rm(test, train)     ### tidying up to clear up memory


# 2. Extract only the measurements on the mean and standard deviation for each
# measurement.
## This is done by finding only those variables with either "mean." or "std."
## in their name.

my_measurements <- mydataset[ , c(1:3, 
                                  grep("(mean\\.)|(std\\.)", names(mydataset)))]

rm(mydataset)     ### we don't need the full dataset any further, so tidying up


# 3. Use descriptive activity names to name the activities in the data set
## The activity names were in the 'activity_labels.txt' file that was read into
## the labels table.
## I'm thinking there's a cleaner way to do this through indexing, but I'm just
## not quite smart enough yet, and this method works.

for (x in 1:nrow(my_measurements)) 
        {tmp <- labels[my_measurements[x, "activityID"], 2]
        my_measurements[x, "activityID"] <- as.character(tmp)
        }
names(my_measurements)[2] <- "activity"     ### rename since it's no longer an ID


# 4. Appropriately label the data set with descriptive variable names.
## Clean things up to make the labels human readable. Respectivly replace: 
##   -  a starting 't' or 'f' with 'time' or 'freq'; 
##   -  '.mean' and '.std' with 'Mean' and 'Std'; 
##   -  and remove the miscellaneous '.'

names(my_measurements) <- gsub("^t","time",names(my_measurements))
names(my_measurements) <- gsub("^f","freq",names(my_measurements))
names(my_measurements) <- gsub(".mean","Mean",names(my_measurements))
names(my_measurements) <- gsub(".std","Std",names(my_measurements))
names(my_measurements) <- gsub("\\.","",names(my_measurements))


# 5. From the data set in step 4, create a second, independent tidy data set  
# with the average of each variable for each activity and each subject.
## We'll group the table by 'subject' and 'activity', and find the mean of the
## remaining variables for all the unique combinations of 'subject' and 'activity'.

subj_activity_avg <- my_measurements[-(3)] %>% 
        group_by(subject, activity) %>% 
        summarise_all(mean)

## Output the resulting tidy table
write.table(subj_activity_avg, "SubjectActivityAverages.txt", row.name = FALSE)


### Return to original working directory
setwd(orig_dir)