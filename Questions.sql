-- Questions answered in this project

-- 1) Total sales per month
select distinct to_char(to_date(invoicedate, 'mm/dd/yyyy hh24:mi'), 'Month') "Month", sum(quantity*price) over (partition by to_char(to_date(invoicedate, 'mm/dd/yyyy hh24:mi'), 'mm')) "Total sales"
from tableretail
order by "Total sales" desc;

-- 2) Purchases count per month
select distinct to_char(to_date(invoicedate, 'mm/dd/yyyy hh24:mi'), 'Month') "Month", count(distinct invoice) over (partition by to_char(to_date(invoicedate, 'mm/dd/yyyy hh24:mi'), 'mm')) "Purchases count"
from tableretail
order by "Purchases count" desc;

-- 3) Number of purchases for each customer
select distinct customer_id, count(distinct invoicedate) over (partition by customer_id) "Number of purchases"
from tableretail
order by "Number of purchases" desc;

-- 4) Sales for each customer
select distinct customer_id, sum(price*quantity) over (partition by customer_id) "Sales"
from tableretail
order by "Sales" desc;

-- 5) Number of customers and total sales in each country
select distinct country, count(distinct customer_id) over (partition by country) "Customers count",
         round(sum(quantity*price) over (partition by country)) "Total sales"
from tableretail;
