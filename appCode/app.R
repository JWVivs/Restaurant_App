library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(ggplot2)
library(tableHTML)

# reading in custom_theme
custom_theme <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/appCode/custom_theme")

# features everything complete_df_app has plus the similar restaurants
sim_rest_df <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/sim_rest_df")
# same as above, but includes NYC restaurants
sim_rest_df_nyc <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/sim_rest_df_nyc")
# unlike above, we now have no duplicated restaurants in the Similar_Restaurants column (i.e. franchises with same menu)
# this is the final, and complete df required going forward
sim_rest_df_noadd <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/sim_rest_df_noadd")

# euclidean distances > 0 and < 0.15
eucdistCount <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/eucdistCount")

# complete_df_app has addresses needed for map (compatible with 6th deisgn for app)
complete_df_app <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/complete_df_app")
# NYC restaurants added
complete_df_nyc_app2 <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/complete_df_nyc_app2")

# boston_add contains the coordinates
boston_add <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/boston_addresses.csv")
# df_boston has the restaurant names and cuisine
df_boston <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/df_boston.csv")
# menu data
boston_final <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/boston_final.csv")

# portland_add contains the coordinates
portland_add <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/portland_addresses.csv")
# df_portland has the restaurant names and cuisine
df_portland <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/df_portland.csv")
# menu data
portland_final <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/portland_final.csv")

# charleston_add contains the coordinates
charleston_add <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/charleston_addresses.csv")
# df_charleston has the restaurant names and cuisine
df_charleston <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/raw/df_charleston.csv")
# menu data
charleston_final <- read.csv("C:/Users/JVivs/Documents/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/charleston_final.csv")

# binding df_boston and df_portland (contains restaurant info)
df_combined <- rbind(df_boston, df_portland)

# reading in restaurant info
df_3 <- read.csv("./data/processed/df_3.csv")
# reading in the coordinate data
df_3_coord <- read.csv("./data/processed/df_3_coord.csv")

### 1st design for app ###

# Define UI for application that draws a histogram
ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "Dashboard"),
                    # Sidebar content
                    dashboardSidebar(
                        sidebarMenu(
                            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                            menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                            selectInput("city", "City:",
                                        c("Boston" = "boston",
                                          "Portland" = "portland",
                                          "Charleston" = "charleston"))
                        )
                    ),
                    # Body content
                    dashboardBody(
                        tabItems(
                            # First tab content
                            tabItem(tabName = "dashboard",
                                    fluidRow(
                                        box(plotOutput("map", height = 700)),
                                     
                                    )),
                            tabItem(tabName = "appinfo",
                                    h2("App Instructions"),
                                    h3("Select a city from the drop down menu, and a map will be generated featuring restaurants in the surrounding area."))
                        )
                    ))
                    
                    

# Preview the UI in the console
shinyApp(ui = ui, server = function(input, output) { })

##########################

### 2nd design for app ###

ui <- dashboardPage(
    skin = "red",
    dashboardHeader(title = "Restaurant App"),
    
    # Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
        selectInput("city", label = "City",
                    choices = df_3_coord$City)
    )),
    
    # Body content
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboard",
                    fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 875)))),
            tabItem(tabName = "appinfo",
                    h2("App Instructions"),
                    h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area."))
    )))

server <- function(input, output) {
    react <- reactive({
        req(input$city)
        df <- df_3_coord[df_3_coord$City == input$city]
        df
    })
    
    output$mymap<- renderLeaflet({
        req(input$city)
        
        validate(need(df_3_coord, "Coordinate data"))
        validate(need(df_3_coord$City, "Select City"))
        df_3_coord %>%
            leaflet() %>%
            addTiles() %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste(df_3$Restaurant, "<br>",
                                     df_3$Cuisine, "<br>",
                                     df_3$Address))
    })
}

shinyApp(ui = ui, server = server)

##########################

### 3rd design for app ###

ui <- dashboardPage(
    skin = "red",
    dashboardHeader(title = "Restaurant App"),
    
    # Sidebar content
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
            selectInput("city", label = "City",
                        choices = c("Boston", "Portland", "Charleston")),
            actionButton(inputId = "reset_view", label = "Reset View")
        )),
    
    # Body content
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboard",
                    fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 875)))),
            tabItem(tabName = "appinfo",
                    h1("App Instructions"),
                    h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                    h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data (IN PROGRESS)."))
        )))

server <- function(input, output) {
    react <- reactive({
        
        req(input$city)
        df <- df_3_coord[df_3_coord$City == input$city]
        df
        
    })
    
    output$mymap <- renderLeaflet({
        req(input$city)
        
        lng <- if(input$city == "Boston") {
            -71.05
        } else if(input$city == "Portland") {
            -70.25
        } else if(input$city == "Charleston") {
            -79.92
        }
        
        lat <- if(input$city == "Boston") {
            42.35
        } else if(input$city == "Portland") {
            43.65
        } else if(input$city == "Charleston") {
            32.78
        }
        
        df_3_coord %>%
            leaflet() %>%
            addTiles() %>%
            setView(lng, lat, zoom = 11) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste(df_3$Restaurant, "<br>",
                                     df_3$Cuisine, "<br>",
                                     df_3$Address))
    })
    
}

shinyApp(ui = ui, server = server)

##########################

### 4th design for app ###

ui <- dashboardPage(
    skin = "red",
    dashboardHeader(title = "Restaurant App"),
    
    # Sidebar content
    dashboardSidebar(width = "300px", HTML("<br><center>"), img(src = "oyster.png", width = "300px", align = "middle"), HTML("</center><br>"),
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
            selectInput("city", label = "City",
                        choices = c("Boston", "Portland", "Charleston")),
            actionButton(inputId = "reset_view", label = "Reset View")
        )),
    
    # Body content
    dashboardBody(
        tabItems(
            tabItem(tabName = "dashboard",
                    fluidRow(box(width = 12, leafletOutput(outputId = "mymap", height = 875)))),
            tabItem(tabName = "appinfo",
                    h1("App Instructions"),
                    h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                    h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data (IN PROGRESS)."))
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
        }
        
        v$lat <- if(input$city == "Boston") {
            42.35
        } else if(input$city == "Portland") {
            43.65
        } else if(input$city == "Charleston") {
            32.78
        }
        
        v$zoom <- if(input$city == "Boston") {
            11
        } else if(input$city == "Portland") {
            11
        } else if(input$city == "Charleston") {
            11
        }
    })
    
    output$mymap <- renderLeaflet({
        df_3_coord %>%
            leaflet() %>%
            addTiles() %>%
            setView(v$lng, v$lat, v$zoom) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste(df_3$Restaurant, "<br>",
                                     df_3$Cuisine, "<br>",
                                     df_3$Address))
    })
    
    
}

shinyApp(ui = ui, server = server)


##########################

### 5th design for app ###

ui <- dashboardPage(
    dashboardHeader(title = "Sales Forecasting Tool",
                    titleWidth = 235),
    
    # Sidebar content
    dashboardSidebar(imageOutput("oyster", height = "auto"),
                     sidebarMenu(
                         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                         menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                         selectInput("city", label = "City",
                                     choices = c("Boston", "Portland", "Charleston")),
                         actionButton(inputId = "reset_view", label = "Reset View")
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
                    h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                    h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data."))
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
        }
        
        v$lat <- if(input$city == "Boston") {
            42.35
        } else if(input$city == "Portland") {
            43.65
        } else if(input$city == "Charleston") {
            32.78
        }
        
        v$zoom <- if(input$city == "Boston") {
            11
        } else if(input$city == "Portland") {
            11
        } else if(input$city == "Charleston") {
            11
        }
    })
    
    output$mymap <- renderLeaflet({
        df_3_coord %>%
            leaflet() %>%
            addTiles() %>%
            setView(v$lng, v$lat, v$zoom) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste(df_3$Restaurant, "<br>",
                                     df_3$Cuisine, "<br>",
                                     df_3$Address))
    })
    
    output$oyster <- renderImage({
        return(list(src = "./appCode/www/oyster.png", contentType = "image/png", height = "auto", width = "230px"))
    }, deleteFile = FALSE)
    
}

shinyApp(ui = ui, server = server)

###############################

### 6th design for app ### removing 7 restaurants w/o menu data ### updated address for Captain Marden's Seafood ###

ui <- dashboardPage(
    dashboardHeader(title = "Sales Forecasting Tool",
                    titleWidth = 235),
    
    # Sidebar content
    dashboardSidebar(imageOutput("oyster", height = "auto"),
                     sidebarMenu(
                         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                         menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                         selectInput("city", label = "City",
                                     choices = c("Boston", "Portland", "Charleston")),
                         actionButton(inputId = "reset_view", label = "Reset View")
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
                              h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                              h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data."))
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
        }
        
        v$lat <- if(input$city == "Boston") {
            42.35
        } else if(input$city == "Portland") {
            43.65
        } else if(input$city == "Charleston") {
            32.78
        }
        
        v$zoom <- if(input$city == "Boston") {
            11
        } else if(input$city == "Portland") {
            11
        } else if(input$city == "Charleston") {
            11
        }
    })
    
    output$mymap <- renderLeaflet({
        sim_rest_df %>%
            leaflet() %>%
            addTiles() %>%
            setView(v$lng, v$lat, v$zoom) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste("<b> Restaurant Name: </b>", sim_rest_df$Restaurant, "<br>",
                                     "<b> Type: </b>", sim_rest_df$Cuisine, "<br>",
                                     "<b> Address: </b>", sim_rest_df$Address, "<br>",
                                     "<b> Most Similar Restaurants: </b>", sim_rest_df$Similar_Restaurant))
    })
    
    output$oyster <- renderImage({
        return(list(src = "./appCode/www/oyster.png", contentType = "image/png", height = "auto", width = "230px"))
    }, deleteFile = FALSE)
    
}

shinyApp(ui = ui, server = server)

##########################

### 7th design for app ### features NYC restaurants ### no more repeated franchises for "Most Similar Restaurants" info

ui <- dashboardPage(
    dashboardHeader(title = "Sales Forecasting Tool",
                    titleWidth = 235),
    
    # Sidebar content
    dashboardSidebar(imageOutput("oyster", height = "auto"),
                     sidebarMenu(
                         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                         menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                         selectInput("city", label = "City",
                                     choices = c("Boston", "Portland", "Charleston", "New York City")),
                         actionButton(inputId = "reset_view", label = "Reset View")
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
                              h3("Select a city from the drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                              h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data."))
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
    
    output$oyster <- renderImage({
        return(list(src = "./appCode/www/oyster.png", contentType = "image/png", height = "auto", width = "230px"))
    }, deleteFile = FALSE)
    
}

shinyApp(ui = ui, server = server)

##########################

### 8th design for app ### 

ui <- dashboardPage(
    dashboardHeader(title = "Sales Forecasting Tool",
                    titleWidth = 235),
    
    # Sidebar content
    dashboardSidebar(imageOutput("oyster", height = "auto"),
                     sidebarMenu(
                         menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                         menuItem("App Info", tabName = "appinfo", icon = icon("info-circle")),
                         menuItem("Restaurant Lookup", tabName = "restlookup", icon = icon("search")),
                         menuItem("Similarity Tool", tabName = "simtool", icon = icon("sort-amount-up")),
                         selectInput("city", label = "City",
                                     choices = c("Boston", "Portland", "Charleston", "New York City")),
                         actionButton(inputId = "reset_view", label = "Reset View"),
                         selectizeInput("restaurant", label = "Restaurant", choices = eucdistCount$Restaurant,
                                        selected = NULL, multiple = TRUE, options = list(create = FALSE)),
                         sliderInput("range", label = "Range:",
                                     min = min(eucdistCount$Count), max = max(eucdistCount$Count),
                                     value = c(min, max),
                                     step = 1)
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
                              h3("Select a city from the 'City' drop down menu, and you will be provided with restaurants in the surrounding area. You can zoom in by double-clicking, scrolling, or using the zoom panel in the top-left corner of the map."),
                              h3("The 'Reset View' button will zoom out and allow you to see the entirety of the data."),
                              h2("Restaurant Lookup:"),
                              h3("Search for and select a restaurant using the 'Restaurant' input box to see the restaurants that are similar. The number of restaurants it is similar to can be found in the 'Count' column. You can search for multiple restaurants, and can delete a selected restaurant by clicking on it and pressing the 'backspace' button."),
                              h3("Click on the arrows next to the column names to sort in alphabetical/numerical order."),
                              h2("Similarity Tool:"),
                              h3("Using the range slider, you can filter the available restaurants based on the number of restaurants they are similar to (the 'Count' column). The 'Count' column is color-coded, whereby the color red indicates a lower number of similar restaurants, and the color green indicates a higher number of similar restaurants.")),
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
        distFilter <- eucdistCount
        
        if(!is.null(input$restaurant)){distFilter <- distFilter %>% filter(Restaurant %in% input$restaurant)}
        
        return(distFilter)
    })
    
    output$distTable <- DT::renderDataTable({
        restaurant()
    }
        
    )
    
    counter <- reactive({
        distCount <- eucdistCount[,1:3]
        
        if(!is.null(input$range)){distCount <- distCount %>% filter(Count %in% input$range[1]:input$range[2])}
        
        return(distCount)
    })
    
    output$similarityFeature <- DT::renderDataTable({
        datatable(counter()) %>% 
            formatStyle("Count",
                        backgroundColor = styleInterval(c(5, 13, 22, max(eucdistCount$Count)), c("#FF0000", "#FFC200", "#CAFF00", "#33FF00", "#F500FF")))
    })
    
    output$oyster <- renderImage({
        return(list(src = "./appCode/www/oyster.png", contentType = "image/png", height = "auto", width = "230px"))
    }, deleteFile = FALSE)
    
}

shinyApp(ui = ui, server = server)

