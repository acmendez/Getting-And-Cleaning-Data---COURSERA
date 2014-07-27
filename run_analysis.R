# Script called run_analysis.R for the Getting and Cleaning Data course project, 
# the aforementioned script does the following:

# Section 1.
# Merge the training and the test sets to create one data set. 
# After setting the source directory for the files, read into tables the data 
# and combine the data to put it all together

setwd('c:/Documents and Settings/Administrador/Mis documentos/UCI HAR Dataset')

y_test.labels <- read.table("test/y_test.txt", col.names="label")
test.subjects <- read.table("test/subject_test.txt", col.names="subject")
x_test.data <- read.table("test/X_test.txt")
y_train.labels <- read.table("train/y_train.txt", col.names="label")
train.subjects <- read.table("train/subject_train.txt", col.names="subject")
x_train.data <- read.table("train/X_train.txt")

data <- rbind(cbind(test.subjects, y_test.labels, x_test.data),
              cbind(train.subjects, y_train.labels, x_train.data))

# Section 2.
# Extract only the measurements on the mean and standard deviation for each measurement. 
# Here is create a logical vector that contains TRUE values for the ID, mean and stdev columns
# and FALSE values for the others. Subset this data to keep only the necessary columns. 

features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# select only the means and standard deviations from data and increment
# by 2, because data has subjects and labels in the beginning

data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]

# Section 3.
# Use descriptive activity names to name the activities in the data set.
# Merge data subset with the activityType table to include the descriptive activity names
# therefore: read the labels (activities) and replace labels in data with label names

labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
data.mean.std$label <- labels[data.mean.std$label, 2]

# Section 4.
# Appropriately label the data set with descriptive activity names. 
# Use gsub function for pattern replacement to clean up the data labels

# Here first make a list of the current column names and feature names, then tidy that list
# by removing every non-alphabetic character and converting to lowercase, then use the list
# as column names for data

fix.colum_names <- c("subject", "label", features.mean.std$V2)
fix.colum_names <- tolower(gsub("[^[:alpha:]]", "", fix.colum_names))
colnames(data.mean.std) <- fix.colum_names

# Section 5.
# Create a second, independent tidy data set with the average of each variable for each
# activity and each subject. 
# Per the project instructions, we need to produce only a data set with the average of each
# variable for each activity and subject

# go to find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)], 
            by=list(subject = data.mean.std$subject,label = data.mean.std$label),mean)

# The final step is write the tidy data result for the course upload in github
write.table(format(aggr.data, scientific=T), "tidy data result.txt",
            row.names=F, col.names=F, quote=2)
