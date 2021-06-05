SELECT *
FROM PortfolioProject..CovidDeaths
Order by 3,4;
----SELECT *
----FROM PortfolioProject..CovidVaccinations
----Order by 3,4;

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2;

--total cases vs total deaths
--likelihood of dying if you are infected with covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location='United States'
order by 1,2;

--total cases vs population

Select Location, date, total_cases, population, (total_cases/population)*100 as casePercentage
From PortfolioProject..CovidDeaths
Where location='United States'
order by 1,2;


--highest infection rates


Select Location, population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as HighestInfectionPercent
From PortfolioProject..CovidDeaths
Group by location, population
order by HighestInfectionPercent desc;

--Highest death count in each country
Select Location, MAX(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by totaldeathcount desc;

--Highest death count in each continent
Select continent, MAX(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
order by totaldeathcount desc;



--global rates
Select date, SUM(new_cases) as totalcases, SUM(cast(new_deaths as int)) as totaldeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
From PortfolioProject..CovidDeaths
Where continent is not null
group by date
order by 1,2;


--total population vs. vaccinations
Select dea.continent, dea.location, dea.date, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as Peoplevaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--CTE     percent of people vaccinated

With PopvsVac (Continent, Loaction, Date, Population, new_vaccinations, Peoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as Peoplevaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (Peoplevaccinated/Population)*100
From PopvsVac;


--creating a view

Create View PercentPopulationVaccinate as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, 
dea.date) as Peoplevaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;
