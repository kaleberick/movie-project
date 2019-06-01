# This loads the required packages for the app
library(shiny)
library(colorRamps)
library(scales)


# This reads in the data required and initializes the model that will be used to predict. 
movies <- read.csv('movie_dataset.csv', header= TRUE, stringsAsFactors = TRUE)
movie_predict <- glm(log(gross_adj) ~ log(budget) +  rating + season + widest_opening, data=movies)


# Define UI for the Box Office app
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Box Office Projections"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    
    h2("Use this app to predict the domestic box office earnings for a movie!"),
    
    br(),
    
    p("Select a budget, the widest theater opening, the rating, and the release season to see the predicted earnings:"),
    
    br(),
    
    # This sets up the slider to select a budget
    sliderInput('budget', 'Movie Budget:', min=1000000, max=400000000,
                value=min(1000000, 400000000), step=100000, round=0),
    
    # This sets up the slider to select the widest theater opening
    sliderInput('widest_opening', 'Widest Theater Opening:', min=500, max=5000,
                value=min(500, 5000), step=100, round=0),
    
    # This creates the input selector for the movie's rating
    selectInput("rating", "Rating:", 
                c("G" = "G",
                  "PG" = "PG",
                  "PG-13" = "PG-13",
                  "R" = "R")),
    
    # This creates the input selector for the release season
    selectInput("season", "Season:",
                c("Spring" = "Spring",
                  "Summer" = "Summer",
                  "Fall" = "Fall",
                  "Winter" = "Winter")),
    
    
    # Below are some examples
    h4("Here are some example films:"),
    strong("Antz (1998)"),
    p('Budget: $105 million, Widest Opening: 2,929, Rating: PG, Season: Fall'),
    p('Predicted Domestic Earnings: $186,714,985'),
    p('Actual Domestic Earnings: $174,355,724'),
    
    
    strong("Monsters Vs. Aliens (2009)"),
    p('Budget: $175 million, Widest Opening: 4,136, Rating: PG, Season: Spring'),
    p('Predicted Domestic Earinings: $247,447,582'),
    p('Actual Domestic Earnings: $238,286,299'),
    
    strong("Dunkirk (2017)"),
    p('Budget: $100 million, Widest Opening: 4,014, Rating: PG-13, Season: Summer'),
    p('Predicted Domestic Earinings: $229,087,452'),
    p('Actual Domestic Earnings: $190,586,777')
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # This places the text and histograms on the main section of the app. 
    h1(textOutput("predicted_box")),
    br(),
    br(),
    br(),
    strong("Below are some histograms that show the distribution of box office earnings across film ratings and throughout the year."),
    br(),
    p("These aren't related to the prediction, but are controlled by the selected Rating and Season on the left."),
    br(),
    br(),
    h3(textOutput("caption")),
    
    
    plotOutput("ratingsplot"),
    
    h3(textOutput('caption2')),
    
    plotOutput('seasonplot')
    
  )
)

# This defines the server function, which control the calculations and plotting happening behind the scenes. 
server <- function(input, output) {
  
  
  
  
  # This takes the values from the sliders and inputs and puts them in the predictive model.
  predictedText <- reactive({
    prediction <- predict(movie_predict, data.frame(budget = input$budget,rating = input$rating,
                                                    season = input$season, widest_opening = input$widest_opening))
    predicted_value <- exp(prediction)
    paste("For the selected values, the predicted box office earnings is ",dollar(predicted_value))
  })
  
  output$predicted_box <- renderText({
    predictedText()
  })
  
  
  # This creates the histogram that shows the distribution of earnings for different film ratings
  formulaText <- reactive({
    paste("Distribution of earnings for films rated ",input$rating)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  output$ratingsplot <- renderPlot({
    hist(movies[movies$rating==input$rating,]$gross_adj,xaxt='n',xlab='Adjusted Earnings',
         xlim=c(0,1000000000),freq=FALSE,main=NULL,col=matlab.like(8))
    axis(1, at=c(0,2e8,4e8,6e8,8e8,1e9),labels=c('$0','$200 mil','$400 mil','$600 mil','$800 mil','$1 billion'))
  })
  
  
  # This creates the histogram that shows the distribution of earnings for different release seasons. 
  formulaText2 <- reactive({
    paste("Distribution of earnings for films released in ",input$season)
  })
  
  output$caption2 <- renderText({
    formulaText2()
  })
  
  output$seasonplot <- renderPlot({
    hist(movies[movies$season==input$season,]$gross_adj,xaxt='n',xlab='Adjusted Earnings',
         xlim=c(0,1000000000),freq=FALSE,main=NULL,col=matlab.like2(8))
    axis(1, at=c(0,2e8,4e8,6e8,8e8,1e9),labels=c('$0','$200 mil','$400 mil','$600 mil','$800 mil','$1 billion'))
  })
  
}

# The code below uses the ui and server functions (written above) to assemble the shiny app. 
# Run this code to build the app locally through R. 
# Alternatively, if you are using R-Studio, you can click the "Run App" button in the top-right corner of this screen. 
shinyApp(ui, server)