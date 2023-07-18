--Deleting empty rows
DELETE 
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
WHERE Date IS NULL;

--Deleting single row in cruise data where cruise ship name is incorrect
DELETE 
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
WHERE Market_Penetration____ = "#N/A";

DELETE
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies` 
WHERE Date IS NULL;


---------------------------------Cruise Ships Only-------------------------
--Total guests and percent kids from each tour company
SELECT
  Tour_Company,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
GROUP BY Tour_Company;


--Total guests and percent kids from each ship
SELECT
  Cruise_Ship_Name,
  Cruise_Company,
  Market_Penetration____,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
GROUP BY Cruise_Ship_Name, Cruise_Company, Market_Penetration____;


--Same as above with date added
SELECT
  Date,
  Cruise_Ship_Name,
  Cruise_Company,
  Market_Penetration____,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
GROUP BY Cruise_Ship_Name, Cruise_Company, Date, Market_Penetration____;


--Total guests and percent kids from each cruise company
SELECT
  Cruise_Company,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests,
  AVG(market_pen) AS market_pene,
FROM   
  (
    SELECT *,
      PARSE_NUMERIC(Market_Penetration____ ) AS market_pen
    FROM`optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
  )
GROUP BY Cruise_Company;


--Most popular time for cruise companies
SELECT
  Cruise_Company,
  Time,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
GROUP BY Time, Cruise_Company;




---------------------------------Tour Companies------------------------------

SELECT
  Tour_Company,
  Price,
  SUM(Total) AS total_paid,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  ROUND(AVG(Total_Guests)) AS avg_guests,
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies`
WHERE Cruise_Ship_Name IS NULL
GROUP BY 
  Tour_Company,
  Price;

SELECT
  Tour_Company,
  Time,
  SUM(Total) AS total_paid,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  ROUND(AVG(Total_Guests)) AS avg_guests,
  SUM(Total_Guests) AS total_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies`
WHERE Cruise_Ship_Name IS NULL
GROUP BY 
  Tour_Company,
  Time;







----------------------------Full Data---------------------------------------
--Deleting rows that are N/A for analysis and adding boolean column for local
CREATE TABLE Cayman_Crystal_Caves.customer_data_stayovers
  AS (SELECT *,
        CASE
          WHEN Adult_Type LIKE "Local Adult"
            THEN TRUE
            ELSE FALSE
        END AS Local
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data`
      WHERE Adult_Rate_US_ <> "0" AND 
        Reservation_Type LIKE "%Peek%" OR 
        Reservation_Type LIKE "%peek%");

--Finding different adult types
SELECT
DISTINCT Adult_Type
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`;

--Local vs non-local
SELECT 
  SUM(Total_Qty) AS Total_Qty,
  Local
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`
GROUP BY Local;

--Tour Times for stayovers
SELECT
  SUM(Total_Qty) AS total_guests,
  SUM(Adult_Qty) AS total_adults,
  SUM(Kids_Qty) AS total_kids,
  Tour_Time,
  Local
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`
GROUP BY 
  Tour_Time,
  Local;




-------Time Grouped----------------------------------
SELECT
  Time,
  SUM(Total_Guests) AS Total_Guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
GROUP BY 
Time;



SELECT
  Time,
  SUM(Total_Guests) AS Total_Guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies`
WHERE Cruise_Ship_Name IS NULL
GROUP BY 
  Time;

--Stayovers
SELECT
  Tour_Time AS Time,
  SUM(Total_Qty) AS Total_Guests
FROM
`optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`
WHERE Local IS FALSE
GROUP BY
  Tour_Time;

--Locals
SELECT
  Tour_Time AS Time,
  SUM(Total_Qty) AS Total_Guests
FROM
`optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`
WHERE Local IS TRUE
GROUP BY
  Tour_Time;




--Grpuping times 4 types
CREATE TABLE Cayman_Crystal_Caves.time_grouped
  AS (SELECT
  Time,
  Type,
  SUM(Total_Guests) AS Total_Guests
FROM(SELECT 
  *,
  CASE WHEN Total_Guests IS NOT NULL THEN "Cruise" ELSE null END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only`)
GROUP BY 
Time,
Type
UNION ALL
(SELECT
  Time,
  Type,
  SUM(Total_Guests) AS Total_Guests
FROM(SELECT 
  *,
  CASE WHEN Total_Guests IS NOT NULL THEN "Tour" ELSE null END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies`)
WHERE Cruise_Ship_Name IS NULL
GROUP BY 
  Time,
  Type
  )
UNION ALL
(SELECT
  Tour_Time AS Time,
  Type,
  SUM(Total_Qty) AS Total_Guests
FROM
(SELECT 
  *,
  CASE WHEN Local IS FALSE THEN "Stayover" ELSE "Local" END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`)
GROUP BY
  Tour_Time,
  Type));

--Making table for grouped donut
SELECT
  Type,
  SUM(Total_Guests) AS total_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.time_grouped`
GROUP BY 
  Type;
---------------------------------------------------------


----------------------Date Grouped----------------------
--Cruise Date table
CREATE TABLE Cayman_Crystal_Caves.date_cruise
  AS (SELECT *,
        (CASE
          WHEN Total_Guests > 0
            THEN "Cruise"
            ELSE "0"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only`);

--Tour date table
CREATE TABLE Cayman_Crystal_Caves.date_tour
  AS (SELECT *,
        (CASE
          WHEN Total_Guests > 0
            THEN "Tour"
            ELSE "0"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_tour_companies`);

--Stayover date table
CREATE TABLE Cayman_Crystal_Caves.date_stayover
  AS (SELECT *,
        (CASE
          WHEN Local IS TRUE
            THEN "Local"
            ELSE "Stayover"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`);



--Joining tables of dates from each guest source--
-------NEED fulll customer peek/reservation data from matthew--------
--Casting date column in datestayover as date
SELECT PARSE_DATE('%m/%d/%Y', Date)
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_stayover`
WHERE Date != "Darien Hall";

CREATE TABLE Cayman_Crystal_Caves.dates_grouped
  AS
  (SELECT
    Date,
    guest_source,
    SUM(Total_Guests) AS total_guests
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_cruise` 
  GROUP BY
    Date,
    guest_source
  UNION ALL
    (SELECT
      Date,
      guest_source,
      SUM(Total_Guests) AS total_guests
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_tour` 
    WHERE 
      Cruise_Ship_Name IS NULL
    GROUP BY
      Date,
      guest_source)
  UNION ALL
    (SELECT
      Dated AS Date,
      guest_source,
      SUM(Total_Qty) AS total_guests
    FROM 
      (SELECT *, 
      PARSE_DATE('%m/%d/%Y', Date) AS Dated
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_stayover`
      WHERE Date != "Darien Hall")
    GROUP BY
      Date,
      guest_source));
--------------------------------------------------------------------------------------


-------------------Family amount-------------------------------------------------------
--How many people in group when at least one kid present
SELECT
  Total_Qty,
  Kids_Qty,
  Local,
  SUM(Total_Qty) AS total_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`
  WHERE 
    Kids_Qty > 0
Group By 
  Total_Qty, 
  Kids_Qty,
  Local;

-------


----Number of occurance of cruise ship----
--Shows how number of cruise is with market pen
SELECT
  Cruise_Ship_Name,
  SUM(Total_Guests) AS total,
  COUNT(Total_Guests) AS count,
  SUM(Total_Guests)/COUNT(Total_Guests) AS guests_per_occurance,
  SUM(Total_Guests)/SUM(total_passenger_on_ship) AS market_pen
FROM 
  (
    SELECT *,
      PARSE_NUMERIC(Total_Passengers_on_Ship) AS total_passenger_on_ship
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only`)
GROUP BY Cruise_Ship_Name;
---------------------------------------------------------------------------


------Pickup vs walk-in for stayovers------------------------------------------------------
SELECT
  SUM(Total_Qty) AS total_guests,
  tour_time,
  pickup
FROM 
  (SELECT 
    *,
    (CASE 
      WHEN Reservation_type LIKE "%Pickup%" 
      OR Reservation_type LIKE "%pickup%"
      OR Reservation_type LIKE "%Pkup%" 
      OR Reservation_type LIKE "%pkup%"
      AND Local IS FALSE
        THEN "Pickup"
        ELSE "No Pickup" 
        END) AS pickup
   FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`)
   WHERE Local IS FALSE
GROUP BY pickup, tour_time;
----------------------------------------------------------------------------------


--Kids split for date
SELECT
  SUM(Adult_Qty) AS total_guests,
  Date,
  Local,
  age
FROM
  (SELECT 
    *,
    (CASE
      WHEN Adult_Qty > 0
      THEN "Adult"
      ELSE null
      END) AS age
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`)
WHERE Adult_Qty > 0
GROUP BY 
  Date,
  Local,
  age
UNION ALL
(SELECT
  SUM(Kids_Qty) AS total_kids,
  Date,
  Local,
  age
FROM
  (SELECT 
    *,
    (CASE
      WHEN Kids_Qty > 0
      THEN "kid"
      ELSE null
      END) AS age
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_stayovers`)
WHERE Kids_Qty > 0
GROUP BY 
  Date,
  Local,
  age);


--Checking if percentage market pen adds up
SELECT
  SUM(Total_Passengers_On_Ships),
  Cruise_Company
FROM(SELECT *,
  PARSE_NUMERIC(Total_Passengers_On_Ship) AS Total_Passengers_On_Ships
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only`)
GROUP BY Cruise_Company;


------------------------------------------------Cruise company dates bar chart
SELECT
  Date,
  Cruise_Company,
  SUM(Total_Guests) AS total_guests,
  AVG(Market_Penetrations) AS market_pen
FROM
  (
    SELECT
      *,
      PARSE_NUMERIC(Market_Penetration____) AS Market_Penetrations
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_cruise_ships_only` 
  )
GROUP BY
  Date,
  Cruise_Company;
