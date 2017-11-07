---
<<<<<<< HEAD
output:
  pdf_document:default
  html_document: default
=======
title: "LimpiezaDeDataset.Rmd"
author: "Pedro Burgo V?zquez"
date: "06/11/2017"
output: html_document
>>>>>>> 7ec0228d18926d43de46183118043b347424b231
---
SCRIPT: LimpiezaDeDataset.Rmd

AUTHOR: Pedro Burgo V?zquez

DATE: 06/11/2017

OUTPUT: cleanData_yyyy-mm-dd_hh-mm.ss.csv

PURPOSE: Limpieza de un dataset para poder con posterioridad

DATA SOURCE: https://raw.githubusercontent.com/rdempsey/dataiku-posts/master/building-data-pipeline-data-science-studio/dss_dirty_data_example.csv

INPUT DATA: dss_dirty_data_example.csv

LIMITATIONS:
rm(list = ls())
options(warn = 1)
# Comprobamos y establecemos directorio de trabajo
getwd()
pathToMain <- "/Users/pburgo/Documents/MBD/M3_Actividad_Colaborativa"
setwd(pathToMain)

# Funci?n que toma una cadema de fecha en formato YYYYmmdd o mmddYYYY
# y devuelve otra en formato YYYY-mm-dd
CustomDateFormatting <- function(x){
  x <- as.Date(parse_date_time(x, c("mdY", "Ymd")),"%Y-%m-%d",  tz = "UTC")
  return(format(x, "%Y-%m-%d"))
}

# Funci?n que toma un n?mero de tel?fono sin formato y lo devuelve formateado
  CustomPhoneFormatting <- function(phone, invalid = NA)
  {
    phone <- gsub("(\\d{2})*(\\d{1})*(\\d{3}){1}(\\d{3}){1}(\\d{4}){1}","\\3-\\4-\\5",phone)
    return(phone)
  }

# Nombre de los directorios en d?nde se van a guardar los ficheros originales, el dataset limpio, scripts...
folderData <- "datos"
folderScripts <- paste0(folderData, "/","scripts")
folderRawData <- paste0(folderData, "/","rawData")
folderCleanData <- paste0(folderData, "/","cleanData")

# Se crean los directorios necesarios
if (!file.exists(folderData)) {dir.create(folderData)}
if (!file.exists(folderScripts)) {dir.create(folderScripts)}
if (!file.exists(folderRawData)) {dir.create(folderRawData)}
if (!file.exists(folderCleanData)) {dir.create(folderCleanData)}


outputFileNameOriginal <- "cleandata"
# Se obtiene la fecha con formato yyyy-mm-dd_hh-mm-ss
downloadDateString <- format(Sys.time(),"%Y-%m-%d_%H-%M-%S")


#Cargamos las librer?as que vamos a usar
if (!"stringr" %in% installed.packages()) install.packages("stringr", depend = TRUE)
if (!"stringi" %in% installed.packages()) install.packages("stringi", depend = TRUE)
if (!"tidyr" %in% installed.packages()) install.packages("tidyr", depend = TRUE)
if (!"dplyr" %in% installed.packages()) install.packages("dplyr", depend = TRUE)
if (!"data.table" %in% installed.packages()) install.packages("data.table", depend = TRUE)
if (!"lubridate" %in% installed.packages()) install.packages("lubridate", depend = TRUE)
library(stringr)
library(stringi)
library(tidyr)
library(dplyr)
library(data.table)
library(lubridate)

#Establecemos la conexi?n con la fuente de datos y la descargamos
fileURL <- "https://raw.githubusercontent.com/rdempsey/dataiku-posts/master/building-data-pipeline-data-science-studio/dss_dirty_data_example.csv"

con <- file(fileURL,"r")
# dataToClean <- read.csv2(con, sep = ",", colClasses = "character", header = TRUE )
dataToClean <- read.csv2(con, sep = ",",  header = TRUE )
close(con)

names(dataToClean)

#Guardamos una copia de los datos originales 
originalFileName <- paste0(folderRawData,"/dirtydata_",format(Sys.time(),"%Y-%m-%d_%H-%M-%S"),".csv")
originalFileName
# write.csv2(as.data.frame(dataToClean), originalFileName)
names(dataToClean)
newOrder <- c(1:7,15,8:14)
setcolorder(dataToClean,newOrder)
names(dataToClean)
names(dataToClean) <- c("name","address","city","state","zip","phone","email","created", "work","work.address","work.city",
                         "work.state","work.zipcode","work.phone","work.email")


# Nos quedamos ?nicamente con las 8 primeras columnas. Los datos relativos al trabajo (work) los obviamos
dataToClean <- dataToClean[1:1000 ,1:8]


# Separamos la columna name en name (nombre) y surname (apellidos). Primero removemos los espacios a los lados
dataToClean$name <- stri_trim_both(dataToClean$name) 
dataToClean <- dataToClean %>% separate("name",  c("name", "surname"), " " , remove = TRUE)

# Separamos la columna addres en addres (direcci?n) y flat (piso).
# Si se usase la direcci?n para una geolocalizaci?n inversa el numero de apartamento o Suite no parecen relevantes.
# Como no aparecen en todos los registros los separamos para homogeneizar la columna address.
# Primero removemos los espacios a los lados y usamos la regex addressPattern
dataToClean$address <- stri_trim_both(dataToClean$address) 
addresPattern <- "(?=((Apt\\.))|(Suite))"
dataToClean <- dataToClean %>% separate(address, c("address", "flat"), addresPattern, remove = TRUE)

# Separamos la columna created en created (que llevar? la fecha) y created.hour (que llevar? el detalle de la hora).
# No todos los registros presentan la hora, por lo que vamos a prescindir de ella. Adem?s a priori viendo los datos
# no parece que sea algo importante para conservar.
# Primero removemos los espacios a los lados.

dataToClean$created <- stri_trim_both(dataToClean$created) 
dataToClean <- dataToClean %>% separate("created", c("created", "created.hour"), " ", remove = TRUE)

# Las fechas se encuentran en dos formatos distintos mm/dd/yyyy y yyyy-mm-dd
# Para homogeneizar los datos primero vamos a eliminar los '-' y los '/' qued?ndonos los formatos
# mmddyyyy e yyyymmdd. Usamos una regex reemplazando las ocurrencias con ''
# Tambi?n se habr?a podido usar la regex
# datePatttern <- "([0-9]+)-([0-9]+)-([0-9]+)|([0-9]+)\\/([0-9]+)\\/([0-9]+)"
# Usando como reemplazo los grupos encontrados
# dateReplacement <- "\\1\\2\\3\\4\\5\\6"
datePatttern <- "([-]+)|([/]+)"
dateReplacement <- ""
dataToClean$created <- gsub(datePatttern,dateReplacement,dataToClean$created)

# Aplicamos la funci?n CustomDateFormatting a la columna created
dataToClean$created <- sapply(dataToClean$created, CustomDateFormatting)
dataToClean$created <- as.Date(dataToClean$created)

# Separamos la columna phone en phone (que llevar? el n?mero de tel?fono) y ext (que llevar? la extensi?n).
# No todos los registros presentan la extensi?n, por lo que vamos a prescindir de ella.
# Primero removemos los espacios a los lados.
dataToClean$phone <- stri_trim_both(dataToClean$phone) 
dataToClean <- dataToClean %>% separate("phone", c("phone", "ext"), "x", remove = TRUE)

# Los tel?fonos se encuentran en distintos formatos 
# Para homogeneizar los datos primero vamos a eliminar todo lo que no sea un d?gito
phonePatttern <- "([^0-9]+)"
dataToClean$phone <-  gsub(phonePatttern,dateReplacement,dataToClean$phone)

# Aplicamos la funci?n CustomPhoneFormatting a la columna phone
dataToClean$phone <- sapply(dataToClean$phone, CustomPhoneFormatting)



# Finalmente nos vamos a quedar ?nicamente con las columnas name, surname,address, city, state, zip, phone, email y created
newOrder <- c(1:3,5:6,8,10:11,4,7,9,12)
setcolorder(dataToClean,newOrder)
dataToClean <- dataToClean[ ,1:8]
dim(dataToClean)
#Nos quedamos con los registros que carecen de NA
dataToClean <- dataToClean[complete.cases(dataToClean),]
dim(dataToClean)

# A mayores vamos a filtrar a aquellos registros que en los campos phone y email tiene cadena vac?a.
# No son NA pero s? est?n vacios.
dataToClean <- dataToClean[!(dataToClean$phone == "" | dataToClean$email == ""), ]
dim(dataToClean) 

# Ordenamos el dataset por el campo created en sentido ascendente
dataToClean <- dataToClean[order(dataToClean$created), ]
# summary(dataToClean) 

          




