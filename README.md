RShinyMandela
=================================================================

Wordcloud generator using R and Shiny for Mandela's Speeches

=================================================================

Example here:
http://glimmer.rstudio.com/benporter/mandela/

=================================================================

Shiny Server expects server.R and ui.R to be in ~/ShinyApps/mandela

The server.R and ui.R code expect a series of directories with the .txt file of the individual speech.  For example, the "We Defy.txt" file should be located at: ~/ShinyApps/mandela/1952/We Defy.txt

Simplying adding a folder of any name and putting a .txt file in that directory will add an option to the drop down menu.  I have noticed that it can take 10+ minutes for the folders to syncronized, don't expect newly added directories and .txt files to show up immediately.

Also, all .txt files should end with a new line character.
