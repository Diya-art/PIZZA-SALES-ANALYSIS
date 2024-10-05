/*Pizza Sales*/

create database pizza;

use pizza;

create table orders 
(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id)
);

create table order_details 
(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id)
);

select * from pizzas;  /*pizza_id,pizza_type_id,size,price*/ 
select * from pizza_types;  /*pizza_type_id, name,category,ingredients*/
select * from orders;  /*order_id,order_date,order_time*/
select * from order_details;  /*order_details_id,order_id,pizza_id,quantity*/

/*Questions Solved*/

/*1.Retrieve the total number of orders placed.*/
SELECT 
    COUNT(order_id) AS 'total orders'
FROM
    orders;
-- 21350


/*2.Calculate the total revenue generated from pizza sales.*/
SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS 'total revenue'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id;
-- 817860.05

/*3.Identify the highest-priced pizza.*/
SELECT 
    p.pizza_type_id, pt.name, p.price
FROM
    pizzas p
        LEFT JOIN
    pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE
    p.price = (SELECT 
            MAX(price)
        FROM
            pizzas);
-- the_greek	The Greek Pizza 	35.95


/*4.Identify the most common pizza size ordered.*/
SELECT 
    p.size, COUNT(od.quantity) AS 'Size_count'
FROM
    pizzas p
        LEFT JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY Size_count DESC
LIMIT 1;
-- L	18526


/*5.List the top 5 most ordered pizza types along with their quantities.*/
SELECT 
    pt.pizza_type_id,
    pt.name,
    SUM(od.quantity) AS 'Total_Quantity'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.pizza_type_id , pt.name
ORDER BY Total_Quantity DESC
LIMIT 5;
-- classic_dlx	  The Classic Deluxe Pizza	    2453
-- bbq_ckn	      The Barbecue Chicken Pizza	2432
-- hawaiian	      The Hawaiian Pizza	        2422
-- pepperoni      The Pepperoni Pizza	        2418
-- thai_ckn	      The Thai Chicken Pizza	    2371



/*6.Join the necessary tables to find the total quantity of each pizza category ordered.*/
SELECT 
    pt.category, SUM(od.quantity) AS 'Quantity_ordered'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category;
-- Classic	14888
-- Veggie	11649
-- Supreme	11987
-- Chicken	11050

/*7.Determine the distribution of orders by hour of the day.*/
SELECT 
    HOUR(order_time) as 'Hour', COUNT(order_id) as 'Order_count'
FROM
    orders
GROUP BY HOUR(order_time);
-- 11	1231
-- 12	2520
-- 13	2455
-- 14	1472
-- 15	1468
-- 16	1920
-- 17	2336
-- 18	2399
-- 19	2009
-- 20	1642
-- 21	1198
-- 22	663
-- 23	28
-- 10	8
-- 9	1

/*8.Join relevant tables to find the category-wise distribution of pizzas.*/
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;
-- Chicken	6
-- Classic	8
-- Supreme	9
-- Veggie	9

/*9.Group the orders by date and calculate the average number of pizzas ordered per day.*/
SELECT 
    ROUND(AVG(Order_qty))
FROM
    (SELECT 
        o.order_date, ROUND(SUM(od.quantity)) AS 'Order_qty'
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS A;
-- 138

/*10.Determine the top 3 most ordered pizza types based on revenue.*/
SELECT 
    pt.name, SUM(p.price * od.quantity) AS 'Revenue'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.name
ORDER BY Revenue DESC
LIMIT 3;
-- The Thai Chicken Pizza	     43434.25
-- The Barbecue Chicken Pizza	 42768
-- The California Chicken Pizza	 41409.5		


/*11.Calculate the percentage contribution of each pizza type to total revenue.*/
SELECT 
    pt.category,
    ROUND((SUM(p.price * od.quantity) / (SELECT 
                    ROUND(SUM(p.price * od.quantity), 2)
                FROM
                    pizzas p
                        JOIN
                    order_details od ON p.pizza_id = od.pizza_id)) * 100,
            2) AS 'Percentage_Contribution'
FROM
    pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY Percentage_Contribution DESC;
-- Classic	26.91
-- Supreme	25.46
-- Chicken	23.96
-- Veggie	23.68


/*12.Analyze the cumulative revenue generated over time.*/
select order_date, sum(revenue) over (order by order_date) as 'cumulative_reveue'
from (
select o.order_date, sum(p.price*od.quantity) as 'revenue'
from
 pizzas p
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
        JOIN
    orders o ON od.order_id = o.order_id
    group by o.order_date
    ) as A
    ORDER BY 
    order_date;
   
   
/*13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.*/
With A as
(
select pt.category,pt.name, sum(p.price*od.quantity) as 'revenue', 
rank() over (partition by pt.category order by sum(p.price*od.quantity) desc) as 'rnk'
from  
pizza_types pt join pizzas p 
on pt.pizza_type_id=p.pizza_type_id
join 
order_details od 
on p.pizza_id=od.pizza_id
group by pt.name,pt.category
)
select category, name, round(revenue,2)
from A 
where rnk<=3
order by category, revenue desc;
-- Chicken	The Thai Chicken Pizza	          43434.25
-- Chicken	The Barbecue Chicken Pizza	      42768
-- Chicken	The California Chicken Pizza      41409.5
-- Classic	The Classic Deluxe Pizza	      38180.5
-- Classic	The Hawaiian Pizza           	  32273.25
-- Classic	The Pepperoni Pizza	              30161.75
-- Supreme	The Spicy Italian Pizza	          34831.25
-- Supreme	The Italian Supreme Pizza	      33476.75
-- Supreme	The Sicilian Pizza	              30940.5
-- Veggie	The Four Cheese Pizza	          32265.7
-- Veggie	The Mexicana Pizza	              26780.75
-- Veggie	The Five Cheese Pizza	          26066.5



    