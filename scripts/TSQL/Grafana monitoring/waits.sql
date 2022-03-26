--insert into [mssql_health] ([utctime], [time], [metric], [inc], [percent], [value], [type]) 

select	GETUTCDATE()
		,GETDATE()
		,data.metric		
		,1.0 * case when SUM(data.inc) = SUM(data.value) then 0 else SUM(data.inc) end / SUM(seconds) as inc
		,SUM(data.[Percent]) as [Percent]
		,SUM(data.value) as value
		,4							
from (
	select * from (select top 5				
		[wait_type] as metric,
		[wait_time_ms] as inc,                
		CAST([wait_time_ms] * 1.0 / SUM([wait_time_ms]) OVER() * 100.0 as decimal(5, 2)) as [Percent],	
		[wait_time_ms] as value,
		DATEDIFF_BIG(SECOND, '2000-01-01 0:0:00', GETUTCDATE()) as seconds    
	from sys.dm_os_wait_stats
	where [wait_type] NOT IN (
		N'BROKER_EVENTHANDLER',         N'BROKER_RECEIVE_WAITFOR',
		N'BROKER_TASK_STOP',            N'BROKER_TO_FLUSH',
		N'BROKER_TRANSMITTER',          N'CHECKPOINT_QUEUE',
		N'CHKPT',                       N'CLR_AUTO_EVENT',
		N'CLR_MANUAL_EVENT',            N'CLR_SEMAPHORE',
		N'DBMIRROR_DBM_EVENT',          N'DBMIRROR_EVENTS_QUEUE',
		N'DBMIRROR_WORKER_QUEUE',       N'DBMIRRORING_CMD',
		N'DIRTY_PAGE_POLL',             N'DISPATCHER_QUEUE_SEMAPHORE',
		N'EXECSYNC',                    N'FSAGENT',
		N'FT_IFTS_SCHEDULER_IDLE_WAIT', N'FT_IFTSHC_MUTEX',
		N'HADR_CLUSAPI_CALL',           N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
		N'HADR_LOGCAPTURE_WAIT',        N'HADR_NOTIFICATION_DEQUEUE',
		N'HADR_TIMER_TASK',             N'HADR_WORK_QUEUE',
		N'KSOURCE_WAKEUP',              N'LAZYWRITER_SLEEP',
		N'LOGMGR_QUEUE',                N'ONDEMAND_TASK_QUEUE',
		N'PWAIT_ALL_COMPONENTS_INITIALIZED',
		N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
		N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
		N'REQUEST_FOR_DEADLOCK_SEARCH', N'RESOURCE_QUEUE',
		N'SERVER_IDLE_CHECK',           N'SLEEP_BPOOL_FLUSH',
		N'SLEEP_DBSTARTUP',             N'SLEEP_DCOMSTARTUP',
		N'SLEEP_MASTERDBREADY',         N'SLEEP_MASTERMDREADY',
		N'SLEEP_MASTERUPGRADED',        N'SLEEP_MSDBSTARTUP',
		N'SLEEP_SYSTEMTASK',            N'SLEEP_TASK',
		N'SLEEP_TEMPDBSTARTUP',         N'SNI_HTTP_ACCEPT',
		N'SP_SERVER_DIAGNOSTICS_SLEEP', N'SQLTRACE_BUFFER_FLUSH',
		N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
		N'SQLTRACE_WAIT_ENTRIES',       N'WAIT_FOR_RESULTS',
		N'WAITFOR',                     N'WAITFOR_TASKSHUTDOWN',
		N'WAIT_XTP_HOST_WAIT',          N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
		N'WAIT_XTP_CKPT_CLOSE',         N'XE_DISPATCHER_JOIN',
		N'XE_DISPATCHER_WAIT',          N'XE_TIMER_EVENT')	
		
	order by value desc) as td	

	UNION ALL  

	select 
		metric
		, -value
		, 0
		, 0
		, -DATEDIFF_BIG(SECOND, '2000-01-01 0:0:00', utctime)
	from [dbo].[mssql_health]
	where type = 4 and utctime = (select MAX(utctime) from [dbo].[mssql_health] where type = 4) 
) as data
group by data.metric
HAVING SUM(data.inc) >= 0