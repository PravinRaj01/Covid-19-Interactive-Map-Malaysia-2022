# API Usage Guide for COVID-19 Interactive Map

## Current Data Source

The app currently fetches data from the **MoH-Malaysia GitHub API**:
- **Cases**: `https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/cases_state.csv`
- **Deaths**: `https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/deaths_state.csv`
- **Tests**: `https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/tests_state.csv`

## Using data.gov.my API

If you find COVID-19 datasets on [data.gov.my](https://data.gov.my/data-catalogue), you can update the app to use their API.

### Step 1: Find the Dataset ID

1. Go to [data.gov.my/data-catalogue](https://data.gov.my/data-catalogue)
2. Search for COVID-19 related datasets
3. Click on a dataset to view its details
4. Note the dataset ID (e.g., `covid19_cases`, `covid19_deaths`)

### Step 2: Test the API Endpoint

Test the API endpoint using the format:
```
GET https://api.data.gov.my/data-catalogue?id=DATASET_ID&limit=1000
```

Example:
```r
library(httr)
library(jsonlite)

# Test the API
response <- GET("https://api.data.gov.my/data-catalogue?id=covid19_cases&limit=10")
data <- fromJSON(content(response, as = "text"))
```

### Step 3: Update fetch_data.R

Update the `fetch_covid_data_from_api()` function in `covid19_interactive_map/fetch_data.R` to use data.gov.my API:

```r
# In fetch_data.R, add a function to fetch from data.gov.my
fetch_from_datagovmy_covid <- function() {
  # Replace these IDs with actual dataset IDs from data.gov.my
  cases_data <- fetch_from_datagovmy("covid19_cases", limit = 10000)
  deaths_data <- fetch_from_datagovmy("covid19_deaths", limit = 10000)
  tests_data <- fetch_from_datagovmy("covid19_tests", limit = 10000)
  
  # Process and return data in the same format
  # ...
}
```

### Step 4: Update the Fetch Function Priority

Modify `fetch_covid_data_from_api()` to prioritize data.gov.my:

```r
fetch_covid_data_from_api <- function() {
  # Try data.gov.my first
  datagovmy_data <- fetch_from_datagovmy_covid()
  if (!is.null(datagovmy_data)) {
    return(datagovmy_data)
  }
  
  # Fallback to MoH-Malaysia GitHub
  # ... existing code ...
}
```

## API Endpoint Format

The data.gov.my API uses this format:
```
https://api.data.gov.my/data-catalogue?id=DATASET_ID&limit=N
```

Parameters:
- `id`: The dataset ID from data.gov.my catalogue
- `limit`: Maximum number of records to return (optional)

## Example: Fuel Price API (Reference)

As shown in the data.gov.my documentation:
```
GET https://api.data.gov.my/data-catalogue?id=fuelprice&limit=3
```

Returns JSON data that can be parsed and used in R.

## Data Format Requirements

The app expects data with these columns:
- **Cases**: `date`, `state`, `cases_new`, `cases_import`, `cases_recovered`, `cases_active`
- **Deaths**: `date`, `state`, `deaths_new_dod`
- **Tests**: `date`, `state`, `rtk-ag`, `pcr`

If the data.gov.my API returns different column names, you'll need to map them in the `fetch_from_datagovmy_covid()` function.

## Refresh Functionality

The app includes a "Refresh Data from API" button that:
1. Fetches the latest data from the API
2. Updates the map data
3. Refreshes the date selector with new dates

This ensures your app always shows the most current data available.

## Troubleshooting

1. **API not responding**: Check your internet connection and the API endpoint URL
2. **Data format mismatch**: Verify column names match expected format
3. **Date format issues**: Ensure dates are in a format R can parse (YYYY-MM-DD or DD/MM/YYYY)
4. **Rate limiting**: Some APIs have rate limits; add delays between requests if needed

## Additional Resources

- [data.gov.my API Documentation](https://developer.data.gov.my/)
- [data.gov.my Data Catalogue](https://data.gov.my/data-catalogue)
- [MoH-Malaysia COVID-19 Data Repository](https://github.com/MoH-Malaysia/covid19-public)

