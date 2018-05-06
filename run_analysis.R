library(reshape2)

#Download Zip file & unzip it
file<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(file,"dataset.zip")
unzip("dataset.zip")


#Load Activity labels
activityL <- read.table("UCI HAR Dataset/activity_labels.txt")

#Load Features
featureL <- read.table("UCI HAR Dataset/features.txt")

#Extract only mean and std Fields
# Appropriately labels the data set with descriptive variable names.

featureL[,2] <- as.character(featureL[,2])
requiredFeatures <- grep("*mean*|*std*",featureL[,2])
requiredFeatures.names <- featureL[requiredFeatures,2]
requiredFeatures.names <- gsub("-mean","Mean",requiredFeatures.names)
requiredFeatures.names <- gsub("-std","Std",requiredFeatures.names)
requiredFeatures.names <- gsub("[()-]","",requiredFeatures.names)

#Load the train datasets
#Extracts only the measurements on the mean and standard deviation for each measurement.

train <- read.table("UCI HAR Dataset/train/X_train.txt")[requiredFeatures]
trainAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSub, trainAct, train)

#Load the test datasets
#Extracts only the measurements on the mean and standard deviation for each measurement.

test <- read.table("UCI HAR Dataset/test/X_test.txt")[requiredFeatures]
testAct <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSub <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSub, testAct, test)

#Merge train and test followed by adding Labels

final <- rbind(train,test)
colnames(final)<-c("Subject","Activity",requiredFeatures.names)

# Uses descriptive activity names to name the activities in the data set


final$Activity <- factor(final$Activity, levels = activityL[,1], labels = activityL[,2])
final$Subject <- as.factor(final$Subject)

final.melted <- melt(final, id = c("Subject", "Activity"))
# the average of each variable for each activity and each subject.

final.mean <- dcast(final.melted, Subject + Activity ~ variable, mean)

# From the data set in step 4, creates a second, independent tidy data set with 
write.table(final.mean, "tidyData.txt", row.names = FALSE, quote = FALSE)

