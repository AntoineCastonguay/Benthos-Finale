# Analyze de données du benthos des rivières du Québec
Auteurs: Antoine Castonguay, Claudiane Bondu et Juliette Robin

Ce project analyze la biodiversité du benthos des rivières du Québec. Nous utilisons la librairie `targets` de R pour gérer les tâches de lecture, de nettoyage, d'analyse et de présentation des données. Le rapport final est généré en RMarkdown et produit un fichier .html.

## Structure du projet

- `R/`: scripts R
- `data/`: données du benthos
- `_targets.R`: défini les étapes du pipeline du projet
- `rapport.Rmd`: RMarkdown document for reporting analysis results.
- `benthos.db`: base de données générées à partir des données CSV brutes.

## Configuration

### Prérequis

Les libraries suivantes sont prérequises:
- `targets`
- `rmarkdown`
- `dplyr`
- `RSQLite`
- `tarchetypes`
- `rticles`
- `taxize`

### Installation

Cloner le repository suivant:
https://github.com/AntoineCastonguay/Benthos-Finale.git

### Données

Les données doivent être installées dans le dossier `data/` et être des fichiers .csv. Pour être lues correctement, les fichiers doivent avoir les colonnes suivantes:
- `date` date de l'échantillonnage
- `site` identifiant unique du site
- `date_obs` date de l'observation
- `heure_obs` heure de l'observation
- `fraction` fraction de l'échantillon qui a été analysé
- `nom_sci` nom scientifique de l'espèce
- `abondance` quantité d'individus de l'espèce trouvée dans l'échantillon
- `largeur_riviere` largeur de la rivière (m)
- `profondeur_riviere` profondeur de la rivière (m)
- `vitesse_courant` vitesse du courant
- `transparence_eau` transparence de l'eau
- `temperature_eau_c` température de l'eau en degrés Celsius
- `ETIQSTATION` étiquette de la station

### Rouler l'analyse

Utiliser la commande suivante pour rouler l'analyse:
`targets::tar_make()`