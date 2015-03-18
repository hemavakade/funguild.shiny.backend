# 13 March 2015 /stbates/fg_upload/
library(shiny)
library(mail)
library(rmongodb)
library(Hmisc)
source("helpers.R")

shinyServer(function(input, output) {
  
  observe({

      isolate({
        output$t2FU <- renderText({
        inFile1FU <- input$fileFU
        if (is.null(inFile1FU))
          return(print("Please upload a tab delimited text file."))
        data1FU <- read.table(inFile1FU$datapath, header = TRUE, sep = "\t", na.strings = "NA")
        xFU <- dim(data1FU)[1]
        entsFU <- c()
        cntsFU <- 0
      
        for(i in 1:xFU){
          cntsFU <- cntsFU + 1
          txnFU <- as.character(data1FU[i,1])
          txnFU <- capitalize(txnFU)
          txlFU <- as.character(data1FU[i,2])
          tmdFU <- as.character(data1FU[i,3])
          tmdFU <- capitalize(tmdFU)
          gldFU <- as.character(data1FU[i,4])
          gldFU <- allCapFU(gldFU)
          cnrFU <- as.character(data1FU[i,5])
          cnrFU <- allCapFU(cnrFU)
          grmFU <- as.character(data1FU[i,6])
          grmFU <- allCapFU(grmFU)
          trtFU <- as.character(data1FU[i,7])
          trtFU <- allCapFU(trtFU)
          nteFU <- as.character(data1FU[i,8])
          nteFU <- capitalize(nteFU)
          cteFU <- as.character(data1FU[i,9])
          if (cntsFU < xFU){
            strngFU <- paste('{\n    "taxon": "', txnFU, '", \n    "taxonomicLevel": "', txlFU, '", \n    "trophicMode": "', tmdFU, '", \n    "guild": "',
                            gldFU, '", \n    "confidenceRanking": "', cnrFU, '", \n    "growthMorphology": "', grmFU, '", \n    "trait": "',
                            trtFU, '", \n    "notes": "', nteFU, '", \n    "citationSource": "', cteFU, '"\n },\n', sep = "")
           entsFU[i] <- as.character(strngFU)
           }else{
             strngFU <- paste('{\n    "taxon": "', txnFU, '", \n    "taxonomicLevel": "', txlFU, '", \n    "trophicMode": "', tmdFU, '", \n    "guild": "',
                            gldFU, '", \n    "confidenceRanking": "', cnrFU, '", \n    "growthMorphology": "', grmFU, '", \n    "trait": "',
                            trtFU, '", \n    "notes": "', nteFU, '", \n    "citationSource": "', cteFU, '"\n }', sep = "")
              entsFU[i] <- as.character(strngFU)
           }    
       }
          print(entsFU)
        })
    })
    
    isolate({
      output$t1FU <- renderText({
        inFile2FU <- input$fileFU
        if (input$b1FU == 0)
          return(NULL)
        data2FU <- read.table(inFile2FU$datapath, header = TRUE, sep = "\t", na.strings = "NA")
        yFU <- dim(data2FU)[1]
        entsMailFU <- c("blank")
        
        for(j in 1:yFU){
          
          ## pull data from the input table
          taxonFU <- as.character(data2FU[j,1])
          taxonFU <- capitalize(taxonFU)
          taxLevelFU <- as.character(data2FU[j,2])
          trophModeFU <- as.character(data2FU[j,3])
          trophModeFU <- capitalize(trophModeFU)
          guildFU <- as.character(data2FU[j,4])
          guildFU <- allCapFU(guildFU)
          conRankFU <- as.character(data2FU[j,5])
          conRankFU <- allCapFU(conRankFU)
          growMorphFU <- as.character(data2FU[j,6])
          growMorphFU <- allCapFU(growMorphFU)
          traitFU <- as.character(data2FU[j,7])
          traitFU <- allCapFU(traitFU)
          notesFU <- as.character(data2FU[j,8])
          notesFU <- capitalize(notesFU)
          citationFU <- as.character(data2FU[j,9])
          emlFU <- as.character(input$emFU)
          nmeFU <- as.character(input$nmFU)
          nmeFU <- allCapFU(nmeFU)
          
          ## build vector with the data to mail
          
          entryDataFU <- paste(" taxon: ", taxonFU, "\n taxonomicLevel: ", taxLevelFU, "\n trophicMode: ", trophModeFU, "\n guild: ",
                               guildFU, "\n confidenceRanking: ", conRankFU, "\n growthMorphology: ", growMorphFU, "\n trait: ",
                               traitFU, "\n notes: ", notesFU, "\n citationSource: ", citationFU, "\n\n", sep = "")
          
          entsMailFU[j+1] <- entryDataFU
          
          
          insertTabFU(taxonFU, taxLevelFU, trophModeFU, guildFU, conRankFU, growMorphFU, traitFU, notesFU, citationFU)
        }    
        
        ## send emails to contributor and db curators
        
        moneFU <- entsMailFU
        mtwoFU <- entsMailFU
        moneFU[1] <- paste("From: ", nmeFU, ", Email: ", emlFU, ", Entry:\n\n", sep = "")
        mtwoFU[1] <- paste(nmeFU, ": \n\nThank you for your submission to the FUNGuild DB!\n\nYour Entry:\n\n", sep = "")
        moneFU <- paste(moneFU, collapse = "")
        mtwoFU <- paste(mtwoFU, collapse = "")
        
        ## send entry to uploading function in helpers.R file
        emailSenderFU(moneFU, emlFU, mtwoFU)
        
        ## print completed upload message on page
        print("Your entries have been submitted!")
      })
    })
    
    isolate({
      output$conPanelFU <- renderUI({
        if(is.null(input$fileFU)){
          wellPanel(
            fileInput("fileFU", label = h4("File Input:"), multiple = FALSE, accept = c("text/plain")),
            #tags$head(tags$style("#t1FU{color: #05F5A5; font-size: 16px; font-style: italic;}")),
            p("* Select multiple entry file for upload.", style = "color:#fff;"),
            p("* File ", (a("formatting",     href="https://github.com/UMNFuN/FUNGuild/blob/master/db_upload_example.txt", target="_blank")), " (tab delimited text). ", style = "color:#fff;"),
            p("* More information on data fields at ", (a("GitHub",     href="https://github.com/UMNFuN/FUNGuild/blob/master/README.md", target="_blank")), ".", style = "color:#fff;"),
            hr()
          )
        } else{
          wellPanel(
            actionButton("b1FU", "Submit File", "primary"),
            br(),
            br(),
            p(textOutput("t1FU")),
            tags$head(tags$style("#t1FU{color:#F0843C; font-size: 16px;}")),
            br(),
            p("* Click button to send entries for review.", style = "color:#fff;"),
            p("* Message will appear after process has completed.", style = "color:#fff;"),
            p("* Please review entries here before submission."),
            p("* Enter name and email address below before submitting!"),
            hr(),
            p("* To reset application ", (a("CLICK HERE", href="https://thelab.shinyapps.io/fg_upload")), ".", style = "color:#fff;")
          )
        }
      })
    })
    
  })
})
