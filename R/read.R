# Fonction read.dossier

read.dossier <- function(){
  
  # Emplacement dossier data benthos
  dossier <- "data/"
  
  # Liste tous les fichiers du dossier
  fichiers <- list.files(dossier)
  
  # Enleve le fichier README.md
  fichiersCSV <- fichiers[-1]
  
  # Lecture des fichiers .csv 
  data_list <- lapply(paste0(dossier,fichiersCSV), read.csv)
  
  # Fusionner les lectures des fichiers
  benthos <- do.call(rbind, data_list)
  
  return(benthos)
}