run_analysis.R - Readme.MD
========================================================

The run_analysis.R script creates a tidy data set of "Human Activity 
Recognition Using Smartphones Data Set" from the selected features "mean()"
and "std()" and calculates the mean of each measurement from each subject and
each activity. The tidy data set has 66 features of sensor-measurements and
additionally the 2 columns "subject" and "activity". The both separated data sets
"training" and "test" were joined as one data set.


The following describes in detail how the tidy data set were created.

#### Requirements to create a tidy data set

* run_analysis.R was written with "R, version 3.1.0 (2014-04-10),
svn rev. 65387, platform x86_64-pc-linux-gnu" and needs the R library
"reshape2", version 1.4, Packaged: 2014-04-23 12:12:47 UTC; hadley".
"RStudio Version 0.98.507 – © 2009-2013 RStudio, Inc." was used to create the
run_anaylsis.R script.

* run_analysis.R was written and tested on a Linux operating system.
For Windows and Mac operating systems, you need to modify the paths in the
R script up to 9 times.

* run_analysis.R needs in the working directory only containing the R file
itself and uses the "Human Activity Recognition Using Smartphones Data Set" as
file-name "FUCI HAR Dataset.zip" or "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip".
The data set file has the SHA1-hash "566456a9e02a23c2c0144674d9fa42a8b5390e71".


#### The tidy data set file

run_analysis.R produces a CSV file with name "tidydata.csv" which has a 
SHA1-hash of "107c0b747c447fca59ee7b3bc5f59065921dcc64".

"tidydata.csv" is written as CSV file format in following format:
  * The CSV file has ";" as separator,  
  * without an index for each measurement in a row and
  * uses "\n" newline escape sequences for Unix like operating systems to indicate new lines/rows.  
  Windows operating systems will prefer "\r\n"
escape sequence and Mac OS will prefer the "\r" sequence.


#### The methods that were applied to the raw data to create tidy data
Merging, adapting and processing the data set.

* Merging data set  
The data sets "training" and "tests" are available in separated parts. They will
be read into memory.
 * "X_train.txt" / "X_test.txt" the data sets variables with numeric measurements.
 * "y_train.txt" / "y_test.txt" the activities corresponding to the measurements
 * "subject_train.txt" / "subject_test.txt" the subject which had generated the data
 * "activity_labels.txt" the labels to the activities mentioned above
 * "features.txt" the names of the features in the data set

 The data sets variables column of the data sets were renamed with the names
from the "features.txt".

 Both data sets "training" and "tests" were joined corresponding to the
columns together. Two new columns were added. The first new column is
"subject" and the second column is "activity".

* Adapting data set  
Extracting only the measurements on the mean and standard deviation from the
data set. The measurements variables are recognizable with "mean()" and "std()"
as part of the name of the columns. The columns "activity" and "subject" are
needed as categorical variables and extracted also.  
I suppose there was a typo mistake in "features.txt" where some features
using as part of in their name "BodyBody" instead of "Body". The affected
feature names were renamed.  
 All feature names were also renamed to the name convention:
only lower letters, no abbreviations, and only character symbols from a to z.  
In detail the renamed parts are:
 * "tBody" to "timebody"
 * "fBody" to "frequencybody"
 * "tGravity" to "timegravity"
 * "Acc" to "accelerometer"
 * "Gyro" to "gyroscope"
 * "Jerk" to "jerk"
 * "Mag" to "mag"
 * "-mean()" to "mean"
 * "-std()" to "std"
 * "-X" to "x"
 * "-Y" to "y"
 * "-Z" to "z"

* Processing data set  
 For later calculation the melt-function of libray reshape2 is used to group the
 columns "subject" and "activity" with sensor-variables.

 Calculating the mean from each sensor-variable for each activity and
each subject.  

 The Output is a CSV file containing a tidy data set is calculated with method
mentioned above and file format mentioned above.
