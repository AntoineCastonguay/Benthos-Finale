# Fonction qui va chercher les données nécessaires à l'analyse et la production de 3 figures

SQL.get <- function(database) {
  
  con <- dbConnect(SQLite(), dbname=database)
  
  # Première requête calcule le nombre de rivières par niveau de pollution
  req <- 
  "WITH abondances_par_echantillonnage AS (
			SELECT 
				date_ab, 
				site_ab, 
				SUM(abondance) / fraction AS  abondance_site
			FROM abondance
			INNER JOIN site ON (site = site_ab AND date = date_ab)
			GROUP BY date_ab, site_ab
			),
			indice_pollution_par_echantillonnage AS (
			SELECT date_ab, site_ab,
				SUM((abondance / fraction) * score_EPT / abondance_site) AS indice_pollution
			FROM abondance 
			INNER JOIN espece ON identification_ab = identification
			INNER JOIN abondances_par_echantillonnage USING (site_ab, date_ab)
			INNER JOIN site ON (site = site_ab AND date = date_ab)
			GROUP BY date_ab, site_ab
			),
			categories_pollution AS (
			SELECT 'Excellente' AS categorie, 0 AS minimum, 3.50 AS maximum, 1 AS ordre
			UNION ALL
			SELECT 'Très bonne', 3.50, 4.5, 2
			UNION ALL
			SELECT 'Bonne', 4.5, 5.5, 3
			UNION ALL
			SELECT 'Moyenne', 5.5, 6.5, 4
			UNION ALL
			SELECT 'Plutôt mauvaise', 6.5, 7.5, 5
			UNION ALL
			SELECT 'Mauvaise', 7.5, 8.5, 6
			UNION ALL
			SELECT 'Très mauvaise', 8.5, 9.5, 7
			)
			
	SELECT 
		categories_pollution.categorie categorie_pollution, 
		COUNT(site_ab) nombre_rivieres,
		ordre
	FROM categories_pollution
	LEFT JOIN (
    SELECT 
    	site_ab, 
    	AVG(indice_pollution) as indice_pollution
    FROM indice_pollution_par_echantillonnage
    GROUP BY site_ab
	) rivieres ON (rivieres.indice_pollution <= categories_pollution.maximum AND rivieres.indice_pollution > categories_pollution.minimum)
	GROUP BY categorie, ordre
	ORDER BY ordre DESC"
  
  res <- dbGetQuery(con, req)
  
  # Deuxième requête calcule la richesse moyenne de chaque site et son indice de pollution moyen
  req2 <- 
"SELECT site_ab, AVG(parDate.richesse) AS richesse, AVG(sc) AS HBI
FROM
	(SELECT 
		a.site_ab, 
		a.date_ab, 
		richesse,
		SUM(CAST(a.abondance AS FLOAT)* e.score_EPT / CAST(abTotal AS FLOAT)) AS sc
	FROM 
		espece e
		INNER JOIN abondance a ON a.identification_ab = e.identification
		INNER JOIN site s ON s.site = a.site_ab AND s.date = a.date_ab
		INNER JOIN (
			SELECT 
				site_ab,
				date_ab,
				SUM(abondance) AS abTotal
			FROM 
				abondance
			GROUP BY 
				site_ab,
				date_ab
		) AS abT ON (a.site_ab = abT.site_ab AND a.date_ab = abT.date_ab)
		INNER JOIN (
			SELECT 
				site_ab,
				date_ab,
				COUNT(identification_ab) AS richesse
			FROM 
				abondance
			GROUP BY 
				site_ab,
				date_ab
		) AS abR ON (a.site_ab = abR.site_ab AND a.date_ab = abR.date_ab)
	GROUP BY 
		a.site_ab, 
		a.date_ab
	ORDER BY a.site_ab) AS parDate
GROUP BY site_ab
ORDER BY site_ab"
  
  res2 <- dbGetQuery(con, req2)
  
  # La troisième requête calcule le nombre de taxons distincts moyen pour chaque rivière, ainsi que sa température moyenne
  req3 <- 
    "WITH 
			richesse_par_echantillonnage AS (
			SELECT 
				date_ab, 
				site_ab, 
				COUNT(abondance) AS  richesse_echantillonnage
			FROM abondance
			INNER JOIN site ON (site = site_ab AND date = date_ab)
			GROUP BY date_ab, site_ab
			)
			
    SELECT 
    	site_ab, 
    	AVG(richesse_echantillonnage) as richesse,
    	AVG(temperature_eau_c) as temperature_eau_c
    FROM richesse_par_echantillonnage
    INNER JOIN condition_echantillonnage ON (date_ab = date_cond AND site_ab = site_cond)
    GROUP BY site_ab
    ORDER BY site_ab"
  
  res3 <- dbGetQuery(con, req3)
  
  dbDisconnect(con)
  
  results <- list(res,res2,res3)
  
  return(results)
}
