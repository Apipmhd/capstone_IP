#import library
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggpubr)
library(scales)
library(glue)
library(plotly)
library(lubridate)
library(shinydashboard)
library(shiny)
library(DT)
library(stringr)

# Settingan Agar tidak muncul numeric value
options(scipen = 9999)

# read data
lazadaitem <- read.csv("data_input/20191002-items.csv",
                 stringsAsFactors = TRUE)


# cleansing data
lazada <- lazadaitem %>% 
  # deselect kolom yang tidak dibutuhkan
  select(-url) %>% 
  
  # manipulasi kolom
  mutate(
    
    # mengubah tipe data
    retrievedDate = ymd(retrievedDate),
    name = as.character(name),
    brandName = as.character(brandName),
    totalReviews = as.integer(totalReviews)
  )




