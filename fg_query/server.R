# 14 March 2015 /stbates/fg_query/

library(shiny)
library(rmongodb)
library(Hmisc)
source("helpers.R")

shinyServer(function(input, output) {
  
  output$t1FQ <- renderText({
    
    input$b1FQ
    
    isolate({
      butStat <- input$b1FQ
      if(butStat == 0)
        return(NULL)
      
      qTermFQ <- as.character(input$qtFQ)
      qFieldFQ <- as.character(input$qfFQ)
      qMatchFQ <- as.character(input$qmFQ)
      qReturnFQ <- qDBFQ(qTermFQ, qFieldFQ, qMatchFQ)
      output$tbl1FQ <- renderDataTable(qReturnFQ, options = list(searching = FALSE))
      return(NULL)
    })
  })
})
