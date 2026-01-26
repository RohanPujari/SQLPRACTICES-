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

--Show all Student Names and their GPA. If a student doesn't have an Advisor (AdvisorID is NULL), show the word 'NONE'.
Select Students.Name , Students.GPA, COALESCE(AdvisorID, 'NONE') as Test FROM Students;


--Find all Departments in the Courses table that offer more than 5 total credits across all their courses.
SELECT Department, SUM(Credits) as Total_Credits
FROM Courses
GROUP BY Department
HAVING SUM(Credits) > 5;
--Find the names of all Students who are not enrolled in any courses.
SELECT s.Name 
FROM Students s 
LEFT JOIN Enrollments e
ON s.StudentID = e.StudentID
WHERE e.CourseID is NULL;
--Find the Name of the student with the highest GPA in the 'CS' Major.
Select *
FROM Students s
WHERE s.Major  = 'CS'
Order by s.GPA DESC;
