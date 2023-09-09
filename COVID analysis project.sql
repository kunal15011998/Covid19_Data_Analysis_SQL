/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From [portfolio project]..['covid deaths']
Where continent is not null 
order by 3,4




-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [portfolio project]..['covid deaths']
Where continent is not null 
order by 1,2




-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in india

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [portfolio project]..['covid deaths']
Where location ='india'
and continent is not null 
order by 1,2





-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From [portfolio project]..['covid deaths']
order by 1,2





-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  round(Max((total_cases/population)),2)*100 as PercentPopulationInfected
From [portfolio project]..['covid deaths']
Group by Location, Population
order by PercentPopulationInfected desc




-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolio project]..['covid deaths']
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From  [portfolio project]..['covid deaths']
Where continent is not null 
Group by continent
order by TotalDeathCount desc




-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From  [portfolio project]..['covid deaths']
where continent is not null 
order by 1,2



-- Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..['covid deaths'] dea
Join [portfolio project]..['covid vaccination'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Creating View to store data for later visualizations

Create View PercentPopulation_VaccinateNo AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [portfolio project]..['covid deaths'] dea
Join [portfolio project]..['covid vaccination'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select * from PercentPopulation_VaccinateNo
