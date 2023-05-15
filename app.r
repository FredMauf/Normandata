
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
donnee = dbGetQuery(con, "SELECT * FROM atmonormandiedata.donnee_claire")
donnee_lien = dbGetQuery(con, "SELECT * FROM atmonormandiedata.donnee_lien")
media = dbGetQuery(con, "SELECT * FROM atmonormandiedata.media")

polluant=data.table(polluant)
donnee=data.table(donnee)
media=data.table(media)



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
                             column(2,textInput("Nom_polluant", "Nom du polluant", "") ),
                             column(2, textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", " ") ),
                             column(2, textInput("Date_maj", "Date de mise à jour:", "Date du jour") ),
                             actionButton("Ajouter_Polluant","Ajouter")
                             
                           ) , 
                           fluidRow( 
                             h3("Données Associées avec "), h3(textOutput("tab_pol_lib_polluant_selectionne")),
                            
                             DT::dataTableOutput("Table_Donne_Asso_Poll_polluant" )
                             
                           ) 
                           
                  ),
                  
                  
                  
                  tabPanel("Données ",  
                         fluidRow( 
                           h3("Données Associées avec "), h3(textOutput("tab_don_lib_polluant_selectionne")),
                           DT::dataTableOutput("Table_Donne_Asso_Poll_donnee" ),

                           
                         )
                  ), # Navbar 1, tabPanel
                  tabPanel("Media",  fluidRow( 
                    h3("Media Associées avec "), h3(textOutput("tab_media_lib_polluant_selectionne")))),
                  
                  tabPanel("Supports ", fluidRow( 
                    h3("Media Associées avec "), h3(textOutput("tab_support_lib_polluant_selectionne"))))
                  
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
  output$Table_Donne_Asso_Poll_polluant <- DT::renderDataTable({
    DT::datatable(filtered_data_polluant())
  })
  
  output$Table_Donne_Asso_Poll_donnee <- DT::renderDataTable({
    DT::datatable(filtered_data_polluant())
  })
  
  output$Table_Donne_Asso_Poll_donnee_np1 <- DT::renderDataTable({
    DT::datatable(filtered_data_cible())
  })
  
  

  
  lib_polluant_selectionne <- reactive({
    print(" lib_polluant_selectionne bouge ")
    rows_selected <- input$Table_Poll_Filtre_rows_selected
  
    if (length(rows_selected) == 0) {
      return("Aucun polluant sélectionné")
    } else {
      polluant_selected <- polluant[rows_selected, "libelle_polluant"][ ,1]
      liste_txt=""
      for (pol in polluant_selected) {
        if(liste_txt=="")
        {
          liste_txt<-pol
        }
        else {
          liste_txt<-paste(liste_txt,',',pol)
        }
      return(liste_txt)
      }
    }
  }
  )
  
  output$tab_pol_lib_polluant_selectionne <- renderText({
    lib_polluant_selectionne()
  })
  output$tab_don_lib_polluant_selectionne <- renderText({
    lib_polluant_selectionne()
  })
  output$tab_media_lib_polluant_selectionne <- renderText({
    lib_polluant_selectionne()
  })
    output$tab_support_lib_polluant_selectionne <- renderText({
    lib_polluant_selectionne()
  })
    
    
  

  # Fonction de filtrage du second tableau

  filtered_data_polluant <- reactive({
    rows_selected <- input$Table_DonneeCible_rows_selected
    if (length(rows_selected) == 0) {
      donnee
    } else {
      v_code_pol_select <- polluant[rows_selected, "id_polluant"][ ,1]
       
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
      print(" filtered_data_polluant bouge ")
      donnee[grepl(selected_code_polluant, donnee$id_polluant), ]
    }
  })
  
  filtered_data_cible <- reactive({
    rows_selected <- input$Table_Poll_Filtre_rows_selected
    print(" filtered_data_cible bouge ")
    if (length(rows_selected) == 0) {
      donnee_lien
    } else {
      v_code_pol_select <- donnee[rows_selected, "id_donnee"][ ,1]
      
      liste_txt=""
      for (donnee in v_code_pol_select) {
        if(liste_txt=="")
        {
          liste_txt<-donnee
        }
        else {
          liste_txt<-paste(liste_txt,'|',donnee)
        }
      }
      selected_code_polluant <- paste(liste_txt, collapse="|")
      print(" filtered_data_polluant bouge ")
   
      donnee_lien[grepl(selected_code_polluant, donnee$id_donnee), ]
    }
  }
  )
  
  
  
  
  
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

