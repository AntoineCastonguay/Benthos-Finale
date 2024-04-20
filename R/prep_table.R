# Fonction qui crée les data.frame pour la création des table

prep.table <- function(benthos, taxonomie){

  # Création des data.frame selon les tables choisi
  taxonomie <- as.data.frame(taxonomie)
  taxonomie <- data.frame(identification = taxonomie$identification,
                          phylum = taxonomie$phylum,
                          class = taxonomie$class,
                          orders = taxonomie$order,
                          family = taxonomie$family,
                          genus = taxonomie$genus,
                          taxo_min = taxonomie$taxo_identification,
                          score_EPT = taxonomie$score_EPT)
  
  abondance <- data.frame(date_ab = benthos$date,
                          site_ab = benthos$site,
                          identification_ab = benthos$nom_sci,
                          abondance = benthos$abondance)
  
  # Garde juste les entré différente
  benthos.cond <- benthos %>% distinct(site,date, .keep_all = TRUE)
  
  site <- data.frame(date = benthos.cond$date,     
                     site = benthos.cond$site,
                     date_obs = benthos.cond$date_obs,
                     heure_obs = benthos.cond$heure_obs,
                     fraction = benthos.cond$fraction)
  
  condition_echantillonnage <- data.frame(date_cond = benthos.cond$date,
                                          site_cond = benthos.cond$site,
                                          station = benthos.cond$ETIQSTATION,
                                          largeur_riviere = benthos.cond$largeur_riviere,
                                          profondeur_riviere = benthos.cond$profondeur_riviere,
                                          vitesse_courant = benthos.cond$vitesse_courant,
                                          transparence_eau = benthos.cond$transparence_eau,
                                          temperature_eau_c = benthos.cond$temperature_eau_c)
  
  # # écriture des fichier .csv
  # write.csv(x = taxonomie,file = "taxonomie.csv",row.names = FALSE)
  # write.csv(x = site,file = "site.csv",row.names = FALSE)
  # write.csv(x = condition_echantillonnage,file = "condition_echantillonnage.csv",row.names = FALSE)
  # write.csv(x = abondance,file = "abondance.csv",row.names = FALSE) 
  return(list(taxonomie,abondance,site,condition_echantillonnage))
}