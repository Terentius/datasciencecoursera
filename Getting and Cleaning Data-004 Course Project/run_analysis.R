# run_analysis.R
#
# Requirements:
#  1. Working directory contains only
#     "run_analysis.R" and
#     "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip", or
#     "FUCI HAR Dataset.zip"
#  2. library reshape2 for melt-function
#  3. Please read Readme.MD
# 

# Script needs R library reshape2
library(reshape2)

Read.Merged.Dataset <- function(){
        # check if the needed file is existing
        Filename1.Dataset <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
        Filename2.Dataset <- "FUCI HAR Dataset.zip"
        if (file.exists(Filename1.Dataset)){
                unzip(Filename1.Dataset,setTimes=TRUE)
        } else if (file.exists(Filename2.Dataset)){
                unzip(Filename2.Dataset,setTimes=TRUE)
        } else {stop("Dataset ZIP file is missing")}
        
        ## Loading the machine learning "training sets" and "tests sets" into
        ## one merged table. Both sets will added together in row.
        ## * The "training" sets contains the "X_test.txt" with its
        ## activity indices "y_test.txt"
        ## * The "test" sets contains the "X_train.txt" with its
        ## activity indices "y_train.txt"
        ## * The activity indices loaded as column "activity"
        ## * The activity indices renamed with file "activity_labels.txt"
        ## which has indices corresponding to column "activity
        ## * The "subject" data set corresponding to the measurements
        
        # Reading Training - Dataset
        Training.Dataset <- read.table("UCI HAR Dataset/train/X_train.txt",
                                       comment.char = "",
                                       colClasses="numeric")
        Activities.Training.Dataset <- read.table("UCI HAR Dataset/train/y_train.txt",
                                                  comment.char = "",
                                                  colClasses="factor",
                                                  col.names=c("activity"))
        Subject.Training.Dataset <- read.table("UCI HAR Dataset/train/subject_train.txt",
                                               comment.char = "",
                                               colClasses="numeric",
                                               col.names=c("subject"))
        
        # Reading Test - Dataset
        Test.Dataset <- read.table("UCI HAR Dataset/test/X_test.txt",
                                   comment.char = "",
                                   colClasses="numeric")
        Activities.Test.Dataset <- read.table("UCI HAR Dataset/test/y_test.txt",
                                              comment.char = "",
                                              colClasses="factor",
                                              col.names=c("activity"))
        Subject.Test.Dataset <- read.table("UCI HAR Dataset/test/subject_test.txt",
                                           comment.char = "",
                                           colClasses="numeric",
                                           col.names=c("subject"))
        
        # Reading activity labels for later use to label the entries of the
        # Dataset$Activity column with descriptives names
        Activities.Label.Dataset <- read.table("UCI HAR Dataset/activity_labels.txt",
                                               sep=" ",
                                               comment.char = "",
                                               colClasses=c("numeric","character"),
                                               col.names=c("index","activity"))
        
        # Reading Feature List for later use to rename the columns of
        # the datasets
        Features.Dataset <- read.table("UCI HAR Dataset/features.txt",
                                       comment.char = "",
                                       colClasses=c("numeric","character"),
                                       col.names=c("index","feature"))
        
        # Renaming the columns of the Training.Dataset and Test.Dataset
        # with the corresponding Features.Dataset
        names(Training.Dataset) <- Features.Dataset$feature
        names(Test.Dataset) <- Features.Dataset$feature
        
        # Merging Datasets from sets "Training" and "Tests" and merges with
        # desciptivly activity names and subjects who generated the data
        merged.Dataset <- rbind(cbind(Training.Dataset,
                                      Activities.Training.Dataset,
                                      Subject.Training.Dataset),
                                cbind(Test.Dataset,
                                      Activities.Test.Dataset,
                                      Subject.Test.Dataset))
        
        # Renames the label of the merged.Dataset from
        # Activities.Label.Dataset$Activity to descriptives names
        levels(merged.Dataset$activity) <- Activities.Label.Dataset$activity
        
        # Extracting only the measurements on the mean and
        # standard deviation from the dataset.
        # Columns "Activity" and "Subject" are needed as categorical variables.
        NeededColumns <- grepl("mean\\(\\)|std\\(\\)|activity|subject",
                               names(merged.Dataset))
        merged.Dataset <- merged.Dataset[,NeededColumns]
        
        
        # Typo correction of column names of the sensor-variables
        names(merged.Dataset) <- gsub(names(merged.Dataset),
                                      pattern="BodyBody",
                                      replacement="Body")
        
        # Renaming columns of the sensor-variable with appropriately labels
        renaming.columns <- names(merged.Dataset)[1:66]
        renaming.columns <- sub("tBody","timebody",renaming.columns)
        renaming.columns <- sub("fBody","frequencybody",renaming.columns)
        renaming.columns <- sub("tGravity","timegravity",renaming.columns)
        renaming.columns <- sub("Acc","accelerometer",renaming.columns)
        renaming.columns <- sub("Gyro","gyroscope",renaming.columns)
        renaming.columns <- sub("Jerk","jerk",renaming.columns)
        renaming.columns <- sub("Mag","mag",renaming.columns)
        renaming.columns <- sub("-mean\\(\\)","mean",renaming.columns)
        renaming.columns <- sub("-std\\(\\)","std",renaming.columns)
        renaming.columns <- sub("-X","x",renaming.columns)
        renaming.columns <- sub("-Y","y",renaming.columns)
        renaming.columns <- sub("-Z","z",renaming.columns)
        names(merged.Dataset)[1:66] <- renaming.columns

        return(merged.Dataset)
}

# Getting result of the selected Dataset for the tidy data set
merged.Dataset <- Read.Merged.Dataset()

# Creating a tidy data set
#
## For later calculation the melt-function of libray reshape2 is used to group
## the columns "subject" and "activity" with sensor-variables.
melted.sensors.merged.Dataset <- melt(merged.Dataset,
                                      id=c("subject","activity"),
                                      measure.vars=names(merged.Dataset[1:66]))
## Calculating the mean from each sensor-variable for each activity and
## each subject.
mean.sensors.merged.Dataset <- dcast(melted.sensors.merged.Dataset,
                                     subject+activity~variable,
                                     mean)
## The Output is a CSV file containing a tidy data set is calculated with method
## mentioned above and file format mentioned below
##
## The CSV file in following format:
##  ";" as separator,
##  without an index for each measurement in a row and
##  uses "\n" newline escape sequences for Unix like operating systems to
##  indicate new lines/rows.
## Windows operating systems will prefer "\r\n" escape sequence and
## Mac OS will prefer the "\r" sequence.
write.table(mean.sensors.merged.Dataset,
            file = "./tidydata.csv",
            eol = "\n",         # for Unix like operating systems
###         eol = "\r\n"        # for Windows operating systems
###         eol = "\r",         # for Mac operating systems
            na = "NA",
            sep = ";",
            row.names = FALSE)
