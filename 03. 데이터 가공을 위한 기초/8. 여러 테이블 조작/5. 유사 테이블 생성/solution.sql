-- 1. select 구문으로 유사 테이블 만들기
with mst_devices as
(
			      select 1 as device_id, 'PC' as device_name
	union all select 2 as device_id, 'SP' as device_name
	union all select 3 as device_id, 'APP' as device_name
)
select *
from mst_devices;


-- 2. values 구문으로 유사 테이블 만들기
with mst_devices(device_id, device_name) as 
(
  values 
    (1, 'PC'),
    (2, 'SP'),
    (3, 'APP')
)
select *
from mst_devices;


-- 3. 순번을 활용해서 유사 테이블 생성
-- generate_series(start, end)
with series as
(
  select generate_series(1,5) as idx
)
select *
from series;

