-- CTR(Click Through Rate): 클릭/노출수

/* 정수형 자료형의 데이터 나누기 */
select dt, ad_id,
  -- PostgreSQL의 경우 정수를 나누면 정수반환하므로 명시적으로 자료형 변환해야함. 
	CAST(clicks as real) / impressions as ctr,
  -- 실수를 상수 앞에 두면 자료형 변환이 일어남
	100.0 * clicks / impressions as ctr_percent
from advertising_stats
where dt = '2017-04-01'
order by dt, ad_id;


/* 0으로 나누는 것 피하기: NULLIF */
select dt, ad_id,
	100.0 * clicks / NULLIF(impressions,0) as ctr_percent
from advertising_stats
order by dt, ad_id;
