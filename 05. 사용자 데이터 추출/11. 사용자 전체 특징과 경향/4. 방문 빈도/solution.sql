-- 특정 시점동안 며칠 동안 사용자가 서비스를 이용했는지(timestamp에서 date추출 후 비교 distinct 활용)
with
    action_log_with_dt as (
        select *, substring(stamp, 1, 10) as dt
        from action_log
    )
select user_id, count(distinct dt) as day_cnt
from action_log_with_dt
where
    dt between '2016-11-01' and '2016-11-07'
group by
    user_id;

-- 11-9 특정 기간동안의 사용일 수 별 유저수
with
    action_log_with_dt as (
        select *, substring(stamp, 1, 10) as dt
        from action_log
    ),
    action_day_count_per_user as (
        select user_id, count(distinct dt) as action_day_count
        from action_log_with_dt
        where
            dt between '2016-11-01' and '2016-11-07'
        group by
            user_id
    )
select action_day_count, count(distinct user_id) as user_count
from action_day_count_per_user
group by
    action_day_count
order by action_day_count;

-- 11-10 구성비와 구성비누계 계산
with
    action_log_with_dt as (
        select *, substring(stamp, 1, 10) as dt
        from action_log
    ),
    action_day_count_per_user as (
        select user_id, count(distinct dt) as action_day_count
        from action_log_with_dt
        where
            dt between '2016-11-01' and '2016-11-07'
        group by
            user_id
    )
select
    action_day_count,
    count(distinct user_id) as user_count,
    -- 구성비
    100.0 * count(distinct user_id) / sum(count(distinct user_id)) over () as composition_ratio,
    -- 구성비 누계
    100.0 * sum(count(distinct user_id)) over (
        order by action_day_count rows between unbounded preceding
            and current row
    ) / sum(count(distinct user_id)) over () as cululative_ratio
from action_day_count_per_user
group by
    action_day_count
order by action_day_count;