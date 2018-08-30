## ui.R ##
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Our Financial Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Savings", tabName = "savings", icon = icon("money")),
      menuItem("Housing", tabName = "housing", icon = icon("building")),
      menuItem("Investments", tabName = "invest", icon = icon("university"))
    )
  ),
  ## Body content
  dashboardBody(
    tabItems(
      # Overview tab
      tabItem(tabName = "dashboard",
              fluidRow(
                box(plotOutput("plot1", height = 250)),
                
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      ),
      
      # Savings tab
      tabItem(tabName = "savings",
              h2("Savings")
      ),
      
      # Housing tab
      tabItem(tabName = "housing",
              h2("Housing")
      ),
      
      # Investment tab
      tabItem(tabName = "invest",
              h2("Investments")
      )
    )
  )
)