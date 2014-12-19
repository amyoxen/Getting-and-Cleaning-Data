
testdirName<-"UCI HAR Dataset/test"
traindirName<-"UCI HAR Dataset/train"

testFiles<-list.files(testdirName, full.names=TRUE)
trainFiles<-list.files(traindirName, full.names=TRUE)
testFiles<-testFiles[grepl("txt", testFiles)]
trainFiles<-trainFiles[grepl("txt", trainFiles)]

#Merges the training and the test sets to create one data set.
testR <- vector(mode = "list", length = length(testFiles))
trainR <- vector(mode = "list", length = length(trainFiles))
test_trainR <- testR

for (i in seq_along(testFiles)) {
  testR[[i]]<-read.table(testFiles[i])
  trainR[[i]]<-read.table(trainFiles[i])
  test_trainR[[i]] <-rbind(testR[[i]],trainR[[i]])
}
#test_trainR contains a list of the three datasets combinding the test and train data.
#set 1 consists of the test subject, set 2 consists of the test results.
#set 3 consists of the activities performed.

#label the test result columns, from "features.txt"
testNames<-read.table("UCI HAR Dataset/features.txt")

colnames(test_trainR[[2]])<-testNames$V2

#extract the data with "mean()" and "std()" text in it.
colwithMean<-grepl("mean()",colnames(test_trainR[[2]]),fixed=TRUE)
colwithStd<-grepl("std()",colnames(test_trainR[[2]]),fixed=TRUE)

extractTest<-test_trainR[[2]][(colwithMean|colwithStd)]
extractTestCols<-colnames(extractTest)

#label the variables 
colnames(test_trainR[[1]])<-"Subject"
colnames(test_trainR[[3]])<-"Activity"

#Combine the tables into one dataste.
sub_act<-cbind(test_trainR[[1]],test_trainR[[3]])
testTable<-cbind(sub_act,extractTest)

#Order the table so that it is arranged first by subjects, then by activities.
orderTable<-testTable[order(testTable$Subject, testTable$Activity),]

#summarize the table so that it calculate all the averages for all the test by each subject 
#and each test.
summaryTable<-aggregate(orderTable, by=list(orderTable$Activity,orderTable$Subject), FUN=mean)
#Delete the fist two group columns.
summaryTable<-summaryTable[,-(1:2)]

#label the activity columns, from "activity_labels.txt"
activityNames<-read.table("UCI HAR Dataset/activity_labels.txt")
ActivityRepNames<-activityNames[summaryTable$Activity,"V2"]
summaryTable$Activity<-ActivityRepNames

#Write the dateframe into a txt file.
write.table(summaryTable, file="finalTable.txt",row.name=FALSE)

colnames(summaryTable)

