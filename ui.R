## ui.R ##
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Our Financial Dashboard", tags$li(class = "dropdown", actionButton('add.entry', label = "New Entry", icon = icon("plus-square")))
                  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Overview", tabName = "dashboard", icon = icon("dashboard")),
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
                box(width = 7,
                    fluidRow(
                      column(4, align = 'right',
                             actionButton('dash.left', label = NULL, icon = icon("arrow-left"))
                             ),
                      column(4,
                             selectInput(inputId = 'dash.select',
                                         label = NULL,
                                         width = '100%',
                                         choices = c("Overview", "Gross Income", "Other Allowances", "Disposable income",
                                                     "Food", "Groceries", "Transport", "Shopping", "Entertainment",
                                                     "Medical", "Insurance", "Phone Bills", "Tithes", "Family",
                                                     "Home Savings", "Emergency Fund", "General Savings")
                             )
                      ),
                      column(4, align = 'left',
                             actionButton('dash.right', label = NULL, icon = icon("arrow-right"))
                      )
                    ),
                    uiOutput('dash.chart')),
                box(width = 5, title = "Housing Fund")
              ),
              fluidRow(
                box(width = 4, title = "General Savings",
                    textOutput("gen.sav.total"),
                    textOutput("avg.gs.monthly")),
                box(width = 4, title = "Investments"),
                box(width = 4, title = "Emergency Fund")
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