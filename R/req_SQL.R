SQL.get <- function() {
  
  con <- dbConnect(SQLite(), dbname="benthos.db")
  
  req <- 
"SELECT HBI_cat, count(HBI_cat)
FROM(
	SELECT 
		a.site_ab, 
		a.date_ab, 
		SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) AS HBI,
		CASE 
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 0 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 3.51 THEN 'Excellente'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 3.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 4.51 THEN 'Très bonne'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 4.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 5.51 THEN 'Bonne'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 5.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 6.51 THEN 'Moyenne'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 6.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 7.51 THEN 'Plutôt mauvaise'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 7.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 8.51 THEN 'Mauvaise'
			WHEN SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) >= 8.51 AND SUM(CAST(a.abondance AS FLOAT) * e.score_EPT / CAST(abTotal AS FLOAT)) < 10.01 THEN 'Très mauvaise'
			ELSE 'Autre Interval'
		END AS HBI_cat
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
	GROUP BY 
		a.site_ab, 
		a.date_ab
	ORDER BY 
		a.site_ab)
GROUP BY
	HBI_cat
ORDER BY
	CASE 
		WHEN HBI_cat = 'Excellente' THEN 1
		WHEN HBI_cat = 'Très bonne' THEN 2
		WHEN HBI_cat = 'Bonne' THEN 3
		WHEN HBI_cat = 'Moyenne' THEN 4
		WHEN HBI_cat = 'Plutôt mauvaise' THEN 5
		WHEN HBI_cat = 'Mauvaise' THEN 6
		WHEN HBI_cat = 'Très mauvaise' THEN 7
	END"
  
  res <- dbGetQuery(con, req)
  
  req2 <- 
"SELECT site_ab, AVG(parDate.abTotal) AS abTotal, AVG(sc) AS HBI
FROM
	(SELECT 
		a.site_ab, 
		a.date_ab, 
		abTotal,
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
	GROUP BY 
		a.site_ab, 
		a.date_ab
	ORDER BY a.site_ab) AS parDate
GROUP BY site_ab
ORDER BY site_ab"
  
  res2 <- dbGetQuery(con, req2)
  
  req3 <- 
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
  
  res3 <- dbGetQuery(con, req3)
  
  dbDisconnect(con)
  
  return(list(res,res2,res3))
}
