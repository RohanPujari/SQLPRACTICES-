-- 1. Departments Table
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

-- 2. Employees Table (With some messy data)
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100), -- Needs cleaning!
    DeptID INT,
    ManagerID INT
);

-- 3. Salaries Table
CREATE TABLE Salaries (
    EmpID INT,
    Amount INT,
    EffectiveDate DATE
);

-- 1. Departments
INSERT INTO Departments (DeptID, DeptName) VALUES 
(10, 'Engineering'),
(20, 'Marketing'),
(30, 'Sales');

-- 2. Employees (Notice the messy names!)
INSERT INTO Employee (EmpID, EmpName, DeptID, ManagerID) VALUES 
(1, '   ALICE SMITH  ', 10, NULL),
(2, 'Bob Jones', 10, 1),
(3, '  charlie brown ', 20, NULL),
(4, 'david EVANS', 20, 3),
(5, ' EVE WHITE ', 30, NULL);

-- 3. Salaries
INSERT INTO Salaries (EmpID, Amount, EffectiveDate) VALUES 
(1, 120000, '2023-01-01'),
(2, 95000, '2023-01-01'),
(3, 85000, '2023-01-01'),
(4, 110000, '2023-01-01'), -- David makes more than his manager Charlie!
(5, 75000, '2023-01-01');

--------------------------------------------------------------------------------------------------------------
--Now that the data is live, try to write the query that finds the highest-paid person in each department.
WITH CleanStaff AS (
    SELECT 
        EmpID, 
        DeptID, 
        TRIM(UPPER(EmpName)) AS CleanName -- Cleaning the "messy" data
    FROM Employee
),
RankedSalaries AS (
    SELECT 
        c.CleanName,
        c.DeptID,
        s.Amount,
        -- Use DESC to get the highest salary as #1
        RANK() OVER(PARTITION BY c.DeptID ORDER BY s.Amount DESC) as SalaryRank
    FROM CleanStaff c
    JOIN Salaries s ON c.EmpID = s.EmpID
)
SELECT 
    d.DeptName,
    rs.CleanName,
    rs.Amount
FROM RankedSalaries rs
JOIN Departments d ON rs.DeptID = d.DeptID
WHERE rs.SalaryRank = 1;

-- "Looking at your code, what happens if two employees in the same department have the exact same highest salary? Will your query show both of them, or just one?"
--Use Row_Number function instead of Rank or Dense_Rank

--The Task: Write a query that displays each employee's name alongside their manager's name.
Select e1.EmpName, (e2.EmpName) as Manager_Name From Employee e1 
LEFT JOIN Employee e2 
ON  e2.ManagerID = e1.EmpID 

SELECT 
    TRIM(UPPER(e.EmpName)) AS Employee_Name,
    TRIM(UPPER(m.EmpName)) AS Manager_Name
FROM Employee e
LEFT JOIN Employee m 
    ON e.ManagerID = m.EmpID; -- Link the worker's manager link to the manager's actual ID

-- Write a query that shows only the employees who make more money than their manager.
SELECT 
    TRIM(UPPER(e.EmpName)) AS Employee,
    es.Amount AS Emp_Salary,
    TRIM(UPPER(m.EmpName)) AS Manager,
    ms.Amount AS Manager_Salary
FROM Employee e
JOIN Salaries es ON e.EmpID = es.EmpID
JOIN Employee m ON e.ManagerID = m.EmpID
JOIN Salaries ms ON m.EmpID = ms.EmpID
WHERE es.Amount > ms.Amount; -- The "Salary Gap" Filter

--The HR department wants to know who the most recently hired employee is in each department.
WITH JoinDate as (
Select e.EmpName, d.DeptName, s.EffectiveDate, Row_NUMBER() Over(Partition by d.DeptName Order by s.EffectiveDate DESC) as Rows1
From  EMPLOYEE e
Left Join Departments d
ON e.DeptID = d.DeptID
Left JOIN Salaries s
ON e.EmpID = s.EmpID
)
Select * from JoinDate
Where Rows1 = 1;

--The board wants a "Diversity & Budget" report. They need to see the employee names, their salaries, and a Salary Category.
--;Write a query using your Employees and Salaries tables that creates a new column called Budget_Status based on these rules:
--If the salary is above 100,000, label it 'Executive Budget'.
--If the salary is between 80,000 and 100,000, label it 'Standard Budget'.
--Anything else is 'Growth Budget'.
Select EmpName, Amount, Case 
When Amount > 100000 THEN 'Executive Budget'
WHEN Amount >= 80000 THEN 'Standard Budget'
Else 'Growth Budget'	
END as Salary_Category
From Salaries s
JOIN EMPLOYEE e
ON e.EMPID = s.EMPID

