SELECT * FROM (SELECT   
    cdet.CounterName + isnull(' (' + cdet.InstanceName + ')','') as metric,   
    cdata.CounterValue as value,	
	  DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), GETDATE()), convert(datetime, SUBSTRING(cdata.CounterDateTime, 0, 20) , 21)) as time  
FROM    
    dbo.CounterDetails as cdet
        LEFT JOIN dbo.CounterData as cdata
            ON cdet.CounterID = cdata.CounterID 
 ) as t
WHERE 
    $__timeFilter(time) 
ORDER BY 
	time ASC