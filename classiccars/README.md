##  Overview
This project analyzes historical order data to answer questions pertaining to the classic_cars data set.

* What products are commonly purchased together, and which combinations are rare?
* What does overall sales performance look like for 2004, broken down by product and geography?
* How do customer credit limits relate to sales performance, and which orders contribute most to revenue?

The goal of this project is to demonstrate SQL querying, aggregation logic, and clear business-focused roeporting using Excel

---

## Product Pair Analysis

Product pairing was analyzed at the product line level to identify combinations frequently purchased together within the same order.

* Product line pairs
* Number of orders in which each pair appears
* Frequency classification (Frequently, Occasionally, Rarely)

This approach avoids inflated counts from multiple SKUs and focuses on true co-purchase behavior.

---

## 2004 Sales Analysis
Sales, product cost, and net profit were calculated for 2004 and summarized using pivot tables.

* Net profit by country
* Top 25 products by net profit

Raw data is retained in the first worksheet, with summarized views used for presentation.

---

## Sales & Credit Analysis
This analysis examines customer order data to understand sales performance relative to customer credit limits. The goal is to identify patterns such as whether higher-credit customers generate higher revenue, and which individual orders contribute most to overall sales.

* Total revenue broken down by country
* Sales summarized by credit limit group
* Customer-level sales compared to credit limits (% utilization)
* Top 10 highest-value orders with associated credit group
* Average Order Value (AOV) calculated to contextualize order behavior

Pivot tables and curated tables were used to summarize results, while charts provide visual insights for reporting.

---
## Tools and Techniques
* postgreSQL was used for data preparation and aggregation.
* Excel was used for pivot tables and presentation.
---

