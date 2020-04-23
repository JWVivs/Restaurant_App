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


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)



### Body contentbckup
dashboardBody(
    fluidRow(
        box(plotOutput("map")),
        
        box(
            "Box content here", br(), "More box content",
            selectInput("select", "Select a City:", c("Boston", "Portland", "Charleston"))
        )
    )
))
