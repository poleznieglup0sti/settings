SELECT 
	COUNT(*) AS cached_pages_count,  
    Sum(CASE WHEN (is_modified = 1) THEN 1 
	ELSE 0 END) as modified_pages,
	CASE database_id WHEN 32767 THEN 'ResourceDb'   
	ELSE db_name(database_id)   
	END AS database_name  
FROM sys.dm_os_buffer_descriptors  
GROUP BY database_id  
ORDER BY cached_pages_count DESC;  