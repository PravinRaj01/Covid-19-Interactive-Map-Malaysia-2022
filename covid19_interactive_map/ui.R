# Professional Dashboard UI for COVID-19 Interactive Map
# Using all_mapdata from global.R for date choices

# Custom CSS for dashboard with dark mode support
custom_css <- tags$head(
  tags$style(HTML("
    /* Dashboard Styles - Using Bootstrap CSS Variables for Dark Mode */
    html, body {
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif;
      height: 100vh;
      overflow: hidden;
      margin: 0;
      padding: 0;
    }
    
    /* Value boxes */
    .bslib-value-box {
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 2px 4px rgba(0, 0, 0, 0.06) !important;
      border-radius: 8px !important;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    
    .bslib-value-box:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 12px rgba(0, 0, 0, 0.15), 0 4px 6px rgba(0, 0, 0, 0.1) !important;
    }
    
    /* Map container */
    .map-container {
      border-radius: 8px;
      overflow: hidden;
      border: 1px solid var(--bs-border-color, #e2e8f0);
      height: 600px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    /* Navbar */
    .navbar {
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      min-height: 70px !important;
      padding: 16px 24px !important;
    }
    
    .navbar-brand {
      font-size: 24px !important;
      font-weight: 600 !important;
      padding: 8px 0 !important;
    }
    
    /* Sidebar styling - 'Auto' allows scrolling ONLY if needed */
    .bslib-sidebar,
    .sidebar {
      padding: 12px 16px !important;
      overflow-y: auto !important; 
      max-height: calc(100vh - 70px) !important;
      height: calc(100vh - 70px) !important;
    }
    
    /* Sidebar Headers */
    .sidebar h6 {
      margin-top: 12px !important;
      margin-bottom: 8px !important;
      font-size: 11px !important;
      font-weight: 700;
      opacity: 0.8;
      letter-spacing: 0.5px;
    }
    
    /* Compact elements */
    .sidebar .form-group { margin-bottom: 6px !important; }
    .sidebar .btn { margin-top: 4px !important; margin-bottom: 4px !important; }
    .sidebar ul { margin-top: 4px !important; margin-bottom: 6px !important; }
    .sidebar p { margin-top: 4px !important; margin-bottom: 6px !important; }
    
    /* --- NEW BUTTON LINK STYLING --- */
    .link-card {
      display: flex;
      align-items: center;
      padding: 8px 12px;
      background-color: var(--bs-tertiary-bg, #f8f9fa);
      border: 1px solid var(--bs-border-color, #dee2e6);
      border-radius: 6px;
      text-decoration: none !important;
      color: var(--bs-body-color, #212529) !important;
      transition: all 0.2s ease;
      margin-bottom: 8px; /* Spacing between buttons */
    }
    
    .link-card:hover {
      background-color: var(--bs-secondary-bg, #e9ecef);
      border-color: var(--bs-primary, #0d6efd);
      transform: translateY(-1px);
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    
    .link-card i {
      margin-right: 10px;
      color: var(--bs-primary, #0d6efd);
      font-size: 14px;
    }
    
    .link-card span {
      font-size: 12px;
      font-weight: 600;
    }
  "))
)

# Define UI using bslib dashboard layout
ui <- bslib::page_sidebar(
  title = div(style = "display: flex; align-items: center; justify-content: space-between; width: 100%;",
    span("COVID-19 Interactive Map - Malaysia"),
    bslib::input_dark_mode(id = "theme_mode", mode = "dark")
  ),
  theme = bslib::bs_theme(preset = "shiny"),
  custom_css,
  class = "bslib-page-dashboard",
  
  # Sidebar - collapsible like in the example
  sidebar = bslib::sidebar(
    title = "Controls",
    open = TRUE,  # Start open but allow collapsing
    width = 350,  # Wider sidebar
    style = "padding-top: 8px;", # Fixed typo (removed negative padding)
    
    # Date Selection
    h6("Date Selection", class = "text-uppercase"),
    dateInput(
      "date",
      label = NULL,
      value = {
        if (exists("all_mapdata") && !is.null(all_mapdata) && nrow(all_mapdata) > 0) {
          dates <- unique(all_mapdata$date)
          max(as.Date(dates), na.rm = TRUE)
        } else {
          Sys.Date()
        }
      },
      min = {
        if (exists("all_mapdata") && !is.null(all_mapdata) && nrow(all_mapdata) > 0) {
          dates <- unique(all_mapdata$date)
          min(as.Date(dates), na.rm = TRUE)
        } else {
          as.Date("2020-01-25")
        }
      },
      max = {
        if (exists("all_mapdata") && !is.null(all_mapdata) && nrow(all_mapdata) > 0) {
          dates <- unique(all_mapdata$date)
          max(as.Date(dates), na.rm = TRUE)
        } else {
          as.Date("2025-05-31")
        }
      },
      format = "yyyy-mm-dd",
      startview = "month",
      weekstart = 1,
      language = "en",
      width = "100%",
      autoclose = TRUE
    ),
    
    div(style = "margin-top: 4px; padding: 10px; background: var(--bs-secondary-bg, #edf2f7); border-radius: 4px; border-left: 3px solid var(--bs-primary, #2c5282);",
      div(style = "font-size: 11px; color: var(--bs-secondary-color, #718096); text-transform: uppercase;", "Selected Date"),
      div(style = "font-size: 13px; color: var(--bs-body-color, #1a202c); font-weight: 500; margin-top: 4px;",
        textOutput("selected_date_display", inline = TRUE)
      ),
      div(style = "font-size: 11px; color: var(--bs-secondary-color, #718096); margin-top: 8px;",
        textOutput("data_range_info", inline = TRUE)
      )
    ),
    
    # Refresh Button
    actionButton(
      "refresh_data",
      "Refresh Data from API",
      class = "btn-primary",
      style = "width: 100%; margin-top: 4px; margin-bottom: 4px;"
    ),
    
    # Information
    h6("About This Application", class = "text-uppercase", style = "margin-top: 12px !important; margin-bottom: 0px !important;"), # Changed bottom to 0
    tags$ul(style = "font-size: 13px; padding-left: 20px; margin-top: 0px; margin-bottom: 10px;", # Changed top from 8px to 0px
      tags$li(strong("Cases:"), "Confirmed cases, imports, active, and recovered"),
      tags$li(strong("Tests:"), "RTK-Ag and RT-PCR test counts"),
      tags$li(strong("Deaths:"), "COVID-19 related deaths")
    ),
    p(style = "font-size: 12px; margin-top: 4px; margin-bottom: 10px; color: var(--bs-secondary-color, #718096);", # Optional: reduced top margin here too
      "Color intensity indicates severity - darker colors represent higher values."),
    
    # --- UPDATED LINKS SECTION (Buttons) ---
    h6("Resources", class = "text-uppercase", style = "margin-top: 16px !important; margin-bottom: 8px;"),
    
    tags$a(
      href = "https://github.com/MoH-Malaysia/covid19-public",
      target = "_blank",
      class = "link-card", # Uses the new CSS class
      bsicons::bs_icon("github"),
      span("Data Source: MoH-Malaysia")
    ),
    
    tags$a(
      href = "https://github.com/PravinRaj01/Covid-19-Interactive-Map-Malaysia-2022.git",
      target = "_blank",
      class = "link-card", # Uses the new CSS class
      bsicons::bs_icon("code-slash"),
      span("Project Repository")
    )
    
  ),
  
  bslib::navset_tab(
    id = "main_tabs",
    bslib::nav_panel(
      "Cases",
      div(style = "margin-top: 20px;",
        bslib::layout_columns(
          bslib::value_box(
            title = "Total New Cases",
            value = textOutput("total_cases", inline = TRUE),
            showcase = bsicons::bs_icon("exclamation-triangle"),
            class = "value-box-container"
          ),
          bslib::value_box(
            title = "Active Cases",
            value = textOutput("total_active", inline = TRUE),
            showcase = bsicons::bs_icon("arrow-up"),
            class = "value-box-container"
          ),
          bslib::value_box(
            title = "Recovered Cases",
            value = textOutput("total_recovered", inline = TRUE),
            showcase = bsicons::bs_icon("check-circle"),
            class = "value-box-container"
          ),
          col_widths = c(4, 4, 4)
        )
      ),
      div(class = "map-container", style = "margin-top: 20px;",
        leafletOutput("cases", height = "600px")
      )
    ),
    
    bslib::nav_panel(
      "Tests",
      div(style = "margin-top: 20px;",
        bslib::layout_columns(
        bslib::value_box(
          title = "Total RTK-Ag Tests",
          value = textOutput("total_rtk_ag", inline = TRUE),
          showcase = bsicons::bs_icon("clipboard"),
          class = "value-box-container"
        ),
        bslib::value_box(
          title = "Total RT-PCR Tests",
          value = textOutput("total_pcr", inline = TRUE),
          showcase = bsicons::bs_icon("clipboard-data"),
          class = "value-box-container"
        ),
        bslib::value_box(
          title = "Total Tests",
          value = textOutput("total_tests", inline = TRUE),
          showcase = bsicons::bs_icon("check-circle"),
          class = "value-box-container"
        ),
        col_widths = c(4, 4, 4)
        )
      ),
      div(class = "map-container", style = "margin-top: 20px;",
        leafletOutput("tests", height = "600px")
      )
    ),
    
    bslib::nav_panel(
      "Deaths",
      div(style = "margin-top: 20px;",
        bslib::layout_columns(
        bslib::value_box(
          title = "Total Deaths",
          value = textOutput("total_deaths", inline = TRUE),
          showcase = bsicons::bs_icon("x-circle"),
          class = "value-box-container"
        ),
        bslib::value_box(
          title = "States Affected",
          value = textOutput("states_with_deaths", inline = TRUE),
          showcase = bsicons::bs_icon("geo-alt"),
          class = "value-box-container"
        ),
        bslib::value_box(
          title = "Date",
          value = textOutput("selected_date_display_short", inline = TRUE),
          showcase = bsicons::bs_icon("calendar"),
          class = "value-box-container"
        ),
        col_widths = c(4, 4, 4)
        )
      ),
      div(class = "map-container", style = "margin-top: 20px;",
        leafletOutput("deaths", height = "600px")
      )
    )
  )
)