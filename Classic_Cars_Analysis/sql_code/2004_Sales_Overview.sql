--Hi there
--Can you give me an overview of sales for 2004?
--I would like to see a breakdown by product, country, and city and please include the sales value, cost of sales and net profit.


with product_details as (
select
  od.ordernumber,
  p.productcode,
  p.productname,
  p.buyprice,
  p.msrp,
  od.quantityordered,
  od.priceeach
from products p
left join orderdetails od
  on p.productcode = od.productcode
),
customer_details as (
select
  o.ordernumber,
  extract(year from o.orderdate) as order_year,
  c.country,
  c.city
from orders o
left join customers c
  on o.customernumber = c.customernumber
where extract(year from o.orderdate) = 2004
)
select
  cd.order_year,
  pd.productcode,
  pd.productname,
  cd.country,
  cd.city,
  sum(pd.priceeach * quantityordered) as sales_value,
  sum(pd.buyprice * quantityordered) as cost_of_sales,
  sum((pd.quantityordered * pd.priceeach) - (pd.quantityordered * pd.buyprice)) as net_profit
from customer_details cd
join product_details pd
  on cd.ordernumber = pd.ordernumber
group by
  cd.order_year,
  pd.productcode,
  pd.productname,
  cd.country,
  cd.city
order by net_profit desc;
  