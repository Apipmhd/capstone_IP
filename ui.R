library(shinydashboard)
library(shiny)

total_reviews <- sum(duplicated(lazada$totalReviews))
total_category <- sum(!duplicated(lazada$category))
dashboardPage(
  skin = "yellow",
  dashboardHeader(title = span("Lazada reviews")),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "overview", icon = icon("video")),
      menuItem("Trending Review", tabName = "trending", icon = icon("signal")),
      menuItem("Lazada Item", tabName = "data", icon = icon("table"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(
        tabName = "overview",
        fluidRow(
          infoBox("Categories",
                  icon = icon("video"),
                  value = total_category,
                  color = "yellow"),
          infoBox("Brand",
                  icon = icon("bold"),
                  value = length(unique(lazada$brandName)),
                  color = "blue"),
          infoBox("Total review",
                  icon = icon("plus"),
                  value=total_reviews,
                  color = "orange")
        ),
        fluidRow(
          box(
            width = 12,
            plotlyOutput("plot1")
          ),
          box(
            width = 12,
            plotlyOutput("plot2")
          ),
          box(
            width = 12,
            plotlyOutput("plot3")
          )
        )
      ),
      tabItem(
        tabName = "trending",
        fluidRow(
          box(
            width = 12,
            selectInput(
              inputId = "select_category", 
              label = "Choose Video Category",
              choices = unique(lazada$brandName)
            )
          )
        ),
        fluidRow(
          box(
            width = 12,
            plotlyOutput("plot4")
          )
        )
      ),
      # ---- Halaman 1 ----
      tabItem(
        tabName = "data",
        
        fluidRow(
          box(
            title = "Dataset Item Lazada 2019",
            width = 12,
            dataTableOutput("table_lazada")
          )
        )
      )
    )
  )
)