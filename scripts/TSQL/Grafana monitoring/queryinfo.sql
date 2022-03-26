	WITH QueryInfo
	AS
	(SELECT DatabaseID, DB_Name(DatabaseID) AS [DatabaseName], SUM(total_worker_time) AS [CPU_Time_Ms], SUM(total_elapsed_time) AS [duration_Time_Ms], SUM(total_logical_writes + total_logical_reads) as [logical_io] 
	 FROM sys.dm_exec_query_stats AS qs
	 CROSS APPLY (SELECT CONVERT(int, value) AS [DatabaseID] 
				  FROM sys.dm_exec_plan_attributes(qs.plan_handle)
				  WHERE attribute = N'dbid') AS F_DB
	 WHERE DatabaseID NOT IN (1,3,4)
	 GROUP BY DatabaseID)

	 insert into [mssql_health] ([utctime], [time], [metric], [value], [percent], [type]) 

	select 	 
		GETUTCDATE() as utctime, 
		GETDATE() as time,
		InfoData.DatabaseName + ' (' + InfoData.metric + ') ' as metric,  
		InfoData.value, 
		InfoData.[Percent],
		5
	from (
				select Info.metric as metric, Info.DatabaseName as DatabaseName, Info.value, Info.[Percent] From 				
				(	
					select top 3 'CPU' as metric, DatabaseName, [CPU_Time_Ms] as value,
					CAST([CPU_Time_Ms] * 1.0 / SUM([CPU_Time_Ms]) over() * 100.0 AS decimal(5, 2)) AS [Percent]
					from QueryInfo	
					order by [CPU_Time_Ms] desc			

					union all

					select top 3 'Duration', DatabaseName, [duration_Time_Ms],  
					CAST([duration_Time_Ms] * 1.0 / SUM([duration_Time_Ms]) over() * 100.0 AS decimal(5, 2)) AS [Percent]
					from QueryInfo	
					order by [duration_Time_Ms] desc		

					union all

					select top 3 'I/O', DatabaseName, [logical_io],  
					CAST([logical_io] * 1.0 / SUM([logical_io]) over() * 100.0 AS decimal(5, 2)) AS [Percent]
					from QueryInfo	
					order by [logical_io] desc

				) as Info		

	) as InfoData 
	where [Percent] > 0	 

--ORDER BY metric,value DESC OPTION (RECOMPILE);