library(shiny)
library(leaflet)
library(readr)
library(shinythemes)

d <- read_csv("data-for-shiny.csv")

ui <- fluidPage(theme = shinytheme("paper"),
  h2("U.S. School Districts' Responses to COVID-19"),
  p("This map represents an attempt to document U.S. school districts' responses to the COVID-19 pandemic"),
  tags$hr(),
  leafletOutput("map", width = "60%"),
  tags$hr(),
  p(),
  p("All of the data used is available for use and re-use on ", 
    tags$a(href="https://github.com/making-data-science-count/covidapp", "GitHub")
    ),
  p(),
  p("This map is based upon programatically accessing the websites for 15,262 U.S. school districts, 14,093 (92.3%) for which we were able to identify a website. 
    Of those 14,093 districts, 11,172 (79.2%) contained links to pages or attachments that mentioned COVID-19, coronavirus, or a closure; 
    10,025 (67.1%) contained links that mentioned only COVID-19 or coronavirus. 
    Those links (28,085 in total, to COVID-19-related webpages and attachments, primarily PDFs) are also available from GitHub."),
  p("Made by the ",
    tags$a(href="https://makingdatasciencecount.com", "Making Data Science Count Research Group"),
    " at the ",
    tags$a(href="https://utk.edu", "University of Tennessee, Knoxville"),
    " with ",
    tags$a(href="https://rutherfordlab.wordpress.com/", "Teomara (Teya) Rutherford"),
    ", ",
    tags$a(href="https://www.datalorax.com/", "Daniel Anderson"),
    "and ",
    tags$a(href="https://ha-nguyen.net/", "Ha Nguyen")),
  tags$a(
    href="https://makingdatasciencecount.com", 
    tags$img(src="mdsc-logo.png", 
             width="15%",
             height="15%")
  )
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>% 
      setView(-97, 39, zoom = 4) %>% 
      addCircleMarkers(data = d,
                       radius = .25,
                       fillOpacity = .25,
                       #layerId = ~ncessch,
                       lng = ~longitude_district_2017_18,
                       lat = ~latitude_district_2017_18,
                       label = ~lapply(district, htmltools::HTML),
                       popup = ~lapply(text_to_display, htmltools::HTML),
                       labelOptions = labelOptions(style = list(
                         "color" = "black",
                         "font-size" = "13px"
                       )))
  })
}

shinyApp(ui, server)