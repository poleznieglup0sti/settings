USE msdb;
GO

EXEC dbo.sp_start_job N'ERPBackUp.Full';
EXEC dbo.sp_start_job N'ERPBackUp.Difference';
EXEC dbo.sp_start_job N'ERPBackUp.Log';
GO