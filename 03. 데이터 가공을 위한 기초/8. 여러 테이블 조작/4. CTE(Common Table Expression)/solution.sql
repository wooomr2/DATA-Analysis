with cte as
(
	select *, row_number() over(partition by category_name order by sales desc) as rank
	from product_sales
)
select *
from cte


-- 
with cte as
(
	select *, row_number() over(partition by category_name order by sales desc) as rank
	from product_sales
),
mst_rank as
(
  select distinct rank
  from cte
)
select *
from mst_rank


-- 카테고리들의 순위를 횡단적으로 출력하는 쿼리
with cte as
(
	select *, row_number() over(partition by category_name order by sales desc) as rank
	from product_sales
),
mst_rank as
(
  select distinct rank
  from cte
)
select m.rank, 
	r1.product_id as dvd, r1.sales as dvd_sales,
	r2.product_id as cd, r2.sales as cd_sales,
	r3.product_id as book, r3.sales as book_sales
from mst_rank as m
left join cte as r1 
on m.rank = r1.rank and r1.category_name = 'dvd'
left join cte as r2
on m.rank = r2.rank and r2.category_name = 'cd'
left join cte as r3
on m.rank = r3.rank and r3.category_name = 'book'
order by m.rank;