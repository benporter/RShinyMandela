
library(shiny)
library(tm)
library(wordcloud)
#library(Snowball) #for stemming

shinyServer(function(input, output) {
  
  output$caption1 <- renderTable( {
    
    if (is.null(input$file1)) { return(NULL) }
    inFile <- input$file1
    inFile
    
  })
  
  output$customstopwords <- renderText( {
    print(paste("Current value of user defined custom stop words: ",input$customstop,sep=""))
  })
  
  
  folder.chosen <- reactive({ 
      return(substr(input$dataset, 1, regexpr("\\/",input$dataset)[1])) 
  })
  
  # Return the requested dataset
  datasetInput <- reactive({
    
    filepath<-paste('~/ShinyApps/mandela/',folder.chosen(),sep="")
    current.corpus <- Corpus(DirSource(filepath), 
                             readerControl = list(language = "eng",encoding = "UTF-8"))
    return(current.corpus)
    
  })
    
  corpus.choice <- reactive(function() {
    if(is.null(datasetInput())) return(NULL)
    b <- datasetInput() 
  })
  
  transform.corpus <- reactive(function() {
    
    b <- corpus.choice()
    
    if(input$lowercase) {
      b <- tm_map(b, tolower) }
    
    if(input$stripwhite) {
      b <- tm_map(b, stripWhitespace) } 
    
    if(input$removepunc) {
      b <- tm_map(b, removePunctuation) }
    
    b <- tm_map(b, removeWords, as.character(unlist(strsplit(input$customstop,",")),mode=list)) # remove user defined words
    
    if(input$stopwords) { 
      b <- tm_map(b, removeWords, stopwords("english")) }
    
    #if(input$stem) { 
    #  b <- tm_map(b, stemDocument) }
    
    tdm <- TermDocumentMatrix(b)
    m1 <- as.matrix(tdm)
    v1 <- sort(rowSums(m1),decreasing=TRUE)
    
    df <- data.frame(word = names(v1),freq=v1)
    
    rowsToKeep <- input$maxwords
    if(nrow(df) > rowsToKeep ) {
      df <- df[1:rowsToKeep,]
    }
    
    
    return(df)
    
  })
  
  
  #generate wordcloud
  output$wordcloudplot <- renderPlot({ 
    
    dt <- transform.corpus()
    wordcloud(dt$word,dt$freq)
    
  })
  
  #generate frequency table
  output$freqtable <- renderTable({ 
    
    dt <- transform.corpus()
    dt <- subset(dt,freq>2)
    rownames(dt) <- NULL
    colnames(dt) <- c("Word","Frequency")
    dt
  })
  
  output$inputtext <- renderText( {
    b <- corpus.choice()
    b[[1]]
  })                           
  
  output$credits <- renderText( {
    t <- "Source for speeches: <a href=\"http://www.nelsonmandela.org/content/page/speeches\">Nelson Mandela Foundation</a>"
    t
  })  
  
  
  formatDownload <- reactive({
    dt <- transform.corpus()
    rownames(dt) <- NULL
    colnames(dt) <- c("Word","Frequency")
    dt       
  })
  
  output$downloadFreq <- downloadHandler(
    filename = function() { paste("Word Cloud Frequencies", '.csv', sep='') },
    content = function(file) {
      write.csv(formatDownload(), file)
    }
  )
  
  
})