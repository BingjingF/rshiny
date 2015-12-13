function(input,output){
  
  output$line1<-renderPlot({
    
    dat.sub.n <- dat.referrals[ dat.referrals$Learner.Need == input$need , ]
    
    t.need.sub <- tapply( dat.sub.n$Learner.Need, dat.sub.n$month, length )
    t.need.sub[ is.na(t.need.sub) ] <- 0
    
    plot( t.need.sub,xlab="Month",ylab="Number of Reasons", type="b",
          pch=19, xaxt="n", xlim=c(0,13), ylim=c(0,max(t.need.sub)+3), bty="n",col="steelblue" )
    text( 1:12, t.need.sub, labels=names(t.need.sub), cex=0.8, pos=3 )
    axis( 1, at=1:12, labels=names(t.need.sub), cex.axis=0.7 ) 
    segments(x0=seq(1,12,1),y0=0,x1=seq(1,12,1),y1=t.need.sub,col="gray",lty=3)
  })
  
}
