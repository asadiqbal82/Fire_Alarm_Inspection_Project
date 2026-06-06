# Fire Alarm Inspection System MySQL Project

This is a MySQL project I built while learning SQL.
Instead of making a basic student database, I chose a real-world system: fire alarm inspections.

Buildings must have their fire alarm systems checked regularly.
Technicians inspect devices and record results.
This database manages all that information.

## What This Project Does

### • Stores Buildings Data

Saves information about buildings that are being inspected.

### •	Stores Devices Data

Keeps records of devices installed in buildings
Examples: smoke detectors, speakers, heat sensors

### •	Manages Inspectors

Stores information about technicians who perform inspections

### •	Schedules Inspections

Tracks inspection dates
Assigns inspectors to buildings

### •	Stores Test Results

Records results for each device
Shows if a device passed or failed

### •	Tracks Deficiencies (Repairs)

Automatically tracks failed devices
Helps manage repair work

## Database Structure (Tables)

### 1. Buildings

Stores information about each building

### 2. Inspectors

Stores details of inspection technicians

### 3. Devices

Stores all fire safety devices in buildings

### 4. Inspection_schedule

Stores inspection dates and assigned inspectors

### 5. Test_results

Stores pass/fail results for each device

### 6. Deficiencies

Stores failed devices that need repair


## SQL Concepts Used

### DDL & DML

•	CREATE TABLE

•	INSERT INTO

### Data Retrieval

•	SELECT

•	WHERE

•	ORDER BY

•	LIMIT


### Joins

•	INNER JOIN

•	LEFT JOIN

### Aggregation

•	GROUP BY

•	COUNT()

•	SUM()

### Advanced Features

### Subqueries
•	VIEW (for easy reporting)

### Constraints

•	PRIMARY KEY

•	FOREIGN KEY

•	NOT NULL

•	DEFAULT

•	ENUM

## Sample Data Included

The project includes sample data so you can test queries easily:

• 3 Buildings

• 2 Inspectors

• 6 Devices installed

• 6 Test Results

• 4 Passed

• 2 Failed

• 2 Active Deficiencies (from failed devices)


## What I Learned

• How to design and organize database tables properly

• How to use Primary Keys and Foreign Keys for data integrity

• How to write JOIN queries for real-world data

• How to use GROUP BY for reports and analysis

• How to use VIEW to simplify repeated queries
