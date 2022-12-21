

SELECT * FROM CovidDeaths
ORDER BY 3,4

--SELECT * FROM [covid project]..CovidVaccinations
--ORDER BY 3,4

--- SELECT DATA THAT WE are goin' to use
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
 
ORDER BY 1,2

--total cases vs total deaths

--- the chance of dying if you get coivd 19 in egypt
select location,date,total_cases,total_deaths,populations 
,(total_deaths/total_cases)*100 as 'deathpercentag'
from CovidDeaths
where location like  '%egypt%'

ORDER BY 1,2

-----total cases vs populations

select location,date ,total_cases,populations , 
(total_cases/populations )*100 as 'casespercentage'
from CovidDeaths
where location like  '%egypt%' and continent is not null

ORDER BY casespercentage desc

---- the hiegest infection rate compared to population


select location,populations,MAX (total_cases) as 'highest infection rate',
MAX((total_cases/populations ))*100 as 'percent population infected '
from CovidDeaths
--where location like  '%egypt%'
group by location,populations
ORDER BY 'percent population infected' desc

---- the highest  death count  per population

select location,MAX (cast(total_deaths as int)) as 'total death count'
from CovidDeaths
where continent is not null
group by location
ORDER BY 'total death count' desc


---- the hiegest death rate compared to population
select location,populations,MAX (cast(total_deaths as int)) as 'highest death rate',
MAX((total_deaths/populations ))*100 as 'percent population death '
from CovidDeaths
where continent is not null
group by location,populations
ORDER BY 'highest death rate' desc

---- continent total death and cases 

select continent,MAX (cast(total_cases as int)) as 'continent total cases'
,sum (cast(total_deaths as int))  as 'continent total deaths' 
from CovidDeaths
where continent  is not null
group by continent
ORDER BY 'continent total cases' desc
-------
select location,MAX (cast(total_cases as int)) as 'continent total cases'
,sum (cast(total_deaths as int))  as 'continent total deaths' 
from CovidDeaths
where continent  is  null
group by location
ORDER BY 'continent total cases' desc
-----------
                  --- global number---
select  sum (cast(total_cases as int))as 'global total cases', sum(cast(total_deaths as int)) as 'global total deaths'
from CovidDeaths
where continent  is not null
group by date
order by 1,2
-----------
--- TOTal Vac vs Deaths
select  sum (new_cases) as 'global new cases', sum(cast(new_deaths as int)) as 'global new deaths'
,sum(cast(new_deaths as int)) / sum (new_cases)    *100
as 'global new deaths percent '
from CovidDeaths
where continent  is not null 
--group by date
order by 1,2 
--------
select CD.continent,CD.location,CD.date,CD.populations,cv.new_vaccinations
, sum (cast(cv.new_vaccinations as int)) over ( partition by  cd.location order by cd.location ,cd.date  ) as 'totalnewvaccinated'
from CovidDeaths CD
join
CovidVaccinations CV
on cd.location = cv.location
and cd.date = cv.date 
where cd. continent  is not null 
ORDER BY 2,3
------
--use cte
with populations_VS_vaccinations(continent,location,date,populations,new_vaccinations,totalnewvaccinated)
as
(

select CD.continent,CD.location,CD.date,CD.populations,cv.new_vaccinations
, sum (cast(cv.new_vaccinations as int)) over 
( partition by  cd.location order by cd.location ,cd.date  ) as 'totalnewvaccinated'
from CovidDeaths CD
join
CovidVaccinations CV
on cd.location = cv.location
and cd.date = cv.date 
where cd. continent  is not null )
select *, (totalnewvaccinated /populations)*100 from populations_VS_vaccinations

               --New table--

create table  #populations_vaccinations_summery
(
continent NVARCHAR (255),
location  NVARCHAR (255),
DATE datetime,
populations numeric,
new_vaccinations numeric,
totalnewvaccinated numeric
)
insert into #populations_vaccinations_summery

select CD.continent,CD.location,CD.date,CD.populations,cv.new_vaccinations
, sum (cast(cv.new_vaccinations as int)) over 
( partition by  cd.location order by cd.location ,cd.date  ) as 'totalnewvaccinated'
from CovidDeaths CD
join
CovidVaccinations CV
on cd.location = cv.location
and cd.date = cv.date 
--where cd. continent  is not null ) 
select *, (totalnewvaccinated /populations)*100 from #populations_vaccinations_summery 
 
          --- Creating a View



 create view populations_vaccinations_summery as

select CD.continent,CD.location,CD.date,CD.populations,cv.new_vaccinations
, sum (cast(cv.new_vaccinations as int)) over 
( partition by  cd.location order by cd.location ,cd.date  ) as 'totalnewvaccinated'
from CovidDeaths CD
join
CovidVaccinations CV
on cd.location = cv.location
and cd.date = cv.date 
where cd.continent  is not null 

select * 
from populations_vaccinations_summery