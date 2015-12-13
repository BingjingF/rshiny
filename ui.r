ui<-fluidPage(
  titlePanel('Central New York Community Foundation CNY'),
  
  sidebarLayout(
    sidebarPanel = (selectInput(inputId = "need", 
                    label = "Reasons for Referral:", 
                    choices = unique( dat.referrals$Learner.Need))),
    mainPanel = ( plotOutput("line1"))
    )
  )

