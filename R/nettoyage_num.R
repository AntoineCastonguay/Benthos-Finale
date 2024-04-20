nettoyer_num <- function(nums, min, max) {
  # S'assurer que tous les nombres soient entre 2 valeurs qui font du sens pour cette colonne
  # Sinon, insérer un NA pour cette valeur
  cleaned <- ifelse((nums >= min) & (nums <= max), nums, NA)
  return(cleaned)
}