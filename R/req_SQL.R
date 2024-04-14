SQL.get <- function() {
  req <- "SELECT orders, site_ab, AVG(abond) AS abondance_moyenne
  FROM (
    SELECT e.orders, a.site_ab, a.date_ab, SUM(a.abondance / s.fraction) AS abond
    FROM espece e
    INNER JOIN abondance a ON a.identification_ab = e.identification
    INNER JOIN site s ON (s.site = a.site_ab AND s.date = a.date_ab)
    WHERE orders IN ('Ephemeroptera','Trichoptera', 'Plecoptera')
    GROUP BY e.orders, a.site_ab, a.date_ab
  )
  GROUP BY orders, site_ab
  ORDER BY site_ab"
  
  con <- dbConnect(SQLite(), dbname="benthos.db")
  res <- dbGetQuery(con, req)
  
}