# 14 March 2015 /stbates/fg_query/

allCapFQ <- function(wdsFQ) {
  sFQ <- strsplit(wdsFQ, " ")[[1]]
  paste(toupper(substring(sFQ, 1, 1)), substring(sFQ, 2),
        sep="", collapse=" ")
}

qDBFQ <- function(theTFQ, theFFQ, theMFQ){
  
  blnk <- 0
  if(theFFQ == 1){
    theQFFQ <- "taxon"
    theTFQ <- capitalize(theTFQ)
  }else if(theFFQ == 2){
    theQFFQ <- "growthForm"
    theTFQ <- allCapFQ(theTFQ)
  }else if(theFFQ == 3){
    theQFFQ <- "guild"
    theTFQ <- allCapFQ(theTFQ)
  }else if(theFFQ == 4){
    theQFFQ <- "trait"
    theTFQ <- allCapFQ(theTFQ)
  }else if(theFFQ == 5){
    theQFFQ <- "trophicMode"
    theTFQ <- allCapFQ(theTFQ)
  }else blnk <- blnk + 0

  hostFQ <- "@@@@@@@@@@.mongolab.com:@@@@@@@@@@"
  unFQ <- "@@@@@@@@@@"
  pwFQ <- "@@@@@@@@@@"
  dbFQ <- "funguild_db"
  collectionFQ <- "main"
  nsFQ <- paste(dbFQ, collectionFQ, sep=".")
  mgFQ <- mongo.create(host=hostFQ, db=dbFQ, username=unFQ, password=pwFQ)
  bufFQ <- mongo.bson.buffer.create()
  
  
  if(theMFQ == 2){
    theExFQ <- paste(".*", theTFQ, ".*", sep = "")
    regex <- mongo.regex.create(theExFQ, options="i")
    mongo.bson.buffer.append(bufFQ, theQFFQ, regex)
    bFQ <- mongo.bson.from.buffer(bufFQ)
  }else{
    mongo.bson.buffer.append(bufFQ, theQFFQ, theTFQ)
    bFQ <- mongo.bson.from.buffer(bufFQ)}
  
  qResultFQ <- mongo.find.all(mgFQ, nsFQ, bFQ)
  qResLFQ <- length(qResultFQ)
 
  fVecFQ <- c("NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL", "NULL")
  fNamVecFQ <- c("taxon", "taxonomicLevel", "trophicMode", "guild", "confidenceRanking", "growthForm", "trait", "notes", "citationSource")
  
  if(qResLFQ != 0){
    qResTabFQ <- do.call(rbind.data.frame, qResultFQ)
    drops <- "X_id"
    qResTabFQ <- qResTabFQ[,!(names(qResTabFQ) %in% drops)]
    qResTabFQ <- qResTabFQ[ order(qResTabFQ$taxon), ]
    return(qResTabFQ)
  }else{
    qResTabFQ <- data.frame(rbind(fVecFQ), row.names = "1")
    names(qResTabFQ) <- fNamVecFQ
    row.names(qResTabFQ[1,]) <- "1"
    return(qResTabFQ)
  }
  mongo.bson.destroy(bFQ)
  mongo.destroy(mgFQ)
}

