rm(list = ls())

options(warn = 1)
#options(stringsAsFactors=FALSE)
pathToMain <- "/Users/pburgo/Documents/MBD/M3_Actividad_Colaborativa"
setwd(pathToMain)
getwd()

# Nombre del directorio y los subdirectorios donde se guardaran los ficheros originales y los tidy
folderData <- "datos"
folderScripts <- "scripts"
folderRawData <- "rawData"
folderCleanData <- "cleanData"
# URL para descargar el fichero
fileURL <- "https://raw.githubusercontent.com/rdempsey/dataiku-posts/master/building-data-pipeline-data-science-studio/dss_dirty_data_example.csv"
# fileURL <- "datos/rawData/dss_dirty_data_example.csv"


# Nombre del messydata y del output. Despues se unira a la fecha para obtener el nombre completo
originalFileNameOriginal <- "messydata"
outputFileNameOriginal <- "tidydata"
# Se obtiene la fecha con formato yyyy-mm-dd_hh-mm-ss
downloadDateString <- format(Sys.time(),"%Y-%m-%d_%H-%M-%S")

# Se crea un directorio para los datos
if (!file.exists(folderData)) { 
  dir.create(folderData)
}
# Creamos un subdirectorio para los "rawdata"
if (!file.exists(paste0(folderData, "/", folderRawData))) { 
  dir.create(paste0(folderData, "/", folderRawData))
}
# Creamos un subdirectorio para los "rawdata"
if (!file.exists(paste0(folderData, "/", folderCleanData))) {
  dir.create(paste0(folderData, "/", folderCleanData))
}
# Creamos un subdirectorio para los scripts
if (!file.exists(paste0(folderData, "/", folderScripts))) {
  dir.create(paste0(folderData, "/", folderScripts))
}
if (!"stringr" %in% installed.packages()) install.packages("stringr", depend = TRUE)
if (!"tidyr" %in% installed.packages()) install.packages("tidyr", depend = TRUE)
if (!"dplyr" %in% installed.packages()) install.packages("dplyr", depend = TRUE)
if (!"data.table" %in% installed.packages()) install.packages("data.table", depend = TRUE)
if (!"lubridate" %in% installed.packages()) install.packages("lubridate", depend = TRUE)
library(stringr)
library(tidyr)
library(dplyr)
library(data.table)
library(lubridate)
con <- file(fileURL,"r")
dataToClean <- read.csv2(con, sep = ",", colClasses = "character")

close(con)
# write.xlsx(as.data.frame(dataToClean), "datos/rawData/dss_dirty_data_example.xlsx", row.names=FALSE, showNA=FALSE)
names(dataToClean) <- c("full.name","full.address","city","state","zip","phone","email","work","work.address","work.city",
                         "work.state","work.zipcode","work.phone","work.email","account.created")





dataToClean$full.name <- stringi::stri_trim_both(dataToClean$full.name) 
dataToClean <- dataToClean %>% separate(full.name,  c("name", "surname"), " " , remove = FALSE)


newOrder <- c("full.name", "name","surname","full.address","city","state","zip","phone","email","account.created","work","work.address","work.city",
              "work.state","work.zipcode","work.phone","work.email")
setcolorder(dataToClean,newOrder)
dataToClean <- dataToClean[1:20,1:10]

addresPattern <- "(?=((Apt\\.))|(Suite))"
dataToClean <- dataToClean %>% separate(full.address, c("add", "flat"), addresPattern, remove = FALSE)

# datePatttern <- "([0-9]+)-([0-9]+)-([0-9]+)|([0-9]+)\\/([0-9]+)\\/([0-9]+)"
datePatttern <-"([-]+)|([/]+)"
# dateReplacement <- "\\1\\2\\3\\4\\5\\6"
dateReplacement <- ""
dataToClean <- dataToClean %>% separate(account.created, c("account.created.date", "account.created.hour"), " ", remove = FALSE)
# dataToClean$account.created.date <- str_split_fixed(stringi::stri_trim_both(dataToClean$account.created.date), " ", n = 2)
class(dataToClean$account.created.date)
dataToClean$account.created.date <- gsub(datePatttern,dateReplacement,dataToClean$account.created.date)
dataToClean$account.created.date2 <- dataToClean$account.created.date
# dataToClean$account.created.date <- ymd(dataToClean$account.created.date)

dateFormatting <- function(x){
  # if(is.Date(parse_date_time(x, c("mdy", "ymd")))){
     x <- as.Date(parse_date_time(x, c("mdY", "Ymd")),"%d-%m-%Y",  tz = "UTC")
       # return(x)
        return (format(x, "%d-%m-%Y"))
}
class(dataToClean$account.created.date)
dataToClean$account.created.date <- sapply(dataToClean$account.created.date, dateFormatting)
 # dataToClean$account.created.date <- as.Date(dataToClean$account.created.date)
class(dataToClean$account.created.date)
 summary(dataToClean)

