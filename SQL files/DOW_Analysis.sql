-- Analysis based on DAY OF WEEK and TIME OF THE DAY 
/*
DOW SUMMARY: Summary of calories, intensity, average_intensity combined 
PER person(ID) 
PER day of week (Sunday,Monday...,Saturday) 
PER time of day (Morning,Afternoon,Evening,Night)
*/

WITH dow_summary AS (
  SELECT 
    HI."Id",
    EXTRACT (DOW FROM HI.activityhour) AS dow_number,
    TO_CHAR(HI.activityhour, 'FMDay') AS day_of_week,
    CASE 
      WHEN TO_CHAR(HI.activityhour, 'FMDay') IN ('Sunday','Saturday') THEN 'Weekend'
      WHEN TO_CHAR(HI.activityhour, 'FMDay') NOT IN ('Sunday','Saturday') THEN 'Weekday'
      ELSE 'ERROR'
    END AS part_of_week,
    CASE
      WHEN EXTRACT(hour FROM HI.activityhour) BETWEEN 6 AND 12 THEN 'Morning'
      WHEN EXTRACT(hour FROM HI.activityhour) BETWEEN 12 AND 18 THEN 'Afternoon'
      WHEN EXTRACT(hour FROM HI.activityhour) BETWEEN 18 AND 21 THEN 'Evening'  
      WHEN EXTRACT(hour FROM HI.activityhour) BETWEEN 21 AND 23 OR EXTRACT(hour FROM HI.activityhour) BETWEEN 0 AND 5 THEN 'Night'
      ELSE 'ERROR'
    END AS time_of_day,

   -- Aggregations for each person("Id")
    SUM(HC.calories) AS total_calories, 
    SUM(totalintensity) AS total_intensity,
    SUM(averageintensity) AS total_average_intensity,
    AVG(averageintensity) AS average_intensity,
 
    MAX(AverageIntensity) AS max_intensity,
    MIN(AverageIntensity) AS min_intensity
  FROM
     public.hourly_intensities AS HI
     LEFT JOIN hourly_calories AS HC 
     ON HI."Id" = HC."Id"
 
  GROUP BY
     1,2,3,4,5

  ORDER BY
     1,2,3,4,5
),

/*
COMBINED SUMMARY: combined table that has intensity summary for all 33 people ordered by 
  (part_of_week,   Weekday, Weekend
  dow_number,      0,1,2,3,4...6 
  day_of_week,     Monday-Fri(1,2,3,4,5), Sun-Sat(0,6)
  time_of_day)     Morning,Afternoon,Evening,Night
*/
combined_summary AS (
 SELECT 
  part_of_week,
  day_of_week,
  time_of_day,
  -- calories (all combined)
  SUM(total_calories) AS all_calories,
  AVG(total_calories) AS all_avg_calories,
  -- intensity (all combined)
  SUM(total_intensity) AS all_intensity,
    AVG(total_intensity) AS all_avg_intensity,
  -- average_intensity (all combined)
     SUM(total_average_intensity) AS all_average_intensity,
     AVG(total_average_intensity) AS all_avg_average_intensity,
  -- average intensity
     AVG(max_intensity) AS all_average_max_intensity,
     AVG(min_intensity) AS all_average_min_intensity
 FROM
  dow_summary
 GROUP BY
  1,
  dow_number,
  2,
  3
 ORDER BY
  1,
  dow_number,
  2,
  CASE
   WHEN time_of_day = 'Morning' THEN 0
     WHEN time_of_day = 'Afternoon' THEN 1
      WHEN time_of_day = 'Evening' THEN 2
      WHEN time_of_day = 'Night' THEN 3
  END
)