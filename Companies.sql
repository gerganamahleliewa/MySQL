CREATE DATABASE Companies;
USE Companies;

CREATE TABLE InsuranceCompanies(
    companies_Id INT PRIMARY KEY ,
    NameOfCompanies VARCHAR(100)
);

CREATE TABLE Customers(
    customer_ID INT PRIMARY KEY ,
    Name VARCHAR(100),
    Egn VARCHAR(10),
    Phone VARCHAR(10),
    Email VARCHAR(50)
);

CREATE TABLE Employees(
    employees_ID INT PRIMARY KEY ,
    Name VARCHAR(100),
    Position VARCHAR(100)
);

CREATE TABLE CustomerEmployee(
    customers_ID INT,
    employees_ID INT,
    primary key (customers_ID,employees_ID),
    FOREIGN KEY (customers_ID) REFERENCES Customers(customer_ID),
    FOREIGN KEY (employees_ID) REFERENCES Employees(employees_ID)
);

CREATE TABLE SalaryPayments(
    salary_ID INT PRIMARY KEY ,
    salaryAmount VARCHAR(10),
    monthsBonus INT,
    dateOfPayment DATE,
     monthOfPayment INT AS (MONTH(dateOfPayment)),
    yearOfPayment INT AS (YEAR(dateOfPayment))
);

CREATE TABLE InsurancePolicies(
    policies_ID INT PRIMARY KEY ,
    startDate DATE,
    endDate DATE,
    Swinsured INT
);

CREATE TABLE Insurance(
    insurance_ID INT PRIMARY KEY ,
    Price INT ,
    insuranceType VARCHAR(100),
    description VARCHAR(250)
);



-- Insert data into InsuranceCompanies table
INSERT INTO InsuranceCompanies (companies_Id, NameOfCompanies) VALUES
(1, 'ABC Insurance Company'),
(2, 'XYZ Insurance Ltd');

-- Insert data into Customers table
INSERT INTO Customers (customer_ID, Name, Egn, Phone, Email) VALUES
(1, 'John Doe', '1234567890', '1234567890', 'john@example.com'),
(2, 'Jane Smith', '0987654321', '0987654321', 'jane@example.com');

-- Insert data into Employees table
INSERT INTO Employees (employees_ID, Name, Position) VALUES
(1, 'Alice Johnson', 'Agent'),
(2, 'Bob Smith', 'Manager');

-- Insert data into CustomerEmployee table
INSERT INTO CustomerEmployee (customers_ID, employees_ID) VALUES
(1, 1),
(2, 2);

-- Insert data into SalaryPayments table
INSERT INTO SalaryPayments (salary_ID, salaryAmount, monthsBonus, dateOfPayment) VALUES
(1, 5000.00, 200, '2024-03-01'),
(2, 6000.00, 250, '2024-03-15');

-- Insert data into InsurancePolicies table
INSERT INTO InsurancePolicies (policies_ID, startDate, endDate, Swinsured) VALUES
(1, '2024-01-01', '2024-12-31', 100000),
(2, '2024-02-01', '2024-12-31', 200000);

-- Insert data into Insurance table
INSERT INTO Insurance (insurance_ID, Price, insuranceType, description) VALUES
(1, 1000, 'Car Insurance', 'Comprehensive coverage for automobiles'),
(2, 1500, 'Home Insurance', 'Coverage for residential properties');

INSERT INTO Insurance (insurance_ID, Price, insuranceType, description) VALUES
(3, 1700, 'AutoKasko', 'Comprehensive coverage for automobiles');

DROP VIEW info1;

UPDATE SalaryPayments
SET employee_id = salary_ID
WHERE salary_ID  = 5;
-- ex.1
CREATE VIEW Info1 AS
SELECT c.Name AS CustomerName, i.insuranceType AS Type, IC.NameOfCompanies,e.Name AS NameOfBroker
FROM Customers AS c
JOIN CustomerEmployee CE on c.customer_ID = CE.customers_ID
JOIN Insurance AS i ON c.customer_ID = i.customer_id
JOIN InsuranceCompanies AS IC ON i.insurance_ID = IC.insurances_id
JOIN Employees AS e ON IC.companies_Id = e.companies_id
WHERE i.insuranceType = 'AutoKasko'
ORDER BY i.insurance_ID DESC
LIMIT 2;

-- ex.2
SELECT e.Name AS EmployeeName,COALESCE(sp.monthsBonus,0) AS Bonus
FROM Employees AS e
JOIN SalaryPayments AS sp ON e.employees_ID = sp.employee_id
WHERE sp.monthOfPayment = 3
ORDER BY Name;

-- ex.3
SELECT SUM(i.Price) AS totalPrice,e.Name AS Names
FROM Insurance AS i
JOIN Employees AS e ON i.insurance_ID = e.insure_id
WHERE i.insuranceType = 'Car Insurance'
GROUP BY e.Name
HAVING totalPrice >= 1000;
