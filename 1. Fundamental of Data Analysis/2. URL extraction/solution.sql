-- Regex Check: https://regexr.com/

-- https://www.postgresql.org/docs/12/functions-matching.html
-- substring(string from pattern for escape-character)

-- |교대(두 가지 대안 중 하나)를 나타냅니다.

-- *이전 항목이 0번 이상 반복됨을 나타냅니다.

-- +이전 항목이 한 번 이상 반복됨을 나타냅니다.

-- ?이전 항목이 0회 또는 1회 반복됨을 나타냅니다.

-- {m}이전 항목이 정확히 m몇 번 반복되는지 나타냅니다.

-- {m,}이전 항목이 m여러 번 반복됨을 나타냅니다.

-- {m,n}이전 항목이 최소한 m여러 n번 반복됨을 나타냅니다.

-- 괄호를 ()사용하여 항목을 단일 논리 항목으로 그룹화할 수 있습니다.

-- 대괄호 표현식은 [...]POSIX 정규 표현식과 마찬가지로 문자 클래스를 지정합니다.

-- 1. 어떤 웹 페이지를 거쳐 넘어왔는지 판별하기
select created_at, referer
substring(referer from 'https?:\/\/([^/]*)') AS referer_host
from analysis.access_log

-- 2. URL에서 경로와 요청 매개변수 값 추출하기
select created_at, url,
substring(url from '\/\/[^/]+([^?#]+)') as path,
substring(url from 'id=([^&]*)') as id
from analysis.access_log;

-- 3. 문자열 분해하기
select created_at, url,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) as path1,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) as path2
from analysis.access_log;




-- 8. 결손 값을 디폴트 값으로 대치하기
-- 쿠폰 사용여부가 함께 있는 구매로그
