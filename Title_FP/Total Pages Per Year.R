library(httr)
library(dplyr)
library(tidyr)
library(XML)
library(xml2)

setwd("C:\\Users\\grfai\\Documents\\0_Dissertation\\Code\\ChronAm\\Title_FP")
baseurl <- "https://chroniclingamerica.loc.gov/search/pages/results/"
rowsperpg <- 1
search_pause <- 7

annual_count <- data.frame(year = numeric(0),
                 hits = numeric(0),
                 stringsAsFactors = FALSE)




for (year in 1770:1963) {

  query <- paste0(baseurl,
                  "?",
                  "dateFilterType=yearRange&date1=",year,"&date2=",year,
                  "&page=",1, ####setting to one page so as not to make the server angry
                  "&rows=",rowsperpg,
                  "&language=eng",
                  "&searchType=advanced",
                  "&format=atom")
  Sys.sleep(search_pause)   
  xmlresp <- try(read_xml(GET(query))) #introducing error handling segment here
  while (inherits(xmlresp,"try-error")) {
    message ("Pausing search...")
    Sys.sleep (900) #Takes a fifteen minute break if there's an error
    xmlresp <- try(read_xml(GET(query))) #Try again
  }
  #View(content(htmlresp, "text")) #for debugging
  
  
  hits<-xml_text(xml_find_all(xmlresp,xpath="//opensearch:totalResults")) #total hits from query
  add_year <- c(year,hits)
  annual_count <- rbind(annual_count,add_year)
  print(paste(year,hits))
  
  }

write.csv(annual_count,"annual_count.csv",row.names = FALSE)

