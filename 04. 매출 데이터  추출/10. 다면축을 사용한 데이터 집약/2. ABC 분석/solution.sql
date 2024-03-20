
with monthly_sales as
(
	select category, sum(price) as amount
	from purchase_detail_log
	--  특정 시점 동안의 로그만 분석
	where dt between '2017-01-01' and '2017-01-31'
	group by category
),
sales_composition_ratio as
(
	select category, amount,
	-- 구성비:: 100.0 * 항목별매출/전체매출
	100.0 * amount / sum(amount) over() as composition_ratio,
	-- 구성비누계:: 100.0 * 항목별누계매출/전체매출
	100.0 * sum(amount) over(order by amount desc
		rows between unbounded preceding and current row)
		/ sum(amount) over() 
		as cumulative_ratio
	from monthly_sales	
)
select *,
	case when cumulative_ratio between 0 and 70 then 'A'
	     when cumulative_ratio between 70 and 90 then 'B'
		   when cumulative_ratio between 90 and 100 then 'C'
	end as abc_rank 
from sales_composition_ratio
order by amount desc
;