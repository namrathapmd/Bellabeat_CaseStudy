/*
GETTING TO KNOW THE DATA
*/

-- columns shared across tables
SELECT 
	column_name, 
	COUNT(table_name) 
FROM 
	information_schema.columns
WHERE 
	table_schema = 'public'
GROUP BY 
1


-- tables that have column 'Id'
SELECT
	table_name,
	SUM(CASE
	   	WHEN column_name = 'Id' THEN 1  
	   ELSE
	   0
	END
		) AS has_id_column
FROM
	information_schema.columns
WHERE 
	table_schema = 'public'
GROUP BY 
	1
ORDER BY 
	1 ASC


-- tables who have following datatype: date, time, timestamp, etc.
SELECT
  table_name,
  data_type,
  SUM(CASE
     WHEN data_type IN ('date','time','timestamp without time zone','timestamp with time zone','timestamp') THEN 1
   ELSE
   0
 END
   ) AS has_time_info
FROM
  information_schema.columns
WHERE
	table_schema = 'public'
	AND
	data_type IN ('date','time','timestamp without time zone','timestamp with time zone','timestamp')
GROUP BY
	1,2
ORDER BY
	table_name
	

-- columns having the following datatype: date, time, timestamp, etc.
SELECT
	CONCAT(table_catalog,'.',table_schema,'.',table_name) AS table_path,
	table_name,
	column_name
FROM
	information_schema.columns
WHERE
	table_schema = 'public' 
	AND
 	data_type IN ('date','time','timestamp without time zone','timestamp with time zone','timestamp')



-- column names matching the following keywords: date,minute,daily,hourly,day,seconds.
SELECT
  table_name,
  column_name
FROM
  information_schema.columns
WHERE
  table_schema = 'public' AND
  LOWER(column_name) ~ 'date|minute|daily|hourly|day|seconds';



-- table names matching the following keywords: date|daily
SELECT
  DISTINCT table_name
FROM
  information_schema.columns
WHERE
  table_schema = 'public' AND
  LOWER(table_name) ~ 'day|daily'



-- columns shared across these tables (daily_activity, daily_calories,daily_intensities,daily_sleep,daily_steps)
SELECT
	column_name, 
	data_type,
	COUNT(table_name) AS table_count
FROM 
	information_schema.columns
WHERE 
	table_schema = 'public' AND
	LOWER(table_name) ~ 'day|daily'
GROUP BY
 	1,
 	2
	
	

-- distinct columns that have table names matching ~ day|daily
WITH daily_columns AS (
	SELECT
		DISTINCT column_name
	FROM 
		information_schema.columns
	WHERE 
		table_schema = 'public' AND
		LOWER(table_name) ~ 'day|daily'
	)
	
-- using above, we are finding the data type and columns that are appearing in more than one tables to establish a link between each table	
SELECT 
	column_name,
	data_type,
	COUNT(table_name) AS table_count
FROM 
	information_schema.columns
WHERE 
	table_schema = 'public' AND
	LOWER(table_name) ~ 'day|daily' AND
	column_name IN (SELECT * FROM daily_columns)
GROUP BY 
	1,2
HAVING 
	COUNT(table_name) >= 2
ORDER BY 
	1