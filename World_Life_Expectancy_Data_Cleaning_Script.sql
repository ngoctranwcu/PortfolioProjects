select country, year, concat(country,year), count(concat(country,year))
 from world_life_expectancy
 group by country, year, concat(country,year)
 having count(concat(country,year)) >1; 

select *
from (
	select row_id,
	concat(country,year) as country_year,
	row_number() over( partition by concat(country,year) order by concat(country,year)) as row_num

	from world_life_expectancy 
	) as row_table
   where  row_num > 1
    ;
 
 # delete duplicate rows
 delete from world_life_expectancy
 where 
	row_id in 
		(select row_id
		from (
				select row_id,
				concat(country,year) as country_year,
				row_number() over( partition by concat(country,year) order by concat(country,year)) as row_num
				from world_life_expectancy 
			) as row_table
		where  row_num > 1
        )
;

#Handle blank values in the "Status" column
select *
from  world_life_expectancy
where status = ''
;

select distinct(status)
from  world_life_expectancy;

select distinct(country)
from  world_life_expectancy
where Status = 'Developing';

# using self join
update world_life_expectancy t1
inner join world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'Developing'
where t1.status = ''
and t2.status <> '' 
and t2.status = 'Developing'
;

select *
from  world_life_expectancy
where country = 'United States of America'
;

# using self join
update world_life_expectancy t1
inner join world_life_expectancy t2
	on t1.country = t2.country
set t1.status = 'Developed'
where t1.status = ''
and t2.status <> '' 
and t2.status = 'Developed'
;

#This checks if the cleaning of missing values in the "Status" column has been applied correctly.
select *
from  world_life_expectancy
where status is null
;

#This checks for missing values in the "Life Expectancy" column.
select *
from  world_life_expectancy
where `Life expectancy`  = ''
;

select country, year, `Life expectancy`
from  world_life_expectancy
order by `Life expectancy`
;

# Fill missing values by taking the average of the life expectancy from the previous and next year of the same country using a self join.
#t1 will be current, t2 will be previous year and t3 will be next year
select t1.country, t1.year, t1.`Life expectancy`,
		t2.country, t2.year, t2.`Life expectancy`,
        t3.country, t3.year, t3.`Life expectancy`,
        round((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
from  world_life_expectancy t1
inner join world_life_expectancy t2
	on t1.country = t2.country and t1.year = t2.year - 1
inner join world_life_expectancy t3
	on t1.country = t3.country and t1.year = t3.year + 1
where t1.`Life expectancy` = ''
;

update  world_life_expectancy t1
inner join world_life_expectancy t2
	on t1.country = t2.country and t1.year = t2.year - 1
inner join world_life_expectancy t3
	on t1.country = t3.country and t1.year = t3.year + 1
set t1.`Life expectancy`=  round((t2.`Life expectancy`+ t3.`Life expectancy`)/2,1)
where t1.`Life expectancy` = ''