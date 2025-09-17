USE DWH_USroadAccident;

CREATE TABLE Dim_Accident_Type (
    Accident_Type_ID INT PRIMARY KEY,
    Accident_Type NVARCHAR(50)
);

CREATE TABLE Dim_Weather (
    Weather_ID INT PRIMARY KEY,
    Weather_Condition NVARCHAR(50)
);

CREATE TABLE Dim_Road_Condition (
    Road_Condition_ID INT PRIMARY KEY,
    Road_Condition NVARCHAR(50)
);

CREATE TABLE Dim_Light (
    Light_ID INT PRIMARY KEY,
    Light_Condition NVARCHAR(50)
);

CREATE TABLE Dim_Location (
    Location_SK INT IDENTITY PRIMARY KEY,
    Location_ID INT,
    State_Name NVARCHAR(50),
    Distance_to_Nearest_Hospital FLOAT,
    Distance_to_Nearest_Police_Station FLOAT,
    Start_Date DATE,
    End_Date DATE,
    Is_Current BIT
);

CREATE TABLE Dim_Road (
    Road_SK INT IDENTITY PRIMARY KEY,
    Road_ID INT,
    Road_Type_Name NVARCHAR(50),
    Junction_Type_Name NVARCHAR(50),
    Road_Width FLOAT,
    Road_Surface_Friction_Coefficient FLOAT,
    Start_Date DATE,
    End_Date DATE,
    Is_Current BIT
);

CREATE TABLE Dim_Vehicle_Type (
    Vehicle_Type_ID INT PRIMARY KEY,
    Vehicle_Type_Name NVARCHAR(50)
);

CREATE TABLE Dim_Driver_Age_Group (
    Driver_Age_Group_ID INT PRIMARY KEY,
    Age_Group_Range NVARCHAR(50)
);

CREATE TABLE Fact_Accident (
    Accident_SK INT IDENTITY PRIMARY KEY,
    Accident_ID INT,
    Date_ID INT,
    Accident_Type_ID INT,
    Weather_ID INT,
    Road_Condition_ID INT,
    Light_Condition_ID INT,
    Road_SK INT,
	Location_SK INT,
    Num_Casualties INT,
    Speed_Limit FLOAT,
    Visibility FLOAT,
    Time_Taken_for_Emergency_Response FLOAT
);

ALTER TABLE Fact_Accident
ADD Hour INT;

CREATE TABLE Fact_Accident_Vehicle (
    Accident_Vehicle_ID INT IDENTITY PRIMARY KEY,
    Accident_ID INT,
    Vehicle_Type_ID INT,
    Driver_Age_Group_ID INT,
    Vehicle_Speed FLOAT,
    Num_Vehicles_Involved INT
);

ALTER TABLE Fact_Accident_Vehicle DROP COLUMN Accident_ID;

ALTER TABLE Fact_Accident_Vehicle
ADD Accident_SK INT;


-- Drop and recreate DimDate table
IF OBJECT_ID('DimDate', 'U') IS NOT NULL
    DROP TABLE DimDate;

CREATE TABLE DimDate (
    Date_ID INT PRIMARY KEY,              -- Format: YYYYMMDD
    Full_Date DATE NOT NULL,              -- e.g., 2024-02-20
    Day INT,
    Day_Of_Week VARCHAR(10),
    Day_Name_Short VARCHAR(3),
    Day_Of_Year INT,
    Is_Weekend BIT,
    Month INT,
    Month_Name VARCHAR(10),
    Quarter INT,
    Year INT,
    Week_Of_Year INT,
    Hour INT,                 
    Time_Period VARCHAR(15),              -- Night / Morning / Afternoon / Evening
    PeriodAM_PM CHAR(2)                   -- AM / PM
);

DECLARE @CurrentDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2050-01-01';

WHILE @CurrentDate < @EndDate
BEGIN
    INSERT INTO DimDate (
        Date_ID, Full_Date, Day, Day_Of_Week, Day_Name_Short, Day_Of_Year,
        Is_Weekend, Month, Month_Name, Quarter, Year, Week_Of_Year,
        Hour, Time_Period, PeriodAM_PM
    )
    SELECT
        CONVERT(INT, FORMAT(@CurrentDate, 'yyyyMMdd')),
        @CurrentDate,
        DATEPART(DAY, @CurrentDate),
        DATENAME(WEEKDAY, @CurrentDate),
        LEFT(DATENAME(WEEKDAY, @CurrentDate), 3),
        DATEPART(DAYOFYEAR, @CurrentDate),
        CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1,7) THEN 1 ELSE 0 END,
        DATEPART(MONTH, @CurrentDate),
        DATENAME(MONTH, @CurrentDate),
        DATEPART(QUARTER, @CurrentDate),
        DATEPART(YEAR, @CurrentDate),
        DATEPART(ISO_WEEK, @CurrentDate),
        0,                                  -- Hour default = 0
        'Night',                            -- Default time period for midnight
        'AM'                                -- Default AM/PM for midnight
    ;

    SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END


ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_Date
FOREIGN KEY (Date_ID) REFERENCES DimDate(Date_ID);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_AccidentType
FOREIGN KEY (Accident_Type_ID) REFERENCES Dim_Accident_Type(Accident_Type_ID);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_Weather
FOREIGN KEY (Weather_ID) REFERENCES Dim_Weather(Weather_ID);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_RoadCondition
FOREIGN KEY (Road_Condition_ID) REFERENCES Dim_Road_Condition(Road_Condition_ID);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_Light
FOREIGN KEY (Light_Condition_ID) REFERENCES Dim_Light(Light_ID);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_Road
FOREIGN KEY (Road_SK) REFERENCES Dim_Road(Road_SK);

ALTER TABLE Fact_Accident
ADD CONSTRAINT FK_Fact_Accident_Location
FOREIGN KEY (Location_SK) REFERENCES Dim_Location(Location_SK);


ALTER TABLE Fact_Accident_Vehicle
ADD CONSTRAINT FK_AccidentVehicle_Accident
FOREIGN KEY (Accident_SK) REFERENCES Fact_Accident(Accident_SK);

ALTER TABLE Fact_Accident_Vehicle
ADD CONSTRAINT FK_AccidentVehicle_VehicleType
FOREIGN KEY (Vehicle_Type_ID) REFERENCES Dim_Vehicle_Type(Vehicle_Type_ID);

ALTER TABLE Fact_Accident_Vehicle
ADD CONSTRAINT FK_AccidentVehicle_DriverAgeGroup
FOREIGN KEY (Driver_Age_Group_ID) REFERENCES Dim_Driver_Age_Group(Driver_Age_Group_ID);
