

# download the zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# unzip the file

# Set working directory to the folder where the file is saved
setwd("C:/Users/mmelgoza/Desktop/Coursera/Cleaning_Data_Course_Project/UCI HAR Dataset")

# read and organize all the files needed into R Console

features <- read.table("./features.txt")
activitylabels <- read.table("./activity_labels.txt")
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/Y_test.txt")
subject_test <- read.table("./test/subject_test.txt")
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/Y_train.txt")
subject_train <- read.table("./train/subject_train.txt")


# merge all x/y test and train data into one dataset
x_cmb <- rbind(x_train, x_test)
y_cmb <- rbind(y_train, y_test)
subject_cmb <- rbind(subject_train, subject_test)
alldata <- cbind(subject_cmb, y_cmb, x_cmb)

# name all columns with names in feature file
featureNames <- as.character(features[,2])
newcols <- c("subject", "activity", featureNames)
colnames(alldata) <- newcols

# Create a new data frame, data will only include measurement columns containing features of mean and std dev 

meanonly <- grep("mean()", colnames(alldata))
stddevonly <- grep("std()", colnames(alldata))
updatedcols <- c(meanonly, stddevonly)
updatedcols2 <- sort(updatedcols) 
newDF <- alldata[, c(1,2,updatedcols2)]
newDF2 <- newDF[, !grepl("Freq", colnames(newDF))]

# tidy up the data frame
tidyDF <- data.frame()
for (i in 1:30) {
        subj<- subset(newDF2,subject==i)
        for (j in 1:6){
                actv<- subset(subj, activity==j)
                myresult<-as.vector(apply(actv,2,mean))
                tidyDF<-rbind(tidyDF,myresult) 
        }
        
}S

# Output data to "Samsung_Data.txt"
colnames(tidyDF)<-colnames(newDF2) 
levels(tidyDF[,2])<-c('walk','upstairswalk','downstairswalk', 'sit','stand', 'lay')
write.table(tidyDF, "Samsung_Data.txt", sep = "")