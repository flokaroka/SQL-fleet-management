/* Fleet management: database schema (SQL Server / T-SQL) */

create database fleetmanagement;

go

use fleetmanagement;

go

create table vehicles
  (
     vehicleid    int identity primary key,
     licenseplate varchar(15) not null unique,
     vehicletype  varchar(30),
     capacitytons decimal(5, 2)
  );

create table drivers
  (
     driverid  int identity primary key,
     firstname nvarchar(50) not null,
     lastname  nvarchar(50) not null
  );

create table trips
  (
     tripid     int identity primary key,
     driverid   int not null references drivers(driverid),
     vehicleid  int not null references vehicles(vehicleid),
     tripdate   date not null,
     kilometers decimal(7, 1),
     loadtons   decimal(6, 2),
     fuelliters decimal(6, 1)
  );

create table maintenance
  (
     maintenanceid   int identity primary key,
     vehicleid       int not null references vehicles(vehicleid),
     maintenancedate date not null,
     description     nvarchar(200),
     cost            decimal(10, 2)
  );

go 
