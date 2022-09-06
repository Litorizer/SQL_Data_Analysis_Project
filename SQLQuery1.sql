select * from project.dbo.data1;

select * from project.dbo.data2;

-- number of rows into our dataset

select count(*) from project..data1
select count(*) from project..data2

-- dataset for jharkhand and bihar

select * from project..data1 where state in ('Jharkhand' ,'Bihar')

-- population of India

select sum(population) as Population from project..data2

-- avg growth 

select state,avg(growth)*100 avg_growth from project..data1 group by state;

-- avg sex ratio

select state,round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio desc;

-- avg literacy rate
 
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest growth ratio


select top 3 state,avg(growth)*100 avg_growth from project..data1 group by state order by avg_growth desc;


--bottom 3 state showing lowest sex ratio

select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio asc;


-- top bottom 3 states in literacy date

-- to not override use this code
drop table if exists #topstates;
-- **

create table #topstates
( state nvarchar(255),
	topstate float
	)

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..Data1
group by state order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstate desc;






-- bottom 3 states in literacy date

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float

  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstate asc;


-- combine these 2 

select * from (
select top 3 * from #topstates order by #topstates.topstate desc) a

union

select * from (
select top 3 * from #bottomstates order by #bottomstates.bottomstate asc) b;


-- filter out data for states which are starting with letter A

select distinct state from project..data1 where lower(state) like 'a%' or lower(state) like 'b%'

select distinct state from project..data1 where lower(state) like 'a%' and lower(state) like '%sh'


--total males and females


-- females/males=sex_ratio
-- females  + males = population
-- females = population - males
-- population - males = (sex_ratio)* males
-- population = males(sex_ratio+1)
-- males = population/(sex_ratio+1)

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district ) c) d
group by d.state;
