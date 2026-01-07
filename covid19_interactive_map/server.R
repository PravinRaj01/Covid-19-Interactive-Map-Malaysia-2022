library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(RColorBrewer)
library(sf)

# Source the data fetching function (in case it's needed for refresh)
# The file is in the same directory as server.R
if (file.exists("fetch_data.R")) {
  source("fetch_data.R")
} else if (file.exists(file.path(getwd(), "fetch_data.R"))) {
  source(file.path(getwd(), "fetch_data.R"))
}

# Define server logic
shinyServer(function(input, output, session) {
  
  # Reactive value to store map data (can be refreshed)
  map_data <- reactiveVal(all_mapdata)
  
  # Reactive value to store data source info
  data_source <- reactiveVal(if(exists("all_mapdata") && !is.null(attr(all_mapdata, "source"))) {
    attr(all_mapdata, "source")
  } else {
    "MoH-Malaysia GitHub API"
  })
  
  # Calculate default date (latest available) immediately
  default_date <- reactive({
    current_data <- map_data()
    if (!is.null(current_data) && nrow(current_data) > 0) {
      dates <- unique(current_data$date)
      if (is.character(dates)) {
        dates_date <- as.Date(dates)
      } else {
        dates_date <- as.Date(dates)
      }
      max(dates_date, na.rm = TRUE)
    } else {
      Sys.Date()
    }
  })
  
  # Initialize date selector with calendar picker - set default immediately
  observe({
    current_data <- map_data()
    if (!is.null(current_data) && nrow(current_data) > 0) {
      dates <- unique(current_data$date)
      # Convert character dates to Date objects for dateInput
      if (is.character(dates)) {
        dates_date <- as.Date(dates)
      } else {
        dates_date <- as.Date(dates)
      }
      # Set min, max, and value for dateInput
      min_date <- min(dates_date, na.rm = TRUE)
      max_date <- max(dates_date, na.rm = TRUE)
      latest_date <- max_date  # Most recent date
      
      # Only update if date input is NULL or needs updating
      if (is.null(input$date) || is.na(input$date)) {
        updateDateInput(
          session,
          "date",
          min = min_date,
          max = max_date,
          value = latest_date
        )
      } else {
        # Update min/max but keep current value if valid
        updateDateInput(
          session,
          "date",
          min = min_date,
          max = max_date
        )
      }
    }
  }, priority = 10)  # High priority to run early
  
  # Output data source info
  output$data_source_info <- renderText({
    paste("Data source:", data_source())
  })
  
  # Output selected date display
  output$selected_date_display <- renderText({
    if (is.null(input$date) || is.na(input$date)) {
      if (!is.null(default_date())) {
        format(default_date(), "%B %d, %Y")
      } else {
        "Selecting..."
      }
    } else {
      format(as.Date(input$date), "%B %d, %Y")
    }
  })
  
  # Output data range info (updates when data is refreshed)
  output$data_range_info <- renderText({
    current_data <- map_data()
    if (!is.null(current_data) && nrow(current_data) > 0) {
      dates <- unique(current_data$date)
      if (is.character(dates)) {
        dates_date <- as.Date(dates)
      } else {
        dates_date <- as.Date(dates)
      }
      min_date <- min(dates_date, na.rm = TRUE)
      max_date <- max(dates_date, na.rm = TRUE)
      paste0("Data available from ", format(min_date, "%Y-%m-%d"), " to ", format(max_date, "%Y-%m-%d"))
    } else {
      "Data available from 2020-01-25 to 2025-05-31"
    }
  })
  
  # Function to refresh data from API
  observeEvent(input$refresh_data, {
    showNotification("Refreshing data from API...", type = "message", duration = 2)
    
    tryCatch({
      # Fetch data from API
      api_data <- fetch_covid_data_from_api()
      
      if (!is.null(api_data) && !is.null(api_data$cases)) {
        covidCases <- api_data$cases
        covidDeaths <- api_data$deaths
        covidTests <- api_data$tests
        
        # Merge data
        all <- covidCases %>%
          left_join(covidDeaths, by = c("date", "state")) %>%
          left_join(covidTests, by = c("date", "state"))
        
        # Read shapefile (assuming we're in Group Work directory context)
        if (basename(getwd()) == "covid19_interactive_map") {
          setwd("..")
        }
        
        if (file.exists("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp")) {
          mapdata <- st_read("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp", quiet = TRUE)
          
          # Merge with shapefile
          new_data <- mapdata %>%
            left_join(all, by = c("locname" = "state")) %>%
            filter(!is.na(date))
          
          map_data(new_data)
          
          # Update data source info
          if (!is.null(api_data) && !is.null(api_data$source)) {
            data_source(api_data$source)
          }
          
          # Update date picker
          dates <- sort(unique(new_data$date), decreasing = TRUE)
          if (is.character(dates)) {
            dates_date <- as.Date(dates)
          } else {
            dates_date <- as.Date(dates)
          }
          min_date <- min(dates_date, na.rm = TRUE)
          max_date <- max(dates_date, na.rm = TRUE)
          
          # Try to preserve current selection if valid
          tryCatch({
            current_selection <- as.Date(input$date)
            if (!is.na(current_selection) && current_selection >= min_date && current_selection <= max_date) {
              updateDateInput(session, "date", min = min_date, max = max_date, value = current_selection)
            } else {
              updateDateInput(session, "date", min = min_date, max = max_date, value = max_date)
            }
          }, error = function(e) {
            updateDateInput(session, "date", min = min_date, max = max_date, value = max_date)
          })
          
          showNotification("Data refreshed successfully!", type = "message", duration = 3)
        } else {
          stop("Shapefile not found")
        }
      } else {
        stop("Failed to fetch data from API")
      }
    }, error = function(e) {
      showNotification(paste("Error refreshing data:", e$message), 
                      type = "error", duration = 5)
    })
  })
  
  # Display the map and data based on the date selected
  date_choice <- reactive({
    # Use input date or default to latest date
    selected_date <- if (!is.null(input$date) && !is.na(input$date)) {
      as.Date(input$date)
    } else {
      default_date()
    }
    
    req(selected_date)
    current_data <- map_data()
    
    # Convert date column to Date if it's character
    d <- current_data %>%
      mutate(date_as_date = as.Date(date)) %>%
      filter(date_as_date == selected_date) %>%
      select(-date_as_date)  # Remove temporary column
    
    return(d)
  })
  
  # Get current map data for domain calculations
  current_mapdata <- reactive({
    map_data()
  })

  #Output for "Cases" tab
  output$cases <- renderLeaflet({
    mylabels <- paste(
      "New cases: ", date_choice()$cases_new, "<br/>",
      "<h6> Import cases:", date_choice()$cases_import, "<br/>",
      "Active cases: ", date_choice()$cases_active, "<br/>",
      "Recovered cases: ", date_choice()$cases_recovered, "<br/>") %>%
      lapply(htmltools::HTML)
    
    pal <- colorBin(palette = "OrRd", domain = current_mapdata()$cases_new, na.color = "white")
    htmltitle <- "<h5> Covid-19 Trends | Number of Cases</h5>"
    
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
                 values= ~current_mapdata()$cases_new, 
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

    pal <- colorBin(palette = "BuPu", domain = current_mapdata()$`rtk-ag`,na.color = "white")
    htmltitle <- "<h5> Covid-19 Trends | Number of Covid-19 Tests Done</h5>"
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
                 values= ~current_mapdata()$`rtk-ag`, 
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
    
    pal <- colorBin(palette = "Greys", domain = current_mapdata()$deaths_new_dod, na.color = "black")
    htmltitle <- "<h5> Covid-19 Trends | Number of Deaths </h5>"
    
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
                 values= ~current_mapdata()$deaths_new_dod, 
                 opacity=1, 
                 title = "Number of Deaths: ", 
                 position = "bottomleft" 
      ) %>%
      addControl(html=htmltitle, position = "topright")
  })
  
})
