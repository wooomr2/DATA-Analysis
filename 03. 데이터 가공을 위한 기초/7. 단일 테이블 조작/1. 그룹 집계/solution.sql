-- 테이블 전체 특징량
select 
	count(*) as total_count,
	count(distinct user_id) as user_count,
	count(distinct product_id) as product_count,
	sum(score) as sum,
	avg(score) as avg,
	max(score) as max,
	min(score) as min
from review;

-- 그룹핑한 데이터 특징량
select 
  user_id,
	count(*) as total_count,
	count(distinct user_id) as user_count,
	count(distinct product_id) as product_count,
	sum(score) as sum,
	avg(score) as avg,
	max(score) as max,
	min(score) as min
from review
group by user_id;

-- Window Function 활용 집약 전 값과 집계 값을 동시에 다루기
select 
  user_id, product_id, score,
  avg(score) over() as avg_score,
  avg(score) over(partition by user_id) as user_avg_score,
  score - avg(score) over(partition by user_id) as user_avg_score_diff
from review;