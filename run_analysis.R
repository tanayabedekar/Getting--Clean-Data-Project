# DOwnload File
library(data.table)
Url<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists('./UCI HAR Dataset.zip')){download.file(Url,'./UCI HAR Dataset.zip', mode = 'wb')
  unzip("UCI HAR Dataset.zip",exdir = getwd())
}

# Read Data and COnvert Data
  # Train data 
  x_train <- read.table ('./UCI HAR Dataset/train/X_train.txt')
  y_train <- read.table('./UCI HAR Dataset/train/y_train.txt')
  sub_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
  # Test Data
  x_test <- read.table ('./UCI HAR Dataset/test/X_test.txt')
  y_test <- read.table ('./UCI HAR Dataset/test/y_test.txt')
  sub_test <- read.table ('./UCI HAR Dataset/test/subject_test.txt')
  
  # 1. Merges the training and the test sets to create one data set.
  x_bind <- rbind(x_train,x_test)
  y_bind <- rbind(y_train,y_test)
  sub_bind <- rbind(sub_train,sub_test)
  
  
  # 2.Extracts only the measurements on the mean and standard deviation for each measurement.
  x_mean_std <- x_bind[, grep("-(mean|std)\\(\\)", read.table('./UCI HAR Dataset/features.txt')[, 2])]
  names(x_mean_std) <- read.table('./UCI HAR Dataset/features.txt')[grep("-(mean|std)\\(\\)", read.table('./UCI HAR Dataset/features.txt')[, 2]), 2] 
  #features <- read.table('./UCI HAR Dataset/features.txt')
  #mean_std <- grep("-(mean|std)\\(\\)", features[,2],2)
  #x_mean_std <- x_bind[,mean_std]
 
  # 3.Uses descriptive activity names to name the activities in the data set
  y_bind[, 1] <- read.table('./UCI HAR Dataset/activity_labels.txt')[y_bind[,1],2]
  names(y_bind) <- "Activities"
  names(sub_bind) <- "Subject"
  
  # 4.Appropriately labels the data set with descriptive variable names.
  
  all_data_bind <- cbind(x_mean_std, y_bind, sub_bind)
  names(all_data_bind) <- make.names(names(all_data_bind))
  names(all_data_bind) <- gsub('Gyro',"Gyroscope",names(all_data_bind))
  names(all_data_bind) <- gsub('Acc',"Acceleration",names(all_data_bind))
  names(all_data_bind) <- gsub('^t',"TimeDomain.",names(all_data_bind))
  names(all_data_bind) <- gsub('^f',"FrequencyDomain.",names(all_data_bind))
  names(all_data_bind) <- gsub('Mag',"Magnitude",names(all_data_bind))
  names(all_data_bind) <- gsub('\\.mean',".Mean",names(all_data_bind))
  names(all_data_bind) <- gsub('\\.std',".StandardDeviation",names(all_data_bind))
  names(all_data_bind) <- gsub('Freq\\.',"Frequency.",names(all_data_bind))
  names(all_data_bind) <- gsub('Freq$',"Frequency",names(all_data_bind))
  
  # 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  tidydata2 <- aggregate(.~ Subject + Activities, all_data_bind, mean)
  tidydata2 <- tidydata2 [order(tidydata2$Subject, tidydata2$Activities),]
  write.table(tidydata2, file = "tidydata.txt",row.names = FALSE)

