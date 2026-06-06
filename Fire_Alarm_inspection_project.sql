-- =============================================
--  Fire Alarm Inspection System
--  MySQL Project
--  Concepts used: Apna College SQL Notes
-- =============================================

-- CREATE DATABASE (page 7 of notes)
CREATE DATABASE IF NOT EXISTS inspection_db;
USE inspection_db;

-- =============================================
-- TABLE 1: buildings
-- Datatypes used: INT, VARCHAR (page 9)
-- Constraints: PRIMARY KEY, NOT NULL (page 18)
-- =============================================
CREATE TABLE buildings (
    building_id   INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    total_floors  INT          DEFAULT 1
);

-- =============================================
-- TABLE 2: inspectors
-- =============================================
CREATE TABLE inspectors (
    inspector_id INT PRIMARY KEY AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    phone        VARCHAR(20),
    company      VARCHAR(100)
);

-- =============================================
-- TABLE 3: devices
-- FOREIGN KEY (page 19) -> links to buildings
-- =============================================
CREATE TABLE devices (
    device_id     INT PRIMARY KEY AUTO_INCREMENT,
    building_id   INT          NOT NULL,
    device_name   VARCHAR(100) NOT NULL,
    device_tag    VARCHAR(50)  NOT NULL,
    floor_number  INT,
    FOREIGN KEY (building_id) REFERENCES buildings(building_id)
);

-- =============================================
-- TABLE 4: inspection_schedule
-- ENUM used for status (like a constraint)
-- FOREIGN KEY to buildings and inspectors
-- =============================================
CREATE TABLE inspection_schedule (
    schedule_id     INT PRIMARY KEY AUTO_INCREMENT,
    building_id     INT NOT NULL,
    inspector_id    INT NOT NULL,
    scheduled_date  DATE NOT NULL,
    inspection_type VARCHAR(30) DEFAULT 'Annual',
    status          ENUM('PENDING', 'COMPLETED', 'OVERDUE') DEFAULT 'PENDING',
    FOREIGN KEY (building_id)  REFERENCES buildings(building_id),
    FOREIGN KEY (inspector_id) REFERENCES inspectors(inspector_id)
);

-- =============================================
-- TABLE 5: test_results  <-- MAIN TABLE
-- Pass/Fail log for each device
-- =============================================
CREATE TABLE test_results (
    result_id      INT PRIMARY KEY AUTO_INCREMENT,
    schedule_id    INT NOT NULL,
    device_id      INT NOT NULL,
    test_date      DATE NOT NULL,
    test_name      VARCHAR(100),
    result         ENUM('PASS', 'FAIL', 'NOT TESTED') DEFAULT 'NOT TESTED',
    measured_value VARCHAR(50),
    expected_value VARCHAR(50),
    notes          TEXT,
    FOREIGN KEY (schedule_id) REFERENCES inspection_schedule(schedule_id),
    FOREIGN KEY (device_id)   REFERENCES devices(device_id)
);

-- =============================================
-- TABLE 6: deficiencies
-- Problems found when result = FAIL
-- =============================================
CREATE TABLE deficiencies (
    deficiency_id INT PRIMARY KEY AUTO_INCREMENT,
    result_id     INT NOT NULL,
    problem       TEXT NOT NULL,
    severity      ENUM('CRITICAL', 'MAJOR', 'MINOR'),
    status        ENUM('OPEN', 'FIXED') DEFAULT 'OPEN',
    found_date    DATE,
    FOREIGN KEY (result_id) REFERENCES test_results(result_id)
);


-- =============================================
-- INSERT DATA (page 15 of notes)
-- =============================================

INSERT INTO buildings (building_name, city, total_floors) VALUES
('Al Faisaliah Tower', 'Riyadh', 30),
('City Hospital',      'Riyadh', 7),
('Warehouse Block A',  'Riyadh', 2);

INSERT INTO inspectors (name, phone, company) VALUES
('Ahmed Al-Rashid',  '+966-50-111-2233', 'SafeGuard MEP'),
('Sara Al-Qahtani',  '+966-50-333-4455', 'FireTech Arabia');

INSERT INTO devices (building_id, device_name, device_tag, floor_number) VALUES
(1, 'Smoke Detector',    'SD-F1-01',  1),
(1, 'Smoke Detector',    'SD-F1-02',  1),
(1, 'Heat Detector',     'HD-B1-01', -1),
(1, 'Manual Call Point', 'MCP-GF-01', 0),
(2, 'Smoke Detector',    'SD-F2-01',  2),
(2, 'PA Speaker',        'SPK-F1-01', 1);

INSERT INTO inspection_schedule (building_id, inspector_id, scheduled_date, inspection_type, status) VALUES
(1, 1, '2024-06-15', 'Annual',  'COMPLETED'),
(2, 2, '2024-07-20', 'Annual',  'COMPLETED'),
(3, 1, '2024-08-01', 'Monthly', 'OVERDUE');

INSERT INTO test_results (schedule_id, device_id, test_date, test_name, result, measured_value, expected_value) VALUES
(1, 1, '2024-06-15', 'Smoke Entry Test',   'PASS', '18 sec', '< 60 sec'),
(1, 2, '2024-06-15', 'Smoke Entry Test',   'PASS', '22 sec', '< 60 sec'),
(1, 3, '2024-06-15', 'Heat Response Test', 'PASS', '57C',    '54-65C'),
(1, 4, '2024-06-15', 'Manual Pull Test',   'PASS', 'OK',     'Alarm in 10 sec'),
(2, 5, '2024-07-20', 'Smoke Entry Test',   'FAIL', '90 sec', '< 60 sec'),
(2, 6, '2024-07-20', 'Speaker Test',       'FAIL', '60 dB',  '> 85 dB');

INSERT INTO deficiencies (result_id, problem, severity, status, found_date) VALUES
(5, 'Smoke detector SD-F2-01 response too slow. Needs replacement.', 'MAJOR',    'OPEN', '2024-07-20'),
(6, 'Speaker volume too low. Amplifier may be faulty.',              'CRITICAL', 'OPEN', '2024-07-20');


-- =============================================
-- QUERIES
-- =============================================

-- QUERY 1: SELECT all buildings (page 22)
SELECT * FROM buildings;

-- QUERY 2: WHERE clause (page 23)
-- Show only COMPLETED inspections
SELECT * FROM inspection_schedule
WHERE status = 'COMPLETED';

-- QUERY 3: AND operator (page 25)
-- Show FAIL results from schedule 2
SELECT * FROM test_results
WHERE result = 'FAIL' AND schedule_id = 2;

-- QUERY 4: ORDER BY (page 28)
-- Show all results sorted by date
SELECT * FROM test_results
ORDER BY test_date ASC;

-- QUERY 5: LIMIT (page 27)
-- Show only top 3 test results
SELECT * FROM test_results LIMIT 3;

-- QUERY 6: INNER JOIN (page 43)
-- Show schedule with building name and inspector name
SELECT
    s.schedule_id,
    b.building_name,
    i.name         AS inspector,
    s.scheduled_date,
    s.status
FROM inspection_schedule s
INNER JOIN buildings  b ON b.building_id  = s.building_id
INNER JOIN inspectors i ON i.inspector_id = s.inspector_id;

-- QUERY 7: LEFT JOIN (page 45)
-- Show all devices even if no test done yet
SELECT
    d.device_tag,
    d.device_name,
    t.result,
    t.test_date
FROM devices d
LEFT JOIN test_results t ON t.device_id = d.device_id;

-- QUERY 8: Aggregate Functions (page 29)
-- COUNT how many tests done
SELECT COUNT(*) AS total_tests FROM test_results;

-- Count PASS and FAIL
SELECT result, COUNT(*) AS total
FROM test_results
GROUP BY result;

-- QUERY 9: GROUP BY (page 30)
-- Count tests done per building
SELECT
    b.building_name,
    COUNT(t.result_id) AS total_tests,
    SUM(t.result = 'PASS') AS passed,
    SUM(t.result = 'FAIL') AS failed
FROM test_results t
INNER JOIN devices   d ON d.device_id   = t.device_id
INNER JOIN buildings b ON b.building_id = d.building_id
GROUP BY b.building_name;

-- QUERY 10: WHERE with IN operator (page 26)
-- Show CRITICAL or MAJOR deficiencies
SELECT * FROM deficiencies
WHERE severity IN ('CRITICAL', 'MAJOR');

-- QUERY 11: Sub Query (page 55)
-- Show buildings that have at least one FAIL result
SELECT building_name FROM buildings
WHERE building_id IN (
    SELECT d.building_id
    FROM test_results t
    JOIN devices d ON d.device_id = t.device_id
    WHERE t.result = 'FAIL'
);

-- QUERY 12: VIEW (page 59)
-- Create a view for open deficiencies
CREATE VIEW open_deficiencies AS
SELECT
    b.building_name,
    d.device_tag,
    df.problem,
    df.severity,
    df.found_date,
    df.status
FROM deficiencies df
JOIN test_results  t  ON t.result_id   = df.result_id
JOIN devices       d  ON d.device_id   = t.device_id
JOIN buildings     b  ON b.building_id = d.building_id
WHERE df.status = 'OPEN';

-- Use the view
SELECT * FROM open_deficiencies;

-- =============================================
-- END OF PROJECT
-- =============================================
