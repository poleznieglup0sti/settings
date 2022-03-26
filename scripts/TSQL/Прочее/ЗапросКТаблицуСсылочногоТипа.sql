USE DataBaseName
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF OBJECT_ID (N‘dbo.Convert_IDRRefToGUID’, N‘FN’) IS NOT NULL
DROP FUNCTION dbo.Convert_IDRRefToGUID;
GO

CREATE FUNCTION dbo.Convert_IDRRefToGUID(@_IDRRef binary(16))
RETURNS VARCHAR(36)
AS
BEGIN
RETURN
substring(substring(sys.fn_varbintohexstr(@_IDRRef),3, len(sys.fn_varbintohexstr(@_IDRRef))),25,8) + ‘-‘ +
substring(substring(sys.fn_varbintohexstr(@_IDRRef),3, len(sys.fn_varbintohexstr(@_IDRRef))),21,4) + ‘-‘ +
substring(substring(sys.fn_varbintohexstr(@_IDRRef),3, len(sys.fn_varbintohexstr(@_IDRRef))),17,4) + ‘-‘ +
substring(substring(sys.fn_varbintohexstr(@_IDRRef),3, len(sys.fn_varbintohexstr(@_IDRRef))),1,4) + ‘-‘ +
substring(substring(sys.fn_varbintohexstr(@_IDRRef),3, len(sys.fn_varbintohexstr(@_IDRRef))),5,12);
END;

GO

—Пример работы функции:

SELECT TOP 5 T1._IDRRef, dbo.Convert_IDRRefToGUID(T1._IDRRef) AS _GUID FROM _Document33 AS T1 WITH(NOLOCK)
GO