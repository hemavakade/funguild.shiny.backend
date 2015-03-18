# 13 March 2015 /stbates/fg_upload/

shinyUI(fluidPage(theme = "stylesheet.css",
                  tags$head(tags$style(HTML("
                                            .shiny-text-output {
                                            }
                                            "))),
                  br(),
                  fluidRow(
                    column(11,
                           wellPanel(
                             h2("FUNGuild: Fungi + fUNctional + Guild (multiple DB entries)", style = "color:#FFF6B6;"),
                             hr(),
                             p("* Go to = |", a(" Assignment App ",     href="https://thelab.shinyapps.io/funguild"), "|", a(" DB Queries ",     href="https://thelab.shinyapps.io/fg_query"), "|", a(" Single DB Entries ",     href="https://thelab.shinyapps.io/fg_entry"), "|", a(" Multiple DB Entries ",     href="https://thelab.shinyapps.io/fg_upload"), "|", a(" GitHub Repository ",     href="https://github.com/UMNFuN/FUNGuild", target="_blank"), "|"),
                             hr()
                           ))
                  ),
                 fluidRow(
                   column(4,
                          uiOutput("conPanelFU")
                          ),
                   column(7,
                          wellPanel(
                             h4("Your proposed entries to the FUNGuild DB:"),
                             br(),
                             verbatimTextOutput("t2FU"),
                             p("* Entries in JSON format of the FUNGuild ", (a("MongoDB",     href="http://www.mongodb.org/", target="_blank")), " database.", style = "color:#fff;"),
                             hr()
                           ))
                  ),
                 fluidRow(
                   column(4,
                          wellPanel(
                            textInput("nmFU", label = h4("Name:"),
                                      value = ""),
                            br(),
                            p("* Please enter your full name.", style = "color:#fff;")
                          )),
                   column(7,
                          wellPanel(
                            textInput("emFU", label = h4("Email:"),
                                      value = ""),
                            br(),
                            p("* Please enter your email address.", style = "color:#fff;")
                          ))
                 ),
                  fluidRow(
                    column(11,
                           wellPanel(
                           hr()
                           ))
                  )
                  
))
