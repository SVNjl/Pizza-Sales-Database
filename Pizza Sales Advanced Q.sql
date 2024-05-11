-- ADVANCED
-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category,round(sum(order_details.quantity*pizzas.price) /(select round(sum(order_details.quantity*pizzas.price),2) total_sales 
from order_details
join pizzas on pizzas.pizza_id=order_details.pizza_id)*100,2) revenue from pizza_types
join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category
order by revenue desc;

-- Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) cumulative_revenue
from (select orders.order_date,sum(order_details.quantity*pizzas.price) revenue from order_details
join pizzas on order_details.pizza_id=pizzas.pizza_id
join orders on orders.order_id=order_details.order_id
group by orders.order_date) sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue from 
(select category,name,revenue,
rank() over(partition by category order by revenue desc) rn
from 
(select pizza_types.category,pizza_types.name,sum((order_details.quantity)*pizzas.price) revenue from pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) a) b
where rn<=3;