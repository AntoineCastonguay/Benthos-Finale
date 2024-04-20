# Fonction de normalisation du temps

normalize.time <- function(heures) {
  
  for (i in 1:length(heures)) {
    time.str <- heures[i]
    
    # Trouve les deux premiere positions des charactere qui ne sont pas des chiffres
    pos <- gregexpr("[^0-9]", time.str)[[1]][1:2]
    
    # Extrait les deux chracteres 
    char.trois <- substr(time.str, pos[1], pos[1])
    char.six <- substr(time.str, pos[2], pos[2])
    
    # Definit le format actuel
    format.actuel <- paste0("%H",char.trois,"%M",char.six,"%S")
    
    # Transforme en format universel
    long.time <- strptime(time.str, format = format.actuel)
    
    # Extrait la partie que l'on souhait
    good.time <- format(long.time, format = "%H:%M:%S")
    
    heures[i] <- good.time
  }
  
  return(heures)
}