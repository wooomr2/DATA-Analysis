-- 카테고리의 소계와 총계를 한번에 출력하려면 계층별로 집계한 결과를 같은 컬럼이 되게 변환한 뒤
-- unioin all로 하나의 테이블로 구성
with sub_category_amount as 
(
	select category, sub_category, sum(price) as amount
	from purchase_detail_log
	group by category, sub_category
),
category_amount as
(
	select category, 'all' as sub_category, sum(price) as amount
	from purchase_detail_log
	group by category
),
total_amount as
(
	select 
		'all' as category,
		'all' as sub_category,
		sum(price) as amount
	from purchase_detail_log
)
select * from sub_category_amount
	union all
select * from category_amount
	union all
select * from total_amount
;


-- union all보다는 ROLLUP을 쓰는 것이 성능상 우위
select 
  coalesce(category, 'all') as category,
  coalesce(sub_category 'all') as sub_category,
  sum(price) as amount
from purchase_detail_log
group by rollup(category, sub_category)
;