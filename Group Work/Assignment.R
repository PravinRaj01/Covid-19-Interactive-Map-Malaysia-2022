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

setwd("C:/Users/Meghashyaam's PC/Documents//University Malaya/sem 1/intro to DS/Group Work")
getwd()



#Import data
# download.file(url = "https://github.com/MoH-Malaysia/covid19-public/archive/refs/heads/main.zip",
#               destfile = "covid19-data-master.zip")
# unzip(zipfile = "covid19-data-master.zip")




#read in shape file
mapdata<- st_read("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp")
# mapdata <- mapdata_old %>% select(-c(1:4, 6:15))

#read in data
covidCases <- vroom("cases_state.csv")
covidDeaths <- vroom("deaths_state.csv")
covidTests <- vroom("tests_state.csv")


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

#merge covid data with modzcta shapefile
all_mapdata <- geo_join(mapdata, all,
                     "locname","state",
                     how = "inner")

setdiff(all$state,mapdata$locname)

#check distribution of data
# all %>%
#   ggplot(aes(x=as.numeric(covidmap$cases_new))) +
#   geom_histogram(bins=20, fill='#69b3a2', color='white')

#interactive map_sample
mylabels <- paste(
  "New cases: ", all_mapdata()$cases_new, "<br/>" %>%
  lapply(htmltools::HTML)
)

pal <- colorBin(palette = "OrRd", domain = all_mapdata$cases_new, na.color = "white")
htmltitle <- "<h5> Covid-19 Trends 2022 | Number of Cases</h5>"

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

