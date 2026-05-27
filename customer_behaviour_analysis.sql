use customer_behaviour;
-- 1 what is the total revenue genrated by male vs female customers?
select * from customer limit 20;
select gender ,sum(purchase_amount) as revenue
from customer
group by gender;
-- 2 which customer used a discount but still spent more than the average purchase amount?
select avg(purchase_amount) from customer;
select customer_id ,purchase_amount
from customer
where discount_applied ='YES' and purchase_amount >= (select avg(purchase_amount) from customer);

-- 3 which are the top 5 products with the highest average review rating?

SELECT item_purchased,
ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2)
AS "Average product rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;
  
-- 4 compare the average purchase amount between standard and express shipping

select shipping_type,
round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard' , 'Express')
group by shipping_type;

-- 5 do subscribed customers spend more? compare average spend and total revenue betwee subscrbers and non-subscribers?
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

-- 6 which 5 products have the highest percentage of purchases with discounts applied?
select item_purchased,
round(100 * SUM(case when discount_applied = 'YES' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5;

-- 7 segment customers into new ,returning , and loyal based on their total number of previous purchases and show count of each segment

with customer_type as (
select customer_id ,previous_purchases,
case 
    when previous_purchases =1 then 'new'
    when previous_purchases    between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer
)
    select customer_segment ,count(*) as "number of customers"
    from customer_type
    group by customer_segment;

-- 8 what are the top 3 most purchased products within each category?
with item_counts as(
select category,
item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank <=3;

-- 9 are customers who are repeat buyers (more than 5prevois) also likely to subscribers?

SELECT subscription_status,
COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;
-- 10 what is the revenue contribution ofeach age group?

select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;
