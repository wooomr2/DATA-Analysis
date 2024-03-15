-- 날짜별로 지표가 하나씩만 존재하는 경우 case 조건이 true가 되는 기록이 하나뿐이다.
-- 그 하나를 Max나 Min 함수로 추출하여 변환한다.
select dt
	,max(case when indicator = 'impressions' then val end) as impressions
	,max(case when indicator = 'sessions' then val end) as sessions
	,max(case when indicator = 'users' then val end) as users
from daily_kpi
group by dt
order by dt;


-- 행을 쉼표로 구분한 문자열로 집약하기
-- string_agg(column, '구분자')
select purchase_id
	,string_agg(product_id, ',') as product_ids
	,sum(price) as amount
from purchase_detail_log
group by purchase_id
order by purchase_id;


/* 
cross join 사용하기
행이나 열으로 전개할 데이터 수가 고정되었다면, 그러한 데이터 수와 같은 일련번호를 가진 피벗 테이블을 만들고
cross join 하면 된다.
 */
