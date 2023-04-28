 
# Load R packages
library(shiny)
library(shinythemes)

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
                             DT::dataTableOutput("Table_Donne_Asso_Poll" )
                             
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
  
 
   # Filter data based on selections
    output$Table_Poll_Filtre <- DT::renderDataTable(DT::datatable({
      DT = data.table(
        Code_Polluant = c("1","5","9","3","72","25"),
        Libelle_Polluant = c("Soufre","PM 2.5","Ozone","Pm10","NO2","Methane"),
        Lien_Consulter =  c("Consulter","Consulter")
        
        )
      DT
    }))
    
    # Filter data based on selections
    output$Table_Donne_Asso_Poll <- DT::renderDataTable(DT::datatable({
      DT2 = data.table(
        Code_donnee = c("D99","D89"),
        Type_Donnee = c("Elaborée","Mesurée"),
        Titre_Donnée =c("Nb Depassagement 120µg/8h","Moyenne 1/4h O3"),
        Maturite_Donnée =  c("Consulter","Consulter")
      )
      DT2
    }))
   
}



# Create Shiny object
shinyApp(ui = ui, server = server)

