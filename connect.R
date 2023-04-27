#test_DB
message("Salut")
  
db <-  "postgres"  #provide the name of your db
host_db <- "localhost" 
db_port <- "5432"  # or any other port specified by the DBA
db_user <- "postgres"  
 pw <- "123"

install.packages("RPostgres")

# install.packages("RPostgreSQL")
library(RPostgres)
# create a connection
# save the password that we can "hide" it as best as we can by collapsing it

# loads the PostgreSQL driver
drv <- dbDriver("RPostgres")
# creates a connection to the postgres database
# note that "con" will be used later in each connection to the database
con <- dbConnect(drv, dbname = db,
                 host = host_db, port = db_port,
                 user = db_user, password = pw)
rm(pw) # removes the password
# check for the cartable
dbExistsTable(con, "cartable")
# TRUE