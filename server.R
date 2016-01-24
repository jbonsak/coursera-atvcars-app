#server.R 

# Load libraries
library(shiny)

# Read data file (se how elcars.csv was prepared in '.\code\data download.R')
elcars <- read.csv('data/elcars.csv')
initialMakeValues <- sort(unique(as.character(elcars$make)))
saverange <- c(min(elcars$youSaveSpend), max(elcars$youSaveSpend))

# Fit simple linear model for electric and plug-hybrids
ev_phev_model <- lm(youSaveSpend ~ atvType + year + evMotorElKW,
                    data=subset(elcars, atvType %in% c('EV', 'Plug-in Hybrid'))
                    )

# Prediction function to be used by shinyServer
evphevPred <- function(newpreddata1){
        pr1 <- cat(predict(ev_phev_model, newdata=newpreddata1))
        }

# Fit similar model for hybrid cars
hybrid_model <- lm(youSaveSpend ~ year + evMotorBatterySize + evMotorBatteryType,
                   data=subset(elcars, atvType == 'Hybrid')
                   )

# Prediction function for hybrid cars
hybridPred <- function(newpreddata2){
        pr2 <- cat(predict(hybrid_model, newdata=newpreddata2))
        }


# Running server function
shinyServer(
        function(input, output) {
                # Define and initialize reactive values 
                values <- reactiveValues() 
                values$make <- initialMakeValues
                
                # One checkbox per car manufacturer
                output$makeBoxes <- renderUI({ 
                        checkboxGroupInput('make', 'Car manufacturers', initialMakeValues, selected=values$make)
                        }) 
                
                # Observe and take action on button clicks 
                # The buttons don't reset properly - workaround's a bit complex, so I let them behave like that here
                observeEvent(input$clear, {values$make <- c()}) 
                observeEvent(input$select, {values$make <- initialMakeValues}) 
                
                # Dataset filtered by input from sidebar panel
                plotdata <- reactive({
                        pd <- subset(elcars, year >= input$year[1] &
                                             year <= input$year[2] &
                                             atvType %in% input$atvType &
                                             drive %in% input$drive &
                                             make %in% input$make
                                     )[, c(4,7,2)] #year, atvType and youSaveSpend
                        pd <- droplevels(pd) # Drop unused factor levels
                        return(pd)
                        })
                
                # Plot saving by atvType
                output$youSaveSpendByatvType <- renderPlot({
                        if(nrow(plotdata())>0)
                        boxplot(youSaveSpend~atvType, data=plotdata(), main="Savings by car technology type",
                                ylab="youSaveSpend")
                        })
                
                # Plot saving by year
                output$youSaveSpendByYear <- renderPlot({
                        if(nrow(plotdata())>0)
                        boxplot(youSaveSpend~year, data=plotdata(), main="Savings by car model year",
                                ylab="youSaveSpend")
                })
                
                
                # Data table browser for the Data tab
                output$elcars <- renderDataTable(elcars, options=list(pageLength=10))
                
                
                # Prediction for electric cars and plug-in hybrids
                newpreddata1 <- reactive({df<-data.frame(atvType=input$atvType.pred1, 
                                                         year=input$year.pred1, 
                                                         evMotorElKW=input$evMotorElKW.pred1)})
                
                output$pred1 <- renderPrint(evphevPred(newpreddata1()))
                
                # Prediction for hybrids
                newpreddata2 <- reactive({df<-data.frame(year=input$year.pred2, 
                                                         evMotorBatterySize=input$evMotorBatterySize.pred2, 
                                                         evMotorBatteryType=input$evMotorBatteryType.pred2)})
                
                output$pred2 <- renderPrint(hybridPred(newpreddata2()))
                
                # Images to liven up prediction tab: EV and plug-ins
                output$image1 <- renderImage({
                        if (input$evMotorElKW.pred1 <= 120) {
                                return(list(src = "www/mitsubishii-miev.jpg", contentType = "image/jpeg", alt = "Mitsubishi i-Miev"))
                        } else if (input$evMotorElKW.pred1 <= 260){
                                return(list(src = "www/bmwi3bev.jpg", filetype = "image/jpeg", contentType="image/pjeg", alt = "BMW i3 BEV" ))
                        } else {
                                return(list(src = "www/teslax.jpg", filetype = "image/jpeg", contentType="image/pjeg", alt = "Tesla Model X" ))
                        }
                }, deleteFile=FALSE)
                
                # Images for prediction tab: Hybrid
                output$image2 <- renderImage({
                        if (input$evMotorBatterySize.pred2 <= 170) {
                                return(list(src = "www/lexusct200h.jpg", contentType = "image/jpeg", alt = "Lexus CT200h"))
                        } else if (input$evMotorBatterySize.pred2 <= 350) {
                                return(list(src = "www/caddilacelr.jpg", filetype = "image/jpeg", contentType="image/pjeg", alt = "Caddilac ELR"))
                        } else {
                                return(list(src = "www/laferrari.jpg", filetype = "image/jpeg", contentType="image/pjeg", alt = "LaFerrari"))
                        }
                }, deleteFile=FALSE)

        }
)