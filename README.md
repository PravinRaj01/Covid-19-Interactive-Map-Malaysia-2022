# COVID-19 Interactive Map - Malaysia

An interactive Shiny web application for visualizing COVID-19 data across Malaysian states from 2020 to 2025. The application provides three interactive maps showing cases, tests, and deaths with real-time data fetching capabilities.

**🔗 Live App:** [https://pravinraj-codes.shinyapps.io/covid19_interactive_map/](https://pravinraj-codes.shinyapps.io/covid19_interactive_map/)

## Features

- **Interactive Maps**: Three separate maps for Cases, Tests, and Deaths
- **Calendar Date Picker**: Easy date selection with calendar interface
- **Real-time Data**: Fetches latest data from MoH-Malaysia GitHub API
- **Data Refresh**: Manual refresh button to update data from API
- **Dark Mode**: Built-in dark/light theme toggle
- **Professional UI**: Clean, modern interface with professional design
- **State-level Visualization**: Color-coded maps showing COVID-19 metrics by Malaysian state

## Data Source

The application fetches data from the **MoH-Malaysia GitHub Repository**:
- **API Endpoint**: `https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/`
- **Data Files**:
  - `cases_state.csv` - COVID-19 cases by state
  - `deaths_state.csv` - COVID-19 deaths by state
  - `tests_state.csv` - COVID-19 tests by state (RTK-Ag and RT-PCR)

### Data Flow

1. **On App Start**: Data is fetched from the MoH-Malaysia GitHub API
2. **Fallback**: If API fails, the app falls back to local CSV files (`cases_state.csv`, `deaths_state.csv`, `tests_state.csv`)
3. **Data Refresh**: Click "Refresh Data from API" button to fetch latest data
4. **Date Range**: Data available from 2020-01-25 to 2025-05-31 (automatically updates when refreshed)

## Requirements

### R Packages

Install the following R packages:

```r
install.packages(c(
  "shiny",
  "tidyverse",
  "leaflet",
  "htmlwidgets",
  "RColorBrewer",
  "sf",
  "httr",
  "jsonlite",
  "vroom",
  "lubridate",
  "bslib",
  "bsicons"
))
```

### Data Files

The following files must be present in the project root directory:
- `malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp` (and associated shapefile files)
- `cases_state.csv` (optional - fallback if API fails)
- `deaths_state.csv` (optional - fallback if API fails)
- `tests_state.csv` (optional - fallback if API fails)

## How to Run

### Option 1: From R Console

1. Open R or RStudio
2. Set working directory to the project root:
   ```r
   setwd("path/to/covid19_interactive_map")
   ```
3. Run the app:
   ```r
   shiny::runApp()
   ```

### Option 2: From Terminal/Command Line

**Windows (PowerShell):**
```powershell
cd "path\to\covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

**Mac/Linux:**
```bash
cd "path/to/covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

The app will open automatically in your default browser at `http://127.0.0.1:3838`

## Application Structure

The application follows a flat file structure to ensure compatibility with shinyapps.io deployment:

```
covid19_interactive_map/             # Root Project Directory
├── ui.R                             # User interface definition
├── server.R                         # Server logic and data processing
├── global.R                         # Global variables and data loading
├── fetch_data.R                     # API data fetching functions
├── malaysia_*.shp                   # Shapefile components (.shp, .shx, .dbf, .prj)
├── cases_state.csv                  # Local data backup (optional)
├── deaths_state.csv                 # Local data backup (optional)
├── tests_state.csv                  # Local data backup (optional)
├── README.md                        # This file
├── QUICK_REFERENCE.md               # Quick reference guide
└── API_USAGE_GUIDE.md               # API usage documentation
```

## Usage

1. **Select Date**: Use the calendar date picker to select a date (defaults to latest available date)
2. **View Maps**: Switch between Cases, Tests, and Deaths tabs to view different metrics
3. **Toggle Theme**: Use the theme toggle in the top-right to switch between dark and light modes (starts in dark mode)
4. **Interact**: Hover over states to see detailed information
5. **Refresh Data**: Click "Refresh Data from API" to fetch the latest data
   - The calendar date range will automatically update
   - The date availability note will reflect the new date range

## Map Information

### Cases Map
- New cases
- Import cases
- Active cases
- Recovered cases

### Tests Map
- RTK-Ag (Antigen Rapid Test Kits) tests
- RT-PCR (Real-time Reverse Transcription Polymerase Chain Reaction) tests

### Deaths Map
- New deaths by date of death

**Color Intensity**: Darker colors indicate higher values for the selected metric.

## License

This project uses data from the [MoH-Malaysia COVID-19 Public Repository](https://github.com/MoH-Malaysia/covid19-public), which is publicly available.

## Repository

- **Project Repository**: [GitHub](https://github.com/PravinRaj01/Covid-19-Interactive-Map-Malaysia-2022.git)
- **Data Source**: [MoH-Malaysia GitHub](https://github.com/MoH-Malaysia/covid19-public)