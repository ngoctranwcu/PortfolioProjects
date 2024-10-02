 
 #Top ten largest by land area.
 SELECT State_Name, sum(aland), sum(awater)
 FROM us_project.us_household_income
 group by state_name
 order by 2 desc
 limit 10
 ;
 
 #Top ten largest by water area.
 SELECT State_Name, sum(aland), sum(awater)
 FROM us_project.us_household_income
 group by state_name
 order by 3 desc
 limit 10
 ;
 
#Join the two tables us_household_income and us_household_income_statistics for analysis.
SELECT a.* , b.*
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
;

SELECT a.state_name, a.county, a.type, a.primary, mean, median
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
;

#Top 10 states with the lowest mean household incomes.
SELECT a.state_name, round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by a.state_name
order by 2
limit 10
;

#Top 10 states with the highest mean household incomes.
SELECT a.state_name, round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by a.state_name
order by 2 desc
limit 10
;

#Top 10 states with the lowest median household incomes.
SELECT a.state_name, round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by a.state_name
order by 3
limit 10
;

#Top 10 states with the highest median household incomes.
SELECT a.state_name, round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by a.state_name
order by 3 desc
limit 10
;

#Top 10 states with the highest average incomes, along with insights into the types of areas where residents live.
SELECT type, count(type) ,round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by type
order by 3 desc
limit 10
;

#Top 10 states with the highest median incomes and an analysis of the types of areas where residents live.
SELECT type, count(type) ,round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by type
order by 4 desc
limit 10
;

#Filter out outliers, then identify the top 10 states with the highest median incomes and analyze the types of areas in which residents live.
SELECT type, count(type) ,round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
where mean <> 0
group by type
having count(type) > 100
order by 4 desc
limit 10
;

#Top 10 states and cities with the highest average salaries.
SELECT a.State_Name, a.city, round(avg(mean),1), round(avg(median),1)
FROM us_project.us_household_income as a
inner join us_household_income_statistics as b
on a.id = b.id
group by a.State_Name, a.city
order by 3 desc
limit 10;






