# 13 March 2015 /stbates/fg_entry/
library(shiny)
library(mail)
library(rmongodb)
library(Hmisc)
source("helpers.R")

shinyServer(function(input, output) {

  output$entryFE <- renderText({
    txnFE <- as.character(input$taxonFE)
    txnFE <- capitalize(txnFE)
    txlFE <- as.character(input$taxLevelFE)
    tmdFE <- as.character(input$trophModeFE)
    tmdFE <- capitalize(tmdFE)
    gldFE <- as.character(input$guildFE)
    gldFE <- allCapFE(gldFE)
    cnrFE <- as.character(input$conRankFE)
    cnrFE <- allCapFE(cnrFE)
    grmFE <- as.character(input$groMorphFE)
    grmFE <- allCapFE(grmFE)
    trtFE <- as.character(input$traitFE)
    trtFE <- allCapFE(trtFE)
    nteFE <- as.character(input$noteFE)
    nteFE <- capitalize(nteFE)
    cteFE <- as.character(input$citeFE)
    paste('{\n    "taxon": "', txnFE, '", \n    "taxonomicLevel": "', txlFE, '", \n    "trophicMode": "', tmdFE, '", \n    "guild": "',
                     gldFE, '", \n    "confidenceRanking": "', cnrFE, '", \n    "growthMorphology": "', grmFE, '", \n    "trait": "',
                     trtFE, '", \n    "notes": "', nteFE, '", \n    "citationSource": "', cteFE, '"\n }', sep = "")
    })

  output$t1FE <- renderText({ input$b1FE })
  
  observe({
    if (input$b1FE == 0)
      return(NULL)
    isolate({
      
      txnFE <- as.character(input$taxonFE)
      txnFE <- allCapFE(txnFE)
      txlFE <- as.character(input$taxLevelFE)
      tmdFE <- as.character(input$trophModeFE)
      gldFE <- as.character(input$guildFE)
      gldFE <- allCapFE(gldFE)
      cnrFE <- as.character(input$conRankFE)
      grmFE <- as.character(input$groMorphFE)
      grmFE <- allCapFE(grmFE)
      trtFE <- as.character(input$traitFE)
      trtFE <- allCapFE(trtFE)
      nteFE <- as.character(input$noteFE)
      cteFE <- as.character(input$citeFE)
      emlFE <- as.character(input$emFE)
      nmeFE <- as.character(input$nmFE)
      nmeFE <- allCapFE(nmeFE)
      
      xFE <- paste("taxon: ", txnFE, ",\n taxonomicLevel: ", txlFE, ",\n trophicMode: ", tmdFE, ",\n guild: ",
                 gldFE, ",\n confidenceRanking: ", cnrFE, ",\n growthMorphology: ", grmFE, ",\n trait: ",
                 trtFE, ",\n notes: ", nteFE, ",\n citationSource: ", cteFE, sep = "")
      
      moneFE <- paste("From: ", nmeFE, ", Email: ", emlFE, ", Entry:\n\n", xFE, sep = "")
      mtwoFE <- paste(nmeFE, ": \n\nThank you for your submission to the FUNGuild DB!\n\nYour Entry:\n\n", xFE, sep = "")
      
      emailSenderFE(moneFE, emlFE, mtwoFE)
      insertDBFE(txnFE, txlFE, tmdFE, gldFE, cnrFE, grmFE, trtFE, nteFE, cteFE)
      
    })
  })
})
