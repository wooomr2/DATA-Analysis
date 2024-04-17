-- 11-1
with
    state as (
        -- 로그 전체의 Unique_User 수 구하기
        select count(distinct session) as total_uu
        from action_log
    )
select
    l.action,
    s.total_uu,
    count(distinct l.session) as action_uu,
    count(*) as action_count,
    -- 사용률: 액션uu / 전체uu
    100.0 * count(distinct l.session) / s.total_uu as usage_rate,
    -- 1인당 액션 수
    1.0 * count(*) / count(distinct l.session) as action_per_user
from action_log as l
    cross join state as s
group by
    l.action,
    s.total_uu;

-- 11-2 로그인 유저와 비로그인 사용자를 구분하기
with
    action_log_with_status as (
        select
            session, user_id, action, case
                when coalesce(user_id, '') <> '' then 'login'
                else 'guest'
            end as login_status
        from action_log
    )
select *
from action_log_with_status;

-- 11-3 로그인 유저와 비로그인 사용자를 구분하여 집게
with
    action_log_with_status as (
        select
            session, user_id, action, case
                when coalesce(user_id, '') <> '' then 'login'
                else 'guest'
            end as login_status
        from action_log
    )
select
    coalesce(action, 'all') as action,
    coalesce(login_status, 'all') as login_status,
    count(distinct session) as action_uu,
    count(*) as action_count
from action_log_with_status
group by
    rollup (action, login_status);

-- 11-4 회원과 비회원을 구분(이전에 한번이라도 로그인 했다면 회원으로 계산)
with
    action_log_with_status as (
        select
            session, user_id, action,
            -- 로그를 타임스탬프 순으로 정렬 후,
            -- userId가 있는 경우 최초 로그인 이후 모든 status를 member로 표시
            case
                when COALESCE(
                    max(user_id) over (
                        partition by
                            session
                        order by stamp rows between unbounded preceding
                            and current row
                    ), ''
                ) <> '' then 'member'
                else 'none'
            end as member_status
        from action_log
    )
SELECT
    COALESCE(action, 'all') as action,
    COALESCE(member_status, 'all') as member_status,
    count(distinct session) as action_uu,
    count(*) as action_count
FROM action_log_with_status
GROUP BY
    ROLLUP (action, member_status);