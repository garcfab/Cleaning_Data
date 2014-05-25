rm(list = ls())
# Change your working directory here
root = "/Users/fabian/Dropbox/Coursera/Cleaning_Data/"

setwd(paste(root, "UCI HAR Dataset", sep=""))

# Load name features
feature_names = read.table("features.txt", sep="", fill=TRUE)
feature_names = feature_names[,2]

# Load features
x_train = read.table("train/X_train.txt", sep="", fill=TRUE)
names(x_train) <- feature_names
x_test = read.table("test/X_test.txt", sep="", fill=TRUE)
names(x_test) <- feature_names
# Load activity vector and rename column 
y_train = read.table("train/Y_train.txt", sep="", fill=TRUE)
names(y_train) <- 'activity'

y_test = read.table("test/Y_test.txt", sep="", fill=TRUE)
names(y_test) <- 'activity'

# Load id
id_train = read.table("train/subject_train.txt", sep="", fill=TRUE)
colnames(id_train) <- "id"

id_test = read.table("test/subject_test.txt", sep="", fill=TRUE)
colnames(id_test) <- "id"

# Train Data
train_data <- as.data.frame(x=cbind( id_train, y_train, x_train))
test_data <- as.data.frame(x=cbind( id_test, y_test, x_test))

# data set containing training and test sets
data = as.data.frame(x=rbind(train_data, test_data))

# Subsetting using only mean and std variables
data2 = subset(data, select=c(1,2,grep('mean|std',names(test_data))))

# Label activity
data2$activity = factor(data2$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
x_tidy = aggregate(x=data2, by=list(data2$id, data2$activity), FUN=mean)
colnames(x_tidy)[1] <- c('id_person')
colnames(x_tidy)[2] <- c('activity')
tidy <- x_tidy[,c(-3,-4)]
write.table(tidy , file="tidy.txt", sep=",",row.names=FALSE)
