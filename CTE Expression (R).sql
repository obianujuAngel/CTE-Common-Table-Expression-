-- Active: 1717416458862@@127.0.0.1@3306@stolen_vehicles_db
SELECT *
FROM make_details

WITH vehicle_type_most_stolen AS (
 SELECT 
 SV.vehicle_type,
 SV.model_year,
 MD.make_name,
 L.region,
  DATE_FORMAT(SV.date_stolen, '%Y-%m-%d') AS Date_stolen,
 COUNT(*) OVER (PARTITION BY SV.vehicle_type) AS Vehicle_type_stolen_count
 FROM stolen_vehicles as SV
  JOIN make_details as MD ON SV.make_id =MD.make_id
  JOIN locations as L ON SV.location_id =L.location_id
 GROUP BY SV.vehicle_type,
		  SV.model_year,
          MD.make_name,
		  L.region,
          Date_stolen
        )
SELECT *
FROM vehicle_type_most_stolen
ORDER BY vehicle_type_stolen_count DESC

WITH Theft_location AS
 (
SELECT COUNT(DISTINCT DATE(SV.date_stolen)) AS Total_Days_Stolen,
COUNT (*) AS Theft_Per_day,
SV.vehicle_type,
SV.color,
L.region,
L.population
FROM stolen_vehicles AS SV
JOIN Locations AS L
ON SV.location_id =L.location_id
GROUP BY SV.vehicle_type,
SV.color,
L.region,
L.population
) 
SELECT *
FROM Theft_location
ORDER BY Total_Days_Stolen DESC;

WITH Theft_make AS (
  SELECT 
  COUNT(DISTINCT DATE(SV.date_stolen)) AS Total_Days_Stolen,
  MD.make_name,
  L.region
  FROM stolen_vehicles AS SV
  JOIN make_details AS MD
  ON SV.make_id = MD.make_id
  JOIN locations AS L
  ON SV.location_id = L.location_id
  GROUP BY MD.make_name,
  L.region
)
SELECT *
FROM `Theft_make`
WHERE make_name LIKE 'A%'
ORDER BY Total_Days_Stolen DESC;


