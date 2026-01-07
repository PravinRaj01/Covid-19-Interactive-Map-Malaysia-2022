# Guide: Moving Files from Group Work to Root Folder

## ✅ Yes, it will work! But follow these steps:

### Current Structure:
```
Covid-19-Interactive-Map-Malaysia-2022/
├── Group Work/
│   ├── covid19_interactive_map/
│   │   ├── ui.R
│   │   ├── server.R
│   │   ├── global.R
│   │   └── fetch_data.R
│   ├── cases_state.csv
│   ├── deaths_state.csv
│   ├── tests_state.csv
│   └── malaysia_*.shp (shapefile files)
└── README.md
```

### Target Structure (After Move):
```
Covid-19-Interactive-Map-Malaysia-2022/
├── covid19_interactive_map/
│   ├── ui.R
│   ├── server.R
│   ├── global.R
│   └── fetch_data.R
├── cases_state.csv
├── deaths_state.csv
├── tests_state.csv
├── malaysia_*.shp (shapefile files)
└── README.md
```

## Steps to Move:

### 1. Copy Files (Don't Cut Yet - Test First!)

**Option A: Manual Copy**
1. Copy `covid19_interactive_map` folder to root
2. Copy all CSV files (`cases_state.csv`, `deaths_state.csv`, `tests_state.csv`) to root
3. Copy all shapefile files (`malaysia_*.shp`, `malaysia_*.dbf`, `malaysia_*.shx`, etc.) to root

**Option B: Using PowerShell**
```powershell
# From project root
Copy-Item "Group Work\covid19_interactive_map" -Destination "." -Recurse
Copy-Item "Group Work\*.csv" -Destination "."
Copy-Item "Group Work\malaysia_*" -Destination "."
```

### 2. Test the App

```r
setwd("path/to/Covid-19-Interactive-Map-Malaysia-2022")
shiny::runApp("covid19_interactive_map")
```

If it works, proceed to step 3. If not, check the error messages.

### 3. Update Code (Already Done!)

The code has been updated to:
- ✅ Automatically detect if you're in `covid19_interactive_map` and go up one level
- ✅ Look for CSV files in the current directory
- ✅ Fallback to "Group Work" if files aren't found (for backward compatibility)

### 4. Delete Old Files (After Testing)

Once you've confirmed everything works:
- Delete the `Group Work` folder (or keep it as backup)

## What Will Work:

✅ **App Directory Structure**: The app will find its files correctly  
✅ **Data Files**: CSV and shapefile files will be found in root  
✅ **API Refresh**: Will still work correctly  
✅ **All Features**: Dark mode, calendar, maps, etc. will all work  

## What to Update:

### README.md
Update the paths in README.md:
- Change `Group Work/covid19_interactive_map` → `covid19_interactive_map`
- Change `setwd("Group Work")` → `setwd(".")` or remove it

### Running the App
After moving, run from root:
```r
setwd("path/to/Covid-19-Interactive-Map-Malaysia-2022")
shiny::runApp("covid19_interactive_map")
```

Or from terminal:
```powershell
cd covid19_interactive_map
Rscript -e "shiny::runApp(port=3838, host='127.0.0.1', launch.browser=TRUE)"
```

## Notes:

- The code now handles both old and new structures automatically
- You can keep "Group Work" as backup until you're sure everything works
- All relative paths will work correctly after the move
- The `.gitignore` file will still work the same way

## Quick Test Checklist:

- [ ] App starts without errors
- [ ] Map displays correctly
- [ ] Date picker works
- [ ] Dark mode toggle works
- [ ] Refresh data button works
- [ ] All three tabs (Cases, Tests, Deaths) work

If all checkboxes pass, you're good to delete the old `Group Work` folder!

