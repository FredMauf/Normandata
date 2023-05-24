
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
      fluidRow(h3("Données Associées avec "),
               DT::dataTableOutput("Table_Donnee_poll"),
      )
    ),
    tabPanel("Données",
             fluidRow(
               h3("Données Associées avec "),
               DT::dataTableOutput("Table_Donnee_Maitre"))
    ),
    # Navbar 1, tabPanel
    tabPanel("Media",
             fluidRow(
               h3("Media et Documents publiés "),
               DT::dataTableOutput("Table_Media"))),
    
    tabPanel("Supports de Publication ",
             fluidRow(
               h3("Supports de publication avec "),
               DT::dataTableOutput("Table_Publication"))),
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
  output$Table_Polluant <- DT::renderDataTable({
    DT::datatable(
      data = polluant
    )
  })
  output$Table_Donnee_poll <- DT::renderDataTable({
    DT::datatable(
      data <- donnee
    )
  })
  output$Table_Donnee_Maitre <- DT::renderDataTable({
    DT::datatable(
      data <- donnee
    )
  })
  output$Table_Donnee_Lien <- DT::renderDataTable({
    DT::datatable(
      data <- donnee
    )
  })
  output$Table_Media <- DT::renderDataTable({
    DT::datatable(
      data <- media
    )
  })
  output$Table_Publication <- DT::renderDataTable({
    DT::datatable(
      data <- publication
      
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