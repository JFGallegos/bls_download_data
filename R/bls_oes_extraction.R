#' OES emlpoyment data extraction
#'
#' This function downloads the "All data" Occupation Employment Survey data from BLS for years 2012 onwards \url{https://www.bls.gov/oes/tables.htm}
#' All files will be saved in the oes_all_files.
#'
#' @param years Array containing the year or years for which we want to extract the data
#' @keywords bls
#' @export
#' @examples
#' Extract 2015, 2016 and 2017 "All data" OES data sets from BLS website
#' years<-c(15:17)
#' directory<-"/data/Stata/us_data/"
#' bls_emlpoyment_data_extraction(years,directory)


oes_employment_data_extraction<-function(years,directory){

rm(list=ls())

##Set directory where files will be saved

library(data.table)

library(openxlsx)

directory<- directory

setwd(directory)

##Create folder where final files will be saved

output_dir<-paste0(directory,'oes_all_files/')

if (!dir.exists(output_dir)){
  dir.create(output_dir)
}


## Loop to extract EOS data from 2012 onwards

for (y in years) {

  if (y >= 14) {

    download.file(url=paste0("https://www.bls.gov/oes/special.requests/oesm",y,"all.zip"), destfile=paste0(directory,'localfile',y,'.zip'))

    unzip(zipfile = paste0(directory,"localfile",y,".zip"),files = paste0("oesm",y,"all/all_data_M_20",y,".xlsx"),exdir = ".")

    data_frame<-read.xlsx(paste0(directory,"oesm",y,"all/all_data_M_20",y,".xlsx"),1)

    write.csv(data_frame,paste0(output_dir,"all_oes_20",y,".csv"),row.names = FALSE)}

  if (y==12) {

    download.file(url=paste0("https://www.bls.gov/oes/special.requests/oesm",y,"all.zip"), destfile=paste0(directory,'localfile',y,'.zip'))

    unzip(zipfile = paste0(directory,"localfile",y,".zip"),files = "all_oes_data_2012.xlsx",exdir = ".")

    data_frame<-read.xlsx(paste0(directory,"all_oes_data_2012.xlsx"),1)

    write.csv(data_frame,paste0(output_dir,"all_oes_2012.csv"),row.names = FALSE)}

  if (y==13) {

    download.file(url=paste0("https://www.bls.gov/oes/special.requests/oesm",y,"all.zip"), destfile=paste0(directory,'localfile',y,'.zip'))

    unzip(zipfile = paste0(directory,"localfile",y,".zip"),files = "oes_data_2013.xlsx",exdir = ".")

    data_frame<-read.xlsx(paste0(directory,"oes_data_2013.xlsx"),1)

    write.csv(data_frame,paste0(output_dir,"all_oes_2013.csv"),row.names = FALSE)

  }

}

}
