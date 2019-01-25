#' CPS emlpoyment data extraction
#'
#' This function downloads the Occupations files from the BLS Current Population Survey for years 2011 onwards \url{https://www.bls.gov/cps/lfcharacteristics.htm#occind}
#' All files will be saved in the cps_all_files and mapped to TNR soc taxonomy.
#'
#' @param years Array containing the year or years for which we want to extract the data
#' @param directory Directory where files will be saved
#' @keywords bls
#' @export
#' @examples
#' Extract 2015, 2016 and 2017 CPS data sets from BLS website
#' years<-c(2015:2017)
#' directory<-"/data/Stata/us_data/"
#' cps_employment_data_extraction(years,directory)


cps_employment_data_extraction<-function(years,directory){

for (y in years) {

##Set directory where files will be saved

library(dplyr)

library(data.table)

library(openxlsx)

directory<-directory

setwd(directory)

##Create folder where final files will be saved

output_dir<-paste0(directory,'cps_all_files/')

if (!dir.exists(output_dir)){

  dir.create(output_dir)}

if (y == 2018) {

##For 2018

cps_data<-read.xlsx("https://www.bls.gov/cps/cpsaat11b.xlsx")

} else {
##before 2018

cps_data<-read.xlsx(paste0("https://www.bls.gov/cps/aa",y,"/cpsaat11b.xlsx"))}

##Clean xlsx file

##Keep only first two columns with occupation name and tot employment

cps_data<-cps_data[,c(1:2)]

##Drop ineccesary columns

cps_data<-cps_data[-c(1:4),]

n<-dim(cps_data)[1]

cps_data<-cps_data[1:(n-1),]

##Rename columns

names(cps_data)<-c("occupation_name_cps","tot_emp")

## Convert to numeric employment variable

cps_data$tot_emp<-as.numeric(cps_data$tot_emp)

## In the original file numbers are in thousands

cps_data$tot_emp<-cps_data$tot_emp * 1000

## Make sure there are not empty spaces in occupation name

cps_data$occupation_name_cps<-trimws(cps_data$occupation_name_cps, which = c("both", "left", "right"))

cps_data$occupation_name_cps<-as.character(cps_data$occupation_name_cps)


## Map downloaded data

mapping_cps_occupations<-read.csv("cps_mapping_occupations.csv")

## Merge cps data with mapping

cps_occupation_file<-merge(cps_data,mapping_cps_occupations,by.x = "occupation_name_cps",by.y = "occupation_name",all.x = TRUE)

cps_occupation_file<-cps_occupation_file %>%
                     filter(!is.na(cps_occupation_file$level)) %>%
                     select(soc,occupation_name_cps,tot_emp,level)

## Convert SOC variable to character format to align with data base column format

cps_occupation_file$soc<-as.character(cps_occupation_file$soc)

write.csv(cps_occupation_file,paste0(output_dir,"all_cps_employment_",y,".csv"),row.names = FALSE)

}

}

