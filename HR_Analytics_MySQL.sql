/* create database */
DROP DATABASE hr_analysis;
CREATE DATABASE hr_analysis;

/* select the database being used */
USE hr_analysis;

/* create the first of 3 tables that will be added */
CREATE TABLE Employee_Data (ID INT NOT NULL,
							City VARCHAR(10),
							Gender VARCHAR(10),
                            PRIMARY KEY (ID));

/* look at what we have */
SELECT * FROM hr_analysis.`hr_analytics-employeedata`;

/* accidentally created new table, will delete original and rename new */
DROP TABLE hr_analytics;
RENAME TABLE `hr_analytics-employeedata` TO `employee_data`;
SELECT * FROM employee_data;

/* will add second table with the wizard */
USE hr_analysis;
SELECT * FROM educational_data;

/* will add third table with the wizard */
USE hr_analysis;
SELECT * FROM jobcitydata;

/* checking the last record in the data since the I am using the limit per table at 1000 rows */
SELECT * FROM employee_data
WHERE enrollee_ID = '33380';
SELECT * FROM educational_data
WHERE enrollee_ID = '33380';
SELECT * FROM jobcitydata
WHERE enrollee_ID = '33380';

/* doing a quick exploration of the data for NULL values*/
SELECT * FROM educational_data WHERE enrolled_university IS NULL OR education_level IS NULL 
OR major_discipline IS NULL;

SELECT * FROM educational_data WHERE education_level IS NULL;

/*above queries didn't give me the expected result, trying something else*/
/*adding a new row to test out the NULL*/
INSERT INTO educational_data (enrollee_id, enrolled_university)
VALUES ('3', 'Full Time');

SELECT * FROM educational_data WHERE enrollee_id = '3';
/*looks like blank entry for educational_level (ID = 9) was not technically NULL*/
/*must be that the wizard did not pick it up as NULL*/

/*deleting added row and will fill out missing education_level value*/
DELETE FROM educational_data WHERE enrollee_id = '3';

SELECT * FROM educational_data WHERE enrollee_id = '9';
UPDATE educational_data
SET education_level = 'dummy text'
WHERE enrollee_id = '9';

SELECT * FROM educational_data WHERE enrollee_id = '9';
/*now all cells in this table have data*/

/*counting specific values that look interesting*/
SELECT COUNT(education_level)
FROM educational_data;

SELECT COUNT(education_level)
FROM educational_data
WHERE education_level = 'Primary School';

SELECT COUNT(education_level)
FROM educational_data
WHERE education_level = 'High School';

SELECT COUNT(education_level)
FROM educational_data
WHERE education_level = 'Graduate';
/*looking at counts for certain categories for inspiration*/

/*going to start joining tables - educational_data w/ employee_data*/
SELECT educational_data.enrollee_id, educational_data.relevant_experience, employee_data.city
FROM employee_data
INNER JOIN educational_data ON educational_data.enrollee_id = employee_data.enrollee_id;

/*joining the three tables, this is probably where I would start looking for a correlation 
prospective employees that are looking to get hired*/
SELECT educational_data.enrollee_id, educational_data.relevant_experience, employee_data.city,
jobcitydata.city_development_index, jobcitydata.target
FROM employee_data
INNER JOIN educational_data ON educational_data.enrollee_id = employee_data.enrollee_id
INNER JOIN jobcitydata ON educational_data.enrollee_id = jobcitydata.enrollee_id;

/*data does not really lend itself to other types of joins*/

/*going to do a CASE statement to try to see some patterns*/
SELECT enrollee_id, city_development_index, experience, training_hours
CASE 
WHEN Quantity > 30 THEN 'The quantity is greater than 30'
WHEN Quantity = 30 THEN 'The quantity is 30'
ELSE 'The quantity is under 30'
END AS QuantityText
	WHEN city_development_index > 0.500 THEN 'Developed City'
    WHEN city_development_index < 0.500 THEN 'Underdeveloped City'
    ELSE 'Middle'
FROM jobcitydata;