#Load the dplyr package for grouping reports
library(dplyr)

#Read Metadata
activity_labels <- read.table("./activity_labels.txt", header = FALSE, col.names = c('ID', 'ActivityName'))
features <- read.table("./features.txt", header = FALSE)
features <- as.vector(features[, 2])

#Clean up Feature names
features <- gsub("\\()","", features)
features <- gsub("-","", features)
features <- gsub(",","", features)

#Read Test Data
x_test <- read.table("./test/X_test.txt", header = FALSE, col.names = features)
y_test <- read.table("./test/y_test.txt", header = FALSE, col.names = c('Activity'))
subject_test <- read.table("./test/subject_test.txt", header = FALSE, col.names = c('Subject'))

#Read Training data
subject_train <- read.table("./train/subject_train.txt", header = FALSE, col.names = c('Subject'))
x_train <- read.table("./train/x_train.txt", header = FALSE, col.names = features)
y_train <- read.table("./train/y_train.txt", header = FALSE, col.names = c('Activity'))

#Merge Test Data
TestData <- cbind(subject_test, x_test, y_test)

#Merge Training Data
TrainData <- cbind(subject_train, x_train, y_train)

#Merge Test and Training Data
CombinedData <- rbind(TestData, TrainData)

#Extract the mean and std columns from the full data set.
ExtractedData <- CombinedData[, c(1,2,3,4,5,6,7,563)]

#Merge data with Activity Label
FullDescriptiveData <- merge(ExtractedData, activity_labels, by.x="Activity", by.y="ID", all=FALSE)
FullDescriptiveData <- FullDescriptiveData[, 2:9]
# The order here is optional.  
FullDescriptiveData <- FullDescriptiveData[order(FullDescriptiveData$Subject, FullDescriptiveData$ActivityName), ]

# Export the tidy data set
write.table(FullDescriptiveData, "TidyData.txt", row.names=FALSE, sep=",")

#Group Data to calculate the averages
subjectGroups <- group_by(FullDescriptiveData, Subject, ActivityName)

#Summarize the average value for each variables in the group
groupReport <- summarize(subjectGroups, avgBodyAccmeanX=mean(tBodyAccmeanX), avgBodyAccmeanY=mean(tBodyAccmeanY), avgBodyAccmeanZ=mean(tBodyAccmeanZ), avgBodyAccstdX=mean(tBodyAccstdX), avgBodyAccstdY=mean(tBodyAccstdY), avgBodyAccstdZ=mean(tBodyAccstdZ))

#Export the Report
write.table(groupReport, "GroupReport.txt", row.names=FALSE, sep=",")
