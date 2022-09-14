--select * 
--from PortfolioProject..covid_deaths
--order by 3,4

select * 
from PortfolioProject..covid_vacations
order by 3,4


select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..covid_deaths
order by 1,2;

-- looking at total cases vs total deaths
-- shows likely hood of death after contraction in particular country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covid_deaths
where location like '%india%'
order by 1,2;

--looking at total cases vs population
select location, date, total_cases, population, (total_cases/population)*100 as TotalCasePercentage
from PortfolioProject..covid_deaths
where location like '%india%'
order by 1,2;

-- looking at countries with highest infection rates vs population

select location, population, max(total_cases)as HighestInfectionCount, Max((total_cases/population)*100) as PercentagePopulationInfected
from PortfolioProject..covid_deaths
group by location, population
order by PercentagePopulationInfected desc

--Looking for countriest with highest death count per population

select location, max(cast(total_deaths as int))as totalDeathCount
from PortfolioProject..covid_deaths
where continent is not null
group by location
order by totalDeathCount desc


--global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, (sum(cast(new_deaths as int))/sum(new_cases)*100) --, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..covid_deaths
where continent is not null
--group by date
order by 1,2;
 
 --total population vs vaccination

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 from PortfolioProject..covid_deaths dea
 join PortfolioProject..covid_vacations vac
 on dea.location=vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3

 --CTE 
 with PopvsVac (continent, location,date, population,new_vaccination, rollingPeopleVaccinated) 
 as
 (
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 from PortfolioProject..covid_deaths dea
 join PortfolioProject..covid_vacations vac
 on dea.location=vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3
 )
 select*, (rollingPeopleVaccinated/population)*100 as Pop_vs_Vac    
 from PopvsVac

-- creating view to store data for later visualization

create view persentPopulationVaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100
 from PortfolioProject..covid_deaths dea
 join PortfolioProject..covid_vacations vac
 on dea.location=vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 