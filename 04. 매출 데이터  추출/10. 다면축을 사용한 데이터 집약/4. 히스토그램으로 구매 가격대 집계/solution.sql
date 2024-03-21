-- 10-5. 최대값, 최소값, 범위
with stats as 
(
  select
    max(price) as max_price,
    min(price) as min_price,
    max(price) - min(price) as range_price,
    10 as bucket_num 
  from purchase_detail_log
)
select * from stats

-- 범위를 계층으로 분할하려면, 
-- 정규화금액:: diff = (매출-최소값)
-- 첫번 째 계층의 범위 = 금액범위(range_price) / 계급수(bucket_num)
-- 계급:: bucket = floor(diff / 계층의 범위) 
-- 계급판정로직에 (하한이상~상한미만)을 사용했기 때문에,
-- 최대값이 최대계급수(10)을 넘어가게 된다.
-- 계급 상한을 금액최대값+1로 설정해, 모든 레코드가 금액상한 미만이 되게만들어준다.

-- 10-6 & 7. 데이터 계층 구하기
with stats as 
(
  select
    max(price)+1 as max_price,
    min(price) as min_price,
    max(price)+1 - min(price) as range_price,
    10 as bucket_num 
  from purchase_detail_log
),
purchase_log_with_bucket as
(
  select 
    price, min_price,
    -- 정규화 금액
    price - min_price as diff,
    -- 계층 범위
    1.0 * range_price / bucket_num as bucket_range,
    -- 계층 판정
    floor(1.0*(price-min_price) / (1.0*range_price/bucket_num)) + 1 as bucket

    -- 계층판정(2) 함수:: with_bucket
    -- with_bucket(price, min_price, range_price, bucket_num) as bucket
    from purchase_detail_log, stats
)
select *
from purchase_log_with_bucket
order by price
;


-- 10-8. 히스토그램 구하기
-- 10-6 & 7. 데이터 계층 구하기
with stats as 
(
  select
    max(price)+1 as max_price,
    min(price) as min_price,
    max(price)+1 - min(price) as range_price,
    10 as bucket_num 
  from purchase_detail_log
),
purchase_log_with_bucket as
(
  select 
    price, min_price,
    -- 정규화 금액
    price - min_price as diff,
    -- 계층 범위
    1.0 * range_price / bucket_num as bucket_range,
    -- 계층 판정
    floor(1.0*(price-min_price) / (1.0*range_price/bucket_num)) + 1 as bucket

    -- 계층판정(2) 함수:: with_bucket
    -- with_bucket(price, min_price, range_price, bucket_num) as bucket
    from purchase_detail_log, stats
)
select
  bucket,
  min_price + bucket_range * (bucket-1) as lower_limit,
  min_price + bucket_range * (bucket) as upper_limit,
  count(price) as num_purchase,
  sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket
;


-- 10-9. 임의의 계층 너비로 히스토그램 작성하기
-- 상한-하한으로 최적 버무이를 구할 수도 있지만, 소수점으로 구분된 리포트는 가독성이 좋지 않음.
-- 고정값 기반으로 임의의 게층 너비로 변경할 수 있는 히스토그램을 만들어야함
-- 10-9 최종 히스토그램 쿼리
with stats as 
(
  select
    50000 as max_price,
    0 as min_price,
    50000 - 0 as range_price,
    10 as bucket_num 
  from purchase_detail_log
),
purchase_log_with_bucket as
(
  select 
    price, min_price,
    -- 정규화 금액
    price - min_price as diff,
    -- 계층 범위
    1.0 * range_price / bucket_num as bucket_range,
    -- 계층 판정
    floor(1.0*(price-min_price) / (1.0*range_price/bucket_num)) + 1 as bucket

    -- 계층판정(2) 함수:: with_bucket
    -- with_bucket(price, min_price, range_price, bucket_num) as bucket
    from purchase_detail_log, stats
)
select
  bucket,
  min_price + bucket_range * (bucket-1) as lower_limit,
  min_price + bucket_range * (bucket) as upper_limit,
  count(price) as num_purchase,
  sum(price) as total_amount
from purchase_log_with_bucket
group by bucket, min_price, bucket_range
order by bucket
;
