INSERT INTO Truck(BrandName, RegistrationNumber, [Year], Payload, FuelConsumption, Volume)
VALUES ('MAN', '1ABC234', 2005, 17500, 20, 95);

DELETE FROM Truck
WHERE TruckId  IN (
	SELECT TEMP_TR.TruckId 
	FROM (
		SELECT 
			TR.TruckId,
			ROW_NUMBER() OVER (PARTITION BY RegistrationNumber, RegistrationNumber ORDER BY TruckId ASC) AS RegCount
		FROM Truck TR) TEMP_TR
	WHERE TEMP_TR.RegCount > 1
)

INSERT INTO Truck(BrandName, RegistrationNumber, [Year], Payload, FuelConsumption, Volume)
VALUES ('MAN', '1ABC234', 2005, 17500, 20, 95);

WITH TruckCTE AS
(SELECT *,[Rank]=RANK() OVER (ORDER BY RegistrationNumber)
FROM Truck)
DELETE TruckCTE
WHERE 
	[Rank] IN (SELECT [Rank] FROM TruckCTE GROUP BY [Rank] HAVING COUNT(*)>1) AND
	TruckId NOT IN (SELECT MIN(TruckId) FROM TruckCTE GROUP BY [Rank] HAVING COUNT(*)>1)