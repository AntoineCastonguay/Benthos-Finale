# SQL

SQL.make <- function(table){
  # connection à la base de donnée
  con <- dbConnect(SQLite(), dbname="benthos.db")
  
  # Création de la table espece
  dbSendQuery(con, "DROP TABLE IF EXISTS espece")
  creer_espece <- 
    "CREATE TABLE espece (
    identification        VARCHAR(50),
    phylum                VARCHAR(50),
    class                 VARCHAR(50),
    orders                VARCHAR(50),
    family                VARCHAR(50),
    genus                 VARCHAR(50),
    taxo_min              VARCHAR(50),
    score_EPT             INTEGER(1),
    PRIMARY KEY (identification)
  );"
  dbSendQuery(con, creer_espece)
  
  # Création de la table site
  dbSendQuery(con, "DROP TABLE IF EXISTS site")
  creer_site <-
    "CREATE TABLE site (
    date              DATE(50),
    site              VARCHAR(50),
    date_obs          DATE(50),
    heure_obs         TIME(50),
    fraction          DOUBLE(5),
    PRIMARY KEY (date,site)
  );"
  dbSendQuery(con, creer_site)
  
  # Création de la table condition_echantillonnage
  dbSendQuery(con, "DROP TABLE IF EXISTS condition_echantillonnage")
  creer_condition_echantillonnage <- 
    "CREATE TABLE condition_echantillonnage (
    date_cond           DATE(50),
    site_cond           VARCHAR(50),
    station             VARCHAR(50),
    largeur_riviere     DOUBLE(5),
    profondeur_riviere  DOUBLE(5),
    vitesse_courant     DOUBLE(5),
    transparence_eau    VARCHAR(50),
    temperature_eau_c   DOUBLE(5),
    PRIMARY KEY (date_cond,site_cond),
    FOREIGN KEY (date_cond) REFERENCES site(date),
    FOREIGN KEY (site_cond) REFERENCES site(site)
  );"
  dbSendQuery(con, creer_condition_echantillonnage)
  
  # Cération de la table abondance
  dbSendQuery(con, "DROP TABLE IF EXISTS abondance")
  creer_abondance <-
    "CREATE TABLE abondance (
    date_ab             DATE(50),
    site_ab             VARCHAR(50),
    identification_ab   VARCHAR(50),
    abondance           INTEGER(4),
    PRIMARY KEY (date_ab,site_ab,identification_ab),
    FOREIGN KEY (date_ab) REFERENCES site(date),
    FOREIGN KEY (site_ab) REFERENCES site(site),
    FOREIGN KEY (identification_ab) REFERENCES espece(identification)
  );"
  dbSendQuery(con, creer_abondance)
  
  # # lecture des données Benthos
  # bd.espece <- read.csv("taxonomie.csv")
  # bd.site <- read.csv("site.csv")
  # bd.cond.ech <- read.csv("condition_echantillonnage.csv")
  # bd.ab <- read.csv("abondance.csv")
  
  bd.espece <- table[[1]]  
  bd.ab <- table[[2]]
  bd.site <- table[[3]]
  bd.cond.ech <- table[[4]]
  
  # Integration des données dans la base de données
  dbWriteTable(con, append = TRUE, name = "espece", value = bd.espece, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "site", value = bd.site, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "condition_echantillonnage", value = bd.cond.ech, row.names = FALSE)
  dbWriteTable(con, append = TRUE, name = "abondance", value = bd.ab, row.names = FALSE)
  dbDisconnect(con)
  return("benthos.db")
}

