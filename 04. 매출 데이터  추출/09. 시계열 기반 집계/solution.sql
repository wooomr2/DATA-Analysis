-- 9-1. 날짜별 매출과 평균 구매액
select dt,
  count(*) as purchase_count,
  sum(purchase_amount) as total_amount,
  avg(purchase_amount) as avg_amount
from purchase_log
group by dt
order by dt;


-- 9-2. 이동평균을 사용한 날짜별 추이 보기
select dt,
	sum(purchase_amount) as total_amount,
	-- 최대 7일까지의 이동평균 계산
	avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row) as seven_day_avg,

	-- 7일 간의 데이터가 존재할 시 이동평균계산하기
	case when 7 = count(*) over(order by dt rows between 6 preceding and current row)
		 then avg(sum(purchase_amount)) over(order by dt rows between 6 preceding and current row)
		 end as seven_day_avg_strict
from purchase_log
group by dt
order by dt


-- 9-3. 월 매출 누계 구하기
select dt,
	-- 연-월 추출
	substring(dt,1,7) as year_month,
	sum(purchase_amount) as total_amount,
	-- 월 누계 매출
	sum(sum(purchase_amount)) over(partition by substring(dt,1,7) order by dt)
from purchase_log
group by dt
order by dt


-- 9-4. 날짜별 매출을 일시 테이블로
with daily_purchase as 
(
  select dt,
    substring(dt,1,4) as year,
    substring(dt,6,2) as month,
    substring(dt,9,2) as date,
    sum(purchase_amount) as purchase_amount,
    count(order_id) as orders
  from purchase_log
  group by dt
)
select *
from daily_purchase
order by dt;


--9-5. daily_purchase 테이블에 대해 월 누계 매출을 집계하는 쿼리
-- 데이터 분석의 경우 성능보다 가독성과 재사용성이 우선이다!
with daily_purchase as
(
  select dt,
  substring(dt,1,4) as year,
  substring(dt,6,2) as month,
  substring(dt,9,2) as date,
  sum(purchase_amount) as purchase_amount,
  count(order_id) as orders
  from purchase_log
  group by dt
)
select *, 
	concat(year, '-', month) as year_month,
	sum(purchase_amount) over(partition by year,month order by date)
from daily_purchase
order by dt;