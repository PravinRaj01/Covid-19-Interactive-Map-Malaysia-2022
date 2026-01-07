# Function to fetch COVID-19 data from APIs
# NOTE: MoH-Malaysia GitHub is more up-to-date (data until May 2025)
# data.gov.my API only has data until Dec 2020, so we prioritize MoH-Malaysia GitHub

library(httr)
library(jsonlite)
library(vroom)
library(dplyr)

fetch_covid_data_from_api <- function() {
  # Base URLs
  moh_github_base <- "https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/"
  
  # Fetch cases from MoH-Malaysia GitHub (most up-to-date source)
  # Note: data.gov.my API only has data until Dec 2020, so we use MoH-Malaysia GitHub
  cat("Fetching cases from MoH-Malaysia GitHub API (most up-to-date source)...\n")
  cases_url <- paste0(moh_github_base, "cases_state.csv")
  covidCases <- vroom(cases_url, show_col_types = FALSE)
  used_datagovmy <- FALSE
  
  # Fetch deaths and tests from MoH-Malaysia GitHub (data.gov.my doesn't have these datasets)
  cat("Fetching deaths and tests from MoH-Malaysia GitHub API...\n")
  
  tryCatch({
    # Fetch deaths data
    deaths_url <- paste0(moh_github_base, "deaths_state.csv")
    cat("Fetching deaths data from:", deaths_url, "\n")
    covidDeaths <- vroom(deaths_url, show_col_types = FALSE)
    
    # Fetch tests data
    tests_url <- paste0(moh_github_base, "tests_state.csv")
    cat("Fetching tests data from:", tests_url, "\n")
    covidTests <- vroom(tests_url, show_col_types = FALSE)
    
    # Convert date column to Date format for processing
    # MoH GitHub format: DD/MM/YYYY
    covidCases$date <- as.Date(covidCases$date, format = "%d/%m/%Y")
    covidDeaths$date <- as.Date(covidDeaths$date, format = "%d/%m/%Y")
    covidTests$date <- as.Date(covidTests$date, format = "%d/%m/%Y")
    
    # Keep all available data (2020-2025) - no year filter
    covidCases_all <- covidCases
    covidDeaths_all <- covidDeaths
    covidTests_all <- covidTests
    
    # Convert dates back to character for compatibility
    covidCases_all$date <- as.character(covidCases_all$date)
    covidDeaths_all$date <- as.character(covidDeaths_all$date)
    covidTests_all$date <- as.character(covidTests_all$date)
    
    # Data source (always MoH-Malaysia GitHub - most up-to-date)
    source_name <- "MoH-Malaysia GitHub API"
    
    cat("Successfully fetched data\n")
    cat("Cases records:", nrow(covidCases_all), "\n")
    cat("Deaths records:", nrow(covidDeaths_all), "\n")
    cat("Tests records:", nrow(covidTests_all), "\n")
    cat("Date range:", min(covidCases_all$date, na.rm = TRUE), "to", max(covidCases_all$date, na.rm = TRUE), "\n")
    cat("Data source:", source_name, "\n")
    
    return(list(
      cases = covidCases_all,
      deaths = covidDeaths_all,
      tests = covidTests_all,
      source = source_name
    ))
    
  }, error = function(e) {
    cat("Error fetching data:", e$message, "\n")
    return(NULL)
  })
}

# Function to try data.gov.my API with a specific dataset ID
fetch_from_datagovmy <- function(dataset_id, limit = 1000) {
  api_url <- paste0("https://api.data.gov.my/data-catalogue?id=", dataset_id, "&limit=", limit)
  
  tryCatch({
    cat("Fetching from data.gov.my API:", api_url, "\n")
    response <- GET(api_url, timeout(10))
    
    if (status_code(response) == 200) {
      data <- content(response, as = "text", encoding = "UTF-8")
      df <- fromJSON(data)
      
      if (is.data.frame(df)) {
        cat("Successfully fetched", nrow(df), "records from data.gov.my\n")
        return(df)
      } else if (is.list(df) && length(df) > 0) {
        # Convert list to data frame
        df <- as.data.frame(do.call(rbind, df))
        cat("Successfully fetched", nrow(df), "records from data.gov.my\n")
        return(df)
      } else {
        cat("No data returned from data.gov.my API\n")
        return(NULL)
      }
    } else {
      cat("API request failed with status code:", status_code(response), "\n")
      return(NULL)
    }
  }, error = function(e) {
    cat("Error fetching from data.gov.my:", e$message, "\n")
    return(NULL)
  })
}

