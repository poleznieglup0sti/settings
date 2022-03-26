-- Create a resource pool for production processing  
--- and set limits.  
USE master;  
GO  
ALTER RESOURCE POOL LowRP  
WITH  
(  
     MAX_CPU_PERCENT = 30,  
     MIN_CPU_PERCENT = 20,  
	 MIN_IOPS_PER_VOLUME = 20,
	 MAX_IOPS_PER_VOLUME = 160

);  
GO  
--- Create a workload group for production processing  
--- and configure the relative importance.  
ALTER WORKLOAD GROUP WGLow  
WITH  
(  
     IMPORTANCE = MEDIUM  
)  
--- Assign the workload group to the production processing  
--- resource pool.  
USING LowRP  
GO  

ALTER RESOURCE GOVERNOR RECONFIGURE;  
GO  

ALTER RESOURCE GOVERNOR with (CLASSIFIER_FUNCTION = dbo.UserClassifier);  
ALTER RESOURCE GOVERNOR RECONFIGURE;  
GO  

