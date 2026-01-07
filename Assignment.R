library(tidyverse)
library(vroom)
library(sf)
library(leaflet)
library(tigris)
library(htmlwidgets)
library(rgeos)
library(maptools)
library(RColorBrewer)
library(rgdal)
library(lubridate)
library(httr)
library(jsonlite)

# Set working directory to the Group Work folder (where this script is located)
# This script should be run from the Group Work directory
# If not, try to find it
if (!file.exists("cases_state.csv")) {
  # Try going up one level and into Group Work
  if (file.exists(file.path("..", "Group Work", "cases_state.csv"))) {
    setwd(file.path("..", "Group Work"))
  } else if (file.exists(file.path("Group Work", "cases_state.csv"))) {
    setwd("Group Work")
  }
}
getwd()



#Import data
# download.file(url = "https://github.com/MoH-Malaysia/covid19-public/archive/refs/heads/main.zip",
#               destfile = "covid19-data-master.zip")
# unzip(zipfile = "covid19-data-master.zip")




#read in shape file
mapdata<- st_read("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp")
# mapdata <- mapdata_old %>% select(-c(1:4, 6:15))

# Try to fetch data from API first, then fallback to local files
source("covid19_interactive_map/fetch_data.R")

api_data <- fetch_covid_data_from_api()

if (!is.null(api_data) && !is.null(api_data$cases)) {
  cat("Using data from API:", api_data$source, "\n")
  covidCases <- api_data$cases
  covidDeaths <- api_data$deaths
  covidTests <- api_data$tests
} else {
  cat("API fetch failed, using local CSV files...\n")
  # Fallback to local CSV files
  covidCases <- vroom("cases_state.csv", show_col_types = FALSE)
  covidDeaths <- vroom("deaths_state.csv", show_col_types = FALSE)
  covidTests <- vroom("tests_state.csv", show_col_types = FALSE)
  
  # Keep all available data (no year filter)
  # Dates are already in the correct format from CSV files
}


#clean data
# covidCase <- covidCases %>% select(-c(7, 11:25))
# covidCases_2022 <- covidCase[-c(1:11600),]
# 
# covidDeath <- covidDeaths %>% select(-c(3,4,10,11))
# covidDeaths_2022 <- covidDeath[-c(1:10768),]
# 
# covidTest_2022 <- covidTests[-c(1:3232),]



#merge all separate data into one dataset
all <- covidCases %>%
  left_join(covidDeaths, by = c("date", "state"))%>%
  left_join(covidTests, by = c("date", "state"))

#merge covid data with shapefile
# Use left_join for sf objects (preserves spatial class)
all_mapdata <- mapdata %>%
  left_join(all, by = c("locname" = "state")) %>%
  filter(!is.na(date))  # Keep only rows with matching data (inner join equivalent)

setdiff(all$state,mapdata$locname)

#check distribution of data
# all %>%
#   ggplot(aes(x=as.numeric(covidmap$cases_new))) +
#   geom_histogram(bins=20, fill='#69b3a2', color='white')

#interactive map_sample
mylabels <- paste(
  "New cases: ", all_mapdata$cases_new, "<br/>"
) %>%
  lapply(htmltools::HTML)

pal <- colorBin(palette = "OrRd", domain = all_mapdata$cases_new, na.color = "white")
htmltitle <- "<h5> Covid-19 Trends | Number of Cases</h5>"

interactive_map <- all_mapdata%>%
  st_transform(crs = "+init=epsg:4326") %>%
  leaflet()%>%
  addProviderTiles(provider = "CartoDB.Positron")%>%
  setView(lat = 4.2105,	lng = 108.4, zoom = 5.15)%>%
  addPolygons(
    fillOpacity = 0.7,
    opacity = 1,
    smoothFactor = .5,
    fillColor = ~pal(all_mapdata$cases_new), 
    stroke = TRUE, 
    color = 'White', 
    weight = 1.5,
    highlightOptions = highlightOptions(weight = 1,
                                        fillOpacity = 1,
                                        color = "grey",
                                        opacity =1,
                                        bringToFront = TRUE ),
    label = mylabels,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal= pal, 
             values= ~all_mapdata$cases_new, 
             opacity=1, 
             title = "Number of Cases: ", 
             position = "bottomleft" 
  ) %>%
  addControl(html=htmltitle, position = "topright")

saveRDS(all_mapdata, "covidmap.RDS")
saveWidget(interactive_map, "covid19_interactive_map.html")


# interactive_map()
# invisible(print(interactive_map()))

