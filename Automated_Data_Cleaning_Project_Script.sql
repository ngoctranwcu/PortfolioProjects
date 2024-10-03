delimiter $$
drop procedure if exists copy_and_clean_data;
create procedure copy_and_clean_data()
begin
-- creating our table
	CREATE TABLE if not exists `us_hh_income_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` timestamp DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
-- copy data to new table
	insert into us_hh_income_cleaned
    SELECT *, current_timestamp
    FROM us_hh_income.us_hh_income ;

-- data cleaning steps

	-- Remove Duplicates
	DELETE FROM us_hh_income_cleaned 
	WHERE 
		row_id IN (
		SELECT row_id
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id, `TimeStamp`
				ORDER BY id, `TimeStamp`) AS row_num
		FROM 
			us_hh_income_cleaned
	) duplicates
	WHERE 
		row_num > 1
	);

	-- Fixing some data quality issues by fixing typos and general standardization
	UPDATE us_hh_income_cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia';

	UPDATE us_hh_income_cleaned
	SET County = UPPER(County);

	UPDATE us_hh_income_cleaned
	SET City = UPPER(City);

	UPDATE us_hh_income_cleaned
	SET Place = UPPER(Place);

	UPDATE us_hh_income_cleaned
	SET State_Name = UPPER(State_Name);

	UPDATE us_hh_income_cleaned
	SET `Type` = 'CDP'
	WHERE `Type` = 'CPD';

	UPDATE us_hh_income_cleaned
	SET `Type` = 'Borough'
	WHERE `Type` = 'Boroughs';

end $$
delimiter ;

call copy_and_clean_data();

-- create event
drop event run_data_cleaning;
create event run_data_cleaning
	on schedule every 30 day
    do call copy_and_clean_data();


-- debuging or checking store procedure works

SELECT row_id , id, row_num
	FROM (
		SELECT row_id, id,
			ROW_NUMBER() OVER (
				PARTITION BY id, `TimeStamp`
				ORDER BY id, `TimeStamp`) AS row_num
		FROM 
			us_hh_income_cleaned
	) duplicates
	WHERE 
		row_num > 1
	;
    
select count(row_id)
 from us_hh_income_cleaned;
 
 select state_name, count(state_name)
 from us_hh_income_cleaned
 group by state_name;


