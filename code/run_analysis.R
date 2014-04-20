## import activity label
act_lab <- read.table("data/activity_labels.txt",sep=" ",col.names = c("n","act_type"),stringsAsFactors = FALSE)
## import features 
feat <- read.table("data/features.txt", sep=" ",col.names = c("n","feature_type"),stringsAsFactors = FALSE)
## read test dataset and pull it togather with activity and subject.
test <- matrix(as.numeric(scan("data/test/X_test.txt", what = "complex")),ncol=561)
colnames(test) <- feat$feature_type
test.sub <- read.table("data/test/subject_test.txt",sep=" ",col.names = "subject")
test.act <- read.table("data/test/y_test.txt",sep=" ",col.names = "act_type" )
test.df <- data.frame(test,test.sub,test.act)
## read train dataset and pull it togather with activity and subject.
train <- matrix(as.numeric(scan("data/train/X_train.txt", what = "complex")),ncol=561)
colnames(train) <- feat$feature_type
train.sub <- read.table("data/train/subject_train.txt",sep=" ",col.names = "subject")
train.act <- read.table("data/train/y_train.txt",sep=" ",col.names = "act_type" )
train.df <- data.frame(train,train.sub,train.act)
## row bind two datasets into dat and give colnames
dat <- rbind(test.df,train.df)
# renaming activity with appropriate names
dat$act_type <- as.character(factor(dat$act_type,labels = act_lab$act_type))
# column logical index for subseting
col.index <- grepl(pattern = "mean()|std()",feat$feature_type,ignore.case = TRUE)
dat.sdf <- dat[,col.index]
# tidy data set with avarage values for subject and activity
dat.tidy <- aggregate(dat,by=list(Activity= dat$act_type,Subject= dat$subject),FUN = "mean")
# writing data to csv file.
write.table(dat.tidy, file = "data/dat_tidy.csv", sep= "\t",row.names = FALSE)