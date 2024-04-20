# _targets.R file

library(targets)
library(rmarkdown)
library(dplyr)
library(RSQLite)
library(tarchetypes)
library(rticles)

source("R/read.R")
source("R/colNA.R")
source("R/normalize_time.R")
source("R/la_taxonomie.R")
source("R/prep_table.R")
source("R/script_SQL.R")
source("R/req_SQL.R")

# pipeline
list(
  tar_target(
    benthos.brut,
    read.dossier()
  ),
  tar_target(
    benthos.noNA,
    colNA(benthos.brut)
  ),
  tar_target(
    benthos.normT,
    normalize.time(benthos.noNA)
  ),
  tar_target(
    taxo,
    la.taxonomie(benthos.normT)
  ),
  tar_target(
    table,
    prep.table(benthos.normT,taxo)
  ),
  tar_target(
    SQL,
    SQL.make(table)
  ),
  tar_target(
    graph,
    SQL.get()
  ),
  tar_render(
    rapport,
    path ="rapport.Rmd"
  )
)
