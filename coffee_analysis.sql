--=======================================================================================================================
--COFFEE SALES ANALYSIS 
--======================================================================================================================
--create database
create database coffee_sales;
--=======================================================================================================================
--DATA CLEANING 

--1.check total number of rows 
select count(*) from coffee;

--2.check the columns 
select column_name,data_type from information_schema.columns where table_name= 'coffee';

--3.check for null values 
select * from coffee where transaction_id is null
or transaction_date is null
or transaction_time is null
or transaction_qty is null
or store_id is null
or store_location is null
or product_id is null
or unit_price is null
or product_category is null
or product_type is null
or product_detail is null;

--4.check if there are any duplicates 
select transaction_id from coffee group by transaction_id having count(transaction_id)>1;

--5.check for invalid quantities 
select * from coffee where transaction_qty<=0;

--6.check for negative prices 
select * from coffee where unit_price<=0;

--7.check for distinct product categories 
select distinct product_category from coffee;

--8.check for distinct store location 
select distinct store_location from coffee;

--9.check date range 
select min(transaction_date), max(transaction_date) from coffee;

--==================================================================================
--EXPLORATORY DATA ANALYSIS 

--1.what is the total revenue generated?
select sum(transaction_qty* unit_price) as total_revenue from coffee;

--2.which product category makes the highest revenue? 
select product_category,sum(transaction_qty* unit_price) as total_revenue from coffee group by product_category order by total_revenue desc ;

--3.which store generates the highest revenue?
select store_location,sum(transaction_qty* unit_price) as total_revenue from coffee group by store_location order by total_revenue desc ;

--4.which product type makes the highest revenue?
select product_type,sum(transaction_qty* unit_price) as total_revenue from coffee group by product_type order by total_revenue desc;

--5. top 10 highest revenue products 
select product_category,product_type,product_detail,sum(transaction_qty*unit_price) as total_revenue from coffee group by product_category,product_type,product_detail order by total_revenue desc limit 10;

--6.what is the total quantity sold?
select sum(transaction_qty) as total_sold_quantity from coffee;

--7.what is the total quantity sold per store?
select sum(transaction_qty) as quantity_sold_per_store, store_location from coffee group by store_location order by quantity_sold_per_store desc;

--8.what is the total quantity sold per category?
select sum(transaction_qty) as quantity_sold_per_category, product_category from coffee group by product_category order by quantity_sold_per_category desc;

--9.what is the average sold quantity?
select avg(transaction_qty) as avg_sold_quantity from coffee;

--10.what is the average order value?
select sum(transaction_qty* unit_price)::numeric/count(distinct transaction_id) as order_value from coffee;

--11.what is the revenue by day of the week?
select to_char(transaction_date,'day') as day_of_week, sum(transaction_qty* unit_price) as total_revenue from coffee group by day_of_week order by total_revenue desc;

--12.what is the revenue by month?
select to_char(transaction_date,'month') as month,sum(transaction_qty* unit_price) as total_revenue from coffee group by month order by total_revenue desc;

--13.what is the revenue by hour?
select extract(hour from transaction_time) as revenue_by_hour,sum(transaction_qty* unit_price) as total_revenue from coffee group by revenue_by_hour order by total_revenue desc;

--14. what is the quantity sold per hour?
select sum(transaction_qty) as transaction_quantity, extract(hour from transaction_time) as transaction_hour from coffee group by transaction_hour order by transaction_quantity desc;

--15.what is the busiest day of the week?
select to_char(transaction_date,'day') as busiest_day, count(transaction_id) as total_orders from coffee group by busiest_day order by total_orders desc limit 1;

--16.which store recorded the highest number of transactions?
select store_location, count(transaction_id) as total_transactions from coffee group by store_location order by total_transactions desc limit 1;

--17.what is the best selling product?
select product_detail, sum(transaction_qty) as quantity_sold from coffee group by product_detail order by quantity_sold desc limit 1;

--18.which is the most expensive product?
select product_detail, max(unit_price) as price from coffee group by product_detail order by price desc limit 1;

--19.which is the cheapest product?
select product_detail, min(unit_price) as price from coffee group by product_detail order by price asc limit 1;

--20.rank all product by revenue 
select product_detail, sum(transaction_qty* unit_price) as total_revenue, rank() over( order by sum(transaction_qty* unit_price) desc) as ranking from coffee group by product_detail; 

--21.what are the top 3 product in each category?
select * from (select product_category, product_detail, sum(transaction_qty* unit_price) as total_revenue, rank() over(partition by product_category order by sum(transaction_qty*unit_price) desc ) as ranking from coffee group by product_category, product_detail) where ranking<=3;

--22.which product has more revenue than the average revenue?
select product_detail, sum(transaction_qty* unit_price) as total_revenue from coffee group by product_detail having sum(transaction_qty* unit_price)>( 
select avg(revenue) from (
(select sum(transaction_qty* unit_price) as revenue from coffee group by product_detail)));

--23.classify product based on price 
select product_detail, unit_price ,case when unit_price>=30 then 'premium' when unit_price>=20 then 'expensive' else 'affordable' end as category_of_prices from coffee;

--24.find the revenue generated by each month and rank them 
selec

