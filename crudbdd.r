library(shiny)
library(RPostgreSQL)
library(DT)

drv <- dbDriver("PostgreSQL")
dbp <- dbConnect(drv, dbname = "atmonormandie", host = "10.76.10.19", port = 5432, user = "postgres", password = '$postG*28')

raw_polluant <- dbGetQuery(dbp, "SELECT * FROM si.polluant")
liste_id_polluant <- raw_polluant[,"id_polluant"]
names(liste_id_polluant) <- raw_polluant[,"libelle_polluant"]

raw_donnee <- dbGetQuery(dbp, "SELECT * FROM si.donnee")
liste_id_donnee <- raw_donnee[,"id_donnee"]
names(liste_id_donnee) <- raw_donnee[,"libelle_donnee"]

raw_maturite <- dbGetQuery(dbp, "select * from si.etat_maturite")
liste_id_maturite <- raw_maturite[,"id_etat_maturite"]
names(liste_id_maturite) <- raw_maturite[,"libelle_etat_maturite"]

raw_proprio <- dbGetQuery(dbp, "select * from si.proprietaire_objet")
liste_id_proprio <- raw_proprio[,"id_proprietaire_objet"]
names(liste_id_proprio) <- paste0(raw_proprio[,"libelle_proprietaire_objet"]," (",raw_proprio[,"code_interne_proprietaire"],")")

raw_maille_geo <- dbGetQuery(dbp, "select * from si.maille_geo")
liste_id_maille_geo <- raw_maille_geo[,"id_maille_geo"]
names(liste_id_maille_geo) <- raw_maille_geo[,"libelle_maille_geo"]

raw_maille_temps <- dbGetQuery(dbp, "select * from si.maille_temps")
liste_id_maille_temps <- raw_maille_temps[,"id_maille_temps"]
names(liste_id_maille_temps) <- raw_maille_temps[,"libelle_maille_temps"]

raw_application <- dbGetQuery(dbp, "select * from si.application")
liste_id_application <- raw_application[,"id_application"]
names(liste_id_application) <- raw_application[,"nom_application"]

ui <- fluidPage(
  navbarPage(
    "Cartographie Data Atmo Normandie",
    tabPanel("Polluants et Substances",
		fluidRow(
			column(2,h3("Nouvel enregistrement")),
			column(2,textInput("Nom_polluant", "Nom du polluant *", placeholder="Entrez un nom")),
			column(2,textInput("Code_Polluant_lcsqa", "Code Polluant LCSQA", placeholder="Entrez un code sur 2 caractères")),
			column(1,br(),actionButton("valid", "Valider"))
		),
			fluidRow(
			h3("Tous les polluants"),
			DT::dataTableOutput("Table_Polluant")
		)
    ),
    tabPanel("Données Associées",
		fluidRow(
			column(2,h3("Nouvel enregistrement"),actionButton("valid2", "Valider")),
			column(2,
				textInput("Nom_donnee", "Libellé *", placeholder="Entrez un libellé qualifiant la donnée"),
				selectInput("id_polluant", "Polluant * :", liste_id_polluant),
				textInput("type_donnee", "Type :", placeholder="Type de donnée")
			),
			column(3,
				selectInput("id_maturite", "Maturité * :", liste_id_maturite, width="400px"),
				selectInput("id_proprio", "Propriétaire * :", liste_id_proprio, width="420px"),
				selectInput("id_maille_geo", "Maille Géographique * :", liste_id_maille_geo, width="400px"),
				selectInput("id_maille_temps", "Maille Temporelle * :", liste_id_maille_temps, width="400px")
			),
			column(2,
				checkboxInput("id_reglementaire", "Règlementaire"),
				dateInput("id_datedeb","Début récolte :"),
				selectInput("id_application", "Application :", liste_id_application)
			)
		),
		fluidRow(
			h3("Données Associées "),
			DT::dataTableOutput("Table_Donnee")
		)
    ),
	tabPanel("Sources/Cibles",
		fluidRow(
			column(4, 
				selectInput("id_donnee","Choisir une donnée :", liste_id_donnee,  width = "450px")
			),
			column(4, 
				h3("Donnée(s) source(s) / Entrée(s) :")
			),
			column(4,
				h3("Donnée(s) cible(s) / Sortie(s) :")
			)
		)
	),
	tabPanel("Méta Données",
		fluidRow(
			column(3, 
				h4("Etat de Maturité :"),
				tableOutput("table_maturite"),
				textInput("new_maturite", "Nouvel état de maturité :", placeholder="Entrez un libellé")
			),
			column(3, 
				h4("Propriétaire (Processus) :"),
				tableOutput("table_proprio"),
				textInput("new_proprio", "Nouveau propriétaire :", placeholder="Nouveau processus"), 
				textInput("new_code_proprio", "Code interne associé :")
			),
			column(3, 
				h4("Maille Géographique :"),
				tableOutput("table_maille_geo"),
				textInput("new_maille_geo", "Nouvelle maille :", placeholder="Entrez un libellé")
			),
			column(3, 
				h4("Maille temporelle :"),
				tableOutput("table_maille_temps"),
				textInput("new_maille_temps", "Nouvelle maille :", placeholder="Entrez un libellé")
			)
		)
	)
  ) # navbarPage
) # fluidPage

server <- function(input, output) {

	output$Table_Polluant <- DT::renderDataTable({
		DT::datatable(
			data <- raw_polluant
		)
	})
	output$Table_Donnee <- DT::renderDataTable({
		DT::datatable(
			data <- raw_donnee
		)
	})

	req_new_poll <- eventReactive(input$valid, {
		paste0("insert into si.polluant (libelle_polluant, code_polluant_lcsqa) values (nom='",input$Nom_polluant,"','",input$Code_Polluant_lcsqa,"')")
	})
	
	observeEvent(input$valid, {
		if(input$valid > 0){
			resreq <- dbSendQuery(dbp, req_new_poll())
			raw_polluant <<- dbGetQuery(dbp, "SELECT * FROM si.polluant")
		}
	})
	
	output$table_maturite <- renderTable({ names(liste_id_maturite) }, colnames=F)
	output$table_proprio <- renderTable({ names(liste_id_proprio) }, colnames=F)
	output$table_maille_geo <- renderTable({ names(liste_id_maille_geo) }, colnames=F)
	output$table_maille_temps <- renderTable({ names(liste_id_maille_temps) }, colnames=F)
}

# Create Shiny object
shinyApp(ui = ui, server = server)