# Fonction qui permet d'attribuer les arbre toxonomique au identification

attribution.taxo <- function(benthos, esp.info, list.esp){
  
  # Creation de la matrix taxonomie
  taxonomie <- matrix(NA,length(list.esp),8)
  colnames(taxonomie) <- c("phylum", "class", "order", "family", "genus", "taxo_identification", "identification","score_EPT")
  i <- 1
  
  for (esp in esp.info) {
    # si espece est trouver continue sinon option manuelle
    if(!any(is.na(esp.info[[i]]))){
      
      # si gene est present stock dans taxonomie
      if(any(esp[[2]] == "genus")){
        esp.genus <- subset(esp,esp[[2]] == "genus")
        taxonomie[i,5] <- esp.genus$name
      }
      
      # si family est present stock dans taxonomie
      if(any(esp[[2]] == "family")){
        esp.family <- subset(esp,esp[[2]] == "family")
        taxonomie[i,4] <- esp.family$name
        if(esp.family$name == "Baetiscidae"){
          taxonomie[i,8] <- 3
        }else if(esp.family$name == "Ephemeridae" 
                 || esp.family$name == "Polymitarcyidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Potamanthidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Ephemerellidae"){
          taxonomie[i,8] <- 1
        }else if(esp.family$name == "Leptophlebiidae"){
          taxonomie[i,8] <- 2
        }else if(esp.family$name == "Caenidae"){
          taxonomie[i,8] <- 7
        }else if(esp.family$name == "Leptohyphidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Heptageniidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Isonychiidae"){
          taxonomie[i,8] <- 2
        }else if(esp.family$name == "Ameletidae" 
                 || esp.family$name == "Baetidae" 
                 || esp.family$name == "Siphlonuridae"
                 || esp.family$name == "Metretopodidae"){
          taxonomie[i,8] <- 3
        }else if(esp.family$name == "Hydropsychidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Hydroptilidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Helicopsychidae"){
          taxonomie[i,8] <- 3
        }else if(esp.family$name == "Rhyacophilidae"){
          taxonomie[i,8] <- 0
        }else if(esp.family$name == "Philopotamidae" 
                 || esp.family$name == "Polycentropodidae" 
                 || esp.family$name == "Psychomyiidae"
                 || esp.family$name == "Dipseudopsidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Goeridae"){
          taxonomie[i,8] <- 3
        }else if(esp.family$name == "Leptoceridae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Molannidae"){
          taxonomie[i,8] <- 6
        }else if(esp.family$name == "Limnephilidae" 
                 || esp.family$name == "Apataniidae" 
                 || esp.family$name == "Lepidostomatidae"
                 || esp.family$name == "Brachycentridae"
                 || esp.family$name == "Odontoceridae"
                 || esp.family$name == "Uenoidae"){
          taxonomie[i,8] <- 2
        }else if(esp.family$name == "Phryganeidae"){
          taxonomie[i,8] <- 4
        }else if(esp.family$name == "Glossosomatidae"){
          taxonomie[i,8] <- 0
        }else if(esp.family$name == "Peltoperlidae"){
          taxonomie[i,8] <- 0
        }else if(esp.family$name == "Pteronarcyidae"){
          taxonomie[i,8] <- 0
        }else if(esp.family$name == "Perlidae"){
          taxonomie[i,8] <- 1
        }else if(esp.family$name == "Capniidae" 
                 || esp.family$name == "Chloroperlidae" 
                 || esp.family$name == "Leuctridae"
                 || esp.family$name == "Nemouridae"
                 || esp.family$name == "Taeniopterygidae"
                 || esp.family$name == "Perlodidae"){
          taxonomie[i,8] <- 1
        }
      }
      
      # si order est present stock dans taxonomie
      if(any(esp[[2]] == "order")){
        esp.order <- subset(esp,esp[[2]] == "order")
        taxonomie[i,3] <- esp.order$name
        if(esp.order$name == "Ephemeroptera"){
          if(is.na(taxonomie[i,8])){
            taxonomie[i,8] <- 3
          }
        }else if(esp.order$name == "Plecoptera"){
          if(is.na(taxonomie[i,8])){
            taxonomie[i,8] <- 1
          }
        }else if(esp.order$name == "Trichoptera"){
          if(is.na(taxonomie[i,8])){
            taxonomie[i,8] <- 3
          }
        }
      }
      
      # si class est present stock dans taxonomie
      if(any(esp[[2]] == "class")){
        esp.class <- subset(esp,esp[[2]] == "class")
        taxonomie[i,2] <- esp.class$name
      }
      
      # si phylum est present stock dans taxonomie
      if(any(esp[[2]] == "phylum")){
        esp.phylum <- subset(esp,esp[[2]] == "phylum")
        taxonomie[i,1] <- esp.phylum$name
      }
      
      # Determine le niveau taxonomique de l'identification
      esp.min <- subset(esp,tolower(esp[[1]]) == tolower(names(esp.info[i])))
      taxon.min <- esp.min$rank
      taxonomie[i,6] <- taxon.min[1]
      
      # Identification brut
      taxonomie[i,7] <- list.esp[i]
      
      
    }else{
      if(list.esp[i] == "Caecidota"){
        taxonomie[i,1] <- "Arthropoda"
        taxonomie[i,2] <- "Insecta"
        taxonomie[i,3] <- "Coleoptera"
        taxonomie[i,4] <- "Scarabaeidae"
        taxonomie[i,5] <- "Caecidota"
        taxonomie[i,6] <- "genus"
        taxonomie[i,7] <- list.esp[i]
      }else{
        print(paste("Espece non trouver :", list.esp[i]))
        taxonomie[i,1] <- NA
        taxonomie[i,2] <- NA
        taxonomie[i,3] <- NA
        taxonomie[i,4] <- NA
        taxonomie[i,5] <- NA
        taxonomie[i,6] <- NA
        taxonomie[i,7] <- list.esp[i]
      }
    }
    i <- i+1
  }
  
  return(taxonomie)
}

# Entré manuelle compliquer
# }else{
#   
#   # Entrer manuelle de la taxonomie
#   print(paste("Espece non trouver :",list.esp[i]))
#   
#   # Demande a la console le plus bas niveau taxonomique
#   print("Niveau taxonomique : phylum, class, order, family, genus")
#   esp.min <- readline(prompt = "Entrez le plus bas niveau taxonomique : ")
#   taxonomie[i,6] <- tolower(esp.min)
#   
#   # Demande a la console le phylum
#   esp.phylum <- readline(prompt = "Entrez le phylum : ")
#   taxonomie[i,1] <- esp.phylum
#   
#   if(tolower(esp.min) != "phylum"){
#     # Demande a la console la class
#     esp.class <- readline(prompt = "Entrez la class : ")
#     # Si na met NA
#     if (tolower(esp.class) == "na" || tolower(esp.class) == "-" || esp.class == "") {
#       esp.class <- NA
#     }
#     # Stock dans taxonomie
#     taxonomie[i,2] <- esp.class
#     
#     if(tolower(esp.min) != "class"){
#       # Demande a la console le order
#       esp.order <- readline(prompt = "Entrez le order : ")
#       if (tolower(esp.class) == "na" || tolower(esp.class) == "-" || esp.class == "") {
#         esp.order <- NA
#       }
#       taxonomie[i,3] <- esp.order
#       
#       if(tolower(esp.min) != "order"){
#         # Demande a la console la family
#         esp.family <- readline(prompt = "Entrez la family : ")
#         if (tolower(esp.class) == "na" || tolower(esp.class) == "-" || esp.class == "") {
#           esp.family <- NA
#         }
#         taxonomie[i,4] <- esp.family
#         
#         if(tolower(esp.min) != "family"){
#           # Demande a la console le genus
#           esp.genus <- readline(prompt = "Entrez le genus : ")
#           if (tolower(esp.class) == "na" || tolower(esp.class) == "-" || esp.class == "") {
#             esp.genus <- NA
#           }
#           taxonomie[i,5] <- esp.genus
#           
#         }else{
#           taxonomie[i,5] <- NA
#         }
#       }else{
#         taxonomie[i,4] <- NA
#         taxonomie[i,5] <- NA
#       }
#     }else{
#       taxonomie[i,3] <- NA
#       taxonomie[i,4] <- NA
#       taxonomie[i,5] <- NA
#     }
#   }else{
#     taxonomie[i,2] <- NA
#     taxonomie[i,3] <- NA
#     taxonomie[i,4] <- NA
#     taxonomie[i,5] <- NA
#   }
#   
#   # Identification brut
#   taxonomie[i,7] <- list.esp[i]