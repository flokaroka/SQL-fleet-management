-- Fleet management: database schema (SQL Server / T-SQL)
 
CREATE DATABASE FleetManagement;
GO
USE FleetManagement;
GO
 
CREATE TABLE Vehicles (
    VehicleID     INT IDENTITY PRIMARY KEY,
    LicensePlate  VARCHAR(15)   NOT NULL UNIQUE,
    VehicleType   VARCHAR(30),
    CapacityTons  DECIMAL(5,2)
);
 
CREATE TABLE Drivers (
    DriverID   INT IDENTITY PRIMARY KEY,
    FirstName  NVARCHAR(50) NOT NULL,
    LastName   NVARCHAR(50) NOT NULL
);
 
CREATE TABLE Trips (
    TripID      INT IDENTITY PRIMARY KEY,
    DriverID    INT NOT NULL REFERENCES Drivers(DriverID),
    VehicleID   INT NOT NULL REFERENCES Vehicles(VehicleID),
    TripDate    DATE NOT NULL,
    Kilometers  DECIMAL(7,1),
    LoadTons    DECIMAL(6,2),
    FuelLiters  DECIMAL(6,1)
);
 
CREATE TABLE Maintenance (
    MaintenanceID    INT IDENTITY PRIMARY KEY,
    VehicleID        INT NOT NULL REFERENCES Vehicles(VehicleID),
    MaintenanceDate  DATE NOT NULL,
    Description      NVARCHAR(200),
    Cost             DECIMAL(10,2)
);
GO