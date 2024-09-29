select *
from world_life_expectancy
;

#Which country has the largest difference between minimum and maximum life expectancy?
select country, min(`life expectancy`), max(`life expectancy`),
round(max(`life expectancy`)- min(`life expectancy`),1) as life_increase_over_15years
from world_life_expectancy
group by country
having min(`life expectancy`) <> 0 and max(`life expectancy`)
order by life_increase_over_15years desc
;

#Is there any correlation between GDP and life expectancy?
select country, round(avg(`life expectancy`),1) as Life_Exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by country 
having Life_Exp > 0 and GDP >0
order by GDP desc
;

#A strong correlation was found between high GDP and high life expectancy, as well as between low GDP and low life expectancy.
select
sum(case when GDP >=1500 then 1 else 0 end) high_gdp_count,
avg(case when GDP >=1500 then `Life Expectancy` else null end) high_gdp_life_expectancy,
sum(case when GDP <1500 then 1 else 0 end) low_gdp_count,
avg(case when GDP <1500 then `Life Expectancy` else null end) low_gdp_life_expectancy
from world_life_expectancy
order by GDP;

#Explore Status
select status, count(distinct(country)), round(avg(`Life expectancy`),1)
from world_life_expectancy
group by status
;

#Explore countries: Notice that low BMI is expected to correspond with low life expectancy.
select country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by country
having Life_Exp > 0 and BMI >0
order by BMI asc
;

#Explore adult mortality using a rolling total analysis.
select country,
year,
`Life Expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over (partition by country order by year) as Rolling_Total
from world_life_expectancy
where country like '%United%'
;








