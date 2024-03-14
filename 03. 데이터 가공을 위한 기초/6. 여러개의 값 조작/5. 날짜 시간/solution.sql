/* 시간 계산 */
select user_id,
	register_stamp::timestamp as register_stamp,
	register_stamp::timestamp + '1 hour'::interval as after_1_hour,
	register_stamp::timestamp - '30 minutes'::interval as before_30_minutes,

	register_stamp::date as register_date,
	(register_stamp::date + '1 day'::interval)::date as after_1_day,
	(register_stamp::date - '1 month'::interval)::date as before_1_month
from mst_users_with_dates;


/* 두 날짜의 차이 계산 */
-- PostgreSQL은 날짜 자료형끼리 뺄 수 있음
select user_id,
	CURRENT_DATE as today,
	register_stamp::date as register_date,
	CURRENT_DATE - register_stamp::date as diff_days
from mst_users_with_dates;


/* 생년월일로 나이 계산하기 */
select user_id,
	CURRENT_DATE as today,
	register_stamp::date as register_date,
	birth_date::date as birth_date,
	AGE(birth_date::date) as age,
	EXTRACT(YEAR FROM AGE(birth_date::date)) as current_age,
	EXTRACT(YEAR FROM AGE(register_stamp::date, birth_date::date)) as register_age
from mst_users_with_dates;

/* 나이를 문자열로 계산하기 */
select user_id,
	substring(register_stamp, 1, 10) as register_date,
	birth_date,
	floor(
		(
      CAST(replace(substring(register_stamp, 1, 10), '-', '') as integer)
		  - CAST(replace(birth_date, '-', '') as integer)
	  )
	  / 10000
	) as register_age
from mst_users_with_dates;