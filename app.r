
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
raw_donnee <- dbGetQuery(con, "SELECT * FROM si.donnee_clair")
raw_donnee_lien_source <- dbGetQuery(con, "SELECT * FROM si.donnee_lien_clair")
raw_donnee_lien_cible <- dbGetQuery(con, "SELECT * FROM si.donnee_lien_clair")
raw_media <- dbGetQuery(con, "SELECT * FROM si.media_clair")
raw_media_donnee <- dbGetQuery(con, "SELECT * FROM si.media_donnee_clair")

raw_publication_media <- dbGetQuery(con, "SELECT * FROM si.media_publication_clair")
raw_publication <- dbGetQuery(con, "SELECT * FROM si.publication_clair")


polluant <- data.table(raw_polluant)
donnee<-raw_donnee
donnee_lien_source <- data.table(raw_donnee_lien_source)
donnee_lien_cible <- data.table(raw_donnee_lien_cible)
media <- data.table(raw_media)
media_donnee <- data.table(raw_media_donnee)
media_publication <- data.table(raw_publication_media)
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
      fluidRow(h3("Données Associées avec "),
               DT::dataTableOutput("Table_Donnee_polluant")
      )
    ),
    tabPanel("Données",
             fluidRow(
               h3("Données Associées "),
               DT::dataTableOutput("Table_Donnee_Maitre"),
               h3("Donnees en entree "),
               DT::dataTableOutput("Table_Donnee_Lien_source"),
               h3("Donnees en sortie "),
               DT::dataTableOutput("Table_Donnee_Lien_cible"))
    ),
    # Navbar 1, tabPanel
    tabPanel("Media",
             fluidRow(
               h3("Media et Documents publiés "),
               DT::dataTableOutput("Table_Media"),
               h3("Donnees contenues "),
               DT::dataTableOutput("Table_Media_Donnee")
             )),
    
    tabPanel("Supports de Publication ",
             fluidRow(
               h3("Supports de publication"),
               DT::dataTableOutput("Table_Publication"),
               h3("Medias contenus dans les publications"),
               DT::dataTableOutput("Table_Publication_Media")
             )),
    tabPanel("Ajouter des données ",
             fluidRow(
               column(2,h3("Fiche Polluant")),
               column(2,textInput("Nom_polluant", "Nom du polluant", "")),
               column(2, textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", " ")),
               column(2, textInput("Date_maj", "Date de mise à jour:", "Date du jour")),
               actionButton("Ajouter_Polluant","Ajouter")
             ))
  ) # navbarPage
) # fluidPage

server <- function(input, output) {
  
  data_donnnee_clair <- reactive({
    
    s <- input$Table_Polluant_rows_selected
    
    if(!is.null(s))
      
      raw_donnee <<- dbGetQuery(con, paste0("SELECT * FROM si.donnee_clair where id_polluant in (",paste(raw_polluant[s,1],collapse=","),")"))
    
    else
      raw_donnee <<- dbGetQuery(con, "SELECT * FROM si.donnee_clair")
    
    return(raw_donnee)
    
  })
  
  data_donnee_lien_source<- reactive({
    
    s <- input$Table_Donnee_Maitre_rows_selected
    cat(file=stderr(), "la ligne  ", s, "Du tableau maitre est choisie", "\n")
    cat(file=stderr(), "ca veut dire id donnee vaut ", raw_donnee[s,1], " ", "\n")
    
    if(!is.null(s))
      
     
      
      raw_donnee_lien_source <<- dbGetQuery(con, paste0("SELECT * FROM si.donnee_lien_clair where id_donnee_cible in (",paste(raw_donnee[s,1],collapse=","),")"))
    
    else
      raw_donnee_lien_source <<- dbGetQuery(con, "SELECT * FROM si.donnee_lien_clair")
    
    return(raw_donnee_lien_source)
    
  })
  
  data_donnee_lien_cible<- reactive({
    
    s <- input$Table_Donnee_Maitre_rows_selected
    
    if(!is.null(s))
      
      raw_donnee_lien_cible <<- dbGetQuery(con, paste0("SELECT * FROM si.donnee_lien_clair where id_donnee_source in (",paste(raw_donnee[s,1],collapse=","),")"))
    
    else
      raw_donnee_lien_cible <<- dbGetQuery(con, "SELECT * FROM si.donnee_lien_clair")
    
    return(raw_donnee_lien_cible)
    
  })
  
  data_media_donnee_selectionnee <- reactive({
    
    s <- input$Table_Donnee_Maitre_rows_selected
    
    if(!is.null(s))
      
      raw_media_donnee <<- dbGetQuery(con, paste0("SELECT * FROM si.media_donnee_clair where id_donnee in (",paste(raw_donnee[s,1],collapse=","),")"))
    
    else
      raw_media_donnee <<- dbGetQuery(con, "SELECT * FROM  si.media_donnee_clair") 
    
    return(raw_media_donnee)
    
  })
  
  data_media_selectionne<- reactive({
    
    s <- input$Table_Media_Donnee_rows_selected
    
    if(!is.null(s))
      
      raw_media <<- dbGetQuery(con, paste0("SELECT * FROM si.media_clair where id_media in (",paste(raw_media_donnee[s,7],collapse=","),")"))
    
    else
      raw_media <<- dbGetQuery(con, "SELECT * FROM si.media_clair")
    
    return(raw_media)
    
  })
  
  
  output$Table_Polluant <- DT::renderDataTable({
    DT::datatable(
      data <- polluant
    )
  })
  output$Table_Donnee_polluant <- DT::renderDataTable({
    DT::datatable(
      data <- data_donnnee_clair()
    )
  })
  output$Table_Donnee_Maitre <- DT::renderDataTable({
    DT::datatable(
      data <- data_donnnee_clair()
    )
  })
  output$Table_Donnee_Lien_source <- DT::renderDataTable({
    DT::datatable(
      data <- data_donnee_lien_source()
    )
  })
  output$Table_Donnee_Lien_cible <- DT::renderDataTable({
    DT::datatable(
      data <- data_donnee_lien_cible()
    )
  })
  
  output$Table_Media <- DT::renderDataTable({
    DT::datatable(
      data <- data_media_selectionne()
    )
  })
  output$Table_Media_Donnee <- DT::renderDataTable({
    DT::datatable(
      data <- data_media_donnee_selectionnee()
    )
  })
  output$Table_Publication <- DT::renderDataTable({
    DT::datatable(
      data <- publication
    )
  })
  output$Table_Publication_Media <- DT::renderDataTable({
    DT::datatable(
      data <- media_publication
    )
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