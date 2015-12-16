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

shinyServer(function(input,output){
  
  output$line1<-renderPlot({
    
    dat.referrals$month <- month
    dat.sub.n <- dat.referrals[ dat.referrals$Learner.Need == input$need , ]
    t.need.sub <- tapply( dat.sub.n$Learner.Need, dat.sub.n$month, length )
    t.need.sub[ is.na(t.need.sub) ] <- 0
    
    plot( t.need.sub,xlab="Month",ylab="Number of Reasons", type="b",
          pch=19, xaxt="n", xlim=c(0,13), ylim=c(0,max(t.need.sub)+3), bty="n",col="steelblue" )
    text( 1:12, t.need.sub, labels=names(t.need.sub), cex=1, pos=3 )
    axis( 1, at=1:12, labels=names(t.need.sub), cex.axis=1 ) 
    segments(x0=seq(1,12,1),y0=0,x1=seq(1,12,1),y1=t.need.sub,col="gray",lty=3)
    segments(x0=0,y0=t.need.sub,x1=1:12,y1=t.need.sub,col="gray",lty=3)
  })
  output$line <- renderPlot({   
    
    # to drill down to specific learner types subset by your input values
    dat.referrals$month <- month
    dat.sub <- dat.referrals[ dat.referrals$Referred.To == input$referrals , ]
    t.referrals.sub <- tapply( dat.sub$Referred.To, dat.sub$month, length )
    t.referrals.sub[ is.na(t.referrals.sub) ] <- 0
    
    # time series
    plot( t.referrals.sub, xlab= "Months", ylab= "Number of Referrals", type="b", pch=19, xaxt="n", xlim=c(0,13), ylim=c(0,max(t.referrals.sub)+3), bty="n" ,col="red")
    text( 1:12, t.referrals.sub , labels=names(t.referrals.sub), cex=1, pos=3 )
    axis( 1, at=1:12, labels=names(t.referrals.sub), cex.axis=1 )
    segments(x0=seq(1,12,1),y0=0,x1=seq(1,12,1),y1=t.referrals.sub,col="gray",lty=3)
  })
  output$relationship <- renderPlot({

  # Create a color vector
  color.function <- colorRampPalette(
    colors = c("red", "ghostwhite", "steelblue"),
    space = "Lab" # Option used when colors do not represent a quantitative scale
  )
  
  num.colors <- length(unique(dat.referrals$Referred.To))

  agencies.colors <- color.function(num.colors) 
  
  # Create a matrix of the two inputs and their counts
  counts <- NULL
  
  # Create the selector vector - returns a TRUE value only when both columns are in the respective vectors of checkbox choices
  these.referrals <- ((dat.referrals$Referred.By.1 %in% input$show_refs) & (dat.referrals$Referred.To %in% input$show_agencies))
  
  # Create a subset of the full data based on the selector vector
  dat.referrals.subset <- dat.referrals[these.referrals, ]
  
  # Create a table (matrix) of the two values and the counts 
  counts <- table(dat.referrals.subset$Referred.To, dat.referrals.subset$Referred.By.1)
  
  # Chart the bar plot and the legend based on the counts matrix
  barplot(counts, 
          xlim=c(0,6), ylim = c(0,60), 
          main="Relationship Between Referral Source and Receiving Agency",
          xlab="Referral Sources", ylab="Number of Referrals to Receiving Agencies",
          col=agencies.colors)
  legend("topright",fill=agencies.colors, legend=rownames(counts), title="Receiving Agencies")
  })
  })
