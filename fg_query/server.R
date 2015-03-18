# 15 March 2015 https://thelab.shinyapps.io/funguild/
library(shiny)
library(rPython)
library(Hmisc)
source("helpers.R")

shinyServer(function(input, output) {

  observe({
    
    isolate({
      output$messageFG <- renderText({
        inFileFG <- input$otuFG
        if (is.null(inFileFG))
          return(print("Not yet underway. Please upload OTU table as a tab delimited text file."))
        
        del1FG <- "otu_table.matched.txt"
        if (file.exists(del1FG)) unlink(del1FG, force = TRUE)
        del2FG <- "otu_table.unmatched.txt"
        if (file.exists(del2FG)) unlink(del2FG, force = TRUE)
        del3FG <- "otu_table.combined.txt"
        if (file.exists(del3FG)) unlink(del3FG, force = TRUE)
        del4FG <- "temp.txt"
        if (file.exists(del4FG)) unlink(del4FG, force = TRUE)
        del5FG <- "temp_db.txt"
        if (file.exists(del5FG)) unlink(del5FG, force = TRUE)
        # Start the clock!
        ptmFG <- proc.time()
        fInFG <- input$otuFG
        fPthFG <- fInFG$datapath
        fNamFG <- "otu_table"
        wDirFG <- getwd()
        fOutPthFG <- paste(wDirFG, "/", sep = "")
        fNamNewFG <- strsplit(fNamFG, split = ".txt")
        fNamNewFG <- fNamNewFG[[1]]
        
        python.exec( "import csv" )
        python.assign( "otu_file", fPthFG )
        delimFG <- "\t"
        python.assign( "fNam", fNamFG )
        
        if(delimFG == "\t"){
          
          delimFG <- "TRUE"
          python.assign( "otu_delims", delimFG )
          MfInNewFG <- paste(fNamNewFG, ".matched.txt", sep = "")
          UfInNewFG <- paste(fNamNewFG, ".unmatched.txt", sep = "")
          TfInNewFG <- paste(fNamNewFG, ".combined.txt", sep = "")
          
          python.assign( "matched_file_name", MfInNewFG )
          python.assign( "unmatched_file_name", UfInNewFG )
          python.assign( "total_file_name", TfInNewFG )
          
          MnewPthOutFG <- paste(fOutPthFG, MfInNewFG, sep = "")
          UnewPthOutFG <- paste(fOutPthFG, UfInNewFG, sep = "")
          TnewPthOutFG <- paste(fOutPthFG, TfInNewFG, sep = "")
          
          python.assign( "matched_file", MnewPthOutFG )
          python.assign( "unmatched_file", UnewPthOutFG )
          python.assign( "total_file", TnewPthOutFG )
          
        }else print("Please input a tab delimited text file...")
        
        python.load( "pyCode.py" )
        assdFG <- python.get( "count" )
        unassdFG <- python.get( "count_unmatched" )
        # Stop the clock
        tmOutFG <- proc.time() - ptmFG
        tmFG <- as.numeric(tmOutFG[3])
        theTmFG <- round(tmFG, 2)
        print(c("In", theTmFG, "seconds, FUNGuild made assignments on", assdFG, "OTUs, leaving", unassdFG, "unassigned."))
        })
    })
    
    isolate({
      wDirFG <- getwd()
      mDirFG <- paste(wDirFG, "otu_table.matched.txt", sep = "/")
      output$dl1FG <- downloadHandler(filename = 'otu_table.matched.txt', 
                                    content = function(file) {inTab1FG <- read.table(mDirFG, header = FALSE, sep = "\t")
                                                              write.table(inTab1FG, sep = "\t", row.names = FALSE, col.names = FALSE, fileEncoding = "utf8", file)}, 
                                    contentType = NA)
    })
    isolate({
      wDirFG <- getwd()
      uDirFG <- paste(wDirFG, "otu_table.unmatched.txt", sep = "/")
      output$dl2FG <- downloadHandler(filename = 'otu_table.unmatched.txt', 
                                    content = function(file) {inTab2FG <- read.table(uDirFG, header = FALSE, sep = "\t")
                                                              write.table(inTab2FG, sep = "\t", row.names = FALSE, col.names = FALSE, fileEncoding = "utf8", file)}, 
                                    contentType = NA)
    })
    isolate({
      wDirFG <- getwd()
      cDirFG <- paste(wDirFG, "otu_table.combined.txt", sep = "/")
      output$dl3FG <- downloadHandler(filename = 'otu_table.combined.txt', 
                                    content = function(file) {inTab3FG <- read.table(cDirFG, header = FALSE, sep = "\t")
                                                              write.table(inTab3FG, sep = "\t", row.names = FALSE, col.names = FALSE, fileEncoding = "utf8", file)}, 
                                    contentType = NA)
    })
    
    isolate({
      output$conPanelFG <- renderUI({
        if(is.null(input$otuFG)){
          wellPanel(
            h4("Input OTU Table:"),
            fileInput("otuFG", label = "", multiple = FALSE, accept = c("text/plain")),
            p("* Select OTU table for upload.", style = "color:#fff;"),
            p("* File", (a("formatting",     href="https://github.com/UMNFuN/FUNGuild/blob/master/otu_table_example.txt", target="_blank")), " (tab delimited text) .", style = "color:#fff;"),
            hr())
        } else{
        wellPanel(
          h4("Download OTU Tables:"),
          downloadButton('dl1FG', ' Assigned Output '),
          br(),
          downloadButton('dl2FG', ' Unassigned Output '),
          br(),
          downloadButton('dl3FG', ' Combined Output '),
          br(),
          hr(),
          p("* To reset application ", a("CLICK HERE",     href="https://thelab.shinyapps.io/funguild/"), "."))
        }
      })
    })
    
  })
})
