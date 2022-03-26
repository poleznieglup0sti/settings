DECLARE @db_name varchar(50) = N'db1cv8-erp-01';

SELECT  IndStat.database_id,
                IndStat.object_id,
                QUOTENAME(s.name) + '.' + QUOTENAME(o.name) AS [object_name],
                IndStat.index_id,
                QUOTENAME(i.name) AS index_name,
                IndStat.avg_fragmentation_in_percent,
                IndStat.partition_number,
                (SELECT count (*) FROM sys.partitions p
                        WHERE p.object_id = IndStat.object_id AND p.index_id = IndStat.index_id) AS partition_count
FROM sys.dm_db_index_physical_stats
    (DB_ID(@db_name), NULL, NULL, NULL , 'DETAILED') AS IndStat
        INNER JOIN sys.objects AS o ON (IndStat.object_id = o.object_id)
        INNER JOIN sys.schemas AS s ON s.schema_id = o.schema_id
        INNER JOIN sys.indexes i ON (i.object_id = IndStat.object_id AND i.index_id = IndStat.index_id)
WHERE IndStat.avg_fragmentation_in_percent > 10 AND IndStat.index_id > 0
ORDER BY IndStat.avg_fragmentation_in_percent desc