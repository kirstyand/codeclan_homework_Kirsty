library(tidyverse)
library(shiny)
library(shinyWidgets) 
library(bslib)
source('helpers.R')



ui <- fluidPage(theme = bs_theme(bootswatch = "litera"),
  
  
  fluidRow(
    
    column(
      width = 3,
      pickerInput(inputId = "platform_input",
                  label = "Platform:",
                  choices = c(list("Microsoft" = microsoft,
                                   "Nintendo" = nintendo,
                                   "Sony" = sony,
                                   "Other" = other)),
                 
                  options = pickerOptions(actionsBox = TRUE),
                             multiple = TRUE)),
                    
      
      
      
    
  
  column(
    width = 3,
    pickerInput(inputId = "genre_input",
                   label = "Genre:",
                   choices = genres,
                options = pickerOptions(actionsBox = TRUE),
                multiple = TRUE)
                   
    ),
  
  column(
    width = 3,
    actionButton(inputId = 'search',
                 label = 'search'
    )
  )
),


plotOutput("games_plot")
)


server <- function(input, output, session) {
 
  
  filtered_data <- eventReactive(eventExpr = input$search,
                                 valueExpr = {
                                   game_sales %>% 
                                     filter(platform == c(input$platform_input),
                                            genre == input$genre_input)  %>%
                                     arrange((name))
                                 })
  
  
  
  
  output$games_plot <- renderPlot({
    filtered_data() %>%
      ggplot(aes(x = forcats::fct_rev(name), y = critic_score, fill = platform)) +
      geom_col() +
      coord_flip(expand = FALSE) +
      labs(
        x = "Game\n",
        y = "\nCritic's Score",
        fill = "Platform",
        title = "Critic's Game Scores per Platform") +
      theme_minimal() +
      scale_fill_brewer(palette = "Dark2") +
      theme(axis.text = element_text(size = 14, face = "bold"),
            axis.title = element_text(size = 14)) 
 # I thought it would be useful for the user to be able to view the critic's scores for each game based on their selection of platform and genre.     
    
    
  })
  
}
  
  
  shinyApp(ui = ui, server = server)
  
  