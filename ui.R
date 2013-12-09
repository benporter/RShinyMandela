# Define UI
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Mandela Speech Wordcloud",windowTitle="Mandela Speech Wordcloud - Ben Porter"),
  
  sidebarPanel(
      selectInput("dataset", "Choose a speech:",
                  choices = factor(c(list.files('~/ShinyApps/mandela/', pattern=".txt",recursive = TRUE)))),
    HTML("<hr size=10 width=100% align=\"left\" noshade>"),  
    h4("Transformations"),
    sliderInput("maxwords", "Maximum Number of Words:", 
                  min = 10, max = 400, value = 100, step = 10),
    checkboxInput("lowercase", "Convert to Lowercase", TRUE),
    checkboxInput("stripwhite", "Strip White Space", TRUE),
    checkboxInput("removepunc", "Remove Punctuation", TRUE),
    checkboxInput("stopwords", "Remove Standard English Stopwords", TRUE),
    #checkboxInput("stem", "Stem Words (e.g. like, likes, likely becomes lik)", FALSE),
    
    br(),
    textInput("customstop", "Enter Custom Words to Remove", value = "separate, words, by, comma"),
    HTML("<hr size=10 width=100% align=\"left\" noshade>"),
    downloadButton("downloadFreq", "Download Word Frequencies")
    
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Wordcloud",plotOutput("wordcloudplot")),
      tabPanel("Word Frequency",tableOutput("freqtable")),
      tabPanel("Speech Text",textOutput("inputtext")),
      tabPanel("Credits",htmlOutput("credits"))
    ))
))