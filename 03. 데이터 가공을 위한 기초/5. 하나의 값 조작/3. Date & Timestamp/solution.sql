-- 날짜, 타임스탬프  
-- current_timestamp: 타임존 적용, local_timestamp: 타임존 적용 x
SELECT current_date AS dt, current_timestamp AS stamp, localtimestamp as local_stamp ;

-- 타입 캐스팅 방법
SELECT CAST('2023-01-30' AS DATE) AS dt, CAST('2023-01-30 12:00:00' AS TIMESTAMP) AS stamp;

SELECT DATE '2023-01-30' AS dt, TIMESTAMP '2023-01-30' AS stamp;

SELECT '2024-01-01'::DATE as dt, '2024-01-01 12:00:00'::TIMESTAMP AS stamp;

-- 날짜에서 특정 필드 추출하기
SELECT
  stamp,
  extract(YEAR FROM stamp) as year,
  extract(MONTH FROM stamp) as month,
  extract(DAY FROM stamp) as day,
  extract(HOUR FROM stamp) as hour,
FROM (
SELECT CAST('2023-01-30 12:00:00' AS TIMESTAMP) as stamp
) AS t;

-- 문자로 캐스팅 후 날짜 추출하기
SELECT
 stamp,
  substring(stamp, 1, 4) as year,
  substring(stamp, 6, 2) as month,
  substring(stamp, 9, 2) as day,
  substring(stamp, 12, 2) as hour,
  substring(stamp, 1, 7) as year_month
FROM (
  SELECT '2023-01-30 12:00:00'::text as stamp 
) as t1