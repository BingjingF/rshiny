library(shiny)
library(RCurl)

my.url <- "https://docs.google.com/spreadsheets/d/17_j1MnMg8S49B5K6duBqZttbolPtJ77VQxl8pLtGKTQ/pub?output=csv"

referrals.raw <- getURL( my.url, ssl.verifypeer=FALSE )

dat.referrals <- read.csv( textConnection(referals.raw) )


ui<-fluidPage(
  headerPanel('CNY'),
  selectInput("need", "Reason for Referral:", 
              choices = unique( dat.referrals$Learner.Need) ),
  plotOutput("line")
)

