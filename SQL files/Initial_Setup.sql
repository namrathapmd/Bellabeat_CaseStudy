/*
INITIAL SETUP: Importing data
CREATE TABLE, COLUMN NAMES, DATATYPES
*/

CREATE TABLE IF NOT EXISTS daily_activity (
	"Id" bigint,
	ActivityDate date,
	TotalSteps int,
	TotalDistance float,
	TrackerDistance float,
	LoggedActivitiesDistance float,
	VeryActiveDistance float,
	ModeratelyActiveDistance float,
	LightActiveDistance float,
	SedentaryActiveDistance float,
	VeryActiveMinutes int,
	FairlyActiveMinutes int,
	LightlyActiveMinutes int,
	SedentaryMinutes int,
	Calories int

);


CREATE TABLE IF NOT EXISTS daily_calories (
	"Id" bigint,
	ActivityDate date,
	Calories int
);


CREATE TABLE IF NOT EXISTS daily_intensities (
	"Id" bigint,
	ActivityDay date,
	SedentaryMinutes int,
	LightActiveMinutes int,
	FairlyActiveMinutes int,
	VeryActiveMinutes int,
	SedentaryActiveDistance float,
	LightActiveDistance float,
	ModeratelyActiveDistance float,
	VeryActiveDistance float
);

CREATE TABLE IF NOT EXISTS daily_steps (
	"Id" bigint,
	ActivityDay date,
	StepTotal int
);

CREATE TABLE IF NOT EXISTS daily_sleep (
	"Id" bigint,
	SleepDay TIMESTAMP,
	TotalSleepRecords int,
	TotalMinutesAsleep int,
	TotalTimeInBed int
);

CREATE TABLE IF NOT EXISTS weight_log (
	"Id" bigint,
	"date" TIMESTAMP,
	WeightKg float,
	WeightPounds float,
	Fat int,
	BMI float,
	IsManualReport boolean,
	LogId bigint
);

CREATE TABLE IF NOT EXISTS hourly_calories (
	"Id" bigint,
	ActivityHour TIMESTAMP,
	Calories int
);

CREATE TABLE IF NOT EXISTS hourly_intensities (
	"Id" bigint,
	ActivityHour TIMESTAMP,
	TotalIntensity int,
	AverageIntensity float
);

CREATE TABLE IF NOT EXISTS hourly_steps (
	"Id" bigint,
	ActivityHour TIMESTAMP,
	StepTotal int
);

CREATE TABLE IF NOT EXISTS minute_sleep (
	"Id" bigint,
	"date" TIMESTAMP,
	"value" int,
	logId bigint
);