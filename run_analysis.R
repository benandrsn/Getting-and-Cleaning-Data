# Begin by downloading the zip file here:
#"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# Unzip the file
# Place the directory "UCI HAR Dataset" into the working directory

#From here, use this code to create a tidy dataset.

#Read in data
actLa<-read.table("UCI HAR Dataset/activity_labels.txt", 
                  stringsAsFactors=FALSE)
features<-read.table("UCI HAR Dataset/features.txt", 
                     stringsAsFactors=FALSE)
xTrain<-read.table("UCI HAR Dataset/train/X_train.txt", 
                     stringsAsFactors=FALSE)
yTrain<-read.table("UCI HAR Dataset/train/y_train.txt", 
                   stringsAsFactors=FALSE)
subTrain<-read.table("UCI HAR Dataset/train/subject_train.txt", 
                    stringsAsFactors=FALSE)
xTest<-read.table("UCI HAR Dataset/test/X_test.txt", 
                   stringsAsFactors=FALSE)
yTest<-read.table("UCI HAR Dataset/test/y_test.txt", 
                   stringsAsFactors=FALSE)
subTest<-read.table("UCI HAR Dataset/test/subject_test.txt", 
                  stringsAsFactors=FALSE)

#   1.  Merges the training and the test sets to create one data set.
masterDataX<-rbind(xTrain, xTest)
colnames(masterDataX)<-features$V2

masterDataY<-rbind(yTrain, yTest)
colnames(masterDataY)<-"activity"

masterDataSub<-rbind(subTrain, subTest)
colnames(masterDataSub)<-"subject"

Master<-cbind(masterDataSub,masterDataY,masterDataX)

#   2.  Extracts only the measurements on the mean and 
#       standard deviation for each measurement. 
meanStdIndex<-grep("mean|std", colnames(Master)) 
Master2<-Master[c(1:2,meanStdIndex)]

#   3.  Uses descriptive activity names to name the activities in the data set.
Master3<-merge(actLa, Master2, by.x="V1", by.y="activity")
Master3$V1<-NULL


#   4.  Appropriately labels the data set with descriptive variable names. 
colnames(Master3)[1]<-"activity"
tidy<-Master3[c(2,1,3:ncol(Master3))]
# Some of this was completed earlier with the colnames() functions.


#   5.  Creates a second, independent tidy data set with the average 
#       of each variable for each activity and each subject. 
tidy2<-aggregate(tidy[,3:ncol(tidy)],list(subject=tidy$subject,activity=tidy$activity),mean)
tidy2<-tidy2[order(tidy2$subject),]

#Export data
write.table(tidy, file="tidy1.txt", sep="\t", row.names=FALSE)
write.table(tidy2, file="tidy2.txt", sep="\t", row.names=FALSE)
