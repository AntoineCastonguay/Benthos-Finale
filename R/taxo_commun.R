# Fonction qui trouve le plus bas niveau taxonomique en commun

taxo.commun <- function(esp.info.1, esp.info.2){
  
  # trouve la position au plus bas niveau taxonomique en commun
  pos = 1
  while (esp.info.1[[1]][pos] == esp.info.2[[1]][pos]) {
    pos <- pos + 1
  }
  pos <- pos - 1
  
  # Cree l'object taxonomique qui regroupe les deux espece
  for (i in 1:3) {
    # Enleve les partie qui n'ont pas de correpondance
    esp.info.commun <- list(data.frame(name = esp.info.1[[1]][c(1:pos)],
                                       rank = esp.info.1[[2]][c(1:pos)],
                                       id = esp.info.1[[3]][c(1:pos)]))
    
    # Donne un nom a la liste
    names(esp.info.commun) <- c((esp.info.1[[1]][pos]))
  }
  
  return(esp.info.commun)
  
}