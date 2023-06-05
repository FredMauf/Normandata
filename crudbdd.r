library(shiny)
library(DBI)
library(shinyalert)

# Se connecter à la base de données
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = "localhost",
  port = "5432",
  password = "123",
  user = "postgres"
)

# Fonction pour récupérer les données d'une table
getTableData <- function(table_name) {
  query <- paste0("SELECT * FROM si.", table_name)
  dbGetQuery(con, query)
}

# Fonction pour récupérer les données d'une table de référence pour les clés étrangères
getReferenceTableData <- function(table_name) {
  query <- paste0("SELECT * FROM si.", table_name)
  reference_data <- dbGetQuery(con, query)
  reference_data[, 1] # Utiliser la première colonne (le code) comme choix
}

# Fonction pour insérer une nouvelle ligne dans une table
insertRow <- function(table_name, data) {
  query <- paste0("INSERT INTO si.", table_name, " (", paste(names(data)[-1], collapse = ", "), ") VALUES (", paste0("'", data[-1], "'", collapse = ", "), ")")
  dbExecute(con, query)
}

# Fonction pour mettre à jour une ligne dans une table
updateRow <- function(table_name, data) {
  query <- paste0("UPDATE si.", table_name, " SET ", paste(names(data)[-1], "=", paste0("'", data[-1], "'"), collapse = ", "), " WHERE id_", table_name, "=", data[1])
  dbExecute(con, query)
}

# Fonction pour supprimer une ligne d'une table
deleteRow <- function(table_name, id) {
  query <- paste0("DELETE FROM si.", table_name, " WHERE id_", table_name, "=", id)
  dbExecute(con, query)
}

# Interface utilisateur
ui <- fluidPage(
  titlePanel("Application CRUD"),
  sidebarLayout(
    sidebarPanel(
      selectInput("table_name", "Table", choices = c("application", "donnee", "etat_maturite", "maille_geo", "maille_temps", "polluant", "proprietaire_objet", "serveur", "type_media")),
      uiOutput("input_fields"),
      actionButton("add_button", "Ajouter"),
      actionButton("update_button", "Modifier"),
      actionButton("delete_button", "Supprimer")
    ),
    mainPanel(
      tableOutput("table_data")
    )
  )
)

# Serveur
server <- function(input, output, session) {
  
  # Récupérer les champs de saisie en fonction de la table sélectionnée
  output$input_fields <- renderUI({
    table_name <- input$table_name
    table_data <- getTableData(table_name)
    
    # Exclure les colonnes "id_xxx" des séquences
    exclude_columns <- c()
    
    # Sélectionner les colonnes de la table à afficher
    columns <- setdiff(colnames(table_data), exclude_columns)
    
    # Générer les champs de saisie en fonction des colonnes de la table
    fields <- lapply(columns, function(column) {
      if (startsWith(column, "id_")) {
        reference_table <- gsub("^id_", "", column)
        reference_data <- getReferenceTableData(reference_table)
        choices <- reference_data
        selectInput(column, column, choices = choices, selected = NULL)
      } else {
        if (is.numeric(table_data[[column]])) {
          numericInput(column, column, value = NULL)
        } else {
          textInput(column, column, value = NULL)
        }
      }
    })
    
    # Retourner les champs de saisie
    do.call(tagList, fields)
  })
  
  # Récupérer les données de la table sélectionnée
  output$table_data <- renderTable({
    table_name <- input$table_name
    getTableData(table_name)
  })
  
  # Gérer l'ajout d'une nouvelle ligne
  observeEvent(input$add_button, {
    table_name <- input$table_name
    table_data <- getTableData(table_name)
    
    # Récupérer les valeurs des champs de saisie
    data <- sapply(names(table_data), function(column) {
      if (startsWith(column, "id_")) {
        input[[column]]
      } else {
        if (is.numeric(table_data[[column]])) {
          as.numeric(input[[column]])
        } else {
          input[[column]]
        }
      }
    })
    
    # Insérer la nouvelle ligne dans la table
    insertRow(table_name, data)
    
    # Afficher une alerte de succès
    shinyalert::shinyalert("Succès", "La nouvelle ligne a été ajoutée avec succès.", type = "success")
    
    # Effacer les valeurs des champs de saisie
    updateTextInput(session, names(table_data), value = "")
    updateSelectInput(session, names(table_data[startsWith(names(table_data), "id_")]), selected = NULL)
  })
  
  # Gérer la mise à jour d'une ligne
  observeEvent(input$update_button, {
    table_name <- input$table_name
    table_data <- getTableData(table_name)
    
    # Récupérer les valeurs des champs de saisie
    data <- sapply(names(table_data), function(column) {
      if (startsWith(column, "id_")) {
        input[[column]]
      } else {
        if (is.numeric(table_data[[column]])) {
          as.numeric(input[[column]])
        } else {
          input[[column]]
        }
      }
    })
    
    # Mettre à jour la ligne dans la table
    updateRow(table_name, data)
    
    # Afficher une alerte de succès
    shinyalert::shinyalert("Succès", "La ligne a été mise à jour avec succès.", type = "success")
  })
  
  # Gérer la suppression d'une ligne
  observeEvent(input$delete_button, {
    table_name <- input$table_name
    id <- input[[paste0("id_", table_name)]]
    
    # Supprimer la ligne de la table
    deleteRow(table_name, id)
    
    # Afficher une alerte de succès
    shinyalert::shinyalert("Succès", "La ligne a été supprimée avec succès.", type = "success")
  })
}

# Lancer l'application
shinyApp(ui, server)
