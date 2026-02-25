--Can you show me a breakdown of sales, but also show their credit limit?
--Maybe group the credit limits as I want a high level view to see if we get
--higher sales for customers who have a higher credit limit which we could expect.

select --total orders by country and customer
  c.customernumber,
  c.customername,
  c.contactlastname ||' '||c.contactfirstname as contactname,
  c.country,
  count(o.ordernumber) as total_orders
from customers c
left join orders o
on c.customernumber = o.customernumber
group by c.customernumber
order by total_orders desc;

--order number and customer info with revenue
with customerorder_info as (
  select
    o.ordernumber,
    o.customernumber,
    c.customername,
    c.contactfirstname ||' '||c.contactlastname as contactname,
    c.country,
    c.creditlimit
  from orders o
  join customers c
  on o.customernumber = c.customernumber
)
select -- amount per ordernumber
  ci.ordernumber,
  ci.customername,
  ci.contactname,
  ci.country,
  count(d.productcode) as total_items,
  sum(d.quantityordered * d.priceeach) as total_spent
from customerorder_info ci
join orderdetails d
on ci.ordernumber = d.ordernumber
group by
  ci.ordernumber,
  ci.customername,
  ci.contactname,
  ci.country
order by total_spent desc;

--Total sales to credit limit comparison by customer
with customerorder_info as (
  select
    o.ordernumber,
    o.customernumber,
    c.customername,
    c.country,
    c.creditlimit
  from orders o
  join customers c
  on o.customernumber = c.customernumber
),
revenuecredit as (
select -- amount per ordernumber
  ci.ordernumber,
  ci.customername,
  ci.country,
  ci.creditlimit,
  count(d.productcode) as total_items,
  sum(d.quantityordered * d.priceeach) as total_spent
from customerorder_info ci
join orderdetails d
on ci.ordernumber = d.ordernumber
group by
  ci.ordernumber,
  ci.customername,
  ci.country,
  ci.creditlimit
)
select
  customername,
  country,
  sum(total_spent) as total_revenue,
  creditlimit,
  case
  	when creditlimit > 125000 then 'greater than 125k'
  	when creditlimit > 100000 then '100k - 125k'
  	when creditlimit > 75000 then '75k - 100k'
  	when creditlimit > 50000 then '50k - 75k'
  	else 'less then 50k'
  end as credit_group
from revenuecredit
group by customername,country, creditlimit
order by creditlimit desc;
  