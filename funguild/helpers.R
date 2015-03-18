# 15 March 2015 https://thelab.shinyapps.io/funguild/

allCapFG <- function(wdsFG) {
  sFG <- strsplit(wdsFG, " ")[[1]]
  paste(toupper(substring(sFG, 1,1)), substring(sFG, 2),
        sep="", collapse=" ")
}
