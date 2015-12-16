library(shiny)
library(RCurl)

my.url <- "https://docs.google.com/spreadsheets/d/17_j1MnMg8S49B5K6duBqZttbolPtJ77VQxl8pLtGKTQ/pub?output=csv"

referrals.raw <- getURL( my.url, ssl.verifypeer=FALSE )
#data name: dat.referrals
dat.referrals <- read.csv( textConnection(referrals.raw), stringsAsFactors=F )

#find out data type
lapply( dat.referrals, class )

#change date to month
date <- as.Date(dat.referrals$Timestamp, "%m/%d/%Y")

month <- format( date, "%b")

# you need to do this to ensure months are ordered correctly, default is alphabetic

month <- factor( month, 
                 levels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"))


shinyUI(fluidPage(
  titlePanel('Central New York Community Foundation CNY'),
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel('input.dataset==="Reasons"',
                       selectInput(inputId = "need", 
                                   label = "Reasons for Referral:", 
                                   choices = unique( dat.referrals$Learner.Need))),
      conditionalPanel('input.dataset==="Referrals"',
                       selectInput(inputId = "referrals",
                                   label = "Receiving Agency:", 
                                   choices = unique( dat.referrals$Referred.To))),
      conditionalPanel('input.dataset==="Relationships"',
                       checkboxGroupInput('show_refs', 
                                          'Referral sources to show:', 
                                          unique(dat.referrals$Referred.By.1),
                                          selected = unique(dat.referrals$Referred.By.1)),
                       checkboxGroupInput('show_agencies', 
                                          'Receiving agencies to show:', 
                                          unique(dat.referrals$Referred.To),
                                          selected = unique(dat.referrals$Referred.To)))
      ),
    
    mainPanel = (tabsetPanel(id='dataset',
                             tabPanel("Reasons",plotOutput("line1")),
                
                             tabPanel("Referrals",plotOutput("line")),
                             
                             tabPanel("Relationships", plotOutput("relationship"))
                             )
    ))
  ))



