# US Household Income Data Cleaning.

SELECT * FROM us_project.us_household_income;

SELECT * FROM us_project.us_household_income_statistics;

# Rename the column ï»¿id to id to fix the import error.
alter table us_project.us_household_income_statistics rename column `ï»¿id` to `id`;

#identify duplicate ids in us_household_income table.
select id, count(id)
from us_household_income
group by id
having count(id) > 1
;

# define row_num using a window function to identify and delete duplicate ids later.
select *
from (
		select 
		row_id,
		id,
		row_number() over (partition by id order by id) row_num
		from us_household_income
	) duplicates
where row_num > 1
;

#delete duplicate ids.
delete from us_household_income
where row_id in (
					select row_id
					from (
							select 
							row_id,
							id,
							row_number() over (partition by id order by id) row_num
							from us_household_income
						) duplicates
					where row_num > 1
				)
;

#identify formatting issues in the state_name column.
select State_Name, count(State_Name) as count_state_name
from us_household_income
group by State_Name
order by count_state_name
;

#corect the state name from 'georia' to 'Georgia'.
update us_household_income
set State_Name = 'Georgia'
where State_Name = 'georia'
;

#corect the state name from 'alabama' to 'Alabama'.
update us_household_income
set State_Name = 'Alabama'
where State_Name = 'alabama'
;

#check state name abbrbviations.
select distinct State_ab
from us_household_income
;

#check the place column.
select distinct Place, county
from us_household_income
order by  Place, county
;

#Profile place and county columns to fill missing values in the place column.
select Place, county, count(*)
from us_household_income
where county = 'Autauga County'
group by Place, county
;

#Fill missing values in the place column with Autaugaville.
update us_household_income
set Place = 'Autaugaville'
where County = 'Autauga County' and City = 'Vinemont'
;

#verify if the cleanup was successful.
select * from us_household_income
where Place = ''
;

#profile column type.
select type, count(type) from us_household_income
group by type
order by type
;

#change the value 'Boroughs' to Borough in the column type.
update us_household_income
set type = 'Borough'
where type = 'Boroughs'
;

#profile alan and awater clumns.
select aland, awater, count(*) 
from us_household_income
group by aland, awater
;

#identify rows where awater is 0, null or blank.
select aland, awater
from us_household_income
where awater in ('0', '', null)
;
select distinct awater
from us_household_income
where awater in ('0', '', null)
;

#identify rows where aland is 0, null or blank.
select aland, awater
from us_household_income
where aland in ('0', '', null)
;
select distinct aland
from us_household_income
where aland in ('0', '', null)
;

#identify both awater & aland having values as 0 or null or blank.
select aland, awater
from us_household_income
where awater in ('0', '', null) and aland in ('0', '', null)
;

#identify duplicate ids in us_household_income_statistics table.
select id, count(id)
from us_household_income_statistics
group by id
having count(id) > 1
;

