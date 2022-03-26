SELECT DB_NAME(stats.database_id), files.physical_name, files.type_desc,
stats.num_of_writes, case when stats.num_of_writes = 0 then 0 else (1.0 * stats.io_stall_write_ms / stats.num_of_writes) end AS avg_write_stall_ms,
stats.num_of_reads, case when stats.num_of_reads = 0 then 0 else (1.0 * stats.io_stall_read_ms / stats.num_of_reads) end AS avg_read_stall_ms,
case when stats.num_of_writes = 0 then 0 else (1.0 * stats.io_stall_write_ms / stats.num_of_writes) end + case when stats.num_of_reads = 0 then 0 else (1.0 * stats.io_stall_read_ms / stats.num_of_reads) end AS avg_stall_ms
FROM sys.dm_io_virtual_file_stats(NULL, NULL) as stats
INNER JOIN master.sys.master_files AS files 
ON stats.database_id = files.database_id
AND stats.file_id = files.file_id
order by avg_stall_ms desc