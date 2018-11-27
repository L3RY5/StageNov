/* DATABASE stageProducten*/
SET NOCOUNT ON
GO
PRINT '-!- BEGIN SCRIPT -!-'
PRINT ''


IF EXISTS(SELECT NAME FROM SYS.DATABASES WHERE NAME = 'stageProducten')
BEGIN
	USE master
	PRINT 'Bestaande databank wordt verwijderd...'
	ALTER DATABASE stageProducten
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE
	DROP DATABASE stageProducten
	PRINT 'Bestaande databank is verwijderd.'
END
GO



CREATE DATABASE stageProducten
GO
USE stageProducten
PRINT 'Databank werd aangemaakt'
GO

/* 
==================================================
					 tables
==================================================
*/

PRINT 'Tabellen worden aangemaakt'

 

CREATE TABLE stageProductTabel (

ProductId 		int 			  IDENTITY(1,1)		NOT NULL,
Titel 			nvarchar(100)  						not null,
Locatie 		nvarchar(100),
Straat 			nvarchar(100),
nr 				int,
postCode 		nvarchar(4),
Gemeente 		nvarchar(50),
Land 			nvarchar(10),
Omschrijven 	nvarchar(200),
WikipediaLink 	nvarchar(100),
Website 		nvarchar(50),
Telefoon 		int,
Email 			nvarchar(100),
prijs 			int,
Persoon 		varchar(50)

)

GO
PRINT 'Tabellen werden aangemaakt'

