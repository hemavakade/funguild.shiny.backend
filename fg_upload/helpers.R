# 13 March 2015 /stbates/fg_upload/
emailSenderFU <- function(msgOneFU, emSubmitterFU, msgTwoFU) {
sendmail("@@@@@@@@@@", "FUNGuild: db addition", msgOneFU)
sendmail("@@@@@@@@@@", "FUNGuild: db addition", msgOneFU)
sendmail(emSubmitterFU, "FUNGuild: db addition", msgTwoFU)
}
actionButton <- function(inputId, label, btn.style = "" , css.class = "") {
if ( btn.style %in% c("primary","info","success","warning","danger","inverse","link")) {
btn.css.class <- paste("btn",btn.style,sep="-")
} else btn.css.class = ""
tags$button(id=inputId, type="button", class=paste("btn action-button",btn.css.class,css.class,collapse=" "), label)
}
insertTabFU <- function(inTaxonFU, inTaxLevelFU, inTrophModeFU, inGuildFU, inConRankFU, inGrowMorphFU, inTraitFU, inNotesFU, inCitationFU){
hostFU <- "@@@@@@@@@@.mongolab.com:@@@@@@@@@@"
unFU <- "@@@@@@@@@@"
pwFU <- "@@@@@@@@@@"
dbFU <- "funguild_db"
collectionFU <- "additions"
inListFU <- list(inTaxonFU, inTaxLevelFU, inTrophModeFU, inGuildFU, inConRankFU, inGrowMorphFU, inTraitFU, inNotesFU, inCitationFU)
nFU <- c("taxon", "taxonomicLevel", "trophicMode", "guild", "confidenceRanking", "growthMorphology", "trait", "notes", "citationSource")
names(inListFU) <- nFU
mongoFU <- mongo.create(host=hostFU , db=dbFU, username=unFU, password=pwFU)
nsFU <- paste(dbFU, collectionFU, sep=".")
mongo.insert(mongoFU, nsFU, inListFU)
mongo.disconnect(mongoFU)
}
allCapFU <- function(wdsFU) {
sFU <- strsplit(wdsFU, " ")[[1]]
paste(toupper(substring(sFU, 1,1)), substring(sFU, 2),
sep="", collapse=" ")
}
