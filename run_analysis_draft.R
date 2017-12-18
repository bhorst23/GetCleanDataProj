setwd("/Users/brian/Programming/Coursera/Rstuff")  
## to allow for breaks in the code while drafting

# Load the necessary libraries

## library(curl)
## library(RCurl)
## library(stringr)
## library(data.table)
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
# if we already have a copy of it in the folder.

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file_name <- "UCI HAR Dataset.zip"
if (!file.exists(file_name))
     {download.file(file_url,  destfile = file_name, method = "curl")}
unzip(file_name)    ## we'll unzip again to make sure the files are good


# 1. Merge the training and the test sets to create one data set.
setwd("./UCI HAR Dataset")      ### let's look at the unzipped folder and start
                                ### loading in the data tables
file_list <- list.files(recursive = TRUE)
labels <- read.table(file_list[1], col.names = c("activityID", "activityName"))
features <- read.table(file_list[3], col.names = c("featureID", "featureName"))

##  Read in the test set
subject_test <- read.table(file_list[14], col.names = "subject")
y_test <- read.table(file_list[16], col.names = "activityID")
x_test <- read.table(file_list[15], col.names = features$featureName)
test <- cbind(subject_test, y_test, set="test", x_test)

## rm(subject_test, y_test, x_test)     ### tidying up to clear up memory

##  Read in the training set
subject_train <- read.table(file_list[26], col.names = "subject")
y_train <- read.table(file_list[28], col.names = "activityID")
x_train <- read.table(file_list[27], col.names = features$featureName)
train <- cbind(subject_train, y_train, set="train", x_train)

## rm(subject_train, y_train, x_train)     ### tidying up to clear up memory

##  Combine into one data set
mydataset <- rbind(test, train)

## rm(test, train)     ### tidying up to clear up memory
setwd(".. ")     ### done reading the raw data, back down to the working folder

# 2. Extract only the measurements on the mean and standard deviation for each
# measurement.

my_measurements <- mydataset[ , c(1:3, 
                                  grep("(mean\\.)|(std\\.)", names(mydataset)))]


## rm(mydataset)     ### we aren't going to need this anymore, so tidy up


# 3. Use descriptive activity names to name the activities in the data set

for (x in 1:nrow(my_measurements)) 
        {tmp <- labels[my_measurements[x, "activityID"], 2]
        my_measurements[x, "activityID"] <- as.character(tmp)}
names(my_measurements)[2] <- "activity"     ### rename since it's no longer an ID


# 4. Appropriately label the data set with descriptive variable names.

raw_names <- names(my_measurements)     ### collecting bits for the CodeBook

names(my_measurements) <- gsub("^t","time",names(my_measurements))
names(my_measurements) <- gsub("^f","freq",names(my_measurements))
names(my_measurements) <- gsub(".mean","Mean",names(my_measurements))
names(my_measurements) <- gsub(".std","Std",names(my_measurements))
names(my_measurements) <- gsub("\\.","",names(my_measurements))


### collecting bits for the CodeBook
name_change <- data.frame(tidyName = names(my_measurements), 
                          rawNames = raw_names)
orig_names <-  features[grep("-mean\\(|-std\\(", features$featureName), 2]
### collecting bits for the CodeBook


# 5. From the data set in step 4, create a second, independent tidy data set  
# with the average of each variable for each activity and each subject.

subj_activity_avg <- my_measurements[-(3)] %>% 
                        group_by(subject, activity) %>% 
                        summarise_all(mean)

write.table(subj_activity_avg, "SubjectActivityAverages.txt", row.names = FALSE)


## Return to original working directory
setwd(orig_dir)