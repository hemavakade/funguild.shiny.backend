# 15 March 2015 https://thelab.shinyapps.io/funguild/
actionButton <- function(inputId, label, btn.style = "" , css.class = "") {
  if ( btn.style %in% c("primary","info","success","warning","danger","inverse","link")) {
    btn.css.class <- paste("btn",btn.style,sep="-")
  } else btn.css.class = ""
  tags$button(id=inputId, type="button", class=paste("btn action-button",btn.css.class,css.class,collapse=" "), label)
} 

shinyUI(fluidPage(theme = "stylesheet.css",
                  tags$head(tags$style(HTML("
                                            .shiny-text-output {
                                            }
                                            "))),
                  br(),
                  fluidRow(
                    column(11,
                           wellPanel(
                             h2("FUNGuild: Fungi + fUNctional + Guild (assignment application)", style = "color:#FFF6B6;"),
                             hr(),
                             p("* Go to = |", a(" Assignment App ",     href="https://thelab.shinyapps.io/funguild"), "|", a(" DB Queries ",     href="https://thelab.shinyapps.io/fg_query"), "|", a(" Single DB Entries ",     href="https://thelab.shinyapps.io/fg_entry"), "|", a(" Multiple DB Entries ",     href="https://thelab.shinyapps.io/fg_upload"), "|", a(" GitHub Repository ",     href="https://github.com/UMNFuN/FUNGuild", target="_blank"), "|"),
                             hr()
                           ))
                  ),
                  fluidRow(
                    column(4,
                           uiOutput("conPanelFG")
                           ),
                    column(7,
                           wellPanel(
                             h4("Analysis Status:"),
                             p(textOutput("messageFG")),
                             tags$head(tags$style("#messageFG{color:#F0843C; font-size: 16px;}")),
                             br(),
                             p("* Allow several seconds for the process to complete.", style = "color:#fff;"),
                             hr()
                           ))
                  ),
                    fluidRow(
                      column(11,
                             wellPanel(
                               hr()
                             ))
                  )        
))
