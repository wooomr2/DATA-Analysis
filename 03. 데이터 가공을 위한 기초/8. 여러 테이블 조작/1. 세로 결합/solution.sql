/*
 세로결합 => union all
 비슷한 구조를 가지는 테이블의 데이터를 일괄 처리하고 싶은 경우
 UNION ALL을 활용, 테이블을 새로로 결합하는 것이 좋다.
 컬럼이 완전 일치해야 하므로 한쪽 테이블에만 존재하는 칼럼이 잇는 경우
 SELECT 구문으로 제외하거나, DEFAULT칼럼을 채워준다.
*/

select 'app1' as app_name, user_id, name, email from app1_mst_users
union all
select 'app2' as app_name ,user_id, name, null as email from app2_mst_users
;