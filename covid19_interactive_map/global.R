# Global variables and data loading
library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)
library(RColorBrewer)
library(sf)
library(httr)
library(jsonlite)
library(vroom)
library(lubridate)
library(bslib)
library(bsicons)

# Source the data fetching function
# (Assumes fetch_data.R is in the same folder)
source("fetch_data.R") 

# Function to load and prepare map data
load_map_data <- function() {
  # Try to fetch data from API
  api_data <- fetch_covid_data_from_api()
  
  if (!is.null(api_data) && !is.null(api_data$cases)) {
    cat("Using data from API:", api_data$source, "\n")
    covidCases <- api_data$cases
    covidDeaths <- api_data$deaths
    covidTests <- api_data$tests
  } else {
    # Fallback to local CSV files if API fails
    cat("API fetch failed, trying local CSV files...\n")
    if (file.exists("cases_state.csv")) {
      covidCases <- vroom("cases_state.csv", show_col_types = FALSE)
      covidDeaths <- vroom("deaths_state.csv", show_col_types = FALSE)
      covidTests <- vroom("tests_state.csv", show_col_types = FALSE)
    } else {
      stop("No data source available. Please check your internet connection or ensure CSV files exist.")
    }
  }
  
  # Merge all separate data into one dataset
  all <- covidCases %>%
    left_join(covidDeaths, by = c("date", "state")) %>%
    left_join(covidTests, by = c("date", "state"))
  
  # Read shapefile
  # CRITICAL: We look for the file directly in the current directory
  shp_name <- "malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp"
  
  if (file.exists(shp_name)) {
    mapdata <- st_read(shp_name, quiet = TRUE)
  } else {
    stop(paste("Shapefile not found:", shp_name))
  }
  
  # Merge covid data with shapefile
  all_mapdata <- mapdata %>%
    left_join(all, by = c("locname" = "state")) %>%
    filter(!is.na(date))  # Keep only rows with matching data
  
  return(all_mapdata)
}

# Load the map data
all_mapdata <- load_map_data()

# Set source attribute
api_data <- fetch_covid_data_from_api()
if (!is.null(api_data) && !is.null(api_data$source)) {
  attr(all_mapdata, "source") <- api_data$source
} else {
  attr(all_mapdata, "source") <- "MoH-Malaysia GitHub API"
}

cat("Map data loaded successfully. Total records:", nrow(all_mapdata), "\n")