server<-function(input,output){
  output$hist<-renderPlot({
    hist(input$reasons)
  })
}
