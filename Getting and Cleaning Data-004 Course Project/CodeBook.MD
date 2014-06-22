CodeBook.MD
===========

#### Study Design
The data comes from the "Human Activity Recognition Using Smartphones Data Set"
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones in a ZIP file downloadable from the Data Folder with file name "UCI HAR Dataset.zip"

#### Code Book
There are 68 columns
* Column 1 is "subject" from range 1 to 30.  
The subject who performed
* Column 2 is "activity" from range 1 to 6 where
 * 1 is WALKING
 * 2 is WALKING_UPSTAIRS
 * 3 is WALKING_DOWNSTAIRS
 * 4 is SITTING
 * 5 is STANDING
 * 6 is LAYING
 
 The activity is performed by the subject.
* Column 3 to 68 are features.  
 There is no unit. The values of the features are bounded within [-1,1].  
 The feature values are related to a "subject" and an "activity".  
 They are all mean values from their corresponding feature measurements in the origin data set.  
 The names of the feature measurements are structured by the following name convention.
 
 origin data set | tidy data set
 --- | ---
 "tBody" | "timebody"
 "fBody" | "frequencybody"
 "tGravity" | "timegravity"
 "Acc" | "accelerometer"
 "Gyro" | "gyroscope"
 "Jerk" | "jerk"
 "Mag" | "mag"
 "-mean()" | "mean"
 "-std()" | "std"
 "-X" | "x"
 "-Y" | "y"
 "-Z" | "z"

 Please read the feature.txt and feature_info.txt file for further and detailed explanations about the origin feature names from the "UCI HAR Dataset.zip"

 Following set of variables were used from the original data set:
 * mean(): Mean value
 * std(): Standard deviation

There are 180 rows  
Each row shows the mean value to each feature for each subject for each activity



