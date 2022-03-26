select DB_NAME(database_id) as db, SUM(num_of_bytes_read + num_of_bytes_written) AS bytes, SUM(size_on_disk_bytes / 1024 /1024 /1024) 
from sys.dm_io_virtual_file_stats(NULL,NULL)
group by DB_NAME(database_id) 
ORDER by SUM(num_of_bytes_read + num_of_bytes_written) desc


