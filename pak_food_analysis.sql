/*
Project Name: Pakistan Food Price Analysis
Auther Name:  Zahoor Ahmad
Github link: https://github.com/Ahmad-Zahoor


*/

-- Select all records to explore the dataset
SELECT * FROM food;

-- Q1. Count of records
SELECT count(*) as Total_Records FROM food;
-- A1: Total Record is 12457

-- Q2. Find out from how many states data are taken
SELECT count(distinct Province) as Total_States from food;
-- A2: Data are taken from 4 States (Balochistan, Khyber Pakhtunkhwa, Panjab, Sindh)

-- Q3. How to find out the states which have the highest prices of Rice under cereals and tubers category, and price type is Retail
select Province, max(price) as Rice_high_prices from food where commodity like "%Rice%" and category="cereals and tubers" and pricetype="Retail"
group by Province order by Rice_high_prices desc;
-- A3: There are 4 states that have the highest Rice prices in the category of "cereals and tubers" and its pricetype is "Retail"
   -- (Balochistan: 247.33, Sindh: 221.54, Punjab:208.61, Khyber Pakhtunkhwa 196.61

-- Q4. Find out the states and market which have had the highest prices of Wheat under "cereals and tubers" category, and its price type is "Retail".
select Province, market, max(price) as Wheat_high_prices from food where commodity like "%Wheat%" and category="cereals and tubers" and pricetype="Retail"
group by Province, market order by Wheat_high_prices desc;

-- Q5.Find out the states and market which have the highest prices of Milk under milk and dairy category- Retail purchases only
select Province, market, max(price) as Milk_high_prices from food where commodity like "%Milk%" and category="milk and dairy" and pricetype="Retail"
group by Province, market order by  Milk_high_prices desc;

-- Q6.Find out the states and market which have the highest prices of Sugar under "miscellaneous food" category- Retail purchases only
select Province, market, max(price) as Sugar_high_prices from food where commodity like "%Sugar%" and category="miscellaneous food" and pricetype="Retail"
group by Province, market order by  Sugar_high_prices desc;

-- Q7. Find out the states and market which have had the highest prices of Ghee (artificial) under oil and fats- Retail purchases only
select Province, market, unit, max(price) as Ghee_high_prices from food where commodity="Ghee (artificial)" and category="oil and fats" and pricetype="Retail"
group by Province, market, unit order by  Ghee_high_prices desc;

-- Q8. Finding out the avegarge price of oil and fats as whole
SELECT AVG(price) as average_price from food where category="oil and fats";

-- Q9. Find out the average prices for each type of oil under oil and fats
SELECT commodity, avg(price) as average_price from food where category="oil and fats" group by commodity;

-- Q10. Finding out the average prices of lentils
SELECT commodity, category, AVG(price) as average_price from food where commodity="Lentils (moong)" group by commodity, category;
-- A10: The average price for Lentils (moong) commodity is 140.978885

-- Q11. Finding out the average price of Eggs
SELECT commodity, category, AVG(price) as average_price from food where commodity="Eggs" group by commodity, category;
-- A11. The average price Eggs commodity is 104.367156

-- Q12 Find out which commodity has the highest price
select commodity, max(price) as highest_price from food group by commodity order by highest_price desc;
-- A12. The highest price commodity is Wage (non-qualified labour, non-agricultural)

-- Q13 Find out the commodities which has the highest prices recently year 2022
with cte as(
select date, commodity, max(price) as highest_price, Year(date) as Year from food group by date, commodity order by highest_price desc)
select * from cte where Year=2022 order by date desc;

-- Q14 Create a table for zones
-- Select city and province from food table and insert it into zones table

-- CREATE TABLE zones(
-- 	`City` VARCHAR(255),
--    `State` VARCHAR (255),
--    `zone` VARCHAR(255),
--    PRIMARY KEY(`City`, `State`)
-- )
Insert into zones
SELECT distinct City, Province, NULL from food WHERE City is not NULL;

SET SQL_SAFE_UPDATES = 0;

UPDATE `zones` SET zone ='South'  WHERE State LIKE 'SINDH';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'PUNJAB';
UPDATE `zones` SET zone ='North'  WHERE State LIKE 'KHYBER PAKHTUNKHWA';
UPDATE `zones` SET zone ='North'  WHERE State LIKE 'BALOCHISTAN';

-- Q15 JOIN zones table and food AND Create a view
Create view commodity_prices as
Select fo.date,zo.City,zo.State,fo.market,zo.zone,fo.latitude,fo.longitude,fo.category,fo.commodity,fo.unit,fo.priceflag,fo.pricetype,fo.currency,fo.price,fo.usdprice
from zones zo
JOIN food fo
WHERE zo.State = fo.Province;

select DISTINCT market
from commodity_prices;

-- Q16 Average price of commodities zone wise
select commodity, zone, avg(price) as average_price from commodity_prices group by commodity, zone;

-- Q17 Find out the price differences between  2022 and 2012

SELECT 
	SUM(CASE WHEN Year(date)=2022 THEN price ELSE 0 END) -
    SUM(CASE WHEN Year(date)=2021 THEN price ELSE 0 END) as price_difference
FROM food

-- Q18 Find out the average prices of each category food products zone wise

select zone,category, round(avg(price)) as avgprice from commodity_prices where pricetype = "Retail" 
group by 1,2
order by category,avgprice DESC;

-- Q19 Find out the average prices of each commodity zone wise
SELECT zone,commodity, round(avg(price)) as avgprice
from commodity_prices
where pricetype = "Retail"
group by 1,2
order by commodity,avgprice DESC;

-- ********************* END of Project ***********************************
