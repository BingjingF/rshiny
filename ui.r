ui<-fluidPage(
  headerPanel('Main Reasons for Referrals'),
  checkboxGroupInput("reasons", label="Choices",choices=c("1","2","3","4")),
  plotOutput("hist")
)

