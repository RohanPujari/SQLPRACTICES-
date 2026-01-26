-- 1. Create Tables
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    Title VARCHAR(100),
    AuthorID INT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    Category VARCHAR(50),
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    JoinDate DATE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 2. Insert Data
INSERT INTO Authors VALUES (1, 'Stephen', 'King'), (2, 'J.K.', 'Rowling'), (3, 'George', 'Orwell'), (4, 'Agatha', 'Christie');
INSERT INTO Books VALUES 
(101, 'The Shining', 1, 25.00, 15, 'Horror'),
(102, 'It', 1, 30.00, 10, 'Horror'),
(103, 'Harry Potter', 2, 20.00, 50, 'Fantasy'),
(104, '1984', 3, 15.00, 20, 'Dystopian'),
(105, 'Murder on the Orient Express', 4, 18.00, 5, 'Mystery');

INSERT INTO Customers VALUES 
(1, 'Alice', 'Smith', 'alice@email.com', '2023-01-15'),
(2, 'Bob', 'Johnson', 'bob@email.com', '2023-03-22'),
(3, 'Charlie', 'Brown', 'charlie@email.com', '2023-05-10');

INSERT INTO Orders VALUES 
(501, 1, '2023-06-01', 45.00),
(502, 2, '2023-06-05', 20.00),
(503, 1, '2023-07-10', 30.00);

----------------------------------------------------------------------------
CREATE TABLE Products (
    ProductID INTEGER PRIMARY KEY,
    ProductName TEXT,
    Price DECIMAL(10,2),
    Discount DECIMAL(10,2) -- Note: Some of these will be NULL!
);

INSERT INTO Products (ProductName, Price, Discount) VALUES 
('Laptop', 1000.00, 100.00),
('Mouse', 25.00, NULL),
('Keyboard', 50.00, 5.00),
('Monitor', 200.00, NULL);
Select * from Products;

-----------------------------------------------------------

CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY,
    Name TEXT,
    HireDate DATE
);

INSERT INTO Employees (Name, HireDate) VALUES 
('Alice', '2023-01-15'),
('Bob', '2022-11-20'),
('Charlie', '2023-07-04'),
('David', '2023-12-31 23:59:59'); -- Note the time!

Select * from Employees;
-------------------------------------------------------------
CREATE TABLE Students (
    StudentID INTEGER PRIMARY KEY,
    Name TEXT,
    GPA DECIMAL(3,2),
    Major TEXT,
    AdvisorID INTEGER -- Links to a Mentor/Staff (for self-joins later)
);

CREATE TABLE Courses (
    CourseID INTEGER PRIMARY KEY,
    CourseName TEXT,
    Credits INTEGER,
    Department TEXT
);

CREATE TABLE Enrollments (
    EnrollmentID INTEGER PRIMARY KEY,
    StudentID INTEGER,
    CourseID INTEGER,
    Grade TEXT, -- 'A', 'B', 'C', or NULL (if still attending)
    EnrollmentDate DATE
);

INSERT INTO Students VALUES 
(1, 'Alex', 3.8, 'CS', 3), (2, 'Beth', 3.9, 'CS', 3), 
(3, 'Charlie', 2.5, 'Math', NULL), (4, 'Diana', 3.2, 'Bio', 1);

INSERT INTO Courses VALUES 
(101, 'Intro to SQL', 4, 'CS'), (102, 'Calculus', 4, 'Math'), 
(103, 'Bio 101', 3, 'Bio'), (104, 'Python', 4, 'CS');
Select * from Courses;

INSERT INTO Enrollments VALUES 
(1, 1, 101, 'A', '2023-01-10'), (2, 1, 104, 'B', '2023-01-15'),
(3, 2, 101, 'A', '2023-01-10'), (4, 3, 102, 'C', '2023-02-01');