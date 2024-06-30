Task 1

CREATE SCHEMA pandemic;
use pandemic;


Task 2

Створив нову табличку з даними країни та переніс дані з ненормалізованої таблиці infectious_cases

create table country (id INT auto_increment primary key, country varchar(50), country_code varchar(10));

Insert into country (country, country_code) Select distinct Entity, Code from infectious_cases;

SELECT * FROM pandemic.country;

Створив нову нормалізовану табличку infectious_cases_norm та переніс дані з ненормалізованої таблиці 
infectious_cases та дані country_id з нормалізованої таблиці country

CREATE TABLE `infectious_cases_norm` (
  `country_id` int NOT NULL,
  `Year` int DEFAULT NULL,
  `Number_yaws` text,
  `polio_cases` text,
  `cases_guinea_worm` text,
  `Number_rabies` text,
  `Number_malaria` text,
  `Number_hiv` text,
  `Number_tuberculosis` text,
  `Number_smallpox` text,
  `Number_cholera_cases` text
);

insert into infectious_cases_norm (`country_id`,
`Year`,
`Number_yaws`,
`polio_cases`,
`cases_guinea_worm`,
`Number_rabies`,
`Number_malaria`,
`Number_hiv`,
`Number_tuberculosis`,
`Number_smallpox`,
`Number_cholera_cases`)
select c.id,
i.`Year`,
i.`Number_yaws`,
i.`polio_cases`,
i.`cases_guinea_worm`,
i.`Number_rabies`,
i.`Number_malaria`,
i.`Number_hiv`,
i.`Number_tuberculosis`,
i.`Number_smallpox`,
i.`Number_cholera_cases` from infectious_cases i join country c on c.country = i.Entity and c.country_code = i.Code;

SELECT * FROM pandemic.infectious_cases_norm;

3. Проаналізував дані
SELECT country_id, min(Number_rabies) as min_cases, max(Number_rabies) as max_cases, avg(Number_rabies) as avg_cases, 
sum(Number_rabies) as sum_cases
FROM pandemic.infectious_cases_norm 
WHERE LENGTH(Number_rabies) > 0
GROUP BY country_id
ORDER BY avg_cases DESC
LIMIT 10;

4. 	Побудував колонки різниці в роках
SELECT country_id, `Year`, MAKEDATE(`Year`, 1) as `data`, NOW() as current_data, TIMESTAMPDIFF(YEAR,MAKEDATE(`Year`, 1),NOW()) as difference_years 
FROM pandemic.infectious_cases_norm;


5.1 Власні функції

DROP FUNCTION IF EXISTS fn_difference_in_years;

DELIMITER //

CREATE FUNCTION fn_difference_in_years(year INT)
RETURNS int
DETERMINISTIC
NO SQL
BEGIN
	DECLARE result INT;
    SET result = YEAR(CURDATE()) - year;
    RETURN result;
END //

DELIMITER ;

SELECT fn_difference_in_years(1996)    

5.2 Власні функції

DROP FUNCTION IF EXISTS fn_calc_avg_illnesses;

DELIMITER //

CREATE FUNCTION fn_calc_avg_illnesses(num_illnesses_per_year DOUBLE, period INT)
RETURNS DOUBLE
DETERMINISTIC 
NO SQL
BEGIN
    DECLARE result DOUBLE;
    SET result = num_illnesses_per_year / period;
    RETURN result;
END //

DELIMITER ;

SELECT fn_calc_avg_illnesses(6000, 12); 