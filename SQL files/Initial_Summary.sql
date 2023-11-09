/*
INITIAL SUMMARY
*/


-- no. of unique IDs in daily_activity
SELECT COUNT(DISTINCT "Id") FROM daily_activity

-- no. of unique IDs in daily_sleep
SELECT COUNT(DISTINCT "Id") FROM daily_sleep

-- no. of unique IDs in hourly_calories
SELECT COUNT(DISTINCT "Id") FROM hourly_calories

-- no. of unique IDs in hourly_intensities
SELECT COUNT(DISTINCT "Id") FROM hourly_intensities

-- TOTAL OBSERVATIONS
-- total no. of rows in daily_activity table
SELECT COUNT(*) FROM daily_activity

-- total no. of rows in daily_sleep table
SELECT COUNT(*) FROM daily_sleep

-- total no. of observations in hourly_calories table
SELECT COUNT(*) FROM hourly_calories

-- total no. of observations in hourly_intensities table
SELECT COUNT(*) FROM hourly_intensities

-- SUMMARY STATISTICS

-- Daily totals for steps, distance and calories
SELECT 
 MIN(totalsteps) as totalsteps_min, 
 MIN(totaldistance) as totaldistance_min,
 MIN(calories) as calories_min,
 MAX(totalsteps) as totalsteps_max,
 MAX(totaldistance) as totaldistance_max,
 MAX(calories) as calories_max,
 AVG(totalsteps) as totalsteps_avg,
 AVG(totaldistance) as totaldistance_avg,
 AVG(calories) as calories_avg
FROM daily_activity


-- active minute levels per category
SELECT 
 MIN(veryactiveminutes) as veryactivemin_min, 
 MIN(fairlyactiveminutes) as fairlyactivemin_min,
 MIN(lightlyactiveminutes) as lightactivemin_min,
 MIN(sedentaryminutes) as sedentarymin_min,
 MAX(veryactiveminutes) as veryactivemin_max,
 MAX(fairlyactiveminutes) as fairlyactivemin_max,
 MAX(lightlyactiveminutes) as lightactivemin_max,
 MAX(sedentaryminutes) as sedentarymin_max,
 AVG(veryactiveminutes) as veryactivemin_avg,
 AVG(fairlyactiveminutes) as fairlyactivemin_avg,
 AVG(lightlyactiveminutes) as lightactivemin_avg,
 AVG(veryactiveminutes) as sedentarymin_avg
FROM daily_activity


-- Sleep totals: for records, minutes asleep and time in bed
SELECT 
 MIN(totalsleeprecords) as totalsleeprecords_min, 
 MIN(totalminutesasleep) as totalminutesasleep_min,
 MIN(totaltimeinbed) as totaltimeinbed_min,
 MAX(totalsleeprecords) as totalsleeprecords_max,
 MAX(totalminutesasleep) as totalminutesasleep_max,
 MAX(totaltimeinbed) as totaltimeinbed_max,
 AVG(totalsleeprecords) as totalsleeprecords_avg,
 AVG(totalminutesasleep) as totalminutesasleep_avg,
 AVG(totaltimeinbed) as totaltimeinbed_avg
FROM daily_sleep


-- hourly calories summary
SELECT 
 MIN(calories) as calories_min, 
 MAX(calories) as calories_max,
 AVG(calories) as calories_avg
FROM hourly_calories

