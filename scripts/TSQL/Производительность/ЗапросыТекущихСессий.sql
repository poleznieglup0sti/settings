SELECT es.session_id
, ec.connection_id
, es.login_name
, es.host_name
, st.text
, su.user_objects_alloc_page_count
, su.user_objects_dealloc_page_count
, su.internal_objects_alloc_page_count
, su.internal_objects_dealloc_page_count
, ec.last_read
, ec.last_write
, es.program_name
FROM sys.dm_db_session_space_usage su
INNER JOIN sys.dm_exec_sessions es ON su.session_id = es.session_id
LEFT OUTER JOIN sys.dm_exec_connections ec ON su.session_id = ec.most_recent_session_id
OUTER APPLY sys.dm_exec_sql_text(ec.most_recent_sql_handle) st

WHERE ec.connection_id is not NULL 
--AND (su.user_objects_alloc_page_count > 0 OR su.user_objects_dealloc_page_count > 0 OR su.internal_objects_alloc_page_count > 0 OR su.internal_objects_dealloc_page_count > 0 )