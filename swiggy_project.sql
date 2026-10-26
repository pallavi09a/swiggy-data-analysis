create database swiggy;
use swiggy;

select * from swiggy_data;

ALTER TABLE swiggy_data
RENAME COLUMN ï»¿State TO state;

USE swiggy;

ALTER TABLE swiggy_data
RENAME COLUMN `Order Date` TO orderdate;
describe swiggy;

alter table swiggy_data
rename column `Restaurant Name` to Restaurant_Name;

alter table swiggy_data
rename column `Dish Name` to Dishname;
alter table swiggy_data
rename column `Price (INR)` to price_inr;

alter table swiggy_data
rename column `Rating Count` to RatingCount;

-- Data validation & cleaning
-- null check 
select 
sum(case when state is null then 1 else 0 end) as null_state,
sum(case when city is null then 1 else 0 end) as nul_city,
sum(case when OrderDate is null then 1 else 0 end) as null_orderdate,
sum(case when Restaurant_Name is null then 1 else 0 end) as null_restaurant,
sum(case when location is null then 1 else 0 end) as null_location,
sum(case when Category is null then 1 else 0 end) as null_Category,
sum(case when DishName is null then 1 else 0 end) as null_dish,
sum(case when price_inr is null then 1 else 0 end) as null_price,
sum(case when Rating is null then 1 else 0 end) as null_rating,
sum(case when RatingCount is null then 1 else 0 end) as null_rating_count
from swiggy_data;

-- blank or empty strings
select * from swiggy_data
where state='' or city='' or Restaurant_Name='' or Category='' or DishName=''

-- Duplicate detection
select
state, city, orderdate, restaurant_name, location, category,
dishname, price_inr, rating, ratingcount, count(*) as CNT
from swiggy_data
group by
state, city, orderdate, restaurant_name, location, category, dishname,
price_INR , rating, ratingcount
having count(*)>1

-- Delete Duplications
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY
                   State, city, orderdate, restaurant_name,
                   location, category, dishname, price_inr,
                   rating, ratingcount
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM swiggy_data
)
SELECT *
FROM CTE
WHERE rn > 1;

-- creating schema
-- dimension tables
-- datetable
create table dim_date(
date_id int auto_increment  primary key,
full_date date,
year int, 
month int,
month_name varchar(20),
Quarter int,
week int
)
select * from dim_date;

-- dim location 
create table dim_location(
location_id int auto_increment primary key,
state varchar(100),
city varchar(100),
location varchar(200)
);

-- dim restaurant
create table dim_restaurant(
restaurant_id int  auto_increment primary key ,
restaurant_name varchar(200)
);

-- dim dish
create table dim_dish(
dish_id int auto_increment primary key,
dish_name varchar(200)
);

CREATE TABLE dim_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Fact table
create table fact_swiggy_orders(
order_id int auto_increment primary key ,
date_id int,
price_INR decimal(10,2),
rating decimal (4,2),
rating_count int,

location_id int,
restaurant_id int,
category_id int,
dish_id int,

foreign key (date_id) references dim_date(date_id),
foreign key (location_id) references dim_location(location_id),
foreign key (restaurant_id) references dim_restaurant(restaurant_id),
foreign key (category_id) references dim_category(category_id),
foreign key (dish_id) references dim_dish(dish_id)
);

select * from fact_swiggy_orders;

-- Insert data in tables
-- dim date
INSERT INTO dim_date
(full_date, year, month, month_name, quarter, day, week)
SELECT DISTINCT
    orderdate,
    YEAR(orderdate),
    MONTH(orderdate),
    MONTHNAME(orderdate),
    QUARTER(orderdate),
    DAY(orderdate),
    WEEK(orderdate)
FROM swiggy_data
WHERE orderdate IS NOT NULL;

select * from dim_date

-- display dim date table
DESCRIBE dim_date;
-- add day column
ALTER TABLE dim_date
ADD COLUMN day INT;

-- dim location
insert into dim_location (state,city,location)
select distinct
state, city, location
from swiggy_data;

-- dim restaurant
insert into dim_restaurant (restaurant_name)
select distinct
restaurant_name
from swiggy_data;

-- dim category
insert into dim_category (category_name)
select distinct
category
from swiggy_data
where category is not null;

-- dim dish
insert into dim_dish(dish_name)
select distinct
dishname
from swiggy_data;

-- fact table
INSERT INTO fact_swiggy_orders
(
    date_id,
    price_INR,
    rating,
    rating_count,
    location_id,
    restaurant_id,
    category_id,
    dish_id
)
SELECT
    dd.date_id,
    s.price_inr,
    s.Rating,
    s.RatingCount,
    dl.location_id,
    dr.restaurant_id,
    dc.category_id,
    dsh.dish_id
FROM swiggy_data s
JOIN dim_date dd
    ON dd.full_date = s.orderdate
JOIN dim_location dl
    ON dl.state = s.state
    AND dl.city = s.city
    AND dl.location = s.location
JOIN dim_restaurant dr
    ON dr.restaurant_name = s.Restaurant_Name
JOIN dim_category dc
    ON dc.category_name = s.Category
JOIN dim_dish dsh
    ON dsh.dish_name = s.DishName;

select * from fact_swiggy_orders

select * from fact_swiggy_orders f
join dim_date d on f.date_id = d.date_id
join dim_location l on f.location_id = l.location_id
join dim_restaurant r on f.restaurant_id = r.restaurant_id
join dim_category c on f.category_id = c.category_id
join dim_dish di on f.dish_id = di.dish_id;

-- KPI's
-- total orders
 select count(*) as total_orders 
 from fact_swiggy_orders

-- total revenue (inr million)
SELECT
    CONCAT(
        FORMAT(SUM(price_INR) / 1000000, 2),
        ' INR Million'
    ) AS Total_Revenue
FROM fact_swiggy_orders;

-- Average Dish Price
SELECT
    CONCAT(
        FORMAT(avg(price_INR),2),
        ' INR'
    ) AS Total_Revenue
FROM fact_swiggy_orders;

-- Average Rating
select
avg(rating) as avg_rating
from fact_swiggy_orders


-- monthly order trends
select 
d.year,
d.month,
d.month_name,
count(*) as Total_orders
from fact_swiggy_orders f
join dim_date d 
on f.date_id = d.date_id
group by d.year,
d.month,
d.month_name
order by 
count(*) desc

-- Total Revenue
select 
d.year,
d.month,
d.month_name,
count(Price_INR) as Total_Revenue
from fact_swiggy_orders f
join dim_date d 
on f.date_id = d.date_id
group by d.year,
d.month,
d.month_name
order by 
count(Price_INR) desc

-- Quaterly Trend
select 
d.year,
d.quarter,
count(*) as total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id = d.date_id
group by d.year,
d.quarter
order by count(*) desc

-- yearly trend
select 
d.year,
count(*) as total_orders
from fact_swiggy_orders f
join dim_date d
on f.date_id = d.date_id
group by d.year
order by count(*) desc

-- orders by day of week(mon-sun)
SELECT
    DAYNAME(d.full_date) AS Day_name,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders f
JOIN dim_date d
    ON f.date_id = d.date_id
GROUP BY
    DAYOFWEEK(d.full_date),
    DAYNAME(d.full_date)
ORDER BY
    DAYOFWEEK(d.full_date);

-- Top 10 cities by order volume
select
l.city,
count(*) as total_orders from fact_swiggy_orders f 
join dim_location l
on l.location_id = f.location_id
group by l.city 
order by count(*) desc
limit 10;

-- Revenue contributaion by states
select
l.state,
sum(price_inr) as total_revenue from fact_swiggy_orders f 
join dim_location l
on l.location_id = f.location_id
group by l.state 
order by sum(f.price_INR) desc

-- top 10 restaurant by orders
SELECT
    r.restaurant_name,
    SUM(f.price_INR) AS total_revenue
FROM fact_swiggy_orders f
JOIN dim_restaurant r
    ON r.restaurant_id = f.restaurant_id
GROUP BY r.restaurant_name
ORDER BY total_revenue DESC
LIMIT 10;

-- most ordered dishes
select d.dish_name,
count(*) as order_count
from fact_swiggy_orders f 
join dim_dish d on f.dish_id = d.dish_id
group by d.dish_name
order by order_count desc;

-- Cuisine Performance (orders + avg rating)
select 
c.category_name,
count(*) as total_orders,
avg(f.rating) as avg_rating
from fact_swiggy_orders f 
join dim_category c on f.category_id = c.category_id
group by c.category_name
order by total_orders desc;

-- total orders by price range
SELECT
    CASE
        WHEN price_INR < 100 THEN 'Under 100'
        WHEN price_INR BETWEEN 100 AND 199 THEN '100-199'
        WHEN price_INR BETWEEN 200 AND 299 THEN '200-299'
        WHEN price_INR BETWEEN 300 AND 499 THEN '300-499'
        ELSE '500+'
    END AS price_range,
    COUNT(*) AS total_orders
FROM fact_swiggy_orders
GROUP BY
    CASE
        WHEN price_INR < 100 THEN 'Under 100'
        WHEN price_INR BETWEEN 100 AND 199 THEN '100-199'
        WHEN price_INR BETWEEN 200 AND 299 THEN '200-299'
        WHEN price_INR BETWEEN 300 AND 499 THEN '300-499'
        ELSE '500+'
    END
ORDER BY total_orders DESC;

--  rating count distribution (1-5)
select
rating,
count(*) as rating_count
from fact_swiggy_orders
group by rating
order by count(*) desc;


##############################################################################################################################################################