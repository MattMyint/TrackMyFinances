## server.R ##
library(shiny)
library(shinydashboard)
library(RSQLite)

if(!file.exists("TmF.sqlite")){
  source("runonce/create_db.R", echo = TRUE)
}else{
  db <- dbConnect(RSQLite::SQLite(), "TmF.sqlite")
}

refresh_db <- function(){
  
}

server <- function(input, output, session) {
  reactives <- reactiveValues(choices = c("Overview", "Gross Income","Disposable Income", "Other Income", "Food",
                                          "Transport", "Groceries", "Shopping", "Entertainment", "Medical", 
                                          "Insurance", "Phone Bills", "Tithes", "Family", "Home Savings", 
                                          "Emergency", "General Savings"))
  #### dashboard main chart ####
  observeEvent(input$dash.left, {
    prev.cat <- grep(input$dash.select, reactives$choices) - 1
    if(prev.cat == 0){
      prev.cat <- length(reactives$choices)
    }
    updateSelectInput(session, 'dash.select', selected = reactives$choices[prev.cat])
  })
  
  observeEvent(input$dash.right, {
    next.cat <- grep(input$dash.select, reactives$choices) + 1
    if(next.cat == length(reactives$choices) + 1){
      next.cat <- 1
    }
    updateSelectInput(session, 'dash.select', selected = reactives$choices[next.cat])
  })
  
  output$dash.chart <- renderUI({
    if(input$dash.select == "Overview"){
      print(input$dash.select)
    }else{
      print("Indiv chart AND median amount AND median % of Gross income")
    }
  })
  
  output$gen.sav.total <- renderText({
    x <- as.numeric(dbGetQuery(db, "SELECT SUM(General_savings) FROM db"))
    min <- as.numeric(dbGetQuery(db, "SELECT AVG(Gross_in) FROM db"))
    ## code to set colour if savings are negative red, below avg income yellow, above green
    outTxt <- paste0("$", round(x, 2))
    outTxt
  })

  #### New entry modal ####
  output$entries <- renderUI({
    lapply(2:length(reactives$choices), function(i){
      numericInput(inputId = make.names(reactives$choices[i]), value = 0, label = reactives$choices[i], min = 0)
    })
  })
  
  observeEvent(input$add.entry, {
    showModal(modalDialog(
      title = "New Entry",
      dateInput(inputId = "date", label = "For month:", value = Sys.Date(), format = "MM yyyy", startview = "year"),
      uiOutput("entries"),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("ok", "OK")
      )
    ))
  })
  
  #### storing new inputs ####
  observeEvent(input$ok, {
    ## TO DO: logic to check whether number tallies up, and if not, to save adjustments under general savings
    # format.Date() for converting dates and chr strings
    print(input$date)
    sql.headers <- c("Date", "Gross_in","Disposable_In", "Other_in", "Food", "Transport", "Groceries", "Shopping",
                     "Entertainment", "Medical", "Insurance", "PhoneBill", "Tithes", "Family", "Home_savings",
                     "Emergency", "General_savings")
    dbSendQuery(db, 
                paste0('INSERT INTO db VALUES("', input$date, '", "', input$Gross.Income, '", "', input$Disposable.Income,
                       '", "', input$Other.Income, '", "', input$Food, '", "', input$Transport, '", "', input$Groceries, 
                       '", "', input$Shopping, '", "', input$Entertainment, '", "', input$Medical, '", "', input$Insurance, 
                       '", "', input$Phone.Bills, '", "', input$Tithes, '", "', input$Family, '", "', input$Home.Savings, 
                       '", "', input$Emergency, '", "', input$General.Savings, '")')
                )
    removeModal()
    
  })
  
  #### End session ####
  ## Close connection once session is done
  session$onSessionEnded(function(){
    dbDisconnect(db)
  })
}