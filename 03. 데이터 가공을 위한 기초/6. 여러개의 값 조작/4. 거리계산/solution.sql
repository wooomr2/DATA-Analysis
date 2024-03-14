/* ABS, RMS */ 
select abs(x1-x2) as abs, sqrt(power(x1-x2,2)) as rms
from location_1d;

/* 유클리드 거리 */
-- Postgresql에서는 point 자료형과 거리연산자 활용!!!
select 
  sqrt(power(x1-x2,2) + power(y1-y2,2)) as dist,
  point(x1,y1) <-> point(x2,y2) as dist
from location_2d;