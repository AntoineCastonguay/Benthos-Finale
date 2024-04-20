#Fonction qui nettoie les données avant l'analyse

nettoyer <- function(benthos) {
  
  
  # S'assurer que toutes les colonnes de dates suivent le format attendu
  source("R/nettoyage_date.R")
  benthos$date <- nettoyer_dates(benthos$date)
  benthos$date_obs <- nettoyer_dates(benthos$date_obs)
  
  # S'assurer que toutes les colonnes de temps suivent le format attendu
  source("R/normalize_time.R")
  benthos$heure_obs <- normalize.time(benthos$heure_obs)
  
  # Enlever les valeurs numériques abherrantes
  source("R/nettoyage_num.R")
  # Pour chaque colonne numérique, s'assurer que chaque valeur soit entre un minimum et maximum qui font du sens
  benthos$fraction <- nettoyer_num(benthos$fraction, 0, 1)
  benthos$abondance <- nettoyer_num(benthos$abondance, 0, 499)
  benthos$largeur_riviere <- nettoyer_num(benthos$largeur_riviere, 0, 99)
  benthos$profondeur_riviere <- nettoyer_num(benthos$profondeur_riviere, 0, 99)
  benthos$vitesse_courant <- nettoyer_num(benthos$vitesse_courant, 0, 99)
  benthos$temperature_eau_c <- nettoyer_num(benthos$temperature_eau_c, 0, 49)
  
  return(benthos)
}