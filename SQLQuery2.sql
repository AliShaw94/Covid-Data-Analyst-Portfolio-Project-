

SELECT * FROM CovidDeaths
ORDER BY 3,4

--SELECT * FROM [covid project]..CovidVaccinations
--ORDER BY 3,4

--- SELECT DATA THAT WE are goin' to use
select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where 
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




