library(utils)

mainDir<-getwd()
subDir<-"Getting and Cleaning Data"
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
setwd(file.path(mainDir, subDir))

download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip", mode="wb")
downloadedDate<-date()
downloadedDate

unzip("dataset.zip")

