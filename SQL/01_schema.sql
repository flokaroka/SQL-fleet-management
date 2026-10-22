/* Vozni park: shema baze (SQL Server / T-SQL) */

CREATE DATABASE VozniPark;
GO
USE VozniPark;
GO

CREATE TABLE Vozila (
    VoziloID      INT IDENTITY PRIMARY KEY,
    Registracija  VARCHAR(15)   NOT NULL UNIQUE,
    Tip           VARCHAR(30),
    NosivostT     DECIMAL(5,2)
);

CREATE TABLE Vozaci (
    VozacID  INT IDENTITY PRIMARY KEY,
    Ime      NVARCHAR(50) NOT NULL,
    Prezime  NVARCHAR(50) NOT NULL
);

CREATE TABLE Voznje (
    VoznjaID     INT IDENTITY PRIMARY KEY,
    VozacID      INT NOT NULL REFERENCES Vozaci(VozacID),
    VoziloID     INT NOT NULL REFERENCES Vozila(VoziloID),
    DatumVoznje  DATE NOT NULL,
    Kilometri    DECIMAL(7,1),
    Tone         DECIMAL(6,2),
    Gorivo_L     DECIMAL(6,1)
);

CREATE TABLE Servisi (
    ServisID      INT IDENTITY PRIMARY KEY,
    VoziloID      INT NOT NULL REFERENCES Vozila(VoziloID),
    DatumServisa  DATE NOT NULL,
    Opis          NVARCHAR(200),
    Trosak        DECIMAL(10,2)
);
GO
