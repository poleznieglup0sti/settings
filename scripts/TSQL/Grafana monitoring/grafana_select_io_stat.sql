select top 7
df.physical_name as 'Имя файла'
,df.size / 1024 as 'Размер(МБ)'
,avg_io_stall_read_ms as 'Средняя задержка чтения(мс)'
,avg_io_stall_write_ms as 'Средняя задержка записи(мс)'
,1.0 * total_io / SUM(total_io) OVER() 'Доля'
from
(
select
db_id
,file_id
,SUM(inc_num_of_reads) as total_reads
,SUM(inc_num_of_writes) as total_writes
,SUM(avg_io_stall_read_ms) as avg_io_stall_read_ms
,SUM(avg_io_stall_write_ms) as avg_io_stall_write_ms
,SUM(total_io) as total_io
 from (	
	
	select
	db_id
	,file_id	
	,SUM(inc_num_of_reads) as inc_num_of_reads
	,AVG(1.0 * inc_io_stall_read_ms / inc_num_of_reads) as avg_io_stall_read_ms
	,0 as inc_num_of_writes
	,0 as avg_io_stall_write_ms 
	,SUM(inc_num_of_reads) total_io
	FROM dbo.dbfiles_io_history
	WHERE inc_num_of_reads > 0 and $__timeFilter(utctime)
	GROUP BY db_id, file_id

	union all 

	select
	db_id
	,file_id	
	,0
	,0 
	,SUM(inc_num_of_writes)
	,AVG(1.0 * inc_io_stall_write_ms / inc_num_of_writes)
	,SUM(inc_num_of_writes) 	
	FROM dbo.dbfiles_io_history
	WHERE inc_num_of_writes > 0 and $__timeFilter(utctime)
	GROUP BY db_id, file_id

) as data
group by db_id,file_id
) as avg_ind
INNER JOIN sys.master_files df ON avg_ind.file_id = df.file_id AND avg_ind.db_id = df.database_id
ORDER BY total_io DESC, (avg_io_stall_read_ms + avg_io_stall_write_ms) DESC
