sql.headers <- c("Date", "Gross_in","Disposable_In", "Other_in", "Food", "Transport", "Groceries", "Shopping",
                 "Entertainment", "Medical", "Insurance", "PhoneBill", "Tithes", "Family", "Home_savings",
                 "Emergency", "General_savings")

## Get data for one category
get_column <- function(var){
  print(var)
  var_db <- dbGetQuery(db, paste0("SELECT strftime('%Y', Date) AS year, strftime('%m', Date) AS month, SUM(", var, ") AS var FROM db GROUP BY year, month"))
  return(var_db)
}
var_db <- dbGetQuery(db, paste0("SELECT strftime('%Y', Date) AS year, strftime('%m', Date) AS month, SUM(", var, ") AS var, FROM db GROUP BY year, month"))

## Get summarised data
dbGetQuery(db, "SELECT strftime('%Y', Date) AS year,
                       strftime('%m', Date) AS month,
                       SUM(Disposable_In + Other_in) AS income,
                       SUM(Food + Transport + Groceries + Shopping + Entertainment + Medical + Insurance + PhoneBill + Tithes + Family) AS expenses,
                       SUM(Home_savings + Emergency + General_savings) AS savings
                FROM db
                GROUP BY year,
                         month" )


get_column(sql.headers[2])
