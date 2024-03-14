-- IP주소 활용
select
  -- 대소비교
	cast('127.0.0.1' as inet) < cast('127.0.0.2' as inet) as lt,
	cast('127.0.0.1' as inet) > cast('127.0.0.2' as inet) as gt,
  -- 포함관계
  cast('127.0.0.1' as inet) << cast('127.0.0.2/8' as inet) as is_contained


/* inet 자료형이 없는 경우 ip주소 변환 */
-- ip주소 추출
select ip,
  cast(split_part(ip, '.', 1) as integer) as ip_part_1,
  cast(split_part(ip, '.', 2) as integer) as ip_part_2,
  cast(split_part(ip, '.', 3) as integer) as ip_part_3,
  cast(split_part(ip, '.', 4) as integer) as ip_part_4
from (select cast('192.168.0.1' as text) as ip) as t

-- ip주소를 정수 표기로 변환
select ip,
  cast(split_part(ip, '.', 1) as integer) * 2^24  
  + cast(split_part(ip, '.', 2) as integer) * 2^16
  + cast(split_part(ip, '.', 3) as integer) * 2^8
  + cast(split_part(ip, '.', 4) as integer) * 2^0
	as ip_integer
from (select cast('192.168.0.1' as text) as ip) as t


-- IP주소의 각 부분을 0으로 채우기
-- LPAD:지정한 문자수가 되게 문자열의 왼쪽을 채우기
-- || 연산자로 문자열을 연결
-- 이후 대소비교
select ip,
  lpad(split_part(ip, '.', 1), 3, '0')
  || lpad(split_part(ip, '.', 2), 3, '0')
  || lpad(split_part(ip, '.', 3), 3, '0')
  || lpad(split_part(ip, '.', 4), 3, '0') as ip_pad
from (select cast('192.168.0.1' as text) as ip) as t  