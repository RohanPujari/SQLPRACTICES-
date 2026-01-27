Select  ProductName, (Price- COALESCE(Discount, 0))AS Final_Price  
from Products;
-------------------------------
Select *
FROM Employees
WHERE HireDate >= '2023-01-01' 
  AND HireDate < '2024-01-01';

--Why is this "The Pro Way"?
--Index Friendly: Using LIKE '%2023%' or YEAR(HireDate) forces the database to look 
--at every single row one by one (slow). Using >= and < allows the database
-- to use an "Index" to jump straight to the 2023 section (fast).

--The Time Trap: Notice 'David' in my setup has a time of 23:59:59. If you only used BETWEEN 
--'2023-01-01' AND '2023-12-31', you might accidentally miss people hired in those last few hours!
--Using < '2024-01-01' catches every single second of 2023.


Select * from Courses;

--1Show all Student Names and their GPA. If a student doesn't have an Advisor (AdvisorID is NULL), show the word 'NONE'.
Select Students.Name , Students.GPA, COALESCE(AdvisorID, 'NONE') as Test FROM Students;


--2.Find all Departments in the Courses table that offer more than 5 total credits across all their courses.
SELECT Department, SUM(Credits) as Total_Credits
FROM Courses
GROUP BY Department
HAVING SUM(Credits) > 5;
--3.Find the names of all Students who are not enrolled in any courses.
SELECT s.Name 
FROM Students s 
LEFT JOIN Enrollments e
ON s.StudentID = e.StudentID
WHERE e.CourseID is NULL;
--4.Find the Name of the student with the highest GPA in the 'CS' Major.
Select *
FROM Students s
WHERE s.Major  = 'CS'
Order by s.GPA DESC;
--5. The Goal: Show a list of all CourseNames and the total number of students enrolled in each.
Select c.CourseName, Count(StudentID) as Total_Students
FROM Courses c 
LEFT JOIN Enrollments e 
ON c.CourseID  = e.CourseID
Group by c.CourseName;
--6.  Write a query that shows the Student Name and their Advisor's Name side-by-side.

Select s2.Name as Student_name, s1.Name as Advisor_Name 
FROM Students s1
JOIN Students s2
ON s2.AdvisorID  = s1.StudentID;

--7) 1. Find the Average GPA for each Major. 
--2. Then, show only the Students whose GPA is higher than their Major's average.
--Select Name, GPA
--FROM Students s 
--Where GPA > (Select AVG(s.GPA)
--FRom Students s) 
----
WITH AVG_GPA AS (
    SELECT AVG(GPA) as Global_Avg FROM Students
)
SELECT s.Name, s.GPA
FROM Students s, AVG_GPA  -- This acts like a join
WHERE s.GPA > AVG_GPA.Global_Avg;

--8. Find the names of students who are enrolled in 'Intro to SQL' (CourseID 101) without using a JOIN.
Select s.Name 
FROM Students s 
Where s.StudentID  IN (Select s.StudentID 
FROM Enrollments e
WHere e.CourseID = 101);
--9. Find any Names that appear more than once in the Students table.
SELECT Name
FROM Students
GROUP BY Name
HAVING COUNT(*) > 1;

WITH RankedData AS (
    SELECT Name, 
           DENSE_RANK() OVER(ORDER BY GPA DESC) as Rnk
    FROM Students
)
SELECT Name, Rnk
FROM RankedData
WHERE Rnk > 2;

--Mock Interview Mode: