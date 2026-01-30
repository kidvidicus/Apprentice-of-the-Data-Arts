--Hi there,
--Can you give me a breakdown of what products are commonly purchased together,
--and any products that are rarely purchased together?

--By Order Count
with order_products as (
select distinct
  od.ordernumber,
  p.productline
from orderdetails od
join products p on
  od.productcode = p.productcode
)
select
  op1.productline as product_a,
  op2.productline as product_b,
  count(distinct op1.ordernumber) as ordered_together_count
from order_products op1
join order_products op2 on
  op1.ordernumber = op2.ordernumber
  and op1.productline < op2.productline
group by
  product_a,
  product_b
order by
  ordered_together_count desc;