library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)

# reading in custom_theme
custom_theme <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/appCode/custom_theme")

# complete_df_app has addresses needed for map (compatible with 6th deisgn for app)
complete_df_app <- readRDS("~/COLLEGE/GRAD SCHOOL/Capstone/Restaurant_App/data/processed/complete_df_app")

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
        complete_df_app %>%
            leaflet() %>%
            addTiles() %>%
            setView(v$lng, v$lat, v$zoom) %>%
            addMarkers(clusterOptions = markerClusterOptions(), 
                       popup = paste("<b> Restaurant Name: </b>", complete_df_app$Restaurant, "<br>",
                                     "<b> Type: </b>", complete_df_app$Cuisine, "<br>",
                                     "<b> Address: </b>", complete_df_app$Address, "<br>",
                                     "<b> Most Similar Restaurants: </b>"))
    })
    
    output$oyster <- renderImage({
        return(list(src = "./appCode/www/oyster.png", contentType = "image/png", height = "auto", width = "230px"))
    }, deleteFile = FALSE)
    
}

shinyApp(ui = ui, server = server)



