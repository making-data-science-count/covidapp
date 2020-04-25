library(shiny)
library(leaflet)
library(readr)
library(shinythemes)

d <- read_csv("data-for-shiny.csv")

d$label <- paste(
  "NCES School ID: <a href =",
  "'https://nces.ed.gov/ccd/schoolsearch/school_list.asp?Search=1&InstName=&SchoolID=", 
  d$nces_id, "'>", d$nces_id, "</a>", "<br/>",
  "District:", 
  "<a href =", "'", d$url, "'>", d$agency_name_district_2017_18,  
  "</a>"
) 


ui <- fluidPage(
  #theme = shinytheme("paper"),
  h2("U.S. School Districts' Responses to COVID-19"),
  tabsetPanel(id = "tabs", 
    tabPanel("Map",
      h5("Click on a point (district) to get a link to the corresponding district website and NCES record."),
      div(class = "outer",
        tags$style(type = "text/css", 
                         ".outer { 
                            position: fixed; 
                            top: 150px; 
                            left: 0; 
                            right: 0; 
                            bottom: 0px; 
                            overflow: hidden; 
                            padding: 0
                          }"),
        leafletOutput("map", width = "100%", height = "100%")
      )
    ),
    tabPanel("About",
      p("This map represents an attempt to document U.S. school districts' responses to the COVID-19 pandemic"),
      p("All of the data used is available for use and re-use on ",
        tags$a(href="https://github.com/making-data-science-count/covidapp", 
               "GitHub")
        ),
      p(),
      p("This map is based upon programatically accessing the websites for 15,262 U.S. school districts, 14,093 (92.3%) for which we were able to identify a website. 
    Of those 14,093 districts, 11,172 (79.2%) contained links to pages or attachments that mentioned COVID-19, coronavirus, or a closure; 
    10,025 (67.1%) contained links that mentioned only COVID-19 or coronavirus. 
    Those links (28,085 in total, to COVID-19-related webpages and attachments, primarily PDFs) are also available from GitHub."),
      p("Made by ",
        tags$a(href="https://joshuamrosenberg.com", "Joshua Rosenberg"),
        " and ",
        tags$a(href="http://www.alexlishinski.com/", "Alex Lishinski"),
        " in the ",
        tags$a(href="https://makingdatasciencecount.com", "Making Data Science Count Research Group"),
        " at the ",
        tags$a(href="https://utk.edu", "University of Tennessee, Knoxville"),
        " with contributions from ",
        tags$a(href="https://rutherfordlab.wordpress.com/", "Teomara (Teya) Rutherford"),
        ", ",
        tags$a(href="https://www.datalorax.com/", "Daniel Anderson"),
        ", ",
        tags$a(href="https://ha-nguyen.net/", "Ha Nguyen"),
        " and ", 
        tags$a(href="https://www.linkedin.com/in/aaron-rosenberg-68b55151", "Aaron Rosenberg")
      ),
      tags$a(href="https://makingdatasciencecount.com", 
        tags$img(src="mdsc-logo.png", 
                 width="15%",
                 height="15%")
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles("CartoDB.Positron") %>% 
      leafem::addLogo(img = "mdsc-logo.png",
                      position = "bottomleft",
                      width = 100,
                      offset.x = 13) %>%
      setView(-97, 39, zoom = 4) %>% 
      addCircleMarkers(data = d,
                       radius = .1,
                       fillOpacity = .1,
                       stroke = FALSE,
                       #layerId = ~ncessch,
                       lng = ~longitude_district_2017_18,
                       lat = ~latitude_district_2017_18,
                       label = ~lapply(label, htmltools::HTML),
                           popup = ~lapply(label, htmltools::HTML),
                           labelOptions = labelOptions(
                             textOnly = FALSE,
                             style = list(
                               'background'='rgba(255,255,255,0.95)',
                               'border-color' = 'rgba(95, 106, 106, .8)',
                               'border-radius' = '2px',
                               'border-style' = 'solid',
                               'border-width' = '2px')
                            )
      )
  })
}

shinyApp(ui, server)