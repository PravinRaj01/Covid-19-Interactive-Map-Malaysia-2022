library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(RColorBrewer)

# Define server logic
shinyServer(function(input, output) {
  
  #Display the map and data based on the date selected
  date_choice <- reactive({
    d <- all_mapdata %>% filter(date == input$date)
    return(d)
  })

  #Output for "Cases" tab
  output$cases <- renderLeaflet({
    mylabels <- paste(
      "New cases: ", date_choice()$cases_new, "<br/>",
      "<h6> Import cases:", date_choice()$cases_import, "<br/>",
      "Active cases: ", date_choice()$cases_active, "<br/>",
      "Recovered cases: ", date_choice()$cases_recovered, "<br/>") %>%
      lapply(htmltools::HTML)
    
    pal <- colorBin(palette = "OrRd", domain = all_mapdata$cases_new, na.color = "white")
    htmltitle <- "<h5> Covid-19 Trends 2022 | Number of Cases</h5>"
    
    date_choice() %>%
      st_transform(crs = "+init=epsg:4326") %>%
      leaflet()%>%
      addProviderTiles(provider = "CartoDB.Positron")%>%
      setView(lat = 4.2105,	lng = 108.4, zoom = 5.15)%>%
      addPolygons(
        fillOpacity = 0.7,
        opacity = 1,
        smoothFactor = .5,
        fillColor = ~pal(date_choice()$cases_new), 
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
  })
  
  #Output for "Tests" tab
  output$tests <- renderLeaflet({
    mylabels <- paste(
      "New tests (RTK-Ag): ", date_choice()$`rtk-ag`, "<br/>",
      "New tests (RT-PCR): ", date_choice()$pcr, "<br/>") %>%
      lapply(htmltools::HTML)

    pal <- colorBin(palette = "BuPu", domain = all_mapdata$`rtk-ag`,na.color = "white")
    htmltitle <- "<h5> Covid-19 Trends 2022 | Number of Covid-19 Tests Done</h5>"
    info <- "<h5> Info: </h5>
    <h6> RTK-Ag: Antigen Rapid Test Kits (RTK-Ag) </h6>
    <h6> RT-PCR: Real-time Reverse Transcription Polymerase Chain Reaction technology </h6>"
    
    date_choice() %>%
      st_transform(crs = "+init=epsg:4326") %>%
      leaflet()%>%
      addProviderTiles(provider = "CartoDB.Positron")%>%
      setView(lat = 4.2105,	lng = 108.4, zoom = 5.15)%>%
      addPolygons(
        fillOpacity = 0.7,
        opacity = 1,
        smoothFactor = .5,
        fillColor = ~pal(date_choice()$`rtk-ag`), 
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
                 values= ~all_mapdata$covidTests, 
                 opacity=1, 
                 title = "Number of Tests: ", 
                 position = "bottomleft" 
      ) %>%
      addControl(html=htmltitle, position = "topright")%>%
      addControl(html= info , position = "bottomright")
    
  })
  
  #Output for "Deaths" tab
  output$deaths <- renderLeaflet({
    mylabels <- paste(
      "New deaths: ", date_choice()$deaths_new_dod, "<br/>") %>%
      lapply(htmltools::HTML)
    
    pal <- colorBin(palette = "Greys", domain = all_mapdata$deaths_new_dod, na.color = "black")
    htmltitle <- "<h5> Covid-19 Trends 2022 | Number of Deaths </h5>"
    
    date_choice() %>%
      st_transform(crs = "+init=epsg:4326") %>%
      leaflet()%>%
      addProviderTiles(provider = "CartoDB.Positron")%>%
      setView(lat = 4.2105,	lng = 108.4, zoom = 5.15)%>%
      addPolygons(
        fillOpacity = 0.7,
        opacity = 1,
        smoothFactor = .5,
        fillColor = ~pal(date_choice()$deaths_new_dod), 
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
                 values= ~all_mapdata$covidDeaths, 
                 opacity=1, 
                 title = "Number of Deaths: ", 
                 position = "bottomleft" 
      ) %>%
      addControl(html=htmltitle, position = "topright")
  })
  
})
