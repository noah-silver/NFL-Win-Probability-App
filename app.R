library(shiny)

ui <- fluidPage(
  titlePanel("NFL Home Team Win Probability"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "season",
                  label = "Season",
                  choices = c(2000:2021), 
                  multiple = F,
                  selected = 2021),
    selectInput(inputId = "home",
                label = "Select Team to View Home Schedule",
                choices = c(nflfastR::teams_colors_logos$team_abbr),
                multiple = F,
                selected = "TEN"),
    selectInput(inputId = "away",
                label = "Select Opponent to Model Win Probability",
                choices = c(nflfastR::teams_colors_logos$team_abbr),
                multiple = F,
                selected = "ARI"),
    selectInput(inputId = "game",
                label = "Week",
                choices = c("01","02","03","04","05","06","07","08","09",10:22),
                multiple = F,
                selected = 01)
    ),
    
    mainPanel(  
      tabsetPanel(
      tabPanel("Schedule", tableOutput("schedule")), 
      tabPanel("Win Probability", plotOutput("plot"))
    )
  )
)
)

# Build ridge plot
server <- function(input, output) {
  library(tidyverse)
  library(scales)
  library(nflfastR)
  library(ggridges)
  library(nflreadr)
  library(ggplot2)
  
  pbp <- reactive({load_pbp(seasons = as.numeric(input$season), file_type = "rds")})
  schedule <-  reactive({load_schedules(seasons = as.numeric(input$season)) %>% filter(home_team == input$home) %>% 
      select(week, home_team, away_team)}) 

  output$schedule <- renderTable(schedule())
  
  
  gamecode <- reactive({paste0(input$season, "_", input$game, "_", input$away, "_", input$home)})
  game_of_interest <-   reactive({pbp() %>% filter(game_id == gamecode())}) 
  
  
  
  
  
  output$plot <- renderPlot({
    ggplot(game_of_interest(), aes(x = home_wp, y = as.factor(qtr)))+
      geom_density_ridges(alpha = 0.5)+
      ggtitle(paste(input$home, "Win Probability vs.", input$away, sep = " "),
              subtitle = paste(input$season, ", Week ", input$game, sep = ""))+
      xlab("Win Probability")+
      ylab("Quarter")+
      theme_minimal()+
      theme(legend.position = "none")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

