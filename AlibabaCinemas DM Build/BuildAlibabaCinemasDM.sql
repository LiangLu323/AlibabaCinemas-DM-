-- Alibaba datamart developed and written by Liang Lu
-- First written on 7/15/2018 

IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE name = N'AlibabaCinemasDM')
	CREATE DATABASE AlibabaCinemasDM
GO
USE AlibabaCinemasDM

--
-- Delete existing tables
--
--
IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE name = N'FactSales'
		)
	DROP TABLE FactSales
--
IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE name = N'DimMember'
		)
	DROP TABLE DimMember
--
IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE name = N'DimMovieProduct'
		)
	DROP TABLE DimMovieProduct
--
IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE name = N'DimCinema'
		)
	DROP TABLE DimCinema
--
IF EXISTS(
	SELECT*
	FROM sys.tables
	WHERE name = N'DimDate'
		)
	DROP TABLE DimDate

GO
--
-- Create tables
--
CREATE TABLE DimDate
	(
	Date_SK				INT PRIMARY KEY, 
	Date				DATE,
	FullDate			NCHAR(10),-- Date in MM-dd-yyyy format
	DayOfMonth			INT, -- Field will hold day number of Month
	DayName				NVARCHAR(9), -- Contains name of the day, Sunday, Monday 
	DayOfWeek			INT,-- First Day Sunday=1 and Saturday=7
	DayOfWeekInMonth	INT, -- 1st Monday or 2nd Monday in Month
	DayOfWeekInYear		INT,
	DayOfQuarter		INT,
	DayOfYear			INT,
	WeekOfMonth			INT,-- Week Number of Month 
	WeekOfQuarter		INT, -- Week Number of the Quarter
	WeekOfYear			INT,-- Week Number of the Year
	Month				INT, -- Number of the Month 1 to 12{}
	MonthName			NVARCHAR(9),-- January, February etc
	MonthOfQuarter		INT,-- Month Number belongs to Quarter
	Quarter				NCHAR(2),
	QuarterName			NVARCHAR(9),-- First,Second..
	Year				INT,-- Year value of Date stored in Row
	YearName			CHAR(7), -- CY 2017,CY 2018
	MonthYear			CHAR(10), -- Jan-2018,Feb-2018
	MMYYYY				INT,
	FirstDayOfMonth		DATE,
	LastDayOfMonth		DATE,
	FirstDayOfQuarter	DATE,
	LastDayOfQuarter	DATE,
	FirstDayOfYear		DATE,
	LastDayOfYear		DATE,
	IsHoliday			BIT,-- Flag 1=National Holiday, 0-No National Holiday
	IsWeekday			BIT,-- 0=Week End ,1=Week Day
	Holiday				NVARCHAR(50),--Name of Holiday in US
	Season				NVARCHAR(10)--Name of Season
	);
--
CREATE TABLE AlibabaCinemasDM.dbo.DimCinema
	(
	Cinema_SK			INT IDENTITY(1,1) CONSTRAINT pk_dimcinema PRIMARY KEY,
	Cinema_AK			INT NOT NULL,
	CinemaCity			NVARCHAR(30) NOT NULL,
	CinemaType			NVARCHAR(50) NOT NULL
	);
--
CREATE TABLE AlibabaCinemasDM.dbo.DimMovieProduct
	(
	MovieProduct_SK		INT IDENTITY(1,1) CONSTRAINT pk_dimmovieproduct PRIMARY KEY,
	MovieProduct_AK		INT NOT NULL,
	MovieName			NVARCHAR(100) NOT NULL,
	MovieGenre			NVARCHAR(30) NOT NULL,
	ShowingTime			NVARCHAR(20) NOT NULL,
	FilmFormat			NVARCHAR(20) NOT NULL
	);
--
CREATE TABLE AlibabaCinemasDM.dbo.DimMember
	(
	Member_SK			INT IDENTITY(1,1) CONSTRAINT pk_dimmember PRIMARY KEY,
	Member_AK			INT NOT NULL,
	Birthday			DATE NOT NULL,
	Gender				NCHAR(1) NOT NULL,
	MemberCity			NVARCHAR(30) NOT NULL,
	MembershipLevel		NVARCHAR(20) NOT NULL,
	StartDate			Date NOT NULL,
	EndDate				Date NULL
	);
--
CREATE TABLE AlibabaCinemasDM.dbo.FactSales
	(
	Member_SK			INT NOT NULL CONSTRAINT fk_factsales_dimmember FOREIGN KEY REFERENCES DimMember(Member_SK),
	MovieProduct_SK		INT NOT NULL CONSTRAINT fk_factsales_dimmovieproduct FOREIGN KEY REFERENCES DimMovieProduct(MovieProduct_SK),
	Cinema_SK			INT NOT NULL CONSTRAINT fk_FactSales_dimcinema FOREIGN KEY REFERENCES DimCinema(Cinema_SK),
	SalesDate_SK			INT NOT NULL CONSTRAINT fk_FactSales_dimdate FOREIGN KEY REFERENCES DimDate(Date_SK),
	SalesID_DD			INT NOT NULL,
	TicketPrice			NUMERIC(4,2),
	Quantity			INT,
	MovieCost			NUMERIC (6,0) ,
	SalesDate           Date,
	CONSTRAINT pk_FactSales PRIMARY KEY(Member_SK, MovieProduct_SK, Cinema_SK, SalesDate_SK,SalesID_DD)
	);
--
 

--Finsh creating tables. 