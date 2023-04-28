
library(shiny)
library(shinythemes)
library(DT)
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



theme<-"cosmo"

# Define UI
ui <- fluidPage(theme = shinytheme(theme),
                navbarPage(
                  
                  "Cartographe Data Atmo Normandie",
                  tabPanel("Polluants et Substances", 
                           
                         
                           
                           fluidRow( 
                             h3("Tous les polluants...."),
                             DT::dataTableOutput("Table_Poll_Filtre")
                             
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
                  
                  
                  
                  tabPanel("Données ",  
                         fluidRow( 
                           h3("Hello....")  
                         )
                  ), # Navbar 1, tabPanel
                  tabPanel("Media", "This panel is intentionally left blank"),
                  
                  tabPanel("Supports ", "This panel is intentionally left blank")
                  
                ) # navbarPage
) # fluidPage






server <- function(input, output) {

  
  output$Table_Poll_Filtre <- DT::renderDataTable({
    DT::datatable(
      data = polluant,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  
  # Filter data based on selections
  output$Table_Donne_Asso_Poll <- DT::renderDataTable({
    DT::datatable(filtered_data_polluant())
  })
  
 
  
  output$status_filtre <- renderText({
    paste("On cherche...", input$code_filtre_polluant,  sep = " " )
  })
  
  # Fonction de filtrage du second tableau
  # Fonction de filtrage du second tableau
  # Fonction de filtrage du second tableau
  # Fonction de filtrage du second tableau
  filtered_data_polluant <- reactive({
    rows_selected <- input$Table_Poll_Filtre_rows_selected
    if (length(rows_selected) == 0) {
      donnee
    } else {
      v_code_pol_select <- polluant[rows_selected, "code_polluant"][ ,1]
       
      liste_txt=""
      for (pol in v_code_pol_select) {
        if(liste_txt=="")
        {
          liste_txt<-pol
        }
          else {
            liste_txt<-paste(liste_txt,'|',pol)
          }
      }
      selected_code_polluant <- paste(liste_txt, collapse="|")
      
      donnee[grepl(selected_code_polluant, donnee$code_polluant), ]
    }
  })
  
  
  
  
  
  observeEvent(input$Ajouter_Polluant, {
    print("Reception evenement ajout polluant ")
    output$status_page<- renderText("Reception evenement ajout polluant")
    sql_ajout_polluant=paste("insert into atmonormandiedata.polluant (libelle_polluant, code_polluant_lcsqa) values ('",input$Nom_polluant,"','",input$Code_Polluant_lcsqa,"')")
    output$status_page<-renderText(sql_ajout_polluant)
    dbGetQuery(con,sql_ajout_polluant)
    output$status_page<-renderText(paste("Ajout du polluant " , input$Nom_polluant, " ok!"))
    
  })
  

  
  
  
}



# Create Shiny object
shinyApp(ui = ui, server = server)

