# Professional UI for COVID-19 Interactive Map
# Using all_mapdata from global.R for date choices

# Custom CSS for professional, classy UI
custom_css <- tags$head(
  tags$style(HTML("
    /* Professional Classy UI Styles */
    body {
      font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, 'Helvetica Neue', Arial, sans-serif;
      background: #f5f7fa;
      min-height: 100vh;
      color: #2d3748;
    }
    
    .main-header {
      background: #ffffff;
      border-radius: 8px;
      padding: 16px 20px;
      margin-bottom: 12px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      border-bottom: 3px solid #2c5282;
    }
    
    .main-header h1 {
      color: #1a202c;
      font-weight: 600;
      font-size: 26px;
      margin: 0;
      letter-spacing: -0.5px;
    }
    
    .main-header .subtitle {
      color: #718096;
      font-size: 14px;
      margin-top: 6px;
      font-weight: 400;
    }
    
    .sidebar-panel {
      background: #ffffff;
      border-radius: 8px;
      padding: 16px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      height: fit-content;
    }
    
    .control-card {
      background: #f7fafc;
      border-radius: 6px;
      padding: 20px;
      margin-bottom: 20px;
      border: 1px solid #e2e8f0;
    }
    
    .control-card h4 {
      color: #2d3748;
      font-weight: 600;
      font-size: 14px;
      margin-top: 0;
      margin-bottom: 16px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 12px;
      color: #4a5568;
    }
    
    .date-input-wrapper {
      margin-bottom: 12px;
    }
    
    .date-input-wrapper .form-group {
      margin-bottom: 0;
    }
    
    .date-input-wrapper input {
      border: 1px solid #cbd5e0;
      border-radius: 4px;
      padding: 8px 12px;
      font-size: 14px;
      width: 100%;
      transition: border-color 0.2s;
    }
    
    .date-input-wrapper input:focus {
      border-color: #2c5282;
      outline: none;
      box-shadow: 0 0 0 3px rgba(44, 82, 130, 0.1);
    }
    
    .selected-date-display {
      background: #edf2f7;
      padding: 10px 12px;
      border-radius: 4px;
      font-size: 13px;
      color: #2d3748;
      margin-top: 12px;
      border-left: 3px solid #2c5282;
    }
    
    .selected-date-display .label {
      color: #718096;
      font-size: 11px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 4px;
    }
    
    .selected-date-display .value {
      color: #1a202c;
      font-weight: 500;
    }
    
    .data-range-info {
      font-size: 11px;
      color: #718096;
      margin-top: 8px;
    }
    
    .btn-refresh {
      background: #2c5282;
      color: white;
      border: none;
      border-radius: 6px;
      padding: 10px 16px;
      font-weight: 500;
      font-size: 14px;
      width: 100%;
      transition: all 0.2s ease;
      cursor: pointer;
    }
    
    .btn-refresh:hover {
      background: #2a4365;
      transform: translateY(-1px);
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    
    .btn-refresh:active {
      transform: translateY(0);
    }
    
    .data-source-info {
      background: #edf2f7;
      color: #4a5568;
      padding: 10px 12px;
      border-radius: 4px;
      font-size: 12px;
      text-align: center;
      margin-top: 16px;
      border-left: 3px solid #2c5282;
    }
    
    .info-card {
      background: #f7fafc;
      border-radius: 6px;
      padding: 16px;
      margin-bottom: 16px;
      border-left: 3px solid #2c5282;
    }
    
    .info-card h5 {
      color: #2d3748;
      font-weight: 600;
      font-size: 13px;
      margin: 0 0 12px 0;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-size: 11px;
      color: #4a5568;
    }
    
    .info-card ul {
      margin: 8px 0;
      padding-left: 20px;
    }
    
    .info-card li {
      color: #4a5568;
      font-size: 13px;
      margin: 6px 0;
      line-height: 1.5;
    }
    
    .info-card p {
      color: #4a5568;
      font-size: 12px;
      margin: 8px 0;
      line-height: 1.6;
    }
    
    .link-section {
      margin-top: 24px;
      padding-top: 20px;
      border-top: 1px solid #e2e8f0;
    }
    
    .link-section a {
      color: #2c5282;
      text-decoration: none;
      font-size: 13px;
      display: block;
      margin: 8px 0;
      transition: color 0.2s ease;
    }
    
    .link-section a:hover {
      color: #2a4365;
      text-decoration: underline;
    }
    
    .link-section .note {
      font-size: 11px;
      color: #a0aec0;
      margin-top: 12px;
      font-style: italic;
    }
    
    .main-panel {
      background: #ffffff;
      border-radius: 8px;
      padding: 16px;
      box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
      min-height: 0;
    }
    
    .nav-tabs {
      border-bottom: 2px solid #e2e8f0;
      margin-bottom: 20px;
    }
    
    .nav-tabs > li > a {
      color: #718096;
      font-weight: 500;
      border-radius: 0;
      margin-right: 0;
      padding: 12px 24px;
      border: none;
      border-bottom: 2px solid transparent;
      transition: all 0.2s ease;
    }
    
    .nav-tabs > li > a:hover {
      background: transparent;
      border-color: transparent;
      color: #2c5282;
      border-bottom-color: #cbd5e0;
    }
    
    .nav-tabs > li.active > a {
      background: transparent;
      color: #2c5282;
      border-color: transparent;
      border-bottom-color: #2c5282;
      font-weight: 600;
    }
    
    #cases, #tests, #deaths {
      border-radius: 4px;
      overflow: hidden;
      border: 1px solid #e2e8f0;
    }
    
    .shiny-notification {
      background: #ffffff;
      border-radius: 6px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      border-left: 4px solid #2c5282;
    }
  "))
)

# Define UI for application
ui <- fluidPage(
  theme = bslib::bs_theme(),  # enable bslib theming (required for dark mode)
  custom_css,
  
  # Professional Header with light/dark mode toggle
  div(class = "main-header",
      div(style = "display: flex; align-items: center; justify-content: space-between; gap: 16px;",
          div(
            h1("COVID-19 Interactive Map - Malaysia"),
            div(class = "subtitle", "Track the spread of COVID-19 across Malaysian states (2020-2025)")
          ),
          # Dark mode toggle (bslib 0.6.0+ / shiny 1.8.0+)
          bslib::input_dark_mode(id = "theme_mode")
      )
  ),
  
  sidebarLayout(
    sidebarPanel(
      class = "sidebar-panel",
      width = 3,
      
      # Date Selection Card
      div(class = "control-card",
        h4("Date Selection"),
        div(class = "date-input-wrapper",
          dateInput(
            "date",
            label = NULL,
            value = {
              # Set default to latest available date from all_mapdata
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
          )
        ),
        div(class = "selected-date-display",
          div(class = "label", "Selected Date"),
          div(class = "value", textOutput("selected_date_display", inline = TRUE))
        ),
        div(class = "data-range-info",
          textOutput("data_range_info", inline = TRUE)
        )
      ),
      
      # Refresh Button
      actionButton(
        "refresh_data",
        "Refresh Data from API",
        class = "btn-refresh"
      ),
      
      # Data Source Info
      div(class = "data-source-info",
        textOutput("data_source_info")
      ),
      
      # Information Card
      div(class = "info-card",
        h5("About This Application"),
        tags$ul(
          tags$li(strong("Cases:"), "Confirmed cases, imports, active, and recovered cases"),
          tags$li(strong("Tests:"), "RTK-Ag and RT-PCR test counts by state"),
          tags$li(strong("Deaths:"), "COVID-19 related deaths by state")
        ),
        p(style = "margin-top: 12px;",
          "Color intensity indicates severity - darker colors represent higher values.")
      ),
      
      # Links Section
      div(class = "link-section",
        tags$a(
          href = "https://github.com/MoH-Malaysia/covid19-public",
          target = "_blank",
          "Data Source: MoH-Malaysia GitHub"
        ),
        tags$a(
          href = "https://github.com/PravinRaj01/Covid-19-Interactive-Map-Malaysia-2022.git",
          target = "_blank",
          "Project Repository"
        ),
        p(class = "note",
          "Note: Data available until May 2025")
      )
    ),
    
      # Main Panel with Tabs
      mainPanel(
        class = "main-panel",
        width = 9,
        tabsetPanel(
          id = "main_tabs",
          type = "tabs",
        tabPanel(
          "Cases",
          leafletOutput("cases", height = "640px")
        ),
        tabPanel(
          "Tests",
          leafletOutput("tests", height = "640px")
        ),
        tabPanel(
          "Deaths",
          leafletOutput("deaths", height = "640px")
        )
        )
      )
  )
)
