CREATE TABLE mst_user (
  user_id CHAR(5) NOT NULL,
  register_date DATE NOT NULL,
  register_device SMALLINT NULL,

  created_at timestamp with time zone NOT NULL,
  updated_at timestamp with time zone NOT NULL,

  CONSTRAINT mst_user_pkey_user_id PRIMARY KEY (user_id)
);

COMMENT ON COLUMN mst_user.user_id                   IS 'PK) user_id';
COMMENT ON COLUMN mst_user.register_date             IS '등록일';
COMMENT ON COLUMN mst_user.register_device           IS '등록 Device 1)데스크톱, 2)스마트폰, 3)앱 ';



INSERT INTO mst_user
(user_id, register_date, register_device, created_at, updated_at)
VALUES
('U001', '2016-08-26', 1, now(), now()),
('U002', '2016-08-26', 2, now(), now()),
('U003', '2016-08-27', 3, now(), now()),
('U004', '2016-08-28', null, now(), now()),

