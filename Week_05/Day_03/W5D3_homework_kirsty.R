library(tidyverse)
library(shiny)
# Load data and replace long strings
nyc_dogs <- CodeClanData::nyc_dogs %>% 
  mutate(breed = str_replace(breed,"American Pit Bull Terrier/Pit Bull", "Pit Bull")) %>% 
  mutate(breed = str_replace(breed,"American Pit Bull Mix / Pit Bull Mix", "Pit Bull Mix"))


# Create vector of breeds
breeds <- nyc_dogs %>% 
  distinct(breed) %>%
  arrange(breed) %>% 
  pull()
# Create vector of boroughs
boroughs <- nyc_dogs %>% 
  distinct(borough) %>% 
  arrange(borough) %>% 
  pull()



ui <- fluidPage(
  titlePanel("The Dogs of NYC"),
  tabsetPanel(
    tabPanel( # Tab 1
      title = "Dogs per Borough",
      fluidRow(
        column(
          width = 1,
          offset = 1,
          selectInput(
            inputId = "borough_input",
            label = "NYC Borough",
            choices = boroughs
          )
        ),
        column(
          width = 6,
          plotOutput("breeds_per_borough")
        )
      )
    ),
    tabPanel( # Tab 2
      title = "Count per Breed per Borough",
      fluidRow(
        column(
          width = 2,
          offset = 2,
          selectInput(
            inputId = "borough_input_two",
            label = "NYC Borough",
            choices = boroughs
          ),
          selectInput(
            inputId = "breed_input",
            label = "Breed",
            choices = breeds
          )
        ),
        column(
          width = 4,
          plotOutput("count_per_breed")
        )
      )
    )
  )
)



server <- function(input, output, session) {
  output$breeds_per_borough <- renderPlot({
    nyc_dogs %>% 
      filter(borough == input$borough_input) %>% # filter for input, don't include misc breeds
      filter(breed != "Mixed/Other") %>% 
      group_by(breed) %>% 
      summarise(total_dogs = n()) %>% # count total of breed in borough
      arrange(desc(total_dogs)) %>% 
      head(5) %>%
      ggplot(aes(x = breed, y = total_dogs, fill = breed)) +
      geom_col(show.legend = FALSE) +
      coord_flip() +
      scale_fill_manual(values = c("#1b9e77",
                                   "#d95f02",
                                   "#7570b3",
                                   "#c7295a",
                                   "#4b7b16")) +
      labs(
        x = "Breed\n",
        y = "\nNumber of Dogs",
        title = ifelse(input$borough_input == "Bronx", #as Bronx needs to be stated as the bronx, all other boroughs dont need a "the"
                       paste0("Top 5 Dog Breeds in the ", input$borough_input),
                       paste0("Top 5 Dog Breeds in ", input$borough_input)) 
      ) +
      theme_minimal(base_size = 12) +
      theme(axis.text = element_text(size = 16, colour = "black"),
            axis.title = element_text(size = 14, colour = "grey26"),
            plot.title = element_text(size = 18, colour = "black", face = "bold"))
  })
  output$count_per_breed <- renderPlot({
    nyc_dogs %>% 
      filter(borough == input$borough_input_two) %>%  
      filter(breed == input$breed_input) %>%
      group_by(gender) %>% 
      summarise(total_dogs = n()) %>% 
      ggplot(aes(x = "", y = total_dogs, fill = gender)) +
      geom_col() +
      scale_fill_manual(values = c("#d95f02","#1b9e77")) +
      labs(
        x = ifelse(grepl("[mM]ix$", input$breed_input), paste0(input$breed_input, "es"), paste0(input$breed_input, "s")), # adds "es" to mix to create mixes
        y = "Count\n",
        title = ifelse(grepl("[mM]ix$", input$breed_input),
                       ifelse(input$borough_input_two == "Bronx", 
                              paste0("Number of ", input$breed_input,"es in the ",input$borough_input_two), # fixes "mixes" and "Bronx" transformations as above
                              paste0("Number of ", input$breed_input,"es in ",input$borough_input_two)),
                       ifelse(input$borough_input_two == "Bronx", 
                              paste0("Number of ", input$breed_input,"s in the ",input$borough_input_two),
                              paste0("Number of ", input$breed_input,"s in ",input$borough_input_two))
        ),
        fill = "Gender"
      ) +
      theme_minimal(base_size = 12) +
      theme(axis.text = element_text(size = 16, colour = "black"),
            axis.title = element_text(size = 14, colour = "grey26"),
            plot.title = element_text(size = 18, colour = "black", face = "bold"))
    
  })
  
}



shinyApp(ui, server)
