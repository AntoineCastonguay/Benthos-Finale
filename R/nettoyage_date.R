nettoyer_dates <- function(dates) {
  # Accepte seulement le format ISO 8601 (les autres sont ambigüs)
  # AAAA-MM-JJ
  
  # REGEX qui correspond au format ISO 8601
  iso_8601_pattern <- "^[12][0-9]{3}-[01][0-9]-[0123][0-9]$"
  
  # Si une date ne correspond pas au format, insérer un NA à la place
  clean <- ifelse(grepl(iso_8601_pattern, dates), dates, NA)
  
  return(clean)
}