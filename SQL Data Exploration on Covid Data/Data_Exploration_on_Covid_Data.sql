/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

--Summary of the table
--Table-1
EXEC sp_help '[CovidDeaths]';
--Table-2
EXEC sp_help '[CovidVaccinations]';


--Here column total_deaths is set as varchar that should be int or float
Alter Table CovidDeaths
Alter Column total_deaths Float;


Select *
FROM [SQLPortfolioProject_1].[dbo].[CovidDeaths]
Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]
Where continent is not null 
order by 1,2


--Here column total_deaths is set as varchar that should be int or float
Alter Table CovidDeaths
Alter Column total_deaths Float;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select
	Location,
	Sum(total_deaths) as Total_Deaths,
	Sum(Total_cases) Total_Cases,
	(Sum(total_deaths)*100)/Sum(Total_cases) as Death_Percentage
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]
WHERE total_cases IS NOT NULL
  AND total_deaths IS NOT NULL
Group By Location
Order By Death_Percentage Desc;

--Global Death Rate
Select Sum(total_deaths)*100/Sum(total_cases) as Global_Death_Rate
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]


---Total Cases vs Population
-- Shows what percentage of population infected with Covid
Select
	Location,
	Sum(total_cases) as Total_cases,
	Avg(population) Average_Population,
	(Sum(total_cases)*100)/Sum(population) as Infection_Ratio
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]
WHERE total_cases IS NOT NULL
  AND population IS NOT NULL
Group By Location
Order By Infection_Ratio Desc;


--What is the total number of deaths globally?
Select Sum(total_deaths) as Total_Global_Deaths
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]


--Which are the top 5 countries with the highest total number of deaths?
Select Top 5 location, Sum(total_deaths) as Total_Country_Deaths
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]
Group by location
Order By Total_Country_Deaths Desc;


--Daily New Deaths Trend
--How has the number of daily new deaths evolved over time globally?
Select date, Sum(new_deaths) as Daily_New_Deaths
From [SQLPortfolioProject_1].[dbo].[CovidDeaths]
Group By date
Order By date desc;

--Relationship Between Stringency Index and Deaths
SELECT stringency_index, SUM(new_deaths) AS total_deaths
FROM CovidDeaths
GROUP BY stringency_index
ORDER BY stringency_index;

--Top 5 Countries by Death Rate (Per Million)
SELECT Top 5 location, (SUM(total_deaths) / population) * 1e6 AS death_rate_per_million
FROM CovidDeaths
GROUP BY location, population
ORDER BY death_rate_per_million DESC;

--Impact of Median Age on Death Rates
SELECT AVG(median_age) AS avg_median_age, SUM(total_deaths) AS total_deaths
FROM CovidDeaths
Where median_age is not null
GROUP BY location
ORDER BY avg_median_age;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;








