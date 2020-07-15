library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(ggplot2)
library(DT)

# reading in custom_theme
file_custom_theme <- file.path("data", "custom_theme")
custom_theme <- readRDS(file_custom_theme)
# complete df with top 5 most similar restaurants
file_sim <- file.path("data", "sim_rest_df_noadd")
sim_rest_df_noadd <- readRDS(file_sim)
# euclidean distances > 0 and < 0.15
file_euc <- file.path("data", "eucdistCount")
eucdistCount <- readRDS(file_euc)

### final design for app ###

ui <- dashboardPage(
    dashboardHeader(title = "Sales Forecasting Tool",
                    titleWidth = 235),
    
    # Sidebar content
    dashboardSidebar(sidebarMenu(id = "sidebarid",
                                 menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                                 menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                                 menuItem("Tools", tabname = "tools", icon = icon("toolbox"),
                                          menuSubItem("Restaurant Lookup", tabName = "restlookup", icon = icon("search")),
                                          menuSubItem("Similarity Tool", tabName = "simtool", icon = icon("sort-amount-up"))),
                                 conditionalPanel("input.sidebarid == 'dashboard'",
                                                  selectInput("city", label = "City:",
                                                              choices = c("Boston", "Portland", "Charleston", "New York City")),
                                                  actionButton(inputId = "reset_view", label = "Reset View")),
                                 conditionalPanel("input.sidebarid == 'restlookup'",
                                                  selectizeInput("restaurant", label = "Restaurant:", choices = eucdistCount$Restaurant,
                                                                 selected = NULL, multiple = TRUE, options = list(create = FALSE))),
                                 conditionalPanel("input.sidebarid == 'simtool'",
                                                  sliderInput("range", label = "Range:",
                                                              min = min(eucdistCount$Count), max = max(eucdistCount$Count),
                                                              value = c(min, max),
                                                              step = 1))
                     )),
    
    # Body content
    dashboardBody(custom_theme,
                  tags$head(tags$style(HTML('
                                            /* logo */
                                            .skin-blue .main-header .logo {
                                            color: #01244a;
                                            }'))),
                  tabItems(
                      tabItem(tabName = "dashboard",
                              fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 875)))),
                      tabItem(tabName = "appinfo",
                              h1("App Instructions"),
                              h2("Dashboard:"),
                              h3("Select a city from the 'City' drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map. Click on a marker to see information regarding the restaurant, including its 5 most similar restaurants."),
                              h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data."),
                              h2("Tools:"),
                              h3("Upon clicking the 'Tools' item, you will discover the two features listed below:"),
                              h2("Restaurant Lookup:"),
                              h3("Search for and select a restaurant using the 'Restaurant' input box to see the restaurants that are similar, as well as other information regarding the restaurant selected. You can search for multiple restaurants, and can delete a selected restaurant by clicking on it and pressing the backspace key."),
                              h3("Click on the arrows next to the column names to sort in alphabetical/numerical order."),
                              h2("Similarity Tool:"),
                              h3("Using the range slider, you can filter the available restaurants based on the number of restaurants they are similar to.")),
                      tabItem(tabName = "restlookup",
                              DT::dataTableOutput("distTable")),
                      tabItem(tabName = "simtool",
                              DT::dataTableOutput("similarityFeature"))
                  )))


server <- function(input, output){
    v <- reactiveValues()
    
    observeEvent(input$reset_view, {
        v$lng <- -75
        v$lat <- 38
        v$zoom <- 6
    })
    
    observeEvent(input$city, {
        v$lng <- if(input$city == "Boston") {
            -71.05
        } else if(input$city == "Portland") {
            -70.25
        } else if(input$city == "Charleston") {
            -79.92
        } else if(input$city == "New York City") {
            -73.87
        }
        
        v$lat <- if(input$city == "Boston") {
            42.35
        } else if(input$city == "Portland") {
            43.65
        } else if(input$city == "Charleston") {
            32.78
        } else if(input$city == "New York City") {
            40.81
        }
        
        v$zoom <- if(input$city == "Boston") {
            11
        } else if(input$city == "Portland") {
            11
        } else if(input$city == "Charleston") {
            11
        } else if(input$city == "New York City") {
            11
        }
    })
    
    output$mymap <- renderLeaflet({
        sim_rest_df_noadd %>%
            leaflet() %>%
            addTiles() %>%
            setView(v$lng, v$lat, v$zoom) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste("<b> Restaurant Name: </b>", sim_rest_df_noadd$Restaurant, "<br>",
                                     "<b> Type: </b>", sim_rest_df_noadd$Cuisine, "<br>",
                                     "<b> Address: </b>", sim_rest_df_noadd$Address, "<br>",
                                     "<b> Most Similar Restaurants: </b>", sim_rest_df_noadd$Similar_Restaurant))
    })
    
    restaurant <- reactive({
        distFilter <- eucdistCount[,-c(7:6)] %>% 
            rename(., "Similar Restaurants" = "Similar_Restaurant") %>% 
            rename(., "Number of Similar Restaurants" = "Count") %>% 
            select(., 1,5,4,6,2,3)
        
        if(!is.null(input$restaurant)){distFilter <- distFilter %>% filter(Restaurant %in% input$restaurant)}
        
        return(distFilter)
    })
    
    output$distTable <- DT::renderDataTable({
        restaurant()
    }
    
    )
    
    counter <- reactive({
        distCount <- eucdistCount[,1:3] %>% 
            rename(., "Similar Restaurants" = "Similar_Restaurant") %>% 
            rename(., "Number of Similar Restaurants" = "Count")
        
        if(!is.null(input$range)){distCount <- distCount %>% filter(`Number of Similar Restaurants` %in% input$range[1]:input$range[2])}
        
        return(distCount)
    })
    
    output$similarityFeature <- DT::renderDataTable({
        datatable(counter())
    })
    
}

shinyApp(ui = ui, server = server)
