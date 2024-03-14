-- 구매 로그
CREATE TABLE purchase_log (
  seq SERIAL NOT NULL,
  purchase_id CHAR(5) NOT NULL,
  amount INTEGER NOT NULL,
  coupon INTEGER,

  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,

  CONSTRAINT purchase_log_pkey_seq PRIMARY KEY (seq)
);

INSERT INTO purchase_log
(purchase_id, amount, coupon, created_at, updated_at)
VALUES
('10001', 3280, null, now(), now()),
('10002', 4650, 500,  now(), now()),
('10003', 3870, null, now(), now());
