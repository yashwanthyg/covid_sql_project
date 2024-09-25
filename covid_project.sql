use portfolio

select * 
from portfolio..CovidDeaths$
where continent is not null 
order by 3,4
--i later found out there are null values in continent column
--select * 
--from portfolio..CovidVaccinations$
--order by 3,4

--selecting the data we are going to use
select location,date,total_cases,new_cases,total_deaths,population
from portfolio..CovidDeaths$
where continent is not null 
order by 1,2

--total cases vs total deaths 
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from portfolio..CovidDeaths$
where continent is not null 
order by 1,2

--total cases vs total deaths in india
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from portfolio..CovidDeaths$
where location like '%india%' and
continent is not null 
order by 1,2

--total case vs population
select location,date,total_cases,population,(total_cases/population)*100 as population_affected
from portfolio..CovidDeaths$
where continent is not null 
order by 1,2

--total case vs population in india
select location,date,total_cases,population,(total_cases/population)*100 as population_affected
from portfolio..CovidDeaths$
where location like '%india%' and 
 continent is not null 
order by 1,2

--country with highest infection wrt population
select location,max(total_cases) as highest ,population,max((total_cases/population))*100 as infected_population
from portfolio..CovidDeaths$
where continent is not null 
group by location,population
order by 4 desc

--countries with highest death rate 
select location,max(cast(total_deaths as int)) as total_death
from portfolio..CovidDeaths$
where continent is not null 
group by location
order by total_death desc

--continent with highest death rate
select continent,MAX(cast(total_deaths as int)) as total_death
from portfolio..CovidDeaths$
where continent is not null
group by continent
order by total_death desc


--global death wrt date
select date,SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as deathpercentage
from portfolio..CovidDeaths$
where continent is not null
group by date
order by 4 desc

--total global death
select SUM(new_cases) as total_new_cases, SUM(cast(new_deaths as int)) as total_new_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as deathpercentage
from portfolio..CovidDeaths$
where continent is not null

--polulation vs vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from portfolio..CovidDeaths$ dea
join portfolio..CovidVaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null
order by 2,3
 

 select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as total_vac_by_country
from portfolio..CovidDeaths$ dea
join portfolio..CovidVaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null
order by 2,3

--cte to find 
with vac(continent,location,population,new_vactions,tot_vac_by_country) as
 (select dea.continent,dea.location,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as total_vac_by_country
from portfolio..CovidDeaths$ dea
join portfolio..CovidVaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null
)
select *,(tot_vac_by_country/population)*100 as vac_percentage
from vac

--creating view
 create view total_vaccinacine_percentage as
 select dea.continent,dea.location,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date,dea.location) as total_vac_by_country
from portfolio..CovidDeaths$ dea
join portfolio..CovidVaccinations$ vac
on dea.location = vac.location and
dea.date = vac.date
where dea.continent is not null
