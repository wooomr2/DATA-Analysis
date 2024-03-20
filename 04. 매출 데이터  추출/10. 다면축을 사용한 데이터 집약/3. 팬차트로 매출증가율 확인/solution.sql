with daily_category_amount as
(
select dt, category,
	substring(dt, 1,4) as year,	
	substring(dt, 6,2) as month,	
	substring(dt, 9,2) as date,
	sum(price) as amount
from purchase_detail_log
group by dt, category
),
monthly_category_amount as
(
	select
		concat(year, '-', month) as year_month,
		category,
		sum(amount) as amount
	from daily_category_amount
	group by year, month, category	
)
select year_month, category, amount
	,first_value(amount) over(partition by category
		order by year_month, category rows unbounded preceding) 
	as base_amount
	,100.0 * amount / 
		first_value(amount) over(partition by category
		order by year_month, category rows unbounded preceding)
	as rate
from monthly_category_amount
order by year_month, category
;