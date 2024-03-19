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

-- 9-6. 월별 매출의 작년 대비 비율 구하기
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
select month,
  sum(case year when '2014' then purchase_amount end) as amount_2014,
  sum(case year when '2015' then purchase_amount end) as amount_2015,
  100.0 * sum(case year when '2015' then purchase_amount end) / sum(case year when '2014' then purchase_amount end) as rate
from daily_purchase
group by month
order by month;


/*
  Z-차트(월차매출, 매출누계, 이동년계):: 계절 변동의 영향을 배제하고 트랜드를 분석하는 방법.
  - 월차매출: 매출합계를 월별로 집계
  - 매출누계: 해당월 매출 + 이전월까지의 매출누계를 합한 값
  - 이동년계: 해당월 매출 + 과거11개월의 매출을 합한 갓

  월 단위 집계 데이터가 필요하므로
  구매로그 => 월매출집계 => 각 월매출에 대해 누계매출과 이동년계 계산
*/
with daily_purchase as
(
  select dt,
    substring(dt, 1, 4) as year,
    substring(dt, 6, 2) as month,
    substring(dt, 9, 2) as date,
    sum(purchase_amount) as purchase_amount,
    count(order_id) as orders
  from purchase_log
  group by dt
  order by dt
),
monthly_amount as
(
	select year, month, sum(purchase_amount) as amount
	from daily_purchase
	group by year, month
),
calc_index as
(
	select *,
	-- 2015년 누계 매출
	sum(case when year = '2015' then amount end) 
		over(order by year, month rows unbounded preceding)
		as agg_amount,
	-- 당월부터 11개월 이전까지의 매출 합계(이동년계) 집계
	sum(amount) 
		over(order by year, month rows between 11 preceding and current row)
		as year_avg_amount
	from monthly_amount
	order by year, month
)
-- 2015년의 데이터만 압축하기
select 
	concat(year, '-', month) as year_month,
	amount, agg_amount, year_avg_amount
from calc_index
where year = '2015'
order by year_month;



-- 9-8. 매출과 관련된 다양한 지표를 집계하는 쿼리
with daily_purchase as
(
  select dt,
    substring(dt, 1, 4) as year,
    substring(dt, 6, 2) as month,
    substring(dt, 9, 2) as date,
    sum(purchase_amount) as purchase_amount,
    count(order_id) as orders
  from purchase_log
  group by dt
  order by dt
),
monthly_purchase as
(
	select year, month, 
		sum(orders) as orders,
		sum(purchase_amount) as monthly,
		avg(purchase_amount) as avg_amount
	from daily_purchase
	group by year, month
)
select 
	concat(year, '-', month) as year_month,
	orders,
	avg_amount,
	monthly,
	sum(monthly) over(partition by year order by month rows unbounded preceding)
		as agg_amount,
	-- 작년 동월 매출
	lag(monthly, 12) over(order by year, month rows between 12 preceding and 12 preceding)
		as last_year_monthly,
	-- 작년 비
	100.0 * monthly / lag(monthly, 12) over(order by year, month rows between 12 preceding and 12 preceding)
		as rate
from monthly_purchase
order by year_month;