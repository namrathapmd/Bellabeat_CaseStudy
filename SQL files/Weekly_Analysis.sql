/*
WEEKLY ANALYSIS
*/

WITH daily_sleep_custom AS (
 SELECT 
	*,
   	cast(sleepday as date) as default_date
 FROM
   	public.daily_sleep  
),

daily_activity_custom AS (
 SELECT
	EXTRACT (WEEK FROM activitydate) AS week_number,
  	*
 FROM
  	public.daily_activity
),

daily_analysis AS (
 SELECT 
	 a."Id",
	 a.activitydate,
     week_number,
	 a.totalsteps,
	 a.totaldistance,
	 a.veryactivedistance,
	 a.moderatelyactivedistance,
	 a.lightactivedistance,
	 a.sedentaryactivedistance,
	 a.veryactiveminutes,
	 a.fairlyactiveminutes,
	 a.lightlyactiveminutes,
	 a.sedentaryminutes,
	 a.calories,
	 sl.totalminutesasleep,
	 sl.totaltimeinbed

 FROM
  	daily_activity_custom AS a

 	LEFT JOIN daily_sleep_custom AS sl
  	ON a."Id" = sl."Id"
  	AND a.activitydate = sl.default_date

),

-- total weekly summary for each person
weekly_analysis_perId AS(
SELECT 
	 week_number,
	 "Id",
	 SUM(totalsteps) AS weekly_total_steps,
	 SUM(totaldistance) AS weekly_total_distance,
	 SUM(veryactivedistance) AS weekly_veryactive_d,
	 SUM(moderatelyactivedistance) AS weekly_fairlyactive_d,
	 SUM(lightactivedistance) AS weekly_lightactive_d,
	 SUM(sedentaryactivedistance) AS weekly_sedentary_d,
	 SUM(veryactiveminutes) AS weekly_veryactive_m,
	 SUM(fairlyactiveminutes) AS weekly_fairlyactive_m,
	 SUM(lightlyactiveminutes) AS weekly_lightactive_m,
	 SUM(sedentaryminutes) AS weekly_sedentary_m,
	 SUM(calories) AS weekly_calories,
	 SUM(veryactiveminutes) + SUM(fairlyactiveminutes) AS weekly_active_m,
	 SUM(lightlyactiveminutes) + SUM(sedentaryminutes) AS weekly_notactive_m
FROM 
 	daily_analysis
GROUP BY 1,2
ORDER BY 1,2
),

-- total weekly summary all combined
weekly_summary AS (
SELECT 
	 week_number,
	 SUM(totalsteps) AS weekly_total_steps,
	 SUM(totaldistance) AS weekly_total_distance,
	 SUM(veryactivedistance) AS weekly_veryactive_d,
	 SUM(moderatelyactivedistance) AS weekly_fairlyactive_d,
	 SUM(lightactivedistance) AS weekly_lightactive_d,
	 SUM(sedentaryactivedistance) AS weekly_sedentary_d,
	 SUM(veryactiveminutes) AS weekly_veryactive_m,
	 SUM(fairlyactiveminutes) AS weekly_fairlyactive_m,
	 SUM(lightlyactiveminutes) AS weekly_lightactive_m,
	 SUM(sedentaryminutes) AS weekly_sedentary_m,
	 SUM(calories) AS weekly_calories,
	 SUM(veryactiveminutes) + SUM(fairlyactiveminutes) AS weekly_active_m,
	 SUM(lightlyactiveminutes) + SUM(sedentaryminutes) AS weekly_notactive_m
FROM 
 	daily_analysis
GROUP BY 1
ORDER BY 1
),

-- finding all weeks that have active mins >= 150
highly_active_week AS (
SELECT 
	 week_number, 
	 "Id", 
	 SUM(weekly_active_m) as active_min_total,
	 CASE 
	 WHEN SUM(weekly_active_m) >= 150 THEN 1
	 ELSE 0
	 END AS is_highly_active
FROM 
 	weekly_analysis_perId
GROUP BY 
 	week_number,
 	"Id"
ORDER BY 
 	"Id"
),


-- creating achievement groups
achievement_grp AS (
SELECT 
	 "Id"
	 ,
	 SUM(is_highly_active)/COUNT("Id")::FLOAT*100 AS percentage,
	 CASE 
	  -- low rate ➜ successful 0-59% of weeks
	  WHEN SUM(is_highly_active)/COUNT("Id")::FLOAT*100 <= 59 THEN 'LOW'
	  -- regular rate ➜ successful 60-79% of weeks
	  WHEN SUM(is_highly_active)/COUNT("Id")::FLOAT*100 > 59 AND SUM(is_highly_active)/COUNT("Id")::FLOAT*100 <= 79 THEN 'REGULAR'
	  -- high rate ➜ successful 80-100% of weeks
	  WHEN SUM(is_highly_active)/COUNT("Id")::FLOAT*100 >= 80 THEN 'HIGH'
	 END AS achievement_group
FROM 
 	highly_active_week
GROUP BY "Id"
ORDER BY "Id"
)

-- percentage of weeks a participant is successful in achieving ≥ 150 active minutes
SELECT 
	 achievement_group, 
	 COUNT(*),
	 ROUND((COUNT(*)/33.0),3)*100 AS percent_of_whole
FROM 
 	achievement_grp
GROUP BY 
 	achievement_group