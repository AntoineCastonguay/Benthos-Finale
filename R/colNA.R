# Fonctione enleve les colonnes avec juste des NA

colNA <- function(benthos){
  # Vecteur position de colonnes qui contient juste NA
  col.na <- c(0)
  # Nombre de colonnes
  nb.col <- length(benthos[1,])
  
  # Pour toutes les colonnes
  for (i in 1:nb.col) {
    # Calcule le nombre d'entre differente
    nb.entre.diff <- length(unique(benthos[,i]))
    
    if(nb.entre.diff <= 1){
      # Regarde s'il y a juste NA
      entre.diff <- unique(benthos[,i])
      
      if(is.na(entre.diff)){
        # Ajoute la position de la colonnes
        col.na <- c(col.na,i)
      }
    }
  }
  # Enleve le premier 0
  col.na <- col.na[-1]
  
  # Pour toutes les colonnes avec juste NA
  for (i in rev(col.na)) {
    # Enleve la colonne
    benthos <- benthos[-i]
  }
  
  return(benthos)
}