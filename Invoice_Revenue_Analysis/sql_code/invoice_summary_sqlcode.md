-- Paid invoice count by project ID
```
select
  project_id,
  count(*) as paid_invoice_count
from invoices
where status in ('Paid', 'Partially Paid')
group by project_id
order by project_id;
```

-- Project ID payment status contributing to revenue
```
select
  project_id,
  count(case when status = 'Paid' then 1 end) as paid_invoice_count,
  count(case when status = 'Partially Paid' then 1 end) as partially_paid_invoice_count,
  sum(
    case
    	when status in ('Paid', 'Partially Paid')
   		then total_amount - discount_amount + tax_amount
   		else 0
   	end
  ) as total_revenue
from invoices
group by invoices.project_id
order by project_id;

with revenue_data as (
  select
    project_id,
    sum(
      case
      	when status in ('Paid', 'Partially Paid')
      	then total_amount - discount_amount + tax_amount
      	else 0
      end
    ) as total_revenue
   from invoices
   group by invoices.project_id
)
select
  project_id,
  total_revenue,
  round(
    (100.0 * total_revenue / sum(total_revenue) over ())::numeric,
    2
  ) as pct_of_total_revenue
from revenue_data
order by total_revenue desc;
```

-- Invoice Status summary by project ID
```
with status_summary as (
  select 
    project_id,
    status,
    count(*) as invoice_count,
    sum(total_amount - discount_amount + tax_amount) as gross_revenue
  from invoices
  group by project_id, status
)
select
  project_id,
  status,
  invoice_count,
  gross_revenue,
  round(
    (100.0 * gross_revenue / sum(gross_revenue) over (partition by project_id))::numeric,
    2
  ) as pct_of_project_revenue
from status_summary
order by project_id, status;
```


-- Adding column for collected revenue with only 'Paid' and 'Partially Paid' calculated.
```
with status_summary as (
  select 
    project_id,
    status,
    count(*) as invoice_count,
    sum(total_amount - discount_amount + tax_amount) as gross_revenue
  from invoices
  group by project_id, status
)
select
  project_id,
  status,
  invoice_count,
  gross_revenue,
  case
  	when status in ('Paid', 'Partially Paid') then gross_revenue
  	else 0
  end as collected_revenue,
  round(
    (100.0 * gross_revenue / sum(gross_revenue) over (partition by project_id))::numeric,
    2
  ) as pct_of_project_gross
from status_summary
order by project_id, status;
```  

-- Poject-Level revenue summary
```
with project_summary as (
  select
    project_id,
    sum(total_amount - discount_amount + tax_amount) as gross_revenue,
    sum(
      case
      	when status in ('Paid', 'Partially Paid')
      	then total_amount - discount_amount + tax_amount
      	else 0
      end
  ) as collected_revenue,
  sum(
    case
	    when status not in ('Paid', 'Partially Paid')
	    then total_amount - discount_amount + tax_amount
	    else 0
	end
   ) as uncollected_revenue,
   count (*) as total_invoices,
   count (case when status in ('Paid', 'Partially Paid') then 1 end) as collected_invoices,
   count (case when status not in ('Paid', 'Partially Paid') then 1 end) as uncollected_invoices
  from invoices
  group by project_id
)
select
  project_id,
  total_invoices,
  collected_invoices,
  uncollected_invoices,
  round (gross_revenue::numeric,2) as gross_revenue,
  round (collected_revenue::numeric,2) as collected_revenue,
  round (uncollected_revenue::numeric,2) as uncollected_revenue,
  case
  	when gross_revenue > 0
  	then round((collected_revenue / gross_revenue * 100)::numeric, 2)
  	else 0
  end as pct_collected,
  case
	  when gross_revenue > 0
	  then round ((uncollected_revenue / gross_revenue * 100)::numeric, 2)
	  else 0
  end as pct_uncollected
from project_summary
order by project_id;
```  
