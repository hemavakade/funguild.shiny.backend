# 14 March 2015 /stbates/fg_query/

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
                             h2("FUNGuild: Fungi + fUNctional + Guild (query DB)", style = "color:#FFF6B6;"),
                             hr(),
                             p("* Go to = |", a(" Assignment App ",     href="https://thelab.shinyapps.io/funguild"), "|", a(" DB Queries ",     href="https://thelab.shinyapps.io/fg_query"), "|", a(" Single DB Entries ",     href="https://thelab.shinyapps.io/fg_entry"), "|", a(" Multiple DB Entries ",     href="https://thelab.shinyapps.io/fg_upload/"),"|", a(" GitHub Repository ",     href="https://github.com/UMNFuN/FUNGuild", target="_blank"), "|"),
                             hr()
                           ))
                  ),
                  fluidRow(
                    column(3,
                           wellPanel(
                             hr(),
                             actionButton("b1FQ","Submit Query", "primary"),
                             br(),
                             br(),
                             h4("Query Term:"),
                             textInput("qtFQ", label = "", value = ""),
                             br(),
                             selectInput("qfFQ", label = h4("Query Field:"),
                                         choices = list("Taxon" = 1, "Growth Form" = 2, "Guild" = 3, "Trait" = 4, "Trophic Mode" = 5),
                                         selected = 1),
                             selectInput("qmFQ", h4("Query Match:"),
                                         choices = list("Exact" = 1, "Like" = 2),
                                         selected = 1),
                             br(),
                             hr()
                           )),
                    column(8,
                           wellPanel(
                             hr(),
                             h4("FUNGuild DB query result:"),
                             br(),
                             dataTableOutput('tbl1FQ'),
                             br(),
                             br(),
                             hr())
                           )
                  ),
                  fluidRow(
                    column(11,
                           wellPanel(
                             hr()
                           ),
                           wellPanel(
                             textOutput("t1FQ")
                             ))
                  )
                  
))
