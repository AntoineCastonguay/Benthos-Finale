SQL.get <- function() {
  
  con <- dbConnect(SQLite(), dbname="benthos.db")
  
  req <- 
    "SELECT site_ab, AVG(abond) AS abondance_moyenne
    FROM (
      SELECT a.site_ab, a.date_ab, SUM(a.abondance / s.fraction) AS abond
      FROM espece e
      INNER JOIN abondance a ON a.identification_ab = e.identification
      INNER JOIN site s ON (s.site = a.site_ab AND s.date = a.date_ab)
      WHERE orders IN ('Ephemeroptera','Trichoptera', 'Plecoptera')
      GROUP BY a.site_ab, a.date_ab)
    GROUP BY site_ab
    ORDER BY site_ab"
  
  res <- dbGetQuery(con, req)
  
  graph1 <- barplot(height = res$abondance_moyenne,names.arg = res$site_ab,las = 2)
  
  req2 <- 
    "SELECT site_ab, AVG(cc.count) AS average_count
    FROM (
      SELECT site_ab, date_ab, COUNT(DISTINCT identification_ab) AS count
      FROM abondance
	    INNER JOIN site ON (site = site_ab AND date = date_ab)
      GROUP BY site_ab, date_ab) AS cc
    GROUP BY site_ab"
  
  res2 <- dbGetQuery(con, req2)
  
  graph2 <- barplot(height = res2$average_count,names.arg = res2$site_ab, las=2)
  
  req3 <- 
    "SELECT transparence_eau, AVG(abond) AS abondance_moyenne
    FROM (
      SELECT c.transparence_eau, a.site_ab, a.date_ab, SUM(a.abondance / s.fraction) AS abond
      FROM espece e
      INNER JOIN abondance a ON a.identification_ab = e.identification
      INNER JOIN site s ON (s.site = a.site_ab AND s.date = a.date_ab)
      INNER JOIN condition_echantillonnage c ON (s.site = c.site_cond AND s.date = c.date_cond)
      WHERE orders IN ('Ephemeroptera','Trichoptera', 'Plecoptera')
      GROUP BY c.transparence_eau, a.site_ab, a.date_ab)
    GROUP BY transparence_eau"
  
  res3 <- dbGetQuery(con, req3)
  

  
  dbDisconnect(con)
  
  return(list(res,res2,res3))
}
