/*
 가로 결합 => JOIN 이지 뭐..
*/

-- 카테고리별 상품 매출과, 매출 순위 1위 상품
select m.category_id, m.name, s.sales, r.product_id as top_sale_product
from mst_categories as m
left join category_sales as s on m.category_id = s.category_id
left join product_sale_ranking as r 
	on m.category_id = r.category_id
	and r.rank = 1;

/*
서브쿼리
- 일반적으로 연산 비용이 추가됨.
- 메타 정보가 담겨있지 않기 때문에 제약, 인덱싱 활용 불가함

서브쿼리를 통한 성능 개선
- 집약 및 필터링을 진행한 후 Join 연산을 수행하게 되면 Join 시 스캔하는 레코드의 수가 줄어드는 장점을 활용
- 사전에 결합 레코드 수를 압축하여 Join 레코드의 수를 줄인다.
*/

-- Scalar subquery 활용
select *, 
  (
    select s.sales
    from category_sales as s
    where m.category_id = s.category_id
  ) as sales,
	(select r.product_id
		from product_sale_ranking as r
		where m.category_id = r.category_id
		order by sales desc
		limit 1
	) as top_sale_product
from mst_categories m
