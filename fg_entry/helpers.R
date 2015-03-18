# 13 March 2015 /stbates/fg_entry/

emailSenderFE <- function(msgOneFE, emSubmitterFE, msgTwoFE) {
  
  sendmail("@@@@@@@@@", "FUNGuild: db addition", msgOneFE)
  sendmail("@@@@@@@@@", "FUNGuild: db addition", msgOneFE)
  sendmail(emSubmitterFE, "FUNGuild: db addition", msgTwoFE)
}

insertDBFE <- function(taxonDBFE, taxLevelDBFE, trophModeDBFE, guildDBFE, conRankDBFE, growMorphDBFE, traitDBFE, notesDBFE, citationDBFE){
  
  hostFE <- "@@@@@@@@@.mongolab.com:43991"
  unFE <- "@@@@@@@@@"
  pwFE <- "@@@@@@@@@"
  dbFE <- "funguild_db"
  collectionFE <- "additions"

  mongoFE <- mongo.create(host=hostFE , db=dbFE, username=unFE, password=pwFE)
  nsFE <- paste(dbFE, collectionFE, sep=".")

  nFE <- c("taxon", "taxonomicLevel", "trophicMode", "guild", "confidenceRanking", "growthMorphology", "trait", "notes", "citationSource")
  bFE <- list(taxonDBFE, taxLevelDBFE, trophModeDBFE, guildDBFE, conRankDBFE, growMorphDBFE, traitDBFE, notesDBFE, citationDBFE)
  names(bFE) <- nFE

  mongo.insert(mongoFE, nsFE, bFE)
  mongo.disconnect(mongoFE)
}

allCapFE <- function(wdsFE) {
  sFE <- strsplit(wdsFE, " ")[[1]]
  paste(toupper(substring(sFE, 1,1)), substring(sFE, 2),
        sep="", collapse=" ")
}

