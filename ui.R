#ui.R skeleton:
# Load libraries
library(shiny)
library(markdown)

#Define UI
shinyUI(navbarPage("Electric, plug-in hybrid and hybrid cars",
                   
                   #Separate tabs for prediction, plot, data and about
                   tabPanel("Prediction", 
                            fluidPage(
                                    fluidRow(h4(p("Simple prediction of expected saving/spending over 5 years compared to an average car.")),
                                             p("Savings are positive. A greater amount spent yields a negative number."),
                                             p("Check the 'About' tab for more information."),
                                             column(6,
                                                    br(),
                                                    h3("EV and plug-in hybrids"),
                                                    HTML("<div style='height: 150px;'>"),
                                                    imageOutput("image1"),
                                                    HTML("</div>"),
                                                    br(), br(),
                                                    sliderInput("year.pred1", "Model year", min=2010, max=2020, step=1, value=2016, sep=""),
                                                    radioButtons("atvType.pred1", "Car type", list("EV", "Plug-in Hybrid")),
                                                    sliderInput("evMotorElKW.pred1", "Motor kW", min=18, max=375, value=80),
                                                    h4("Predicted US dollar amount:"),
                                                    textOutput("pred1")
                                             ),
                                             column(6,
                                                    br(),
                                                    h3("Hybrids"),
                                                    HTML("<div style='height: 150px;'>"),
                                                    imageOutput("image2"),
                                                    HTML("</div>"),
                                                    br(), br(),
                                                    sliderInput("year.pred2", "Model year", min=2010, max=2020, step=1, value=2016, sep=""),
                                                    radioButtons("evMotorBatteryType.pred2","Battery type", list("Li-Ion","Ni-MH")),
                                                    sliderInput("evMotorBatterySize.pred2","Battery voltage", min=36, max=480, value=80),
                                                    h4("Predicted US dollar amount:"),
                                                    textOutput("pred2")
                                                    
                                             )
                                    )
                            )
                   ),
                   tabPanel("Plot",
                            #Sidebar panel
                            sidebarPanel(
                                    selectInput("atvType", "Car type", list("EV", "Hybrid", "Plug-in Hybrid"), 
                                                multiple=TRUE, selected=c("EV", "Hybrid", "Plug-in Hybrid")),
                                    sliderInput("year", "Model year", min=2010, max=2016, value=c(2010, 2016), sep=""),
                                    selectInput("drive", "Drive", list("Rear-Wheel Drive", "Front-Wheel Drive", "All-Wheel Drive"),
                                                multiple=TRUE, selected=c("Rear-Wheel Drive", "Front-Wheel Drive", "All-Wheel Drive")),
                                    uiOutput("makeBoxes"), # Check boxes for car manufacturers, created on the server side
                                    actionButton("clear", "Clear all", icon = icon("square-o")), 
                                    actionButton("select", "Select all", icon = icon("check-square-o")) 
                                    
                                     ),
                            mainPanel(h5("Savings are positive. A greater amount spent yields a negative number in 'youSaveSpend'"),
                                    plotOutput("youSaveSpendByatvType"),
                                    plotOutput("youSaveSpendByYear")
                            )
                   ),
                   tabPanel("Data", mainPanel(
                            p("Browse the data set which is a manipulated excerpt from vehicles.csv found at fueleconomy.gov. See 'About' tab."),
                            div(dataTableOutput("elcars"), style="font-size:90%")
                   )),
                   tabPanel("About", mainPanel(
                           h3("About this app"),
                           includeMarkdown("about.md")
                           ))

)
)
