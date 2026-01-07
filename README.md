# COVID-19 Interactive Map - Malaysia

An interactive Shiny web application for visualizing COVID-19 data across Malaysian states from 2020 to 2025. The application provides three interactive maps showing cases, tests, and deaths with real-time data fetching capabilities.

## Features

- **Interactive Maps**: Three separate maps for Cases, Tests, and Deaths
- **Calendar Date Picker**: Easy date selection with calendar interface
- **Real-time Data**: Fetches latest data from MoH-Malaysia GitHub API
- **Data Refresh**: Manual refresh button to update data from API
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
  "lubridate"
))
```

### Data Files

The following files must be present in the `Group Work` directory:
- `malaysia_singapore_brunei_administrative_malaysia_state_province_boundary.shp` (and associated shapefile files)
- `cases_state.csv` (optional - fallback if API fails)
- `deaths_state.csv` (optional - fallback if API fails)
- `tests_state.csv` (optional - fallback if API fails)

## How to Run

### Option 1: From R Console

1. Open R or RStudio
2. Set working directory to the project root:
   ```r
   setwd("path/to/Covid-19-Interactive-Map-Malaysia-2022/Group Work")
   ```
3. Run the app:
   ```r
   shiny::runApp("covid19_interactive_map")
   ```

### Option 2: From Terminal/Command Line

**Windows (PowerShell):**
```powershell
cd "Group Work\covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

**Windows (Command Prompt):**
```cmd
cd "Group Work\covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

**Mac/Linux:**
```bash
cd "Group Work/covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

### Option 3: Using the Run Script

```powershell
# From project root
Rscript "Group Work/run_app.R"
```

The app will open automatically in your default browser at `http://127.0.0.1:3838`

## Application Structure

```
Group Work/
├── covid19_interactive_map/     # Shiny app directory
│   ├── ui.R                     # User interface definition
│   ├── server.R                 # Server logic and data processing
│   ├── global.R                 # Global variables and data loading
│   └── fetch_data.R             # API data fetching functions
├── cases_state.csv              # Local data backup (optional)
├── deaths_state.csv             # Local data backup (optional)
├── tests_state.csv              # Local data backup (optional)
└── malaysia_*.shp               # Shapefile for map visualization
```

## Usage

1. **Select Date**: Use the calendar date picker to select a date (defaults to latest available date)
2. **View Maps**: Switch between Cases, Tests, and Deaths tabs to view different metrics
3. **Interact**: Hover over states to see detailed information
4. **Refresh Data**: Click "Refresh Data from API" to fetch the latest data
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

## Data Refresh Behavior

When you click "Refresh Data from API":
- ✅ Fetches latest data from MoH-Malaysia GitHub API
- ✅ Updates the calendar date picker min/max range automatically
- ✅ Updates the data availability note with new date range
- ✅ Preserves your current date selection if it's still valid
- ✅ Sets to latest date if current selection is outside new range

## Troubleshooting

### App won't start
- Ensure all required R packages are installed
- Check that you're in the correct directory
- Verify shapefile exists in `Group Work` directory

### No data showing
- Check internet connection (for API fetch)
- Verify CSV files exist if using fallback
- Check R console for error messages

### Calendar not working
- Ensure date is within available range
- Try refreshing data from API
- Check browser console for JavaScript errors

## License

This project uses data from the [MoH-Malaysia COVID-19 Public Repository](https://github.com/MoH-Malaysia/covid19-public), which is publicly available.

## Repository

- **Project Repository**: [GitHub](https://github.com/PravinRaj01/Covid-19-Interactive-Map-Malaysia-2022.git)
- **Data Source**: [MoH-Malaysia GitHub](https://github.com/MoH-Malaysia/covid19-public)

## Deployment

### Recommended: ShinyApps.io

**ShinyApps.io** is the best option for deploying Shiny applications:

1. Sign up at https://www.shinyapps.io/ (free tier available)
2. Install `rsconnect` package: `install.packages("rsconnect")`
3. Deploy your app:
   ```r
   library(rsconnect)
   rsconnect::setAccountInfo(name = "your-account", token = "token", secret = "secret")
   setwd("Group Work")
   rsconnect::deployApp(appDir = "covid19_interactive_map", appName = "covid19-malaysia-map")
   ```

**Note**: Vercel is NOT suitable for Shiny apps as it doesn't support R runtime. See `Group Work/DEPLOYMENT_GUIDE.md` for detailed deployment instructions.

## Responsive Design

The app is fully responsive and works on:
- ✅ Desktop computers
- ✅ Tablets
- ✅ Mobile phones

The layout automatically adjusts:
- Sidebar stacks on top on mobile devices
- Map resizes to fit screen
- No horizontal scrolling
- Optimized touch interactions

## Notes

- Data is fetched from the MoH-Malaysia GitHub API on app startup
- The app defaults to the latest available date
- Date range updates automatically when data is refreshed
- Local CSV files serve as fallback if API is unavailable
- App fits within viewport - no scrolling required
