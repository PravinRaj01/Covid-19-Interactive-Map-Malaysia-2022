# Quick Reference Guide

## 1. How is the app getting data?

The app fetches data through the following process:

### Primary Method: MoH-Malaysia GitHub API
- **Source**: `https://raw.githubusercontent.com/MoH-Malaysia/covid19-public/main/epidemic/`
- **Files Fetched**:
  - `cases_state.csv` - COVID-19 cases by state
  - `deaths_state.csv` - COVID-19 deaths by state  
  - `tests_state.csv` - COVID-19 tests by state

### Fallback Method: Local CSV Files
- If API fails, the app uses local files in the `Group Work` directory:
  - `cases_state.csv`
  - `deaths_state.csv`
  - `tests_state.csv`

### Data Flow:
1. **App Startup**: `global.R` calls `fetch_covid_data_from_api()` to get latest data
2. **Data Merging**: Cases, deaths, and tests are merged by date and state
3. **Shapefile Integration**: Data is joined with Malaysian state boundaries
4. **Refresh**: Clicking "Refresh Data from API" re-fetches and updates all data

---

## 2. README Updated ✅

The README.md has been updated with:
- Complete feature list
- Data source information
- Installation requirements
- How to run instructions
- Application structure
- Usage guide
- Troubleshooting tips

---

## 3. Cursor Files Removed ✅

Created `.gitignore` file that excludes:
- `.cursor/` directory
- `.cursorrules` file
- Test files (optional)
- R temporary files
- IDE files

**No cursor-related files found in the project** - safe to commit to GitHub.

---

## 4. How to Run the App

### Windows PowerShell:
```powershell
cd "Group Work\covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

### Windows Command Prompt:
```cmd
cd "Group Work\covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

### Mac/Linux:
```bash
cd "Group Work/covid19_interactive_map"
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

### From R Console:
```r
setwd("Group Work")
shiny::runApp("covid19_interactive_map")
```

The app will open at: `http://127.0.0.1:3838`

---

## 5. Refresh API Updates

**YES** - When you click "Refresh Data from API":

✅ **Calendar Date Range**: Automatically updates min/max dates based on new data
✅ **Date Availability Note**: Updates to show the new date range (e.g., "Data available from 2020-01-25 to 2025-06-15")
✅ **Current Selection**: Preserves your selected date if it's still valid, otherwise sets to latest date
✅ **Map Data**: All three maps (Cases, Tests, Deaths) update with new data

The date range note is now **dynamic** and will automatically reflect the actual date range in your data after refresh.

---

## Files Created/Updated

- ✅ `README.md` - Comprehensive documentation
- ✅ `.gitignore` - Excludes cursor files and temporary files
- ✅ `server.R` - Added dynamic date range output
- ✅ `ui.R` - Made date range note dynamic

