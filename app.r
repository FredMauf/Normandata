
library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)
library(data.table)
library(RPostgres)
library(DBI)

print("connecting to....")
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = "localhost",
  port = "5432",
  password = "123",
  user = "postgres")

print("connecté! ")
raw_polluant <- dbGetQuery(con, "SELECT * FROM si.polluant")
raw_donnee <- dbGetQuery(con, "SELECT * FROM si.donnee_claire")
raw_donnee_lien <- dbGetQuery(con, "SELECT * FROM si.donnee_lien")
raw_media <- dbGetQuery(con, "SELECT * FROM si.media")
raw_publication <- dbGetQuery(con, "SELECT * FROM si.publication")

polluant <- data.table(raw_polluant)
donnee <- data.table(raw_donnee)
donnee_lien <- data.table(raw_donnee_lien)
media <- data.table(raw_media)
publication <- data.table(raw_publication)



theme <- "cosmo"

# Define UI
ui <- fluidPage(
  theme = shinytheme(theme),
  navbarPage(
    "Cartographe Data Atmo Normandie",
    tabPanel(
      "Polluants et Substances",
      fluidRow(
        h3("Tous les polluants"),
        DT::dataTableOutput("Table_Polluant")) ,
      fluidRow(
        column(2,h3("Fiche Polluant")),
        column(2,textInput("Nom_polluant", "Nom du polluant", "")),
        column(2, textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", " ")),
        column(2, textInput("Date_maj", "Date de mise à jour:", "Date du jour")),
        actionButton("Ajouter_Polluant","Ajouter")
      ) ,
      fluidRow(h3("Données Associées avec "),
               h3(textOutput("tab_pol_lib_polluant_selectionne")),
               DT::dataTableOutput("Table_Donnee_poll"),
               )
      ),
    tabPanel("Données",
             fluidRow(
               h3("Données Associées avec "), 
               DT::dataTableOutput("Table_Donnee_Maitre"))
             )
    ), # Navbar 1, tabPanel
    tabPanel("Media",
             fluidRow(
               h3("Media Associées avec "),
               DT::dataTableOutput("Table_Media")))
    ,
    tabPanel("Supports de Publication ",
             fluidRow(
               h3("Supports de publication avec "),
               DT::dataTableOutput("Table_Publication")))
  ) # navbarPage
) # fluidPage

server <- function(input, output) {
  output$Table_Polluant <- DT::renderDataTable({
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
  
  output$Table_Donnee_poll <- DT::renderDataTable({
    DT::datatable(
      data = donnee,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  output$Table_Donnee_Maitre <- DT::renderDataTable({
    DT::datatable(
      data = donnee,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  output$Table_Donnee_Lien <- DT::renderDataTable({
    DT::datatable(
      data = donnee,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  output$Table_Media <- DT::renderDataTable({
    DT::datatable(
      data = media,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  output$Table_Publication <- DT::renderDataTable({
    DT::datatable(
      data = publication,
      options = list(
        dom = 't',
        pageLength = 10,
        select = list(style = "single")
      ),
      rownames = FALSE
    )
  })
  # Filter data based on selections
  output$Table_Donnee_Asso_Poll_polluant <- DT::renderDataTable({
    DT::datatable(filtered_data_polluant())
  })
  lib_polluant_selectionne <- reactive({
    print(" lib_polluant_selectionne bouge ")
    print(Sys.time())
    rows_selected <- input$Table_Polluant_rows_selected
    if (length(rows_selected) == 0) {
      return("Aucun polluant sélectionné")
    } else {
      polluant_selected <- polluant[rows_selected, "libelle_polluant"][ ,1]
      liste_txt=""
      for (pol in polluant_selected) {
        if(liste_txt=="")
        {
          liste_txt<-pol # nolint
        }
        else {
          liste_txt<-paste(liste_txt,',',pol)
        }
      }
      print(liste_txt)
      return(liste_txt)
    }
  }
  )
  
  
  lib_donnee_selectionne <- reactive({
    print(" lib_donnee_selectionne bouge ")
    print(Sys.time())
    rows_selected <- input$Table_Donnee_rows_selected
    if (length(rows_selected) == 0) {
      return("Aucune donnee sélectionné")
    } else {
      donnee_selected <- donnee[rows_selected, "libelle_donnee"][ ,1]
      liste_txt=""
      for (donnne in donnee_selected) {
        if(liste_txt=="")
        {
          liste_txt<-donnne
        }
        else {
          liste_txt<-paste(liste_txt,',',donnne)
        }
      }
      print(liste_txt)
      return(liste_txt)
    }
  }
  )
  
  output$tab_pol_lib_polluant_selectionne <- renderText({
    print("lib_polluant_selectionne bouge")
    lib_polluant_selectionne()
  })
  output$tab_donnee_lib_donee_selectionne <- renderText({
    print("lib_donnee_selectionne bouge")
    lib_donnee_selectionne()
  })
  
  # Fonction de filtrage du second tableau
  
  filtered_data_polluant <- reactive({
    rows_selected <- input$Table_Donnee_rows_selected
    print(" filtered_data_polluant bouge ")
    print(Sys.time())
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
      
      donnee[grepl(selected_code_polluant, donnee$id_polluant), ]
    }
  })
  
  filtered_data_cible <- reactive({
    rows_selected <- input$Table_Polluant_rows_selected
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

