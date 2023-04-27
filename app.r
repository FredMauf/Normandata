####################################
# Data Professor                   #
# http://youtube.com/dataprofessor #
# http://github.com/dataprofessor  #
####################################

# Modified from Winston Chang, 
# https://shiny.rstudio.com/gallery/shiny-theme-selector.html

# Concepts about Reactive programming used by Shiny, 
# https://shiny.rstudio.com/articles/reactivity-overview.html

# Load R packages
library(shiny)
library(shinythemes)
library(DT)

theme<-"cosmo"

# Define UI
ui <- fluidPage(theme = shinytheme(theme),
                navbarPage(
                   
                  "Cartographe Data Atmo Normandie",
                  tabPanel("Polluants et Substances",  
                           fluidRow( 
                             
                             textInput("code_filtre_polluant", "Recherche libre:", "Ozone"),
                             verbatimTextOutput("status_filtre"),
                             verbatimTextOutput("status_page"),
                           ), 
                           fluidRow( 
                             column(2,h3("Fiche Polluant") ),
                             column(2,textInput("Nom_polluant", "Nom du polluant", "Ozone") ),
                             column(2, textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", "XX") ),
                            
                             column(2, textInput("Date_maj", "Date de mise à jour:", "") ),
                             actionButton("Ajouter_Polluant","Ajouter")
                            
                           ) , 
                           fluidRow( 
                             h3("Données Associées.avec le polluant XXX"),
                             DT::dataTableOutput("Table_Donne_Asso_Poll" )
                             
                           ) ,
                           
                           fluidRow( 
                             h3("Tous les polluants...."),
                             DT::dataTableOutput("Table_Poll_Filtre"  )
                             
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
  library(ggplot2)
  library(data.table)
  library(RPostgres)
  library(DBI)
  
  print("connecting to....")
  con<-dbConnect(
    RPostgres::Postgres(),
    dbname = "postgres",
    host = "localhost",
    port = "5432",
    password = "123",
    user = "postgres" 
     
  )
  print("connecté! ")
  polluant = dbGetQuery(con, "SELECT * FROM atmonormandiedata.polluant")
  donnee = dbGetQuery(con, "SELECT * FROM atmonormandiedata.donnee")
  
  polluant=data.table(polluant)
  donnee=data.table(donnee)
  print(donnee)
  
 
   # Filter data based on selections
    output$Table_Poll_Filtre <- DT::renderDataTable(DT::datatable({
      print("Contenu des filtres")
      print(input$code_filtre_polluant)
      
      DT_polluant =  polluant 
      DT_polluant
    }))
    
    # Filter data based on selections
    output$Table_Donne_Asso_Poll <- DT::renderDataTable(DT::datatable({
      DT_donnee =  donnee  
       
      DT_donnee
    }))
    
    output$status_filtre <- renderText({
      paste("On cherche...", input$code_filtre_polluant,  sep = " " )
    })
   
    
    observeEvent(input$Ajouter_Polluant, {
      print("Reception evenement ajout polluant ")
      output$status_page<- renderText("Reception evenement ajout polluant")
      sql_ajout_polluant=paste("insert into atmonormandiedata.polluant (libelle_polluant, code_polluant_lcsqa) values ('",input$Nom_polluant,"','",input$Code_Polluant_lcsqa,"')")
      output$status_page<-renderText(sql_ajout_polluant)
      dbGetQuery(con,sql_ajout_polluant)
      output$status_page<-renderText(paste("Ajout du polluant " , input$Nom_polluant, " ok!"))
      
      
    })
    
    #observe(input$Table_Donne_Asso_Poll_cell_clicked, {
    #  print("je filtre une donnee")
    #  print(input$Table_Donne_Asso_Poll_cell_clicked)
    #})
    
    #observe(input$Table_Poll_Filtre_cell_clicked, {
    #  print("je filtre un polluant")
    #  print(input$Table_Poll_Filtre_cell_clicked)
    #})
      
    
}
  
  

# Create Shiny object
shinyApp(ui = ui, server = server)
 
