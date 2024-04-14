# Fonction qui recense les noms doubles

double.name <- function(list.esp,nom.double){
  list.esp.double <- c(0)
  
  # Créer une liste sans les noms avec le séparateur | 
  # et une liste avec les noms avec le séparateur
  for (nom in nom.double) {
    list.esp <- subset(list.esp, list.esp != nom)
    
    noms <- strsplit(nom, " | ", fixed = TRUE)[[1]]
    list.esp.double <- c(list.esp.double, noms)
  }
  list.esp.double <- list.esp.double[-1]
  
  return(list.esp.double)
}