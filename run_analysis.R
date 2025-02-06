# Peer-graded assignment

# Loading necessary packages

#install.packages("dplyr")
#install.packages("here")
#install.packages("plyr")
library(plyr)
library(dplyr)
library(here)


#Set-up directory for work and data

if(!dir.exists("./data")){dir.create(here("./data"))}

#Loading data

temp <- tempfile() #Temporary variable to save zip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,temp)
zip_names <- unzip(temp, list = TRUE) #Explore and store zip file
zip_list <- as.vector(zip_names[,1])

#Retrieve and store tables in dataframes

i <- 1
for(i in 1:length(zip_list)) {                    # assign function within loop

  if (zip_names[i,2] != 0) { #Check if the file is empty and skip if it is
    assign(gsub(".*\\/", "", (zip_names[i,1])), read.table(unz(temp, zip_names[i,1]), fill = T))
    i < i + 1
  } else {
    i < i + 1
  }
  
}

unlink(temp) #Delete temporary file

# Tidy datasets

colnames(X_test.txt) <- features.txt$V2 # Assign correct column names
colnames(X_train.txt) <- features.txt$V2
colnames(activity_labels.txt) <- c("activity", "label")

# Retrieve the mean and std columns

X_train <- X_train.txt[, grep("mean\\(\\)|std\\(\\)", colnames(X_train.txt))]
X_test <- X_test.txt[, grep("mean\\(\\)|std\\(\\)", colnames(X_test.txt))]

# Add ID fields

X_test$subjectid <- subject_test.txt$V1
X_train$subjectid <- subject_train.txt$V1

X_test$activity <- y_test.txt$V1
X_train$activity <- y_train.txt$V1

# Merge data sets

X_test <- join(X_test, activity_labels.txt, by = "activity")
X_train <- join(X_train, activity_labels.txt, by = "activity")

# Create summary

  # Merge both tables

full_data <- rbind(X_train, X_test)

  #Summary
summary_data <- full_data %>% 
  group_by(subjectid, label, activity) %>%
  summarise_all("mean")

# Save file

write.csv(summary_data, file = "./data/mean_values.csv")

