shinyServer(function(input,output){
  
  output$line1<-renderPlot({
    
    dat.sub.n <- dat.referrals[ dat.referrals$Learner.Need == input$need , ]
    dat.referrals$month <- month
    t.need.sub <- tapply( dat.sub.n$Learner.Need, dat.sub.n$month, length )
    t.need.sub[ is.na(t.need.sub) ] <- 0
    
    plot( t.need.sub,xlab="Month",ylab="Number of Reasons", type="b",
          pch=19, xaxt="n", xlim=c(0,13), ylim=c(0,max(t.need.sub)+3), bty="n",col="steelblue" )
    text( 1:12, t.need.sub, labels=names(t.need.sub), cex=0.8, pos=3 )
    axis( 1, at=1:12, labels=names(t.need.sub), cex.axis=0.7 ) 
    segments(x0=seq(1,12,1),y0=0,x1=seq(1,12,1),y1=t.need.sub,col="gray",lty=3)
    segments(x0=0,y0=t.need.sub,x1=1:12,y1=t.need.sub,col="gray",lty=3)
  })
  output$line <- renderPlot({   
    
    # to drill down to specific learner types subset by your input values
    dat.sub <- dat.referrals[ dat.referrals$Referred.To == input$referrals , ]
    dat.referrals$month <- month
    t.referrals.sub <- tapply( dat.sub$Referred.To, dat.sub$month, length )
    t.referrals.sub[ is.na(t.referrals.sub) ] <- 0
    
    # time series
    plot( t.referrals.sub, type="b", pch=19, xaxt="n", xlim=c(0,13), ylim=c(0,max(t.referrals.sub)+3), bty="n" ,col="darkred")
    axis( 1, at=1:12, labels=names(t.referrals.sub), cex.axis=0.7 )
  })
  output$relationship <- renderPlot({
  
  counts <- NA
  dat.referrals.subset <- NA
  dat.referrals.subset <- dat.referrals[dat.referrals$Referred.By.1 == input$show_refs, ]
  counts <- table(dat.referrals.subset$Referred.To, dat.referrals.subset$Referred.By.1)
  barplot(counts, main="Relationship Between Referral Source and Referral Agency",
      xlab="Referral Sources", col=c("darkblue","darkorange1", "gray", "mediumorchid3", "red", "wheat1", "lawngreen"),
 	)
  })
  })
