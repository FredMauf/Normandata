 
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
                             h3("Hello....") 
                            
                           ),
                           
                           fluidRow( 
                             h3("Tous les polluants...."),
                             DT::dataTableOutput("Table_Poll_Filtre"  )

                           ) ,
                           
                           
                           fluidRow( 
                             column(2,h3("Fiche Polluant") ),
                             column(2,textInput("Nom_polluant", "Nom du polluant", "AJout ICI") ),
                             column(2, textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", "AJout ICI") ),

                             column(2, textInput("Date_maj", "Date de mise à jour:", "") ),
                             actionButton("Ajouter_Polluant","Ajouter")
                            
                           ) , 
                           fluidRow( 
                             h3("Données Associées.avec le polluant XXX"),
                             DT::dataTableOutput("Table_Donne_Asso_Poll" )
                             
                           ) 

                  ),
                           

                           
                  tabPanel("Données ",  "This panel is intentionally left blank"
                            
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

   # Filter data based on selections
    output$Table_Poll_Filtre <- DT::renderDataTable(DT::datatable({
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
    
    observeEvent(input$Table_Donne_Asso_Poll_cell_clicked, {
      print("Je suis dans Observe Envement table donnee")
       
      print(input$Table_Donne_Asso_Poll_cell_clicked)
      
      
    })
    
    observeEvent(input$Table_Poll_Filtre_cell_clicked, {
      print("Je suis dans Observe Envement table polluant")
      
      print(input$Table_Poll_Filtre_cell_clicked)
      
      
    })
    
     
    
}
  
  

# Create Shiny object
shinyApp(ui = ui, server = server)
 
