# Fonction qui regroupe tous ce qui est lier a la taxonomie

la.taxonomie <- function(benthos){
  
  # Liste toutes les identification differente recenser
  list.esp <- unique(benthos$nom_sci)
  # Trouver les noms avec le séparateur |
  nom.double <- list.esp[grep("\\|", list.esp)]
  
  # Liste les noms doubles
  source("R/double_name.R")  
  list.esp.double <- double.name(list.esp,nom.double)
  
  # Enleve de list.esp les nom.double
  list.esp <- list.esp[!(list.esp %in% nom.double)]
  
  # Ajout la taxonomie  
  source("R/taxonomie.R")  
  # Etape difficile a Run a cause de request a une base de donnees, donc l'etape a ete prefaite.
  # esp.info <- taxo(list.esp, list.esp.double)
  load("R/esp_info_4.RData")
  
  # Cree une liste avec tous les especes dans le bonne ordre
  list.esp <- names(esp.info)
  pos.sup <- length(list.esp)
  pos.inf <- pos.sup - (length(nom.double)-1)
  list.esp[pos.inf:pos.sup] <- nom.double
  
  # Ajoute au tableau les niveau taxonomique
  source("R/attribution_taxo.R")  
  taxonomie <- attribution.taxo(benthos, esp.info, list.esp)
  
  return(taxonomie)
}