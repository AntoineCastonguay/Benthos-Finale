# Fonction read.dossier

read.dossier <- function(fichiers){

  noms.cols.attendus <- c( "date", 
                             "site", 
                             "date_obs",
                             "heure_obs",
                             "fraction",
                             "nom_sci",
                             "abondance",
                             "largeur_riviere",
                             "profondeur_riviere",
                             "vitesse_courant",
                             "transparence_eau",
                             "temperature_eau_c",
                             "ETIQSTATION")
  
  # Initialiser un dataframe
  benthos <- data.frame()
  
  for (f in fichiers) {
    # Charger chaque fichier en dataframe
    raw_benthic_df <- read.csv(f)
    
    # Vérifier que les 13 premières colonnes ont le nom attendu
    if (identical(colnames(raw_benthic_df)[1:13], noms.cols.attendus)) {
      # Si oui, concatener les données
      benthos <- rbind(benthos, raw_benthic_df)
    } else {
      # sinon, afficher un message d'erreur pour le mauvais fichier
      message <- sprintf("N'a pu charger %s: mauvais noms de colonnes.", f)
      print(message)
    }
  }
  
  return(benthos)
}