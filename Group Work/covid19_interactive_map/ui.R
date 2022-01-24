library(shiny)
library(tidyverse)
library(leaflet)
library(htmlwidgets)

setwd("C:/Users/Meghashyaam's PC/Documents/University Malaya/sem 1/intro to DS/Group Work")
getwd()
covidmap <- readRDS("covidmap.RDS")

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Interactive Map on Covid-19 spread in Malaysia in 2022"),
  
  
  sidebarLayout(
    sidebarPanel(
      
      # Sidebar panel with a select Input to choose a specific date
      
      h5("Select a date to view the spread of covid-19 cases in Malaysia by state on that specific date"),
      h5("This Interactive Maps App has 3 different Maps:"),
      h5("A) Cases"),
      h5("B) Tests"),
      h5("C) Deaths"),
      h5("The 'Cases' tab displays a Map that shows the number of the confirmed cases for each state in Malaysia on the choosen date."),
      h5("The 'Tests' tab displays a Map that shows the number of covid-19 testings for each state in Malaysia on the choosen date."),
      h5("The 'Deaths' tab displays a Map that shows the number of covid-19 confirmed deathsfor each state in Malaysia on the choosen date."),
      h5("In Each of the maps, the colour intensity reflects the severity of the observed parameter. The greater the intensity of the colour of the map, the more greater the value of the measured paramter."),
      selectInput("date","Select a date:", choices = unique(covidmap$date)),
      tags$a(href="https://github.com/MoH-Malaysia/covid19-public" ,"Source" , target="_blank"),
      h5(" "),
      tags$a(href="https://github.com/MoH-Malaysia/covid19-public" ,"Github" , target="_blank")
    ),
    
    # Display the interactive map based on the tabs labelled
    mainPanel(
      tabsetPanel(
        tabPanel("Cases", leafletOutput("cases")),
        tabPanel("Tests", leafletOutput("tests")),
        tabPanel("Deaths", leafletOutput("deaths"))
      )
    )
  )
)

