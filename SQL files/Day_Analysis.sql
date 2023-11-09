/*
DAY-WISE ANALYSIS 
*/


/*-- Creating custom daily_sleep table with new columns 
using CTE (Common Table Expression)
*/
WITH daily_sleep_custom AS (
	SELECT 
		 *,
		 cast(sleepday as date) as default_date
	FROM
		 public.daily_sleep		
),


/*
Creating custom daily_activity table with new columns that 
extract day of week and week number from the 'activitydate' column
*/
daily_activity_custom AS (
	SELECT
		*,
		TO_CHAR(activitydate, 'FMDay') AS day_of_week,
		EXTRACT (DOW FROM activitydate) AS dow_number
	FROM
		public.daily_activity
),


/* join the above two custom tables with daily_calories and daily_intensities,
daily_steps and daily_sleep tables to form one big table for day analysis
*/
daily_analysis AS (
 
SELECT 
	  a."Id",
	  a.activitydate,
	  a.day_of_week,
	  a.dow_number,
	  a.calories,
	  a.totalsteps,
	  a.totaldistance,
	  a.trackerdistance,
	  i.sedentaryminutes,
	  i.lightactiveminutes,
	  i.fairlyactiveminutes,
	  i.veryactiveminutes,
	  i.sedentaryactivedistance,
	  i.lightactivedistance,
	  i.moderatelyactivedistance,
	  i.veryactivedistance,
	  sl.totaltimeinbed,
	  sl.totalminutesasleep
 
FROM
	 daily_activity_custom AS a

	 LEFT JOIN
	 public.daily_calories AS c
	 ON a."Id" = c."Id"
	 AND a.activitydate = c.activityday
	 AND a.calories = c.calories

	 LEFT JOIN
	 public.daily_intensities AS i
 	 ON a."Id" = i."Id"
	 AND a.activitydate = i.activityday
	 AND a.fairlyactiveminutes = i.fairlyactiveminutes
	 AND a.lightactivedistance = i.lightactivedistance
 	 AND a.lightlyactiveminutes = i.lightactiveminutes
	 AND a.moderatelyactivedistance = i.moderatelyactivedistance
     AND a.sedentaryactivedistance = i.sedentaryactivedistance
     AND a.sedentaryminutes = i.sedentaryminutes
	 AND a.veryactivedistance = i.veryactivedistance
	 AND a.veryactiveminutes = i.veryactiveminutes

	 LEFT JOIN 
	 public.daily_steps AS s
	 ON a."Id" = s."Id"
	 AND a.activitydate = s.activityday

	 LEFT JOIN
	 daily_sleep_custom AS sl
	 ON a."Id" = sl."Id"
	 AND a.activitydate = sl.default_date

	GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18

	ORDER BY activitydate
)


--Total Time spent on activity every day
SELECT 
	 DISTINCT "Id", 
	 ROUND(AVG(sedentaryminutes),2) AS sendentary_mins,
	 ROUND(AVG(lightactiveminutes),2) AS lightly_active_mins,
	 ROUND(AVG(fairlyactiveminutes),2) AS fairly_active_mins, 
	 ROUND(AVG(veryactiveminutes),2) AS very_active_mins,
	 ROUND(AVG(totaltimeinbed),2) AS sleep_mins
FROM 
	daily_analysis
WHERE 
	totaltimeinbed IS NOT NULL
GROUP BY 
	"Id"
ORDER BY 
	"Id"

-- Daily Average Analysis (steps, distance, calories)
SELECT 
	 dow_number,
	 day_of_week,
	 AVG(totalsteps) AS avg_steps,
	 AVG(totaldistance) AS avg_distance,
	 AVG(calories) AS avg_calories
FROM
 	daily_analysis
GROUP BY
 	1,2
ORDER BY 
 	1

-- Active Duration and calories burned relation
SELECT 
	 "Id",
	 SUM(totalsteps) AS total_steps,
	 SUM(veryactiveminutes) as total_very_active_mins,
	 Sum(fairlyactiveminutes) as total_fairly_active_mins,
	 SUM(lightlyactiveminutes) as total_lightly_active_mins,
	 SUM(calories) as total_calories
FROM 
	daily_activity
GROUP BY 
	1
ORDER BY 
	1

-----------------------SLEEP ANALYSIS----------------------------------
--Average sleep time per user
SELECT 
	"Id", 
	AVG(totalminutesasleep)/60 as avg_sleep_time_hour,
	AVG(totaltimeinbed)/60 as avg_time_bed_hour,
	AVG(totaltimeinbed - totalminutesasleep) as wasted_bed_time_min
FROM 
	daily_sleep
GROUP BY 
	"Id"


--total sleep minutes vs calories burned
SELECT 
	"Id",
	SUM(totalminutesasleep) AS total_sleep_min,
	SUM(totaltimeinbed) AS total_time_in_bed_min,
	SUM(calories) AS calories
FROM
	daily_analysis
WHERE totaltimeinbed IS NOT NULL
GROUP BY
	1
ORDER BY
	1
