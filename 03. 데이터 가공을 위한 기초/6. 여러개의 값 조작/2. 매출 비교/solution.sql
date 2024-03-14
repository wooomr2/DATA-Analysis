-- 분기별 매출 증감 판정하기
select year, q1, q2,
	case when q1<q2 then '+'
		   when q1>q2 then '-'
		   else ' ' end as judge_q1_q2,
	q2-q1 as diff_q2_q1,
  -- SIGN 1 0 -1
	sign(q2-q1) as sign_q2_q1
from quarterly_sales
order by year;


-- 연간 최대/최소 4분기 매출 찾기
select year, 
	greatest(q1,q2,q3,q4) as greatest_sales,
	least(q1,q2,q3,q4) as least_sales
FROM quarterly_sales
ORDER BY year;


-- 연간 4분기 평균 매출 계산(NULL 고려를 항상 할 것!!)
select year, 
  (coalesce(q1,0)+coalesce(q2,0)+coalesce(q3,0)+coalesce(q4,0)) /4 as average
from quarterly_sales
order by year;

-- null이 제외한 칼럼의 평균을 구하는 법
select year,
  (coalesce(q1,0)+ coalesce(q2,0)+coalesce(q3,0)+coalesce(q4,0)) / (sign(coalesce(q1,0))+sign(coalesce(q2,0))+sign(coalesce(q3,0))+sign(coalesce(q4,0))) as average
from quarterly_sales
order by year;