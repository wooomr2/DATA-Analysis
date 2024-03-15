-- 신용카드 등록과 구매이력 유무를 0과 1이라는 플래그로 나타내는 쿼리
select m.user_id, m.card_number,
	count(p.user_id) as purchase_count,
	case when m.card_number is not null then 1 else 0 end as has_card,
	sign(count(p.user_id)) as has_purchased
from mst_users_with_card_number as m
left join purchase_log as p
on m.user_id = p.user_id
group by m.user_id, m.card_number
;
