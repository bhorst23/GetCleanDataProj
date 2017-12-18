This code book builds on those included in the UCI HAR Dataset (available from <http://archive.ics.uci.edu/ml/machine-learning-databases/00240/>) and describes: 
* Where the data came from and a brief overview of the originating study 
* Information about the variables (including units) in the data set not contained in the tidy data 
* Information about the transformations made on the data 
* Some other important tips

------------------------------------------------------------------------

Study
=====

The data being used in this project comes from the University of California, Irvine (UCI), Human Activity Recognition (HAR) Using Smartphones Data Set. The data set was built by recording inertial sensor readings from a smartphone strapped to subjects as they performed various activities. A discussion of the original study may be found
here: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#>

Per the information contained in the data set files, 
> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features\_info.txt' for more details.

> For each record it is provided: 
* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables. 
* Its activity label. 
* An identifier of the subject who carried out the experiment.

> Notes: 
* Features are normalized and bounded within \[-1,1\]. 
* Each feature vector is a row on the text file. 
* The units used for the accelerations (total and body) are 'g's (gravity of earth -&gt; 9.80665 m/seg2). 
* The gyroscope units are rad/seg.

------------------------------------------------------------------------

Project CodeBook
================

Source Data
-----------

The raw dataset available from UCI includes the following files:
* 'README.txt': An overview of the dataset and the included files
* 'features\_info.txt': Shows information about the variables used on the feature vector
* 'features.txt': List of all features
* 'activity\_labels.txt': Links the class labels with their activity name
* 'train/X\_train.txt': Training set 
* 'train/y\_train.txt': Training labels *'test/X\_test.txt': Test set 
* 'test/y\_test.txt': Test labels

The following files are available for the train and test data. Their descriptions are equivalent. 
* 'train/subject\_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 
* 'train/Inertial Signals/total\_acc\_x\_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total\_acc\_x\_train.txt' and 'total\_acc\_z\_train.txt' files for the Y and Z axis. 
* 'train/Inertial Signals/body\_acc\_x\_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 
* 'train/Inertial Signals/body\_gyro\_x\_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

Files Used in the Project Analysis
----------------------------------

This analysis made use of the following files: 
#### Common files 
+ 'features.txt': a table of 561 row with 2 variables ('featuresID' and 'featuresName') 
+ 'activity\_labels.txt': a table of 6 rows and 2 variables ('activityID' and 'activityName') 
#### Test dataset files - 2947 observations for each of the following 
+ 'test/subject\_test.txt': single variable 'subject' 
+ 'test/y\_test.txt': single variable 'activityID' 
+ 'test/X\_test.txt': 561 variables representing various measurements 
#### Train data set files - 7352 observations for each of the following 
+ 'train/subject\_train.txt': single variable 'subject' 
+ 'train/y\_train.txt': single variable 'activityID' 
+ 'train/X\_train.txt': 561 variables representing various measurements

None of the files in the 'test/Inertial Signals' or 'train/Inertial Signals' folders were used.

Details of the Transformation Performed by 'run\_analysis.R' Script
-------------------------------------------------------------------

The 'run\_analysis.R' script performs the following functions: 

#### 0. Downloads the raw data. 

- Checks to see if there is a directory to save data and working files in, and creates one if it does not already exist.
- Checks to see if the data has already been downloaded, and then downloads it from the URL specified in the ReadMe if necessary (<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>).
- Unzips the data set.

#### 1.  Merges the training and the test sets to create one data set.

-   Each of the above tables were read using 'read.table'.
-   The data tables read from 'X\_test.txt' and 'X\_train.txt' were
    assigned columns headers from the 'features.txt' 'featureName'
    variable.
-   Test and train tables were created using 'cbind' using the
    corresponding subject, y, and X tables. Additionally, a group
    variable was added to indicate whether the oservations was from the
    "test" or "train" data set.
-   The test and train tables were then combined using 'rbind' to create
    a complete dataset of 10299 rows of 564 variables.

#### 2.  Extracts only the measurements on the mean and standard deviation for each measurement.

-   A new table was created using only the subject, activityID, group,
    and a 'grep' search of the remaining variable to find only those
    that contained either "-mean(" or "-std(". (Note: the 'meanFreq'
    variables were intentionally not included, as they do not represent
    a mean or standard deviation of other measurements.)
-   The resulting table contained 10299 rows of 69 variables.

#### 3.  Uses descriptive activity names to name the activities in the data set

-   The table created from 'activity\_labels.txt' was used as a
    reference to replace the 'activityID' with the corresponding
    descriptive 'activityName'.
-   The variable in the data set was renamed to 'activity' to reflect
    that it was no longer an ID

#### 4.  Appropriately labels the data set with descriptive variable names.

-   A variable starting with "t" or "f" was changed to start with
    "time" or "freq"
-   Non-alphanumeric characters were removed and the initial letters of
    the "mean" and "std" segments were capitalized.

#### 5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

-   The 'dplyr' package was loaded.
-   The data set was grouped by 'subject' and 'activity'.
-   The mean for each variable for unique 'subject' and 'activity' pairs
    was calculated and stored in a new table with the corresponding
    'subject' and 'activity' pairs.
-   This resulted in a tidy table of 180 rows for 68 variables.

Tidy Data Names
---------------

The resulting tidy table 'SubjectActivityAverage.txt' provides the
average for each mean and standard deviation of measurements for a
specific subject and activity.

-   'subject' is the individual who performed the activity and ranges
    from 1 to 30
-   'activity' consists of the 6 different activities that were
    performed
-   'time' indicates a "time domain" value
-   'freq' indicates a "frequency domain" value
-   'BodyAcc' indicates "Body Acceleration"
-   'BodyGyro' indicates "Body Gyro"
-   'GravityAcc' indicates "Gravity Acceleration"
-   'Jerk' indicates a "Jerk" signal
-   'Mag' indicates "Magnitude"
-   'Mean' indicates a "mean" value
-   'Std' indicates a "standard deviation" value

The variable names in the resulting tidy data table are below. Included
is the variable name from the original data.

<table>
<thead>
<tr class="header">
<th>Tidy Name</th>
<th>Raw Data Name</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>subject</td>
<td></td>
</tr>
<tr class="even">
<td>activity</td>
<td></td>
</tr>
<tr class="odd">
<td>timeBodyAccMeanX</td>
<td>tBodyAcc-mean()-X</td>
</tr>
<tr class="even">
<td>timeBodyAccMeanY</td>
<td>tBodyAcc-mean()-Y</td>
</tr>
<tr class="odd">
<td>timeBodyAccMeanZ</td>
<td>tBodyAcc-mean()-Z</td>
</tr>
<tr class="even">
<td>timeBodyAccStdX</td>
<td>tBodyAcc-std()-X</td>
</tr>
<tr class="odd">
<td>timeBodyAccStdY</td>
<td>tBodyAcc-std()-Y</td>
</tr>
<tr class="even">
<td>timeBodyAccStdZ</td>
<td>tBodyAcc-std()-Z</td>
</tr>
<tr class="odd">
<td>timeGravityAccMeanX</td>
<td>tGravityAcc-mean()-X</td>
</tr>
<tr class="even">
<td>timeGravityAccMeanY</td>
<td>tGravityAcc-mean()-Y</td>
</tr>
<tr class="odd">
<td>timeGravityAccMeanZ</td>
<td>tGravityAcc-mean()-Z</td>
</tr>
<tr class="even">
<td>timeGravityAccStdX</td>
<td>tGravityAcc-std()-X</td>
</tr>
<tr class="odd">
<td>timeGravityAccStdY</td>
<td>tGravityAcc-std()-Y</td>
</tr>
<tr class="even">
<td>timeGravityAccStdZ</td>
<td>tGravityAcc-std()-Z</td>
</tr>
<tr class="odd">
<td>timeBodyAccJerkMeanX</td>
<td>tBodyAccJerk-mean()-X</td>
</tr>
<tr class="even">
<td>timeBodyAccJerkMeanY</td>
<td>tBodyAccJerk-mean()-Y</td>
</tr>
<tr class="odd">
<td>timeBodyAccJerkMeanZ</td>
<td>tBodyAccJerk-mean()-Z</td>
</tr>
<tr class="even">
<td>timeBodyAccJerkStdX</td>
<td>tBodyAccJerk-std()-X</td>
</tr>
<tr class="odd">
<td>timeBodyAccJerkStdY</td>
<td>tBodyAccJerk-std()-Y</td>
</tr>
<tr class="even">
<td>timeBodyAccJerkStdZ</td>
<td>tBodyAccJerk-std()-Z</td>
</tr>
<tr class="odd">
<td>timeBodyGyroMeanX</td>
<td>tBodyGyro-mean()-X</td>
</tr>
<tr class="even">
<td>timeBodyGyroMeanY</td>
<td>tBodyGyro-mean()-Y</td>
</tr>
<tr class="odd">
<td>timeBodyGyroMeanZ</td>
<td>tBodyGyro-mean()-Z</td>
</tr>
<tr class="even">
<td>timeBodyGyroStdX</td>
<td>tBodyGyro-std()-X</td>
</tr>
<tr class="odd">
<td>timeBodyGyroStdY</td>
<td>tBodyGyro-std()-Y</td>
</tr>
<tr class="even">
<td>timeBodyGyroStdZ</td>
<td>tBodyGyro-std()-Z</td>
</tr>
<tr class="odd">
<td>timeBodyGyroJerkMeanX</td>
<td>tBodyGyroJerk-mean()-X</td>
</tr>
<tr class="even">
<td>timeBodyGyroJerkMeanY</td>
<td>tBodyGyroJerk-mean()-Y</td>
</tr>
<tr class="odd">
<td>timeBodyGyroJerkMeanZ</td>
<td>tBodyGyroJerk-mean()-Z</td>
</tr>
<tr class="even">
<td>timeBodyGyroJerkStdX</td>
<td>tBodyGyroJerk-std()-X</td>
</tr>
<tr class="odd">
<td>timeBodyGyroJerkStdY</td>
<td>tBodyGyroJerk-std()-Y</td>
</tr>
<tr class="even">
<td>timeBodyGyroJerkStdZ</td>
<td>tBodyGyroJerk-std()-Z</td>
</tr>
<tr class="odd">
<td>timeBodyAccMagMean</td>
<td>tBodyAccMag-mean()</td>
</tr>
<tr class="even">
<td>timeBodyAccMagStd</td>
<td>tBodyAccMag-std()</td>
</tr>
<tr class="odd">
<td>timeGravityAccMagMean</td>
<td>tGravityAccMag-mean()</td>
</tr>
<tr class="even">
<td>timeGravityAccMagStd</td>
<td>tGravityAccMag-std()</td>
</tr>
<tr class="odd">
<td>timeBodyAccJerkMagMean</td>
<td>tBodyAccJerkMag-mean()</td>
</tr>
<tr class="even">
<td>timeBodyAccJerkMagStd</td>
<td>tBodyAccJerkMag-std()</td>
</tr>
<tr class="odd">
<td>timeBodyGyroMagMean</td>
<td>tBodyGyroMag-mean()</td>
</tr>
<tr class="even">
<td>timeBodyGyroMagStd</td>
<td>tBodyGyroMag-std()</td>
</tr>
<tr class="odd">
<td>timeBodyGyroJerkMagMean</td>
<td>tBodyGyroJerkMag-mean()</td>
</tr>
<tr class="even">
<td>timeBodyGyroJerkMagStd</td>
<td>tBodyGyroJerkMag-std()</td>
</tr>
<tr class="odd">
<td>freqBodyAccMeanX</td>
<td>fBodyAcc-mean()-X</td>
</tr>
<tr class="even">
<td>freqBodyAccMeanY</td>
<td>fBodyAcc-mean()-Y</td>
</tr>
<tr class="odd">
<td>freqBodyAccMeanZ</td>
<td>fBodyAcc-mean()-Z</td>
</tr>
<tr class="even">
<td>freqBodyAccStdX</td>
<td>fBodyAcc-std()-X</td>
</tr>
<tr class="odd">
<td>freqBodyAccStdY</td>
<td>fBodyAcc-std()-Y</td>
</tr>
<tr class="even">
<td>freqBodyAccStdZ</td>
<td>fBodyAcc-std()-Z</td>
</tr>
<tr class="odd">
<td>freqBodyAccJerkMeanX</td>
<td>fBodyAccJerk-mean()-X</td>
</tr>
<tr class="even">
<td>freqBodyAccJerkMeanY</td>
<td>fBodyAccJerk-mean()-Y</td>
</tr>
<tr class="odd">
<td>freqBodyAccJerkMeanZ</td>
<td>fBodyAccJerk-mean()-Z</td>
</tr>
<tr class="even">
<td>freqBodyAccJerkStdX</td>
<td>fBodyAccJerk-std()-X</td>
</tr>
<tr class="odd">
<td>freqBodyAccJerkStdY</td>
<td>fBodyAccJerk-std()-Y</td>
</tr>
<tr class="even">
<td>freqBodyAccJerkStdZ</td>
<td>fBodyAccJerk-std()-Z</td>
</tr>
<tr class="odd">
<td>freqBodyGyroMeanX</td>
<td>fBodyGyro-mean()-X</td>
</tr>
<tr class="even">
<td>freqBodyGyroMeanY</td>
<td>fBodyGyro-mean()-Y</td>
</tr>
<tr class="odd">
<td>freqBodyGyroMeanZ</td>
<td>fBodyGyro-mean()-Z</td>
</tr>
<tr class="even">
<td>freqBodyGyroStdX</td>
<td>fBodyGyro-std()-X</td>
</tr>
<tr class="odd">
<td>freqBodyGyroStdY</td>
<td>fBodyGyro-std()-Y</td>
</tr>
<tr class="even">
<td>freqBodyGyroStdZ</td>
<td>fBodyGyro-std()-Z</td>
</tr>
<tr class="odd">
<td>freqBodyAccMagMean</td>
<td>fBodyAccMag-mean()</td>
</tr>
<tr class="even">
<td>freqBodyAccMagStd</td>
<td>fBodyAccMag-std()</td>
</tr>
<tr class="odd">
<td>freqBodyBodyAccJerkMagMean</td>
<td>fBodyBodyAccJerkMag-mean()</td>
</tr>
<tr class="even">
<td>freqBodyBodyAccJerkMagStd</td>
<td>fBodyBodyAccJerkMag-std()</td>
</tr>
<tr class="odd">
<td>freqBodyBodyGyroMagMean</td>
<td>fBodyBodyGyroMag-mean()</td>
</tr>
<tr class="even">
<td>freqBodyBodyGyroMagStd</td>
<td>fBodyBodyGyroMag-std()</td>
</tr>
<tr class="odd">
<td>freqBodyBodyGyroJerkMagMean</td>
<td>fBodyBodyGyroJerkMag-mean()</td>
</tr>
<tr class="even">
<td>freqBodyBodyGyroJerkMagStd</td>
<td>fBodyBodyGyroJerkMag-std()</td>
</tr>
</tbody>
</table>
