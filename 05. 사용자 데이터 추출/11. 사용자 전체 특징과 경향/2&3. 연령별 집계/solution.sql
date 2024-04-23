-- 11-5 사용자 생일, 나이 계산
with
    mst_users_with_int_birth as (
        select *, replace(
                substring(birth_date, 1, 10), '-', ''
            )::integer as int_birth_date
        from mst_users
    ),
    mst_users_with_age as (
        select *, floor(
                -- int 특정 날짜
                (20240101 - int_birth_date) / 10000
            ) as age
        from mst_users_with_int_birth
    )
select user_id, sex, birth_date, age
from mst_users_with_age;

-- 11-6 성별과 연령으로 연령벌 구분
with
    mst_users_with_int_birth as (
        select *, replace(
                substring(birth_date, 1, 10), '-', ''
            )::integer as int_birth_date
        from mst_users
    ),
    mst_users_with_age as (
        select *, floor(
                -- int 특정 날짜
                (20240101 - int_birth_date) / 10000
            ) as age
        from mst_users_with_int_birth
    ),
    mst_users_with_category as (
        select user_id, sex, age, concat(
                case
                    when 20 <= age then sex
                    else ''
                end, case
                    when age between 4 and 12  then 'C'
                    when age between 13 and 19  then 'T'
                    when age between 20 and 34  then '1'
                    when age between 35 and 49  then '2'
                    when age >= 50 then '3'
                end
            ) as category
        from mst_users_with_age
    )
select *
from mst_users_with_category;

-- 11-7 성별과 연령으로 연령벌 구분 후 그룹의 인원 수 파악
with
    mst_users_with_int_birth as (
        select *, replace(
                substring(birth_date, 1, 10), '-', ''
            )::integer as int_birth_date
        from mst_users
    ),
    mst_users_with_age as (
        select *, floor(
                -- int 특정 날짜
                (20240101 - int_birth_date) / 10000
            ) as age
        from mst_users_with_int_birth
    ),
    mst_users_with_category as (
        select user_id, sex, age, concat(
                case
                    when 20 <= age then sex
                    else ''
                end, case
                    when age between 4 and 12  then 'C'
                    when age between 13 and 19  then 'T'
                    when age between 20 and 34  then '1'
                    when age between 35 and 49  then '2'
                    when age >= 50 then '3'
                end
            ) as category
        from mst_users_with_age
    )
select category, count(*)
from mst_users_with_category
group by
    category;

-- 11-8 연령별 특징
with
    mst_users_with_int_birth as (
        select *, replace(
                substring(birth_date, 1, 10), '-', ''
            )::integer as int_birth_date
        from mst_users
    ),
    mst_users_with_age as (
        select *, floor(
                -- int 특정 날짜
                (20240101 - int_birth_date) / 10000
            ) as age
        from mst_users_with_int_birth
    ),
    mst_users_with_category as (
        select user_id, sex, age, concat(
                case
                    when 20 <= age then sex
                    else ''
                end, case
                    when age between 4 and 12  then 'C'
                    when age between 13 and 19  then 'T'
                    when age between 20 and 34  then '1'
                    when age between 35 and 49  then '2'
                    when age >= 50 then '3'
                end
            ) as category
        from mst_users_with_age
    )
select
    t1.category as product_category,
    t2.category as user_category,
    count(*) as purchase_count
from
    action_log as t1
    join mst_users_with_category as t2 on t1.user_id = t2.user_id
where
    action = 'purchase'
group by
    t1.category,
    t2.category
order by t1.category, t2.category;