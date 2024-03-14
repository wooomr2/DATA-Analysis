SELECT user_id,
	CASE WHEN register_device = 1 THEN '데스크톱'
		 WHEN register_device = 2 THEN '스마트폰'
		 WHEN register_device = 3 THEN '앱'
		 ELSE '' 
    -- Null 처리 미리 해주는 것이 좋음.
	END AS device_name
FROM analysis.mst_user;