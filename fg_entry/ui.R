# 13 March 2015 /stbates/fg_entry/

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
             h2("FUNGuild: Fungi + fUNctional + Guild (single DB entries)", style = "color:#FFF6B6;"),
             hr(),
             p("* Go to = |", a(" Assignment App ",     href="https://thelab.shinyapps.io/funguild"), "|", a(" DB Queries ",     href="https://thelab.shinyapps.io/fg_query"), "|", a(" Single DB Entries ",     href="https://thelab.shinyapps.io/fg_entry"), "|", a(" Multiple DB Entries ",     href="https://thelab.shinyapps.io/fg_upload"), "|", a(" GitHub Repository ",     href="https://github.com/UMNFuN/FUNGuild", target="_blank"), "|"),
             hr()
           ))
  ),
  fluidRow(
    column(5,
           wellPanel(
             h4("Taxon:"),
             textInput("taxonFE", label = h4(""), value = ""),
             br(),
             p("* Enter the scientific name of the taxon.", style = "color:#fff;"),
             h6(),
             selectInput("taxLevelFE", label = h4("Taxonomic Level:"),
                         choices = list("Phylum" = 1, "Sub Phylum" = 2,
                                        "Class" = 3, "Sub Class" = 4, "Order" = 5, 
                                        "Family" = 6, "Genus" = 7, "Species" = 8, 
                                        "Keyword" = 0), selected = 1),
             p("* Select the correct taxonomic level for this taxon.", style = "color:#fff;"),
             h6(),
             h4("Guild:"),
             textInput("guildFE", label = h4(""), value = ""),
             br(),
             p("* Ectomycorrhizal, Plant Pathogen, Wood Decomposer, etc.", style = "color:#fff;"),
             hr()
           )),
    column(6,
           wellPanel(
             h4("Your proposed entry to the FUNGuild DB:"),
             verbatimTextOutput("entryFE"),
             p("* Entries in JSON format of the FUNGuild ", (a("MongoDB", href="http://www.mongodb.org/", target="_blank")), " database.", style = "color:#fff;"),
             hr()
           ))
    ),
  fluidRow(
    column(5,
           wellPanel(
             h4("Growth Form:"),
             textInput("groMorphFE", label = "", value = ""),
             br(),
             p("* Facultative Yeast, Gasteroid Fungus, Thallus, etc.", style = "color:#fff;")
           ),
           wellPanel(
             textInput("traitFE", label = h4("Trait:"), value = ""),
             br(),
             p("* Other traits that might be relevant, e.g., White Rot Fungus.", style = "color:#fff;")
           ),
           wellPanel(
             textInput("noteFE", label = h4("Notes:"), value = ""),
             br(),
             p("* Such as “Facultative parasites causing coccidioidomycosis”.", style = "color:#fff;")
           ),
           wellPanel(
             textInput("nmFE", label = h4("Name:"), value = ""),
             br(),
             p("* Please enter your full name.", style = "color:#fff;")
           ),
           wellPanel(
             textInput("emFE", label = h4("Email:"), value = ""),
             br(),
             p("* Please enter your email address.", style = "color:#fff;"),
             br()
           )),
    column(6,
           wellPanel(
             selectInput("trophModeFE", label = h4("Trophic Mode:"),
                         choices = list("Pathotroph" = "Pathotroph",
                                        "Saprotroph" = "Saprotroph", "Symbiotroph" = "Symbiotroph"), selected = 1),
             p("* Pathotroph = receiving nutrients at expense of host cells and causing disease.", style = "color:#fff;"),
             p("* Saprotroph = receiving nutrients by breaking down dead host cells.", style = "color:#fff;"),
             p("* Symbiotroph = receiving nutrients by exchanging resources with host cells.", style = "color:#fff;")
             ),
           wellPanel(
             selectInput("conRankFE", label = h4("Confidence Ranking:"),
                         choices = list("Highly Probable" = "Highly Probable", "Probable" = "Probable",
                                        "Possible" = "Possible"), selected = 1),
             p("* Highly Probable = absolutely certain.", style = "color:#fff;"),
             p("* Probable = fairly certain.", style = "color:#fff;"),
             p("* Possible = suspected but not proven, conflicting reports given, etc.", style = "color:#fff;")
             ),
           wellPanel(
             textInput("citeFE", label = h4("Citation/Source:"), value = ""),
             br(),
             p("* Publication, website, etc. from which the information was derived.", style = "color:#fff;"),
             p("* Data from peer-reviewed publications is preferred.", style = "color:#fff;"),
             p("* Formatting example: Tedersoo L, May TW, Smith ME. 2010. Mycorrhiza 20: 217-263.", style = "color:#fff;"),
             h5(".", style = "color:#4E4E4E;")
             ))
    ),
  fluidRow(
    column(11,
           wellPanel(
             hr(),
             actionButton("b1FE", "Submit Entry", "primary"),
             br(),
             br(),
             p("Number of entries submitted:"),
             textOutput("t1FE"),
             tags$head(tags$style("#t1FE{color:#F0843C; font-size: 16px;}")),
             hr(),
             p("* Each button click sends an entry to FUNGuild DB curators for review.", style = "color:#fff;"),
             p("* Please enter your name and email address above before submitting entries!"),
             hr(),
             p("* To clear all fields ", (a("CLICK HERE", href="https://thelab.shinyapps.io/fg_entry")), ".", style = "color:#fff;")
             ))
    ),
  fluidRow(
    column(11,
           wellPanel(hr()))
  )
))
