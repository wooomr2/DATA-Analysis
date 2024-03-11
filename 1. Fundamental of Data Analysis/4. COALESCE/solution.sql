SELECT purchase_id, amount, coupon, amount-COALESCE(coupon,0) as discount_amount
FROM analysis.purchase_log