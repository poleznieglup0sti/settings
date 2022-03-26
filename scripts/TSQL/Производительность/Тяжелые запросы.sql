select qs.*, st.text, qp.query_plan from (select top 10 
qs.sql_handle
,qs.plan_handle
,sum(convert(money, (total_worker_time))/(execution_count*1000))as [AvgCPUTime]
,sum(qs.total_logical_reads+total_logical_writes) as [AggIO]
,sum(qs.total_elapsed_time/1000) as TotDuration
from sys.dm_exec_query_stats  qs 
where qs.last_logical_reads > 0 
group by qs.sql_handle,qs.plan_handle
order by [AggIO] desc) as qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) st
cross apply sys.dm_exec_query_plan(qs.plan_handle) qp
