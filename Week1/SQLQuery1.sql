USE AdventureWorks2022;
GO

--Q1 
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE c.PersonID IS NOT NULL;

--Q2
SELECT c.CustomerID, p.FirstName, p.LastName, s.Name
FROM Sales.Customer c
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE s.Name LIKE '%n';

--Q3
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName, a.City
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress b ON p.BusinessEntityID = b.BusinessEntityID
JOIN Person.Address a ON b.AddressID = a.AddressID
WHERE a.City IN ('Berlin', 'London');


--Q4
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName, sp.Name AS CountryRegion
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress b ON p.BusinessEntityID = b.BusinessEntityID
JOIN Person.Address a ON b.AddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name IN ('United Kingdom', 'United States');

--Q5
SELECT ProductID, Name, ProductNumber, ListPrice
FROM Production.Product
ORDER BY Name;

--Q6
SELECT ProductID, Name, ProductNumber, ListPrice
FROM Production.Product
WHERE Name LIKE 'A%';

--Q7
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID;

--Q8
SELECT DISTINCT p.FirstName, p.LastName, a.City, pr.Name AS ProductName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.Address a ON bea.AddressID = a.AddressID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE a.City = 'london' AND pr.Name LIKE '%chai%';

--Q9
SELECT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
WHERE c.CustomerID NOT IN (
    SELECT CustomerID FROM Sales.SalesOrderHeader
);

--Q10
SELECT DISTINCT c.CustomerID, p.FirstName, p.LastName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
WHERE pr.Name LIKE '%Tofu%';

--Q11
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate ASC;

--Q12
SELECT TOP 1 soh.OrderDate, soh.SalesOrderID, SUM(sod.LineTotal) AS TotalOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.OrderDate, soh.SalesOrderID
ORDER BY TotalOrderValue DESC;


--Q13
SELECT SalesOrderID, AVG(OrderQty) AS AvgQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;

--Q14
SELECT SalesOrderID,
       MIN(OrderQty) AS MinQuantity,
       MAX(OrderQty) AS MaxQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID;


--Q15
SELECT m.BusinessEntityID AS ManagerID, 
       p.FirstName, 
       p.LastName,
       COUNT(e.BusinessEntityID) AS NumberOfReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN Person.Person p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY m.BusinessEntityID, p.FirstName, p.LastName;

--Q16
SELECT SalesOrderID, SUM(OrderQty) AS TotalQuantity
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty) > 300;

--Q17
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

--Q18
SELECT SalesOrderID, ShipToAddressID
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'Canada';

--Q19
SELECT soh.SalesOrderID, SUM(sod.LineTotal) AS OrderTotal
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.SalesOrderID
HAVING SUM(sod.LineTotal) > 200;

--Q20
SELECT cr.Name AS Country, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY cr.Name;

--Q21
SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(*) AS OrdersCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName;

--Q22
SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(*) AS OrdersCount
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(*) > 3;

--Q23
SELECT DISTINCT pr.Name AS ProductName
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE pr.DiscontinuedDate IS NOT NULL
  AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

--Q24
SELECT e.BusinessEntityID, p1.FirstName AS EmployeeFirstName, p1.LastName AS EmployeeLastName,
       p2.FirstName AS ManagerFirstName, p2.LastName AS ManagerLastName
FROM HumanResources.Employee e
JOIN Person.Person p1 ON e.BusinessEntityID = p1.BusinessEntityID
LEFT JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
LEFT JOIN Person.Person p2 ON m.BusinessEntityID = p2.BusinessEntityID;

--Q25
SELECT e.BusinessEntityID, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN HumanResources.Employee e ON soh.SalesPersonID = e.BusinessEntityID
GROUP BY e.BusinessEntityID;

--Q26
SELECT BusinessEntityID, FirstName, LastName
FROM Person.Person
WHERE FirstName LIKE '%a%';

--Q27
SELECT m.BusinessEntityID, COUNT(e.BusinessEntityID) AS ReportCount
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
GROUP BY m.BusinessEntityID
HAVING COUNT(e.BusinessEntityID) > 4;

--Q28
SELECT soh.SalesOrderID, pr.Name AS ProductName
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID;

--Q29
SELECT TOP 1 soh.CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY COUNT(*) DESC;

--Q30
SELECT DISTINCT p.FirstName + ' ' + p.LastName AS CustomerName
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID
WHERE pp.BusinessEntityID IS NULL;

--Q31
SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE pr.Name LIKE '%Tofu%';

--Q32
SELECT DISTINCT pr.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pr ON sod.ProductID = pr.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE cr.Name = 'France';

-- Q33
SELECT pr.Name AS ProductName, pc.Name AS CategoryName
FROM Production.Product pr
JOIN Production.ProductSubcategory psc ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON pr.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

--Q34
SELECT pr.ProductID, pr.Name
FROM Production.Product pr
LEFT JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
WHERE sod.SalesOrderID IS NULL;

--Q35
SELECT ProductID, Name, SafetyStockLevel, ReorderPoint
FROM Production.Product
WHERE SafetyStockLevel < 10 AND ReorderPoint = 0;

--Q36
SELECT TOP 10 cr.Name AS Country, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion cr ON sp.CountryRegionCode = cr.CountryRegionCode
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY cr.Name
ORDER BY TotalSales DESC;

--Q37
SELECT e.BusinessEntityID AS EmployeeID, COUNT(soh.SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE s.Name BETWEEN 'A' AND 'AO'
GROUP BY e.BusinessEntityID;

--Q38
SELECT TOP 1 soh.OrderDate, SUM(sod.LineTotal) AS TotalOrderValue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.OrderDate, soh.SalesOrderID
ORDER BY SUM(sod.LineTotal) DESC;

--Q39
SELECT pr.Name AS ProductName, SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product pr
JOIN Sales.SalesOrderDetail sod ON pr.ProductID = sod.ProductID
GROUP BY pr.Name
ORDER BY TotalRevenue DESC;

--Q40
SELECT pv.BusinessEntityID AS SupplierID, COUNT(DISTINCT pv.ProductID) AS ProductCount
FROM Purchasing.ProductVendor pv
GROUP BY pv.BusinessEntityID;

--Q41
SELECT TOP 10 c.CustomerID, p.FirstName + ' ' + p.LastName AS CustomerName, SUM(sod.LineTotal) AS TotalSpent
FROM Sales.Customer c
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalSpent DESC;

--Q42
SELECT SUM(LineTotal) AS TotalCompanyRevenue
FROM Sales.SalesOrderDetail;
