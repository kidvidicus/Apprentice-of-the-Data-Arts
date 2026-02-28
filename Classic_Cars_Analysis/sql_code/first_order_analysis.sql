--Can I have a view showing customer sales and include a column which shows the difference
--in value from their previous sale? I want to see if new customers who make their first
--purchase are likely to spend more



with order_rank as (
select
  o.customernumber,
  od.ordernumber,
  sum(od.priceeach * od.quantityordered) as total_amount_ordered,
  o.orderdate,
  row_number() over (partition by o.customernumber order by o.orderdate asc) as order_rank
from orderdetails od
join orders o
on od.ordernumber = o.ordernumber
group by
  o.customernumber,
  od.ordernumber,
  o.orderdate
),
amountsequence as
(
select
  customernumber,
  ordernumber,
  orderdate,
  total_amount_ordered,
  lag(total_amount_ordered, 1) over (partition by customernumber order by orderdate asc) as prev_amount
from order_rank
)
select
  c.customername,
  a.ordernumber,
  a.orderdate,
  a.total_amount_ordered,
  a.prev_amount,
  (a.total_amount_ordered - a.prev_amount) as order_value_change
from
  amountsequence a
join customers c
on a.customernumber = c.customernumber
order by 
  c.customername asc,
  a.orderdate asc;
  
 
  








































