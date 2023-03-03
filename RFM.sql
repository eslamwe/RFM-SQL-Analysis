with Scores as 
(
    select customer_id, Recency, Frequency, Monetary, r_score,
            round((f_score + m_score) / 2) fm_score
    from (
            select customer_id, Recency, Frequency, Monetary,
                    ntile (5) over (order by Recency desc) r_score,
                    ntile (5) over (order by Frequency) f_score,
                    ntile (5) over (order by Monetary) m_score
            from (
                    select customer_id,
                            round(((select max(to_date(invoicedate, 'mm/dd/yyyy hh24:mi')) from tableretail) - max(to_date(invoicedate, 'mm/dd/yyyy hh24:mi'))))  Recency,
                            count(invoice) Frequency,
                            sum(price*quantity) Monetary
                    from tableretail
                    group by customer_id
            )
    )
    order by customer_id
)
select customer_id, Recency, Frequency, Monetary, r_score, fm_score,
        case when r_score =  5 and fm_score = 5 then 'Champions'
               when r_score =  5 and fm_score = 4 then 'Champions'
               when r_score =  4 and fm_score = 5 then 'Champions'
               when r_score =  5 and fm_score = 2 then 'Potential Loyalists'
               when r_score =  4 and fm_score = 2 then 'Potential Loyalists'
               when r_score =  3 and fm_score = 3 then 'Potential Loyalists'
               when r_score =  4 and fm_score = 3 then 'Potential Loyalists'
               when r_score =  5 and fm_score = 3 then 'Loyal Customers'
               when r_score =  4 and fm_score = 4 then 'Loyal Customers'
               when r_score =  3 and fm_score = 5 then 'Loyal Customers'
               when r_score =  3 and fm_score = 4 then 'Loyal Customers'
               when r_score =  5 and fm_score = 1 then 'Recent Customers'
               when r_score =  4 and fm_score = 1 then 'Promising'
               when r_score =  3 and fm_score = 1 then 'Promising'
               when r_score =  3 and fm_score = 2 then 'Customers Needing Attention'
               when r_score =  2 and fm_score = 3 then 'Customers Needing Attention'
               when r_score =  2 and fm_score = 2 then 'Customers Needing Attention'
               when r_score =  2 and fm_score = 5 then 'At Risk'
               when r_score =  2 and fm_score = 4 then 'At Risk'
               when r_score =  2 and fm_score = 1 then 'At Risk'
               when r_score =  1 and fm_score = 3 then 'At Risk'
               when r_score =  1 and fm_score = 5 then 'Cant Lose Them'
               when r_score =  1 and fm_score = 4 then 'Cant Lose Them'
               when r_score =  1 and fm_score = 2 then 'Hibernating'
               when r_score =  1 and fm_score = 1 then 'Lost'
        end as "customer_segment"  
from Scores;