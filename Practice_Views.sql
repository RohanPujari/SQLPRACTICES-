--Problem 1: The "Clean Revenue" View The accounting team wants a simple way to see revenue without typing Quantity * UnitPrice every time.
--Create a View named v_OrderRevenue that shows DetailID, ProductID, and a calculated column TotalRevenue.
Create View OrderRevenue as
Select DetailID, ProductID, (Quantity*UnitPrice) as Total_Revenue
FROM OrderDetails;

--2.Write a SELECT statement to find all rows from the view (v_OrderRevenue) where the Total_Revenue is greater than 300.
Select * from OrderRevenue 
Where Total_Revenue > 100;