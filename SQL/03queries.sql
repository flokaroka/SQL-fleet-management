/* Fleet management: analytical queries (SQL Server / T-SQL)
   Ordered from simple to more advanced. */
use fleetmanagement;

go

/*1. Fuel consumption per driver (JOIN + GROUP BY)
     Business question: who drives most economically? */
select d.firstname,
       d.lastname,
       Count(*)                                              as TripCount,
       Sum(t.kilometers)                                     as TotalKm,
       Round(Sum(t.fuelliters) / Sum(t.kilometers) * 100, 1) as LitersPer100Km
from   trips as t
       join drivers as d
         on d.driverid = t.driverid
group  by d.driverid,
          d.firstname,
          d.lastname
order  by litersper100km;

go

/* 2. Maintenance cost per vehicle (LEFT JOIN keeps vehicles with no maintenance) */
select v.licenseplate,
       v.vehicletype,
       Count(m.maintenanceid) as MaintenanceCount,
       isnull(Sum(m.cost), 0) as TotalCost
from   vehicles as v
       left join maintenance as m
              on m.vehicleid = v.vehicleid
group  by v.vehicleid,
          v.licenseplate,
          v.vehicletype
order  by totalcost desc;

go

/* 3. Monthly totals: kilometers, load and fuel (date functions) */
select Year(tripdate)  as TripYear,
       Month(tripdate) as TripMonth,
       Count(*)        as TripCount,
       Sum(kilometers) as TotalKm,
       Sum(loadtons)   as TotalTons,
       Sum(fuelliters) as TotalFuelLiters
from   trips
group  by Year(tripdate),
          Month(tripdate)
order  by tripyear,
          tripmonth;

go

/* 4. Running total of tons per driver (window function) */
select driverid,
       tripdate,
       loadtons,
       Sum(loadtons)
         over (
           partition by driverid
           order by tripdate, tripid ) as RunningTotalTons
from   trips
order  by driverid,
          tripdate,
          tripid;

go

/* 5. Vehicle utilization: average load as % of capacity */
select v.licenseplate,
       v.capacitytons,
       Round(Avg(t.loadtons), 2)                        as AvgLoadTons,
       Round(Avg(t.loadtons) / v.capacitytons * 100, 1) as AvgUtilizationPct
from   vehicles as v
       join trips as t
         on t.vehicleid = v.vehicleid
group  by v.vehicleid,
          v.licenseplate,
          v.capacitytons
order  by avgutilizationpct desc;

go

/* 6. Rank drivers by fuel efficiency within each month (CTE + RANK) */
with monthlyefficiency
     as (select t.driverid,
                Year(t.tripdate)                            as TripYear,
                Month(t.tripdate)                           as TripMonth,
                Sum(t.fuelliters) / Sum(t.kilometers) * 100 as LitersPer100Km
         from   trips as t
         group  by t.driverid,
                   Year(t.tripdate),
                   Month(t.tripdate))
select me.tripyear,
       me.tripmonth,
       d.firstname,
       d.lastname,
       Round(me.litersper100km, 1)      as LitersPer100Km,
       rank()
         over (
           partition by me.tripyear, me.tripmonth
           order by me.litersper100km ) as EfficiencyRank
from   monthlyefficiency as me
       join drivers as d
         on d.driverid = me.driverid
order  by me.tripyear,
          me.tripmonth,
          efficiencyrank;

go

/* 7. Vehicles whose maintenance cost is above the fleet average (subquery) */
select v.licenseplate,
       Sum(m.cost) as TotalCost
from   vehicles as v
       join maintenance as m
         on m.vehicleid = v.vehicleid
group  by v.vehicleid,
          v.licenseplate
having Sum(m.cost) > (select Avg(vehiclecost)
                      from   (select Sum(cost) as VehicleCost
                              from   maintenance
                              group  by vehicleid) as PerVehicle)
order  by totalcost desc;

go 
