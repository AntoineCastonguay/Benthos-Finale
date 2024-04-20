# Fonction lier a la taxonomie 

# Charger la bibliothèque taxize pour la fonction taxo
library(taxize)
file.edit("~/R-projet/.Renviron")
# Necessaire pour grand volume d'analyse avec taxize
# Ecrire dans le .Renviron : ENTREZ_KEY=***
# Ou *** = API key (https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/)

# Fonction pour trouvre l'arbre taxonomique de chaque espece
taxo <- function(list.esp, list.esp.double){
  
  # Initilisation des listes espece avec les arbre taxonomique
  espece.info <- c(0)
  espece.info2 <- c(0)
  espece.info3 <- c(0)
  espece.info4 <- c(0)
  espece.info.double <- c(0)
  
  # Pour toutes les especes de 1:nb total espece (dans 4 boucle differente pour alleger charge travail)
  for (espece in list.esp[1:50]) {
    # Appele de la fonction classification qui sort l'arbre taxonomique de espece
    classification.info <- classification(espece, db = "ncbi")
    
    # Stock l'information dans espece.info
    espece.info <- c(espece.info, classification.info)
  }
  # Enleve le premier 0
  espece.info <- espece.info[-1]
  
  for (espece in list.esp[51:100]) {
    classification.info2 <- classification(espece, db = "ncbi")
    espece.info2 <- c(espece.info2, classification.info2)
  }
  espece.info2 <- espece.info2[-1]
  
  for (espece in list.esp[101:150]) {
    classification.info3 <- classification(espece, db = "ncbi")
    espece.info3 <- c(espece.info3, classification.info3)
  }
  espece.info3 <- espece.info3[-1]
  
  for (espece in list.esp[151:length(list.esp)]) {
    classification.info4 <- classification(espece, db = "ncbi")
    espece.info4 <- c(espece.info4, classification.info4)
  }
  espece.info4 <- espece.info4[-1]
  
  # Concaténer le resultat
  esp.info <- c(espece.info,espece.info2,espece.info3,espece.info4)
  
  # Même chose mais pour les especes doubles
  for (espece in list.esp.double) {
    classification.info.double <- classification(espece, db = "ncbi")
    espece.info.double <- c(espece.info.double, classification.info.double)
  }
  espece.info.double <- espece.info.double[-1]
  espece.info.double[1]
  
  # Trouve le plus bas niveau taxonomique en commun des espece double
  list.taxo.double <- c(0)
source("R/taxo_commun.R")  
  for (i in seq(1,length(espece.info.double),by =2)) {
    # appele la fonction taxo.commun
    taxo.en.commun <- taxo.commun(espece.info.double[[i]],espece.info.double[[i+1]])
    
    # stock l'information dans une list
    list.taxo.double <- c(list.taxo.double,taxo.en.commun)
  }
  list.taxo.double <- list.taxo.double[-1]
  
  # Concatene les deux listes
  esp.info <- c(esp.info,list.taxo.double)
  
  return(esp.info)
}


