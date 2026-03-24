-- Buisness questions

-- 1. What is the count of distinct cities in the dataset?

select distinct city from amazon;

-- 2. For each branch, what is the corresponding city?

select distinct branch, city from amazon;

-- 3. What is the count of distinct product lines in the dataset?

select distinct product_line from amazon;

-- 4. Which payment method occurs most frequently?

select  payment_method, count(*) as payment_count
from amazon
group by payment_method order by payment_count desc;

-- 5. Which product line has the highest sales?

select product_line, sum(quantity) as total_sales from amazon
group by product_line order by total_sales desc;

-- 6. How much revenue is generated each month?

select monthname, sum(total) as total_revenue from amazon
group by monthname order by total_revenue desc;

-- 7. In which month did the cost of goods sold (COGS) reach its peak?

select monthname, sum(cogs) as total_cogs from amazon
group by monthname order by total_cogs desc;

-- 8. Which product line generated the highest revenue?

select product_line, sum(total) as total_revenue from amazon
group by product_line order by total_revenue desc;

-- 9. In which city was the highest revenue recorded?

select city, sum(total) as total_Revenue from amazon
group by city order by total_Revenue desc;

-- 10. Which product line incurred the highest VAT?

select product_line, sum(vat) as Total_VAT from amazon
group by product_line;

-- 11. For each product line, add a column indicating “Good” if its sales are above average, otherwise “Bad.”

set sql_safe_updates = 0;

update amazon
set sales_review = (case
    when total > 322.967430 then 'Good'
    else 'Bad'
	end);
    
set sql_safe_updates = 1;
select product_line, sales_review from amazon;   -- This will give the good or bad review

-- 12. Identify the branch that exceeded the average number of products sold.

select branch, avg(quantity) as avg_quantity from amazon
group by branch 
having avg_quantity > (select avg(quantity) from amazon);

-- 13. Which product line is most frequently associated with each gender?

select gender, product_line, count(gender) as order_frequency
from amazon group by gender, product_line
order by gender, order_frequency desc;

-- 14. Calculate the average rating for each product line.

select product_line, round(avg(rating), 1) as avg_rating
from amazon
group by product_line;

-- 15. Identify the customer type contributing the highest revenue.

select customer_type, sum(total) as total_revenue
from amazon
group by customer_type
order by total_revenue desc;

-- 16. Determine the city with the highest VAT percentage.

select city, sum(vat) as total_vat
from amazon
group by city order by total_vat desc;

-- 17. Identify the customer type with the highest VAT payments.

select customer_type, sum(vat) as total_vat
from amazon group by customer_type
order by total_vat desc;

-- 18.What is the count of distinct customer types?

select distinct customer_type from amazon;

-- 19. What is the count of distinct payment methods?

select distinct payment_method, count(*) as payment_count from amazon
group by payment_method order by payment_count desc;

-- 20. Which customer type occurs most frequently?

select customer_type, count(*) as customer_count
from amazon group by customer_type order by customer_count desc ;

-- 21. Identify the customer type with the highest purchase frequency

select customer_type, count(*) as purchase_frequency
from amazon group by customer_type
order by purchase_frequency desc;

-- 22. Determine the predominant gender among customers.

select gender, count(*) customer_count from amazon
group by gender order by customer_count desc;

-- 23.Examine the distribution of genders within each branch.

select branch, gender, count(gender) as customer_count
from amazon
group by branch, gender
order by branch, customer_count desc;

-- 24. Count the sales occurrences for each time of day on every weekday.

select dayname, timeofday, count(*) as sales_occurance
from amazon
group by dayname, timeofday
order by field(dayname, 'Monday', 'Tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'),
field(timeofday, 'Morning', 'afternoon', 'evening');

-- 25. Identify the time of day when customers provide the most ratings.

select timeofday, count(rating) as rating_count from amazon
group by timeofday order by rating_count desc;

-- 26. Determine the time of day with the highest customer ratings for each branch.

select branch, timeofday, round(avg(rating), 1) as avg_customer_rating
from amazon
group by branch, timeofday
order by branch, avg_customer_rating desc;

-- 27. Identify the day of the week with the highest average ratings.

select dayname, round(avg(rating), 1) as avg_rating
from amazon
group by dayname
order by avg_rating desc;

-- 28. Determine the day of the week with the highest average ratings for each branch.

with ranking_table AS
(select branch, dayname, round(avg(rating), 1) as avg_rating,
 dense_rank() over(partition by branch order by round(avg(rating), 1) desc) as rating_rank
from amazon group by branch, dayname)
select * from ranking_table where rating_rank = 1;