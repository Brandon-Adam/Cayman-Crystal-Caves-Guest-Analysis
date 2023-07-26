--Deleting empty rows
DELETE 
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
WHERE Date IS NULL;

--Deleting single row in source_A data where source_A group name is incorrect
DELETE 
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
WHERE Market_Penetration____ = "#N/A";

DELETE
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies` 
WHERE Date IS NULL;


---------------------------------source_A Only-------------------------
--Total guests and percent kids from each source_A sub company
SELECT
  source_A_sub_Company,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
GROUP BY source_A_sub_Company;


--Total guests and percent kids from each source_A
SELECT
  source_A_group_Name,
  source_A_Company,
  Market_Penetration____,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
GROUP BY source_A_group_Name, source_A_Company, Market_Penetration____;


--Same as above with date added
SELECT
  Date,
  source_A_group_Name,
  source_A_Company,
  Market_Penetration____,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
GROUP BY source_A_group_Name, source_A_Company, Date, Market_Penetration____;


--Total guests and percent kids from each source_A company
SELECT
  source_A_Company,
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
    FROM`optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
  )
GROUP BY source_A_Company;


--Most popular time for cruise companies
SELECT
  source_A_Company,
  Time,
  SUM(Total_Guests) AS Total_Guests,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  SUM(Total) AS total_paid,
  ROUND(AVG(Total_Guests)) AS avg_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
GROUP BY Time, source_A_Company;




---------------------------------Tour Companies------------------------------

SELECT
  source_D_Company,
  Price,
  SUM(Total) AS total_paid,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  ROUND(AVG(Total_Guests)) AS avg_guests,
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies`
WHERE source_A_group_Name IS NULL
GROUP BY 
  source_D_Company,
  Price;

SELECT
  source_D_Company,
  Time,
  SUM(Total) AS total_paid,
  SUM(Adults) AS Total_Adults,
  SUM(Kids) AS Total_Kids,
  SUM(Kids)/SUM(Total_Guests)*100 AS percent_kids,
  ROUND(AVG(Total_Guests)) AS avg_guests,
  SUM(Total_Guests) AS total_guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies`
WHERE source_A_group_Name IS NULL
GROUP BY 
  source_D_Company,
  Time;







----------------------------Full Data---------------------------------------
--Deleting rows that are N/A for analysis and adding boolean column for local
CREATE TABLE Cayman_Crystal_Caves.customer_data_source_C
  AS (SELECT *,
        CASE
          WHEN Adult_Type LIKE "Source B Adult"
            THEN TRUE
            ELSE FALSE
        END AS BorC
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data`
      WHERE Adult_Rate_US_ <> "0" AND 
        Reservation_Type LIKE "%Peek%" OR 
        Reservation_Type LIKE "%peek%");

--Finding different adult types
SELECT
DISTINCT Adult_Type
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`;

--B vs C
SELECT 
  SUM(Total_Qty) AS Total_Qty,
  Local
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`
GROUP BY Local;

--Tour Times for source_C
SELECT
  SUM(Total_Qty) AS total_guests,
  SUM(Adult_Qty) AS total_adults,
  SUM(Kids_Qty) AS total_kids,
  Tour_Time,
  Local
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`
GROUP BY 
  Tour_Time,
  BorC;




-------Time Grouped----------------------------------
SELECT
  Time,
  SUM(Total_Guests) AS Total_Guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
GROUP BY 
Time;



SELECT
  Time,
  SUM(Total_Guests) AS Total_Guests
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies`
WHERE source_A_group_Name IS NULL
GROUP BY 
  Time;

--Source C
SELECT
  Tour_Time AS Time,
  SUM(Total_Qty) AS Total_Guests
FROM
`optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`
WHERE BorC IS FALSE
GROUP BY
  Tour_Time;

--Source C
SELECT
  Tour_Time AS Time,
  SUM(Total_Qty) AS Total_Guests
FROM
`optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`
WHERE BorC IS TRUE
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
  CASE WHEN Total_Guests IS NOT NULL THEN "source_A" ELSE null END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only`)
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
  CASE WHEN Total_Guests IS NOT NULL THEN "source_D" ELSE null END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies`)
WHERE source_A_group_Name IS NULL
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
  CASE WHEN BorC IS FALSE THEN "source_C" ELSE "source_B" END AS Type
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`)
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
--source_A Date table
CREATE TABLE Cayman_Crystal_Caves.date_source_A
  AS (SELECT *,
        (CASE
          WHEN Total_Guests > 0
            THEN "source_A"
            ELSE "0"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only`);

--source_D date table
CREATE TABLE Cayman_Crystal_Caves.date_source_D
  AS (SELECT *,
        (CASE
          WHEN Total_Guests > 0
            THEN "source_D"
            ELSE "0"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_D_companies`);

--Stayover date table
CREATE TABLE Cayman_Crystal_Caves.date_Stayover
  AS (SELECT *,
        (CASE
          WHEN BorC IS TRUE
            THEN "source_B"
            ELSE "source_C"
        END) AS guest_source
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`);



--Joining tables of dates from each guest source--
--Casting date column in datestayover as date
SELECT PARSE_DATE('%m/%d/%Y', Date)
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_source_C`
WHERE Date != "name";

CREATE TABLE Cayman_Crystal_Caves.dates_grouped
  AS
  (SELECT
    Date,
    guest_source,
    SUM(Total_Guests) AS total_guests
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_source_A` 
  GROUP BY
    Date,
    guest_source
  UNION ALL
    (SELECT
      Date,
      guest_source,
      SUM(Total_Guests) AS total_guests
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_source_D` 
    WHERE 
      source_A_group_Name IS NULL
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
      FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.date_source_C`
      WHERE Date != "name")
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
FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`
  WHERE 
    Kids_Qty > 0
Group By 
  Total_Qty, 
  Kids_Qty,
  BorC;

-------


----Number of occurance of cruise ship----
--Shows how number of cruise is with market pen
SELECT
  source_A_group_Name,
  SUM(Total_Guests) AS total,
  COUNT(Total_Guests) AS count,
  SUM(Total_Guests)/COUNT(Total_Guests) AS guests_per_occurance,
  SUM(Total_Guests)/SUM(total_guests_in_group) AS market_pen
FROM 
  (
    SELECT *,
      PARSE_NUMERIC(total_guest_in_group) AS total_guests_in_group
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only`)
GROUP BY source_A_group_Name;
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
      AND BorC IS FALSE
        THEN "Pickup"
        ELSE "No Pickup" 
        END) AS pickup
   FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`)
   WHERE BorC IS FALSE
GROUP BY pickup, tour_time;
----------------------------------------------------------------------------------


--Kids split for date
SELECT
  SUM(Adult_Qty) AS total_guests,
  Date,
  BorC,
  age
FROM
  (SELECT 
    *,
    (CASE
      WHEN Adult_Qty > 0
      THEN "Adult"
      ELSE null
      END) AS age
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`)
WHERE Adult_Qty > 0
GROUP BY 
  Date,
  BorC,
  age
UNION ALL
(SELECT
  SUM(Kids_Qty) AS total_kids,
  Date,
  BorC,
  age
FROM
  (SELECT 
    *,
    (CASE
      WHEN Kids_Qty > 0
      THEN "kid"
      ELSE null
      END) AS age
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.customer_data_source_C`)
WHERE Kids_Qty > 0
GROUP BY 
  Date,
  BorC,
  age);


--Checking if percentage market pen adds up
SELECT
  SUM(total_guests_in_group),
  source_A_Company
FROM(SELECT *,
  PARSE_NUMERIC(total_guest_in_group) AS total_guests_in_group
  FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A__only`)
GROUP BY source_A_Company;


------------------------------------------------Cruise company dates bar chart
SELECT
  Date,
  source_A_Company,
  SUM(Total_Guests) AS total_guests,
  AVG(Market_Penetrations) AS market_pen
FROM
  (
    SELECT
      *,
      PARSE_NUMERIC(Market_Penetration____) AS Market_Penetrations
    FROM `optimal-bivouac-388416.Cayman_Crystal_Caves.invoices_source_A_only` 
  )
GROUP BY
  Date,
  source_A_Company;

