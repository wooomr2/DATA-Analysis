-- over() 구문에 매개별수를 지정하지 않으면 전체 테이블에서 집약 함수를 적용.
-- over(partition by 칼럼명): 해당 컬럼을 기준으로 그룹화하고 집약함수를 적용. 


-- 윈도우 프레임 지정
-- DEFAULT FRAME:: order by가 없으면 => 모든행, order by가 있는경우 => 첫행~현재행 
-- 기본 문법: ROWS BETWEEN start AND end
-- start, end:  CURRENT_ROW(현재 행)
--              / n PRECEDING(n 행 앞) / n FOLLOWING(n 행 뒤) /
--              / unbounded preceding(이전 행 전부) / unbounded following(이후 행 전부)


-- array로 집약하기: array_agg


select product_id, score,
  row_number() over(order by score desc) as row,
  
  -- 같은 순위를 허용함 
  rank() over(order by score desc) as rank,
  
  -- 동일 순위 허용 x 
  dense_rank() over(order by score desc) as dense_rank,

  -- 현재 행의 앞의 행 값 추출
  lag(product_id) over(order by score desc) as lag1,
  lag(product_id, 2) over(order by score desc) as lag2,
	
  -- 현재 행보다 뒤에 있는 행의 값 추출
  lead(product_id) over(order by score desc) as lead1,
  lead(product_id, 2) over(order by score desc) as lead2
	
from popular_products
order by row;


-- over(order by) 활용
select product_id score,
	-- 점수 순서로 순위
	row_number() over(order by score desc) as row,

	-- 순위 상위부터 누계 점수 계산
	sum(score) over(order by score desc 
		rows between unbounded preceding and current row)
		as cum_score,

	-- 현재 행과 앞뒤의 행이 가진 값을 기반으로 평균 점수 계산
	avg(score) over(order by score desc
		rows between 1 preceding and 1 following
	) as local_avg,

	-- 순위가 높은 상품 id 추출하기
	first_value(product_id) over(order by score desc
		rows between unbounded preceding and unbounded following
	) as first_value,

	-- 순위가 낮은 상품 id 추출하기
	last_value(product_id) over(order by score desc 
		rows between unbounded preceding and unbounded following
	) as last_value
from popular_products
order by row;


-- 윈도 프레임 지졍 별 상품 id를 집약하는 방법
select product_id,
	-- 점수 순서로 순위 매기기
  	row_number() over(order by score desc) as row,

	-- 가장 앞 순위부터 가장 뒷 순위 까지 범위를 대상으로 상품 id array로 만들기
	array_agg(product_id) over(order by score desc 
		rows between unbounded preceding and unbounded following) as whole_agg,

	-- 가장 앞 순위부터 현재 순위까지의 범위를 대상으로 상품 id 집약하기
	array_agg(product_id) over(order by score desc
		rows between unbounded preceding and current row) as cum_agg

	-- 앞뒤 하나 범위를 대상으로 상품 id 집약하기
	array_agg(product_id) over(order by score desc
		rows between 1 preceding and 1 following) as local_agg

from popular_products
where category = 'action'
order by row;


-- partition by 활용하기
select category, product_id, score,
	row_number() over(partition by category order by score desc) as rn,
	rank() over(partition by category order by score desc) as rank,
	dense_rank() over(partition by category order by score desc) as dense_rank
from popular_products
order by category, rn;


-- 각 카테고리의 상위 n 개 추출하기
select *
from
	(select category, product_id, score,
		row_number() over(partition by category order by score desc) as rn
	   from popular_products
	) as t
where rn <= 2
order by category, rn;


-- 각 카테고리별 최상위 상품을 추출하는 경우 subquery없이 데이터 추출 가능
-- distinct 구문을 사용해 중복제거
-- 카테고리별로 최사위 순위 상품의 id를 추출하기
select 
  distinct category,
  first_value(product_id) over
    (partition by category
         order by score 
         rows between unbounded preceding and unbounded following
    ) as product_id
from popular_products;