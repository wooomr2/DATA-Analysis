-- 데이터 집계 시에는 페이지 단위로 집계하면 밀도가 너무 작아 통계 분석이 오히려 힘들다.
-- 호스트 단위로 집계하자

CREATE TABLE analysis.access_log (
  seq SERIAL NOT NULL,
  user_id CHAR(5) NOT NULL,
  referer VARCHAR(256),
  url VARCHAR(256) NOT NULL,

  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,

  CONSTRAINT access_log_pkey_seq PRIMARY KEY (seq)
);

COMMENT ON COLUMN analysis.access_log.seq                       IS 'PK) seq';
COMMENT ON COLUMN analysis.access_log.user_id                   IS 'FK) user_id';
COMMENT ON COLUMN analysis.access_log.referer                   IS '어떤 웹 페이지를 거쳐 왔는지';
COMMENT ON COLUMN analysis.access_log.url                       IS '접속 URL';



INSERT INTO analysis.access_log
(user_id, referer, url, created_at, updated_at)
VALUES
('U001', 'http://www.other.com/path1/index.php?k1-v1&v2-v2#Ref1', 'http://www.example.com/video/detail?id=001', now(), now()),
('U002', 'http://www.other.com/path1/index.php?k1-v1&v2-v2#Ref1', 'http://www.example.com/video#ref', now(), now()),
('U003', 'https://www.other.com', 'http://www.example.com/book/detail?id=002', now(), now());

