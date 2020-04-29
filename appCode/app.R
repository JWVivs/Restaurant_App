library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)

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
