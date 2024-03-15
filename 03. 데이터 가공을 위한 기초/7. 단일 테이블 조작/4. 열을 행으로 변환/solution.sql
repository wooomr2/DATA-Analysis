/* 
cross join 사용하기
행이나 열으로 전개할 데이터 수가 고정되었다면, 그러한 데이터 수와 같은 일련번호를 가진 피벗 테이블을 만들고
cross join 하면 된다.
 */

select q.year,
	case 
    when p.idx = 1 then 'q1'
    when p.idx = 2 then 'q2'
    when p.idx = 3 then 'q3'
    when p.idx = 4 then 'q4'
    end as quarter,
	case when p.idx = 1 then q.q1
    when p.idx = 2 then q.q2
    when p.idx = 3 then q.q3
    when p.idx = 4 then q.q4
    end as sales
from quarterly_sales as q
cross join 
-- 피벗 테이블
(
	select 1 as idx
	union all select 2 as idx
	union all select 3 as idx
	union all select 4 as idx
) as p
;


-- 임의의 길이를 가진 배열을 행으로 전개하기
-- 데이터 길이가 확정되지 않는 경우(,로 구분 된 경우)

-- unnest() 테이블-function 활용: ex)
select unnest(array['A001', 'A002', 'A003']) as product_id;

select *, purchase_id, product_id
from purchase_log as p
cross join unnest(string_to_array(product_ids, ',')) as product_id

-- regexp_split_to_table(): 문자열을 구분자로 분할해서 테이블화 하는 함수
select purchase_id,
  regexp_split_to_table(product_ids, ',') as product_id
from purchase_log;


-- 배열 자료형을 지원하지 않는경우

-- 1. 피벗테이블을 사용해 문자열을 행으로 전개
-- 2. split_part로 n번째 요소를 추출

-- 피벗테이블
select *
from (
  select 1 as idx
  union select 2 as idx
  union select 3 as idx
) as pivot;

-- 문자열을 분할
select 
  split_part('A001,A002,A003', ',', 1) as part1,
  split_part('A001,A002,A003', ',', 2) as part2,
  split_part('A001,A002,A003', ',', 3) as part3;


-- 문자 수의 차이를 사용해 상품 수를 계산
select *,
	1 + char_length(product_ids) - char_length(replace(product_ids,',','')) as product_num
from purchase_log;

-- 피벗 테이블을 사용해 문자열을 행으로 전개
with pivot as
(
	select 1 as idx
	union select 2 as idx
	union select 3 as idx
)
select *, split_part(l.product_ids, ',', pivot.idx) as product_id
from purchase_log as l
join pivot 
on pivot.idx <=
	(1+char_length(l.product_ids) - char_length(replace(l.product_ids, ',', '')))