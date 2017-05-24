#loading required packages
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")
#setting the work directory
#loading the feature file
features <- read.table(".\\UCI HAR Dataset\\features.txt")[,2]
features
#loading the activity lables file
activity_labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
activity_labels
#loading the X_test file
test_x <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
str(test_x)
names(test_x) <- features
#loading the y_test file
test_y <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
test_y[,2] <- activity_labels[test_y[,1],2]
test_y
str(test_y)
names(test_y) <- c("Activity_ID","Activity_Label")
#loading the subject_test file
subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
names(subject_test) <- "subject"
#consolidating the test_data
test_data <- cbind(as.data.table(subject_test),test_y,test_x)

#loading the X_train file
train_x <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
str(train_x)
names(train_x) <- features
#loading the y_train file
train_y <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
train_y[,2] <- activity_labels[train_y[,1],2]
train_y
names(train_y) <- c("Activity_ID","Activity_Label")
#loading the subject_train file
subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
names(subject_train) <- "subject"
#consolidating the train_data
train_data <- cbind(as.data.table(subject_train),train_y,train_x)
#Merging the train and test data
data <- rbind(test_data,train_data)
#Extracting only mean and standard deviation
feature_extract <- grepl("mean|std",features)
X_test = test_x[,feature_extract]
X_train = train_x[,feature_extract]
#Using appropriate labels
id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
#tidying the data using melt function
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)
# mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
# writing the result to file
write.table(tidy_data, file = ".\\tidy_data.txt",row.names = FALSE)

