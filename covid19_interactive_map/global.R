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
library(bsicons)  # For icons in value boxes

# Source the data fetching function
source("fetch_data.R")

# Set working directory to find data files (shapefile and CSV files)
# When Shiny runs, the working directory is the app directory (covid19_interactive_map)
# So we need to go up one level to access the shapefile and CSV files
if (basename(getwd()) == "covid19_interactive_map") {
  setwd("..")
} else if (file.exists("cases_state.csv")) {
  # Already in the correct directory (root or data directory)
} else if (file.exists(file.path("Group Work", "cases_state.csv"))) {
  # Fallback: if still in old structure
  setwd("Group Work")
}
getwd()

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
      
      # Keep all available data (no year filter)
      if ("date" %in% colnames(covidCases)) {
        # Dates are already in the correct format from CSV files
        # No need to filter by year - keep all data
      }
    } else {
      stop("No data source available. Please check your internet connection or ensure CSV files exist.")
    }
  }
  
  # Merge all separate data into one dataset
  all <- covidCases %>%
    left_join(covidDeaths, by = c("date", "state")) %>%
    left_join(covidTests, by = c("date", "state"))
  
  # Read shapefile
  if (file.exists("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp")) {
    mapdata <- st_read("malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp", quiet = TRUE)
  } else {
    stop("Shapefile not found. Please ensure malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp exists.")
  }
  
  # Merge covid data with shapefile
  all_mapdata <- mapdata %>%
    left_join(all, by = c("locname" = "state")) %>%
    filter(!is.na(date))  # Keep only rows with matching data
  
  return(all_mapdata)
}

# Load the map data (will use API if available, otherwise fallback to local files)
all_mapdata <- load_map_data()

# Try to get source info from API fetch
api_data <- fetch_covid_data_from_api()
if (!is.null(api_data) && !is.null(api_data$source)) {
  attr(all_mapdata, "source") <- api_data$source
} else {
  attr(all_mapdata, "source") <- "MoH-Malaysia GitHub API"
}

cat("Map data loaded successfully. Total records:", nrow(all_mapdata), "\n")
cat("Date range:", min(all_mapdata$date, na.rm = TRUE), "to", max(all_mapdata$date, na.rm = TRUE), "\n")
cat("Data source:", attr(all_mapdata, "source"), "\n")

