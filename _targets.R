# _targets.R file

library(targets)
library(rmarkdown)
library(dplyr)
library(RSQLite)
library(tarchetypes)
library(rticles)

source("R/read.R")
source("R/colNA.R")
source("R/nettoyage.R")
source("R/la_taxonomie.R")
source("R/prep_table.R")
source("R/script_SQL.R")
source("R/req_SQL.R")

# pipeline
list(
  tar_target(
    path,
    command = "./data",
    format = "file"
  ),
  tar_target(
    file_paths,
    command = list.files(path, pattern = "\\.csv$", full.names = TRUE)
  ),
  tar_target(
    benthos.brut,
    read.dossier(file_paths)
  ),
  tar_target(
    benthos.noNA,
    colNA(benthos.brut)
  ),
  tar_target(
    benthos.clean,
    nettoyer(benthos.noNA)
  ),
  tar_target(
    taxo,
    la.taxonomie(benthos.clean)
  ),
  tar_target(
    table,
    prep.table(benthos.clean,taxo)
  ),
  tar_target(
    database,
    SQL.make(table),
    format = "file"
  ),
  tar_target(
    graph,
    SQL.get(database)
  ),
  tar_render(
    rapport,
    path ="rapport.Rmd"
  )
)
