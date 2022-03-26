select a.status, b.name,a.login_name,a.session_id, DB_NAME(a.database_id) as dbname, a.host_name, a.program_name from sys.dm_exec_sessions a
inner join  sys.dm_resource_governor_workload_groups b
on a.group_id=b.group_id