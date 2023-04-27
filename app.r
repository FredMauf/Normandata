 

# Load R packages
library(shiny)
library(shinythemes)
library(ggplot2)
library(data.table)
library(RPostgreSQL)
library(DBI)

theme<-"cosmo"

# Define UI
ui <- fluidPage(theme = shinytheme(theme),
                navbarPage(
                   
                  "Cartographe Data Atmo Normandie",
                  tabPanel("Polluants et Substances",  
                           fluidRow( 
                             
                             textInput("txt_filtre_polluant", "Recherche libre:", "Ozone"),
                              
                           ), 
                           fluidRow( 
                             column(2,h3("Fiche Polluant") ),
                             column(2,textInput("txt_filtre_polluant", "Nom du polluant", "Ozone") ),
                             column(2, textInput("txt_filtre_polluant", "Code Polluant LCSQA", "XX") ),
                             column(2, textInput("txt_filtre_polluant", "Code POlluant UE:", "7") ),
                             column(2, textInput("txt_filtre_polluant", "Date de mise à jour:", "") )
                            
                           ) , 
                           fluidRow( 
                             h3("Données Associées.avec le polluant XXX"),
                             DT::dataTableOutput("Table_Donne_Asso_Poll")
                             
                           ) ,
                           
                           fluidRow( 
                             h3("Tous les polluants...."),
                             DT::dataTableOutput("Table_Poll_Filtre")
                             
                           ) 
                  ),
                           
                           
                           
                  tabPanel("Données ",
                           sidebarPanel(
                             tags$h3("Input:"),
                             textInput("txt1", "Given Name:", ""),
                             textInput("txt2", "Surname:", ""),
                             
                           ), # sidebarPanel
                           mainPanel(
                             h1("Header 1"),
                             
                             h4("Output 1"),
                             verbatimTextOutput("txtout"),
                             
                           ) # mainPanel
                           
                  ), # Navbar 1, tabPanel
                  tabPanel("Media", "This panel is intentionally left blank"),
                  
                  tabPanel("Supports ", "This panel is intentionally left blank")
                  
                ) # navbarPage
) # fluidPage


# Define server function 


 server <- function(input, output) {
    
    output$txtout <- renderText({
      paste( input$txt1, input$txt2, sep = " " )
    })
  } # server
  

server <- function(input, output) {
 
   # Filter data based on selections
    output$Table_Poll_Filtre <- DT::renderDataTable(DT::datatable({
      DT = data.table(
        Code_Polluant = c("1","5","9","3","72","25"),
        Libelle_Polluant = c("Soufre","PM 2.5","Ozone","Pm10","NO2","Methane"),
        Lien_Consulter =  c("Consulter","Consulter")
        
        )
       
    }))
    
    # Filter data based on selections
    output$Table_Donne_Asso_Poll <- DT::renderDataTable(DT::datatable({
      DT2 = data.table(
        Code_donnee = c("D99","D89"),
        Type_Donnee = c("Elaborée","Mesurée"),
        Titre_Donnée =c("Nb Depassagement 120µg/8h","Moyenne 1/4h O3"),
        Maturite_Donnée =  c("Consulter","Consulter")
      )
       
    }))
   
}
  
  

# Create Shiny object
shinyApp(ui = ui, server = server)
 
