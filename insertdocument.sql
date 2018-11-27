/* 
==================================================
	DD4 Student Environement Project - DATABASE
==================================================
*/
SET NOCOUNT ON
GO
PRINT '-!- BEGIN SCRIPT -!-'
PRINT ''

IF EXISTS(SELECT NAME FROM SYS.DATABASES WHERE NAME = 'DD4StudentEnvironement')
BEGIN
	USE master
	PRINT 'Bestaande databank wordt verwijderd...'
	ALTER DATABASE DD4StudentEnvironement
		SET SINGLE_USER
		WITH ROLLBACK IMMEDIATE
	DROP DATABASE DD4StudentEnvironement
	PRINT 'Bestaande databank is verwijderd.'
END
GO

CREATE DATABASE DD4StudentEnvironement
GO
USE DD4StudentEnvironement
PRINT 'Databank werd aangemaakt'
GO

/* 
==================================================
					 tables
==================================================
*/

PRINT 'Tabellen worden aangemaakt'

CREATE TABLE tblLike(

	LIKE_id						INT				IDENTITY(1,1)			NOT NULL,
	LIKE_gebruiker_id			INT										NOT NULL,
	LIKE_score					BIT										NOT NULL,
	LIKE_document_id			INT,
	LIKE_comment_id				INT										
)

CREATE TABLE tblOpmerking(

	OPM_id						INT				IDENTITY(1,1)			NOT NULL,
	OPM_gebruiker_id			INT										NOT NULL,
	OPM_document_id				INT										NOT NULL,
	OPM_omschrijving			NVARCHAR(200)							NOT NULL	
)

CREATE TABLE tblArchive(

	ARC_id						INT				IDENTITY(1,1)			NOT NULL,
	ARC_document_id				INT										NOT NULL,
	ARC_DocumentArchived		INT	DEFAULT 0							NOT NULL

)

CREATE TABLE tblDocument(

	DOC_id						INT				IDENTITY(1,1)			NOT NULL,
	DOC_name					NVARCHAR(50)							NOT NULL,
	DOC_vakgebied_id			INT										NOT NULL,
	DOC_geb_id					INT										NOT NULL,
	DOC_extension				NVARCHAR(50)							NOT NULL,
	DOC_bestand					varbinary(max)							NOT	NULL



)

CREATE TABLE tblInschrijving(
	INS_id						INT				IDENTITY(1,1)			NOT NULL,
	INS_student_id				INT										NOT NULL,
	INS_vak_id					INT										NOT NULL
)

CREATE TABLE tblEvent(
	EVE_id						INT				IDENTITY(1,1)			NOT NULL,
	EVE_docent_id				INT										NOT NULL,
	EVE_titel					NVARCHAR(100)							NOT NULL,
	EVE_beschrijving			NVARCHAR(500)							NOT NULL	
)

CREATE TABLE tblVakgebied(
	VAK_id						INT				IDENTITY(1,1)			NOT NULL,
	VAK_name					NVARCHAR(50)							NOT NULL,
	VAK_uitleg					NVARCHAR(500)							NOT NULL,
	VAK_opleiding_id			INT										NOT NULL,
	VAK_Docent_id				INT										NOT NULL
)

CREATE TABLE tblOpleidingsgebied(
	OPL_id						INT				IDENTITY(1,1)			NOT NULL,
	OPL_name					NVARCHAR(50)							NOT NULL,
	OPL_uitleg					NVARCHAR(500)							NOT NULL
)

CREATE TABLE tblDocent(
	DOC_id						INT				IDENTITY(1,1)			NOT NULL,
	DOC_gebruiker_id			INT										NOT NULL	
)

CREATE TABLE tblStudent(
	STU_id						INT				IDENTITY(1,1)			NOT NULL,
	STU_gebruiker_id			INT										NOT NULL,
	STU_like					INT										NOT NULL
)

CREATE TABLE tblGebruiker(
	GEB_id						INT				IDENTITY(1,1)			NOT NULL,
	GEB_first_name				NVARCHAR(50)							NOT NULL,
	GEB_last_name				NVARCHAR(50)							NOT NULL,
	GEB_locatie					INT										NOT NULL,
	GEB_language_id				INT										NOT NULL,
	GEB_email					NVARCHAR(250)							NOT NULL,
	GEB_passwoord				VARCHAR(20)								NOT NULL,
	GEB_telefoonnummer			VARCHAR(10)								NOT NULL,
	GEB_Rol						VARCHAR(1)								NOT NULL
)

CREATE TABLE tblLocatie(

	LOC_id					INT			IDENTITY(1,1)			NOT NULL,
	LOC_postcode			NVARCHAR(4)							NOT NULL,
	LOC_gemeente			NVARCHAR(100)						NOT NULL,
    LOC_gemeenteCaps		NVARCHAR(100)						NOT NULL,
	Loc_structuur			NVARCHAR(100)						NOT NULL	
)

CREATE TABLE tblLanguage(

	LAN_id						INT				IDENTITY(1,1)			NOT NULL,
	LAN_language				VARCHAR(2)								NOT NULL
)

GO
PRINT 'Tabellen werden aangemaakt'

/* 
==================================================
					 Constraints
==================================================
*/
PRINT 'Constraints worden aangemaakt'

ALTER TABLE tblLocatie
	ADD
		CONSTRAINT	PK_LOC_id				PRIMARY KEY(LOC_id)
	GO

ALTER TABLE tblLanguage
	ADD
		CONSTRAINT	PK_LAN_id				PRIMARY KEY(LAN_id)
	GO

ALTER TABLE tblOpleidingsgebied
	ADD
		CONSTRAINT	PK_OPL_id				PRIMARY KEY(OPL_id)
	GO

ALTER TABLE tblGebruiker
	ADD
		CONSTRAINT	PK_gebruiker_id			PRIMARY KEY(GEB_id),
		CONSTRAINT	FK_Geb_locatie			FOREIGN KEY(Geb_locatie)			REFERENCES tblLocatie(LOC_id),
		CONSTRAINT	FK_GEB_language_id		FOREIGN KEY(GEB_language_id)		REFERENCES tblLanguage(LAN_id)
	GO

ALTER TABLE tblStudent
	ADD
		CONSTRAINT	PK_student_id			PRIMARY KEY(STU_id),
		CONSTRAINT	FK_STU_gebruiker_id		FOREIGN KEY(STU_gebruiker_id)		REFERENCES tblGebruiker(GEB_id)
	GO

ALTER TABLE tblDocent
	ADD
		CONSTRAINT	PK_docent_id			PRIMARY KEY(DOC_id),
		CONSTRAINT	FK_DOC_gebruiker_id		FOREIGN KEY(DOC_gebruiker_id)		REFERENCES tblGebruiker(GEB_id)
	GO

ALTER TABLE tblVakgebied
	ADD
		CONSTRAINT	PK_VAK_id				PRIMARY KEY(VAK_id),
		CONSTRAINT	FK_VAK_opleiding_id	 	FOREIGN KEY(VAK_opleiding_id)		REFERENCES tblOpleidingsgebied(OPL_id),
		CONSTRAINT	FK_VAK_docent_id	 	FOREIGN KEY(VAK_Docent_id)			REFERENCES tblDocent(DOC_id)
	GO

ALTER TABLE tblInschrijving
	ADD
		CONSTRAINT	PK_inschrijving_id		PRIMARY KEY(INS_id),
		CONSTRAINT	FK_ins_vak_id			FOREIGN KEY(INS_vak_id)				REFERENCES tblVakgebied(VAK_id),
		CONSTRAINT	FK_INS_student_id	 	FOREIGN KEY(INS_student_id)			REFERENCES tblStudent(STU_id)
	GO

ALTER TABLE tblDocument
	ADD
		CONSTRAINT	PK_DOC_id				PRIMARY KEY(DOC_id),
		CONSTRAINT	FK_DOC_vakgebied_id		FOREIGN KEY(DOC_vakgebied_id)		REFERENCES tblVakgebied(VAK_id),
		CONSTRAINT	FK_DOC_geb_id			FOREIGN KEY(DOC_geb_id)				REFERENCES tblGebruiker(GEB_id)	
	GO

ALTER TABLE tblEvent
	ADD
		CONSTRAINT	PK_event_id				PRIMARY KEY(EVE_id),
		CONSTRAINT	FK_eve_docent_id		FOREIGN KEY(EVE_docent_id)			REFERENCES tblDocent(DOC_id)
	GO

ALTER TABLE tblOpmerking
	ADD
		CONSTRAINT	PK_OPM_id				PRIMARY KEY(OPM_id),
		CONSTRAINT	FK_OPM_gebruiker_id		FOREIGN KEY(OPM_gebruiker_id)		REFERENCES tblGebruiker(GEB_id),
		CONSTRAINT	FK_OPM_document_id		FOREIGN KEY(OPM_document_id)		REFERENCES tblDocument(DOC_id)
	GO

ALTER TABLE tblArchive
	ADD
		CONSTRAINT	PK_ARC_id				PRIMARY KEY(ARC_id),
		CONSTRAINT	FK_ARC_document_id		FOREIGN KEY(ARC_document_id)		REFERENCES tblDocument(DOC_id)
	GO

ALTER TABLE tblLike
	ADD
		CONSTRAINT	PK_LIKE_id				PRIMARY KEY(LIKE_id),
		CONSTRAINT	FK_LIKE_document_id		FOREIGN KEY(LIKE_document_id)		REFERENCES tblDocument(DOC_id),
		CONSTRAINT	FK_LIKE_comment_id		FOREIGN KEY(LIKE_comment_id)		REFERENCES tblOpmerking(OPM_id)
	GO

PRINT 'Constraints werden aangemaakt'

/*
==============================
	Aanmaken van spMessages
==============================
*/

PRINT 'Messages worden aangemaakt'

EXEC SP_ADDMESSAGE 60000,10,'De id van het document werd niet ingegeven', @replace= 'REPLACE' 
EXEC SP_ADDMESSAGE 60001,10,'De id van het event werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60002,10,'De id van de docent van het event werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60003,10,'De titel van de event werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60004,10,'De beschrijving van het event werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60005,10,'De id van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60006,10,'De voornaam van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60007,10,'De familienaam van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60008,10,'De geboortedatum van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60009,10,'De id van de locatie van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60010,10,'De id van de language van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60011,10,'De emailadres van gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60012,10,'Het telefoonnummer van gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60013,10,'Het telefoonnummer van gebruiker is langer dan 10 karakters', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60014,10,'Het nummer van gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60015,10,'De id van de like werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60016,10,'De score van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60017,10,'De postcode van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60018,10,'De gemeente van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60019,10,'De gemeenteCaps van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60020,10,'De locatie structuur van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60021,10,'De passwoord van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60022,10,'De rol van de gebruiker werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60023,10,'De gebruiker id van de student werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60024,10,'De like id van de student werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60025,10,'De naam van de opleiding werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60026,10,'De beschrijving van de opleiding werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60027,10,'De naam van het vak werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60028,10,'De beschrijving van het vak werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60029,10,'De id van de opleiding werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60030,10,'De id van de student werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60031,10,'De id van het vak werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60032,10,'De naam van de document werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60033,10,'De id van het vakgebied werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60034,10,'De omschrijving van de opmerking werd niet ingegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60035,10,'De voornaam is te lang', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60036,10,'De voornaam heeft cijfers', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60037,10,'De familienaam is te lang', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60038,10,'De familienaam heeft cijfers', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60039,10,'De locatie bestaat niet ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60040,10,'De taal bestaat niet ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60041,10,'De email is te lang ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60042,10,'De passwoord is te lang ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60043,10,'De telefoonnummer is te lang ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60044,10,'De telefoonnummer heeft letters ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60045,10,'De rol is te lang ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60046,10,'De rol moet "R" of "W" zijn', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60047,10,'De gearchiveerde document werd niet gegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60048,10,'De score van de like werd niet gegeven', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60049,10,'De id van de commentaar werd niet gegeven', @replace= 'REPLACE'
EXEC sp_ADDMESSAGE 60052,10,'Het bestand mag neit leeg zijn ', @replace= 'REPLACE'
EXEC SP_ADDMESSAGE 60053,10,'De naam van dit bestand is te lang', @replace= 'REPLACE'    

PRINT 'Messages werden aangemaakt'

/*
==================================
	Aanmaken van Stored Procedures
==================================
*/

PRINT 'Stored procedures worden aangemaakt'

/* 
=========================================
		 Stored Procedure
	Naam:		 LikeVanDocument_insert
	Naam:		 LikeVanPersoon_insert
=========================================
*/

GO
CREATE PROCEDURE InsertLikeDocument
(
	@Likeid		INT,
	@Score		INT,
	@Gebid		INT,
	@Documentid INT
)
AS
BEGIN
	IF EXISTS(SELECT LIKE_id FROM tblLike WHERE LIKE_id = @Likeid)
		BEGIN TRY
			BEGIN TRANSACTION
			IF(@Likeid IS NULL)
				RAISERROR(60015,10,1)
					IF(@Score IS NULL)
					RAISERROR(60016,10,1)	
						IF(@Gebid IS NULL)
						RAISERROR(60005,10,1)
							IF(@Documentid IS NULL)
							RAISERROR(60000,10,1)							
	BEGIN
		UPDATE tblLike
				SET LIKE_score = @Score WHERE LIKE_id = @Likeid
	END
	BEGIN
		INSERT INTO tblLike (LIKE_gebruiker_id,LIKE_score,LIKE_document_id)
				VALUES (@Gebid,@Score,@Documentid)
	END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH
	COMMIT TRANSACTION
END
GO


/* 
====================================
	 Stored procedure
	Naam:		documentArchive
	Beschrijving: Een document archiveren zodat deze niet meer zichbaar is maar wel nog bestaat
	Parameters: 
		- document_id
	Returns:
		- 0: gelukt
		- 1: klant bestaat niet
====================================
*/

CREATE PROCEDURE DocumentArchive
(
	@document_id INT
)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			IF(@document_id IS NULL)
				RAISERROR(60000,10,1)							
	BEGIN
		UPDATE tblArchive SET ARC_document_id = 1 WHERE ARC_document_id = @document_id;
	END
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE()
		ROLLBACK TRANSACTION
	END CATCH
	COMMIT TRANSACTION
END
GO

/* 
====================================
	Stored procedure
	Naam:		documenten verwijderen
	Parameters: 
		- document_id
	Returns:
		- 0: gelukt
		- 1: document bestaat niet
====================================
*/

CREATE PROCEDURE DocumentRemove
(
	@doc_id INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@doc_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
									-- Check IF gebruiker EXISTS
				IF NOT EXISTS(SELECT DOC_id FROM tblDocument WHERE DOC_id = @doc_id)
					SET @result = 1 -- gebruiker bestaat niet
				ELSE
				BEGIN
				-- Transacties hier nog gebruiken...
					DECLARE @comment_id	INT 
					DECLARE DATA CURSOR FOR SELECT OPM_id FROM tblOpmerking WHERE OPM_document_id = @doc_id
					OPEN DATA 
					FETCH NEXT FROM DATA INTO @comment_id
					WHILE @@FETCH_STATUS <> -1
					BEGIN
						DELETE FROM tblLike WHERE LIKE_comment_id = @comment_id
						FETCH NEXT FROM DATA INTO @comment_id
					END
					CLOSE DATA
					DEALLOCATE DATA
						DELETE FROM tblLike WHERE LIKE_document_id = @doc_id
						DELETE FROM tblOpmerking WHERE OPM_document_id = @doc_id
						DELETE FROM tblArchive WHERE ARC_document_id = @doc_id 
						DELETE FROM tblDocument WHERE DOC_id = @doc_id 
				SET @result = 0
			END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		opmerking verwijderen
	Parameters: 
		- opmerking_id
	Returns:
		- 0: gelukt
		- 1: document bestaat niet
====================================
*/

CREATE PROCEDURE OpmerkingRemove
(
	@OPM_id INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@OPM_id IS NULL)
					RAISERROR(60008,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT OPM_id FROM tblOpmerking WHERE OPM_id = @OPM_id)
					SET @result = 1
				ELSE
				BEGIN					
						DELETE FROM tblOpmerking WHERE OPM_id = @OPM_id 
				SET @result = 0
			END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Event verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE EventRemove
(
	@event_id INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@event_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT * FROM tblEvent WHERE EVE_id = @event_id)
					SET @result = 1
				ELSE
				BEGIN
					DELETE FROM tblEvent WHERE EVE_id = @event_id
					SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Archive verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE ArchiveRemove
(
	@archive_id INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@archive_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT * FROM tblArchive WHERE ARC_id = @archive_id)
					SET @result = 1
				ELSE
				BEGIN
					DELETE FROM tblArchive WHERE ARC_id = @archive_id
					SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Like verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE LikeRemove
(
	@like_id INT
)
AS
	BEGIN
	PRINT 'Start archive remove'
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@like_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT * FROM tblLike WHERE LIKE_id = @like_id)
					SET @result = 1
				ELSE
				BEGIN
					DELETE FROM tblLike WHERE LIKE_id = @like_id
					SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	PRINT 'End archive remove'
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Student verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE StudentRemove
(
	@student_id INT
)
AS
	BEGIN
	PRINT 'Start student remove'
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@student_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT STU_id FROM tblStudent WHERE STU_id = @student_id)
					SET @result = 1
				ELSE
					DELETE FROM tblInschrijving WHERE INS_student_id = @student_id
					DELETE FROM tblStudent WHERE STU_id = @student_id
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	PRINT 'End student remove'
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Inschrijving verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE InschrijvingRemove
(
	@ins_id INT
)
AS
	BEGIN
	PRINT 'Start gebruiker remove'
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@ins_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT INS_id FROM tblInschrijving WHERE INS_id = @ins_id)
					SET @result = 1
				ELSE
					DELETE FROM tblInschrijving WHERE INS_id = @ins_id
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	PRINT 'End gebruiker remove'
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Vakgebied verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE VakgebiedRemove
(
	@vak_id INT
)
AS
	BEGIN
	PRINT 'Start vakgebied remove'
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@vak_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT VAK_id FROM tblVakgebied WHERE VAK_id = @vak_id)
					SET @result = 1
				ELSE
					DECLARE @id INT
					DECLARE DATA_docs CURSOR LOCAL FOR SELECT DOC_id FROM tblDocument WHERE DOC_vakgebied_id = @vak_id
					OPEN DATA_docs 
					FETCH NEXT FROM DATA_docs INTO @id
					WHILE @@FETCH_STATUS <> -1
					BEGIN
						EXEC DocumentRemove @id
						FETCH NEXT FROM DATA_docs INTO @id
					END
					CLOSE DATA_docs
					DEALLOCATE DATA_docs
					DELETE FROM tblDocument WHERE DOC_vakgebied_id = @vak_id
					DELETE FROM tblInschrijving WHERE INS_vak_id = @vak_id
					DELETE FROM tblVakgebied WHERE VAK_id = @vak_id
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	PRINT 'End vakgebied remove'
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Docent verwijderen
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

CREATE PROCEDURE DocentRemove
(
	@docent_id INT
)
AS
	BEGIN
	PRINT 'Start docent remove'
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@docent_id IS NULL)
					RAISERROR(60005,10,1)
					DECLARE @result INT = 0
				IF NOT EXISTS(SELECT DOC_id FROM tblDocent WHERE DOC_id = @docent_id)
					SET @result = 1
				ELSE
					DECLARE @id INT
					DECLARE DATA_vak CURSOR LOCAL FOR SELECT VAK_id FROM tblVakgebied WHERE VAK_Docent_id = @docent_id
					OPEN DATA_vak 
					FETCH NEXT FROM DATA_vak INTO @id
					WHILE @@FETCH_STATUS <> -1
					BEGIN
						EXEC VakgebiedRemove @id
						FETCH NEXT FROM DATA_vak INTO @id
					END
					CLOSE DATA_vak
					DEALLOCATE DATA_vak
					DELETE FROM tblEvent WHERE EVE_docent_id = @docent_id
					DELETE FROM tblVakgebied WHERE VAK_Docent_id = @docent_id
					DELETE FROM tblDocent WHERE DOC_id = @docent_id
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	PRINT 'End docent remove'
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert Opleidingsgegeven
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/
--DROP PROCEDURE InsertOpleiding
 CREATE PROCEDURE InsertOpleiding
(
	@OPL_NAME			NVARCHAR(50),
	@OPL_UITLEG			NVARCHAR(80)
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@OPL_NAME IS NULL)
						RAISERROR(60025,10,1)
							IF(@OPL_UITLEG IS NULL)
							RAISERROR(60026,10,1)				
					DECLARE @result INT = 0
				IF EXISTS(SELECT OPL_name FROM tblOpleidingsgebied WHERE OPL_name = @OPL_NAME) OR 
				   EXISTS(SELECT OPL_uitleg FROM tblOpleidingsgebied WHERE OPL_uitleg = @OPL_UITLEG) 
				BEGIN
					DECLARE @opleidingnaam NVARCHAR(50) = (SELECT OPL_id FROM tblOpleidingsgebied WHERE OPL_name = @OPL_NAME OR
														OPL_uitleg = @OPL_UITLEG 
														  )
					DECLARE @opleidinguitleg NVARCHAR(80) = (SELECT OPL_id FROM tblOpleidingsgebied WHERE OPL_name = @OPL_NAME OR
														OPL_uitleg = @OPL_UITLEG 
															)    
																															
					PRINT 'Opleidingsnaam: ' + @opleidingnaam + 'Opleidingsuitleg: ' + @opleidinguitleg + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblOpleidingsgebied (OPL_name, OPL_uitleg ) 
						VALUES (@OPL_NAME, @OPL_UITLEG)
				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO
/* 
====================================
	Stored procedure
	Naam:		Insert vakgebied
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/
--DROP PROCEDURE InsertVakgebied

 CREATE PROCEDURE InsertVakgebied
(
	@VAK_name			NVARCHAR(40),
	@VAK_uitleg			NVARCHAR(80),
	@VAK_opleiding_id	INT,
	@VAK_Docent_id		INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@VAK_name IS NULL)
						RAISERROR(60027,10,1)
							IF(@VAK_uitleg IS NULL)
							RAISERROR(60028,10,1)
								IF(@VAK_opleiding_id IS NULL)
								RAISERROR(60029,10,1)
									IF(@VAK_Docent_id IS NULL)
									RAISERROR(60002,10,1)				
					DECLARE @result INT = 0
				IF EXISTS(SELECT VAK_name FROM tblVakgebied WHERE VAK_name = @VAK_name) OR 
				   EXISTS(SELECT VAK_uitleg FROM tblVakgebied WHERE VAK_uitleg = @VAK_uitleg) 
				BEGIN
					DECLARE @vaknaam NVARCHAR(40) = (SELECT VAK_id FROM tblVakgebied WHERE VAK_name = @VAK_name OR
														VAK_uitleg = @VAK_uitleg 
												    )
					DECLARE @vakuitleg NVARCHAR(80) = (SELECT VAK_id FROM tblVakgebied WHERE VAK_name = @VAK_name OR
														VAK_uitleg = @VAK_uitleg 
													  )															
					PRINT 'Vaknaam: ' + @vaknaam + 'Vakuitleg: ' + @vakuitleg + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblVakgebied(VAK_name, VAK_uitleg, VAK_opleiding_id, VAK_Docent_id ) 
						   VALUES (@VAK_name, @VAK_uitleg, @VAK_opleiding_id, @VAK_Docent_id)
 				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert inschrijving
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

--DROP PROCEDURE InsertInschrijving
 
CREATE PROCEDURE InsertInschrijving
(
	@INS_student_id		INT,
	@INS_vak_id			INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@INS_student_id IS NULL)
						RAISERROR(60030,10,1)
							IF(@INS_vak_id IS NULL)
							RAISERROR(60031,10,1)		
					DECLARE @result INT = 0
				IF EXISTS(SELECT INS_student_id FROM tblInschrijving WHERE INS_student_id = @INS_student_id) OR 
				   EXISTS(SELECT INS_vak_id	 FROM tblInschrijving WHERE INS_vak_id = @INS_vak_id) 
				BEGIN
					DECLARE @inschrijvingStudentID INT = (SELECT INS_id FROM tblInschrijving WHERE INS_student_id = @INS_student_id OR
															INS_vak_id = @INS_vak_id 
														  )
					DECLARE @inschrijvingVakID INT = (SELECT INS_id FROM tblInschrijving WHERE INS_student_id = @INS_student_id OR
															INS_vak_id = @INS_vak_id 
														  )   																	
					PRINT 'Student id ' + @inschrijvingStudentID + 'Vak id: ' + @inschrijvingVakID + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblInschrijving(INS_student_id, INS_vak_id ) 
						VALUES (@INS_student_id, @INS_vak_id)
				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO
/* 
====================================
	Stored procedure
	Naam:		Insert document
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

--DROP PROCEDURE InsertDocument

 CREATE PROCEDURE InsertDocument
(
	@DOC_name				NVARCHAR(max),
	@DOC_vakgebied_id		INT,
	@DOC_geb_id				INT,
	@Doc_ext				NVARCHAR(max),
	@DOC_bestand			NVARCHAR(max)


)
AS
	BEGIN
			BEGIN TRY
				IF(LEN(@DOC_name) > 30)
					RAISERROR(60053,10,1)
						ELSE IF(@DOC_vakgebied_id IS NULL)
							RAISERROR(60033,10,1)
							ELSE IF(@DOC_geb_id IS NULL)
								RAISERROR(60005,10,1)
								ELSE IF (@DOC_bestand IS NULL)
									RAISERROR (60052,10,1)
					BEGIN
					DECLARE @table TABLE(id int, name NVARCHAR(30), vakgebied_id INT, geb_id INT, ext NVARCHAR(10), bestand varbinary(max))
					IF EXISTS(SELECT DOC_id FROM tblDocument WHERE DOC_name = @DOC_name)
					BEGIN
						INSERT INTO @table SELECT * FROM tblDocument WHERE DOC_name = @DOC_name
						SELECT * FROM @table
						PRINT 'EVENT ALREADY EXISTS'
					END
					ELSE
					BEGIN
					DECLARE @sql NVARCHAR(1000)
					-- cast gebruiken ipv convert
						SET @sql= 'INSERT INTO tblDocument(DOC_name,DOC_vakgebied_id, DOC_geb_id,DOC_extension,DOC_bestand) 
						SELECT '''+ @DOC_name +''','+ CONVERT(VARCHAR(MAX), @DOC_vakgebied_id) +','+ CONVERT(VARCHAR(MAX), @DOC_geb_id)+','''+ @Doc_ext+''', BulkColumn
					    FROM Openrowset( Bulk '''+ @DOC_bestand +''' , Single_Blob) as InsertedDocument'
						EXEC(@sql)
						INSERT INTO @table SELECT * FROM tblDocument WHERE DOC_name = @DOC_name
						SELECT * FROM @table

						--VALUES (@DOC_name, @DOC_vakgebied_id, @DOC_geb_id, @DOC_bestand)
						PRINT 'EVENT INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
			END CATCH
	END
GO




/* 
====================================
	Stored procedure
	Naam:		Insert opmerking
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

--DROP PROCEDURE InsertOpmerking
CREATE PROCEDURE InsertOpmerking
(
	@OPM_gebruiker_id		INT,
	@OPM_document_id		INT,
	@OPM_omschrijving		NVARCHAR(200)
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@OPM_gebruiker_id IS NULL)
						RAISERROR(60005,10,1)
							IF(@OPM_document_id IS NULL)
							RAISERROR(60000,10,1)
								IF(@OPM_omschrijving IS NULL)
								RAISERROR(60034,10,1)
					DECLARE @result INT = 0
				IF EXISTS(SELECT OPM_gebruiker_id FROM tblOpmerking WHERE OPM_gebruiker_id = @OPM_gebruiker_id)  OR
				   EXISTS(SELECT OPM_document_id FROM tblOpmerking WHERE OPM_document_id = @OPM_document_id)  OR
				   EXISTS(SELECT OPM_omschrijving FROM tblOpmerking WHERE OPM_omschrijving = @OPM_omschrijving)  
				BEGIN
					DECLARE @OPM_GebruikerID	INT = (SELECT OPM_id FROM tblOpmerking WHERE OPM_gebruiker_id = @OPM_gebruiker_id OR
															OPM_document_id = @OPM_document_id OR
															OPM_omschrijving = @OPM_omschrijving
														  )
					DECLARE @OPM_DocID			INT = (SELECT OPM_id FROM tblOpmerking WHERE OPM_gebruiker_id = @OPM_gebruiker_id OR
															OPM_document_id = @OPM_document_id OR
															OPM_omschrijving = @OPM_omschrijving
														  )	
					DECLARE @OPM_omschrijv		NVARCHAR(200) = (SELECT OPM_id FROM tblOpmerking WHERE OPM_gebruiker_id = @OPM_gebruiker_id OR
															OPM_document_id = @OPM_document_id OR
															OPM_omschrijving = @OPM_omschrijving
														  )								
 					PRINT 'Gebruiker id: ' + @OPM_GebruikerID + 'Document id: ' + @OPM_DocID + 'omschrijving: ' + @OPM_omschrijv + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblOpmerking(OPM_gebruiker_id, OPM_document_id, OPM_omschrijving ) 
						VALUES (@OPM_gebruiker_id, @OPM_document_id, @OPM_omschrijving )
				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO
/* 
====================================
	Stored procedure
	Naam:		Insert archive
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

--DROP PROCEDURE InsertArchive

CREATE PROCEDURE InsertArchive
(
	@ARC_document_id			INT,
	@ARC_DocumentArchived		INT	
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@ARC_document_id IS NULL)
						RAISERROR(60000,10,1)
							IF(@ARC_DocumentArchived IS NULL)
							RAISERROR(60047,10,1)
					DECLARE @result INT = 0
				IF EXISTS(SELECT ARC_document_id FROM tblArchive WHERE ARC_document_id = @ARC_document_id)  OR
				   EXISTS(SELECT ARC_DocumentArchived FROM tblArchive WHERE ARC_DocumentArchived = @ARC_DocumentArchived)  
				BEGIN
					DECLARE @ARC_DocID		INT = (SELECT ARC_id FROM tblArchive WHERE ARC_document_id = @ARC_document_id OR
															ARC_DocumentArchived = @ARC_DocumentArchived															
														  )
					DECLARE @ARC_DocArcID	INT = (SELECT ARC_id FROM tblArchive WHERE ARC_document_id = @ARC_document_id OR
															ARC_DocumentArchived = @ARC_DocumentArchived															
														  )
 					PRINT 'Document id: ' + @ARC_DocID + 'gearchiveerde document id: ' + @ARC_DocArcID + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblArchive(ARC_document_id, ARC_DocumentArchived) 
						VALUES (@ARC_document_id, @ARC_DocumentArchived )
				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO
/* 
====================================
	Stored procedure
	Naam:		Insert like
	Returns:
		- 0: gelukt
		- 1: niet gelukt
====================================
*/

--DROP PROCEDURE InsertLike
CREATE PROCEDURE InsertLike
(
	@LIKE_gebruiker_id			INT,
	@LIKE_score					BIT,
	@LIKE_document_id			INT,
	@LIKE_comment_id			INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
					IF(@LIKE_gebruiker_id IS NULL)
						RAISERROR(60005,10,1)
							IF(@LIKE_score IS NULL)
							RAISERROR(60048,10,1)
								IF(@LIKE_document_id IS NULL)
								RAISERROR(60000,10,1)
									IF(@LIKE_comment_id IS NULL)
									RAISERROR(60049,10,1)
					DECLARE @result INT = 0
				IF EXISTS(SELECT LIKE_gebruiker_id FROM tblLike WHERE LIKE_gebruiker_id = @LIKE_gebruiker_id)  OR
				   EXISTS(SELECT LIKE_score FROM tblLike WHERE LIKE_score = @LIKE_score)  OR
				   EXISTS(SELECT LIKE_document_id FROM tblLike WHERE LIKE_document_id = @LIKE_document_id)  OR
				   EXISTS(SELECT LIKE_comment_id FROM tblLike WHERE LIKE_comment_id = @LIKE_comment_id)  
				BEGIN
					DECLARE @LI_GebID		INT = (SELECT LIKE_id FROM tblLike WHERE LIKE_gebruiker_id = @LIKE_gebruiker_id OR
															LIKE_score = @LIKE_score OR
															LIKE_document_id = 	@LIKE_document_id OR
															LIKE_comment_id = 	@LIKE_comment_id							
														  )
					DECLARE @Li_Score		BIT = (SELECT LIKE_id FROM tblLike WHERE LIKE_gebruiker_id = @LIKE_gebruiker_id OR
															LIKE_score = @LIKE_score OR
															LIKE_document_id = 	@LIKE_document_id OR
															LIKE_comment_id = 	@LIKE_comment_id							
														  )
					DECLARE @Li_DocID		INT = (SELECT LIKE_id FROM tblLike WHERE LIKE_gebruiker_id = @LIKE_gebruiker_id OR
															LIKE_score = @LIKE_score OR
															LIKE_document_id = 	@LIKE_document_id OR
															LIKE_comment_id = 	@LIKE_comment_id							
														  )
					DECLARE @Li_ComID		INT = (SELECT LIKE_id FROM tblLike WHERE LIKE_gebruiker_id = @LIKE_gebruiker_id OR
															LIKE_score = @LIKE_score OR
															LIKE_document_id = 	@LIKE_document_id OR
															LIKE_comment_id = 	@LIKE_comment_id							
														  )
 					PRINT 'Gebruiker id: ' + @LI_GebID + 'Score van de like: ' + @Li_Score 
					+ 'Document id :'+ @Li_DocID + 'Comment id: ' + @Li_ComID + ' bestaat al';
					SET @result = 1
				END
				ELSE
				BEGIN
					INSERT INTO tblLike(LIKE_gebruiker_id, LIKE_score, LIKE_document_id, LIKE_comment_id) 
						VALUES (@LIKE_gebruiker_id, @LIKE_score, @LIKE_document_id, @LIKE_comment_id  )
				SET @result = 0
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert Gebruiker
====================================
*/

 CREATE PROCEDURE InsertGebruiker
(
	@GEB_first_name NVARCHAR(MAX),
	@GEB_last_name	NVARCHAR(MAX),
	@GEB_locatie	INT ,
	@GEB_language_id INT,
	@GEB_email		NVARCHAR(MAX),
	@GEB_passwoord	VARCHAR(MAX),
	@GEB_telefoonnummer VARCHAR(MAX),
	@GEB_Rol VARCHAR(MAX)										
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@GEB_first_name IS NULL OR REPLACE(@GEB_first_name, ' ', '') = '')
					RAISERROR(60006,10,1)
				ELSE IF(LEN(@GEB_first_name) > 50)
					RAISERROR(60035,10,1)
				ELSE IF(@GEB_first_name LIKE '%[0-9]%')
					RAISERROR(60036,10,1)
				ELSE IF(@GEB_last_name IS NULL OR REPLACE(@GEB_last_name, ' ', '') = '')
					RAISERROR(60007,10,1)
				ELSE IF(LEN(@GEB_last_name) > 50)
					RAISERROR(60037,10,1)
				ELSE IF(@GEB_last_name LIKE '%[0-9]%')
					RAISERROR(60038,10,1)
				ELSE IF(@GEB_locatie IS NULL)
					RAISERROR(60009,10,1)
				ELSE IF NOT EXISTS(SELECT LOC_id FROM tblLocatie WHERE LOC_id = @GEB_locatie)
				RAISERROR(60039,10,1)
				ELSE IF(@GEB_language_id IS NULL)
					RAISERROR(60010,10,1)
				ELSE IF NOT EXISTS(SELECT LAN_id FROM tblLanguage WHERE LAN_id = @GEB_language_id)
					RAISERROR(60040,10,1)
				ELSE IF(@GEB_email IS NULL OR REPLACE(@GEB_email, ' ', '') = '')
					RAISERROR(60011,10,1)
				ELSE IF(LEN(@GEB_email) > 250)
					RAISERROR(60041,10,1)
				ELSE IF(@GEB_passwoord IS NULL OR REPLACE(@GEB_passwoord, ' ', '') = '')
					RAISERROR(60021,10,1)
				ELSE IF(LEN(@GEB_passwoord) > 20)
					RAISERROR(60042,10,1)
				ELSE IF(@GEB_telefoonnummer IS NULL OR REPLACE(@GEB_telefoonnummer, ' ', '') = '')
					RAISERROR(60012,10,1)
				ELSE IF(LEN(@GEB_telefoonnummer) > 10)
					RAISERROR(60043,10,1)
				ELSE IF(@GEB_telefoonnummer LIKE '%[a-z]%')
					RAISERROR(60044,10,1)
				ELSE IF(@GEB_Rol IS NULL OR REPLACE(@GEB_Rol, ' ', '') = '')
					RAISERROR(60022,10,1)
				ELSE IF(LEN(@GEB_Rol) > 1)
					RAISERROR(60045,10,1)
				ELSE IF(@GEB_Rol != 'R' AND @GEB_Rol != 'W')
					RAISERROR(60046,10,1)
				ELSE
				BEGIN
					DECLARE @table TABLE(id INT,firstname NVARCHAR(20),lastname NVARCHAR(20),locatie INT,language INT,email NVARCHAR(30),passwoord NVARCHAR(20),telefoonnummer NVARCHAR(10),rol NVARCHAR(1));
					IF EXISTS(SELECT GEB_id FROM tblGebruiker WHERE GEB_first_name = @GEB_first_name AND GEB_last_name = @GEB_last_name) OR
						EXISTS(SELECT GEB_id FROM tblGebruiker WHERE GEB_email = @GEB_email) OR
						EXISTS(SELECT GEB_id FROM tblGebruiker WHERE GEB_telefoonnummer = @GEB_telefoonnummer) 
					BEGIN
						INSERT INTO @table SELECT * FROM tblGebruiker WHERE (GEB_first_name = @GEB_first_name AND GEB_last_name = @GEB_last_name) OR GEB_email = @GEB_email OR GEB_telefoonnummer = @GEB_telefoonnummer
						SELECT * FROM @table
						PRINT 'USER ALREADY EXISTS'
					END
					ELSE
					BEGIN
						INSERT INTO tblGebruiker(GEB_first_name, GEB_last_name, GEB_email, GEB_passwoord, GEB_telefoonnummer, GEB_Rol, GEB_locatie, GEB_language_id ) 
							VALUES (@GEB_first_name, @GEB_last_name, @GEB_email, @GEB_passwoord, @GEB_telefoonnummer, @GEB_Rol, @GEB_locatie, @GEB_language_id)
						INSERT INTO @table SELECT * FROM tblGebruiker WHERE GEB_first_name = @GEB_first_name AND GEB_last_name = @GEB_last_name
						SELECT * FROM @table
						PRINT 'USER INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert Student
====================================
*/
	
 CREATE PROCEDURE InsertStudent
(
	@STU_gebruiker_id	INT,
	@STU_like			INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@STU_gebruiker_id IS NULL)
					PRINT 'ERROR NO USER ID GIVEN'
				ELSE IF NOT EXISTS(SELECT GEB_id FROM tblGebruiker WHERE GEB_id = @STU_gebruiker_id)
					PRINT 'ERROR USER DOES NOT EXIST'
				ELSE IF(@STU_like IS NULL)
					PRINT 'ERROR NO LIKES GIVEN'
				ELSE
				BEGIN
					DECLARE @table TABLE(id INT,gebruiker_id INT,likes INT)
					IF EXISTS(SELECT STU_id FROM tblStudent WHERE STU_gebruiker_id = @STU_gebruiker_id)
					BEGIN
						INSERT INTO @table SELECT * FROM tblStudent WHERE STU_gebruiker_id = @STU_gebruiker_id
						SELECT * FROM @table
						PRINT 'STUDENT ALREADY EXISTS'
					END
					ELSE
					BEGIN
						INSERT INTO tblStudent(STU_gebruiker_id,STU_like) VALUES (@STU_gebruiker_id, @STU_like)
						INSERT INTO @table SELECT * FROM tblStudent WHERE STU_gebruiker_id = @STU_gebruiker_id
						SELECT * FROM @table
						PRINT 'STUDENT INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO
	 
/*
====================================
	Stored procedure
	Naam:		Insert Docent
====================================
*/

 CREATE PROCEDURE InsertDocent
(
	
	@DOC_gebruiker_id INT
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@DOC_gebruiker_id IS NULL)
					PRINT 'ERROR NO USER ID GIVEN'
				ELSE IF NOT EXISTS(SELECT GEB_id FROM tblGebruiker WHERE GEB_id = @DOC_gebruiker_id)
					PRINT 'ERROR USER DOES NOT EXIST'
				ELSE
				BEGIN
					DECLARE @table TABLE(id INT,gebruiker_id INT)
					IF EXISTS(SELECT DOC_id FROM tblDocent WHERE DOC_gebruiker_id = @DOC_gebruiker_id) 
					BEGIN
						INSERT INTO @table SELECT * FROM tblDocent WHERE DOC_gebruiker_id = @DOC_gebruiker_id
						SELECT * FROM @table
						PRINT 'DOCENT ALREADY EXISTS'
					END
					ELSE
					BEGIN
						INSERT INTO tblDocent(DOC_gebruiker_id) VALUES (@DOC_gebruiker_id)
						INSERT INTO @table SELECT * FROM tblDocent WHERE DOC_gebruiker_id = @DOC_gebruiker_id
						SELECT * FROM @table
						PRINT 'DOCENT INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert Language
====================================
*/

CREATE PROCEDURE InsertLanguage
(
	@LAN_language NVARCHAR(MAX)
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@LAN_language IS NULL OR REPLACE(@LAN_language, ' ', '') = '')
					PRINT 'ERROR NO LANGUAGE GIVEN'
				ELSE IF(LEN(@LAN_language) > 2)
					PRINT 'ERROR LANGUAGE IS TOO LONG'
				ELSE IF(@LAN_language LIKE '%[0-9]%')
					PRINT 'ERROR LANGUAGE HAS DIGITS'
				ELSE
				BEGIN
					DECLARE @table TABLE(id INT,language NVARCHAR(2))
					IF EXISTS(SELECT LAN_id FROM tblLanguage WHERE LAN_language = @LAN_language) 
					BEGIN
						INSERT INTO @table SELECT * FROM tblLanguage WHERE LAN_language = @LAN_language
						SELECT * FROM @table
						PRINT 'LANGUAGE ALREADY EXISTS'
					END
					ELSE
					BEGIN
						INSERT INTO tblLanguage(LAN_language) VALUES (UPPER(@LAN_language))
						INSERT INTO @table SELECT * FROM tblLanguage WHERE LAN_language = @LAN_language
						SELECT * FROM @table
						PRINT 'LANGUAGE INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

/* 
====================================
	Stored procedure
	Naam:		Insert event
====================================
*/

CREATE PROCEDURE InsertEvent
(
	@EVE_docent_id		INT,
	@EVE_titel			NVARCHAR(MAX),
	@EVE_beschrijving	NVARCHAR(MAX)
)
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				IF(@EVE_docent_id IS NULL)
					PRINT 'ERROR NO DOCENT ID GIVEN'
				ELSE IF NOT EXISTS(SELECT DOC_id FROM tblDocent WHERE DOC_id = @EVE_docent_id)
					PRINT 'ERROR DOCENT DOES NOT EXIST'
				ELSE IF(@EVE_titel IS NULL OR REPLACE(@EVE_titel, ' ', '') = '')
					PRINT 'ERROR NO TITEL GIVEN'
				ELSE IF(LEN(@EVE_titel) > 100)
					PRINT 'ERROR TITEL IS TOO LONG'
				ELSE IF(@EVE_beschrijving IS NULL OR REPLACE(@EVE_beschrijving, ' ', '') = '')
					PRINT 'ERROR NO DESCRIPTION GIVEN'
				ELSE IF(LEN(@EVE_beschrijving) > 500)
					PRINT 'ERROR DESCRIPTION IS TOO LONG'
				ELSE
				BEGIN
					DECLARE @table TABLE(id INT,docent INT,titel NVARCHAR(100),beschrijving NVARCHAR(500))
					IF EXISTS(SELECT EVE_id FROM tblEvent WHERE EVE_titel = @EVE_titel) OR 
						EXISTS(SELECT EVE_id FROM tblEvent WHERE EVE_beschrijving = @EVE_beschrijving)
					BEGIN
						INSERT INTO @table SELECT * FROM tblEvent WHERE EVE_titel = @EVE_titel OR EVE_beschrijving = @EVE_beschrijving
						SELECT * FROM @table
						PRINT 'EVENT ALREADY EXISTS'
					END
					ELSE
					BEGIN
						INSERT INTO tblEvent(EVE_docent_id,EVE_titel,EVE_beschrijving) VALUES (@EVE_docent_id,@EVE_titel,@EVE_beschrijving)
						INSERT INTO @table SELECT * FROM tblEvent WHERE EVE_titel = @EVE_titel
						SELECT * FROM @table
						PRINT 'EVENT INSERTED'
					END
				END
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO 

/* 
====================================
	Stored procedure
	Naam:		Testgegevens invullen
====================================
*/
 
CREATE PROCEDURE InsertTestgegevens
AS
	BEGIN
		BEGIN TRANSACTION
			BEGIN TRY
				PRINT 'Emptying all tables'
				DECLARE @sqlText NVARCHAR(MAX) = ''
				SELECT @sqlText = @sqlText + ' DELETE FROM ' + name + CHAR(13) FROM sys.tables 
				PRINT @sqlText
				EXEC(@sqlText)
				SET @sqlText = ''
				IF(IDENT_CURRENT('tblLanguage') = 1)
				BEGIN
					SELECT @sqlText = @sqlText + ' DBCC CHECKIDENT (' + QUOTENAME(name) + ',RESEED, 1)' + CHAR(13) FROM sys.tables 
					PRINT @sqlText
					EXEC(@sqlText)
				END
				ELSE
				BEGIN
					SELECT @sqlText = @sqlText + ' DBCC CHECKIDENT (' + QUOTENAME(name) + ',RESEED, 0)' + CHAR(13) FROM sys.tables 
					PRINT @sqlText
					EXEC(@sqlText)
				END
				PRINT 'Tables empty'
				INSERT INTO tblLanguage(LAN_language) VALUES ('NL')
				INSERT INTO tblLanguage(LAN_language) VALUES ('FR')
				INSERT INTO tblLanguage(LAN_language) VALUES ('EN')
				INSERT INTO tblLanguage(LAN_language) VALUES ('ES')
				INSERT INTO tblLanguage(LAN_language) VALUES ('DA')
				INSERT INTO tblLanguage(LAN_language) VALUES ('DE')
				INSERT INTO tblLanguage(LAN_language) VALUES ('PT')
				INSERT INTO tblLanguage(LAN_language) VALUES ('RU')
 				PRINT 'Insert tblLanguage'
				--Begin insert INTO tblLocatie
				INSERT INTO tblLocatie(LOC_postcode,LOC_gemeente,LOC_gemeenteCaps,Loc_structuur) VALUES('1000', 'Halle','HALLE','structuur')
 				PRINT 'Insert tblLocatie'
				--Begin insert INTO tblGebruiker
				INSERT INTO tblGebruiker(GEB_first_name,GEB_last_name,GEB_locatie,GEB_language_id,GEB_email,GEB_passwoord,GEB_telefoonnummer,GEB_Rol) VALUES ('Aiko','De Doncker',1,1,'aiko@email.com','aikopass','0457661994','w')
				INSERT INTO tblGebruiker(GEB_first_name,GEB_last_name,GEB_locatie,GEB_language_id,GEB_email,GEB_passwoord,GEB_telefoonnummer,GEB_Rol) VALUES ('Lotfi','Lahcene',1,3,'lotfi@email.com','lotfipass','0465894562','r')
				INSERT INTO tblGebruiker(GEB_first_name,GEB_last_name,GEB_locatie,GEB_language_id,GEB_email,GEB_passwoord,GEB_telefoonnummer,GEB_Rol) VALUES ('Silvio','Mattioli',1,5,'silvio@email.com','silviopass','0879456132','w')
				INSERT INTO tblGebruiker(GEB_first_name,GEB_last_name,GEB_locatie,GEB_language_id,GEB_email,GEB_passwoord,GEB_telefoonnummer,GEB_Rol) VALUES ('Redouan','Kanaa',1,7,'redouan@email.com','redouanpass','0654465187','r')
				PRINT 'Insert tblGebruiker'
				--Begin insert INTO tblStudent
				INSERT INTO tblStudent(STU_gebruiker_id,STU_like) VALUES (2,5)
				INSERT INTO tblStudent(STU_gebruiker_id,STU_like) VALUES (4,17)
				PRINT 'Insert tblStudent'
				--Begin insert INTO tblDocent
				INSERT INTO tblDocent(DOC_gebruiker_id) VALUES (2)
				INSERT INTO tblDocent(DOC_gebruiker_id) VALUES (3)
				PRINT 'Insert tblDocent'
				--Begin insert INTO tblOpleidingsgebied
				INSERT INTO tblOpleidingsgebied(OPL_name,OPL_uitleg) VALUES ('Toegepaste Informatica','ICT Richting')
				INSERT INTO tblOpleidingsgebied(OPL_name,OPL_uitleg) VALUES ('Marketing','Handelsrichting')
				PRINT 'Insert tblOpleidingsgebied'
				--Begin insert INTO tblVakgebied
				INSERT INTO tblVakgebied(VAK_name,VAK_uitleg,VAK_opleiding_id,VAK_Docent_id) VALUES ('Application development','Application development voor TI',1,2)
				INSERT INTO tblVakgebied(VAK_name,VAK_uitleg,VAK_opleiding_id,VAK_Docent_id) VALUES ('Database development','Database development voor TI',1,1)
				INSERT INTO tblVakgebied(VAK_name,VAK_uitleg,VAK_opleiding_id,VAK_Docent_id) VALUES ('Wiskunde','Wiskunde voor Marketing',2,1)
				INSERT INTO tblVakgebied(VAK_name,VAK_uitleg,VAK_opleiding_id,VAK_Docent_id) VALUES ('Handelstechnieken','Handelstechnieken voor Marketing',2,2)
				PRINT 'Insert tblVakgebied'
				--Begin insert INTO tblEvent
				INSERT INTO tblEvent(EVE_docent_id,EVE_titel,EVE_beschrijving) VALUES (1,'Uitstap','Beschrijving van een uitstap')
				INSERT INTO tblEvent(EVE_docent_id,EVE_titel,EVE_beschrijving) VALUES (1,'Opdracht','Beschrijving van een opdracht')
				INSERT INTO tblEvent(EVE_docent_id,EVE_titel,EVE_beschrijving) VALUES (2,'Bericht','Beschrijving van een bericht')
				PRINT 'Insert tblEvent'
				--Begin insert INTO tblInschrijving
				INSERT INTO tblInschrijving(INS_student_id,INS_vak_id) VALUES (1,2)
				INSERT INTO tblInschrijving(INS_student_id,INS_vak_id) VALUES (1,3)
				INSERT INTO tblInschrijving(INS_student_id,INS_vak_id) VALUES (1,4)
				INSERT INTO tblInschrijving(INS_student_id,INS_vak_id) VALUES (2,2)
				INSERT INTO tblInschrijving(INS_student_id,INS_vak_id) VALUES (2,1)
				PRINT 'Insert tblInschrijving'
				--Begin insert INTO tblDocument
					exec InsertDocument 'classes',1,2,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
					exec InsertDocument 'Kegelsnede',3,2,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
					exec InsertDocument 'Parabolen',3,1,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
					exec InsertDocument 'Inheritance',1,1,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
					exec InsertDocument 'Transact SQL',2,1,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
				PRINT 'Insert tblDocument'
				--Begin insert INTO tblArchive
				INSERT INTO tblArchive(ARC_document_id,ARC_DocumentArchived) VALUES (3,1/*wat is dit?*/)
				INSERT INTO tblArchive(ARC_document_id,ARC_DocumentArchived) VALUES (1,0)
				PRINT 'Insert tblArchive'
				--Begin insert INTO tblOpmerking
				INSERT INTO tblOpmerking(OPM_gebruiker_id,OPM_document_id,OPM_omschrijving) VALUES (3,2,'Dit document is goed voor dit vak')
				INSERT INTO tblOpmerking(OPM_gebruiker_id,OPM_document_id,OPM_omschrijving) VALUES (2,4,'Dit document is niet goed opgesteld')
				PRINT 'Insert tblOpmerking'
				--Begin insert INTO tblLike
				INSERT INTO tblLike(LIKE_gebruiker_id,LIKE_score,LIKE_document_id) VALUES (3,1,2)
				INSERT INTO tblLike(LIKE_gebruiker_id,LIKE_score,LIKE_document_id) VALUES (2,0,4)
				INSERT INTO tblLike(LIKE_gebruiker_id,LIKE_score,LIKE_comment_id) VALUES (1,1,1)
				PRINT 'Insert tblLike'
			END TRY
			BEGIN CATCH
				PRINT ERROR_MESSAGE()
				ROLLBACK TRANSACTION
			END CATCH
	    COMMIT TRANSACTION
	END
GO

PRINT 'Stored procedures werden aangemaakt'
/* 
==================================================
					 FUNCTIONS
==================================================
*/
GO
CREATE FUNCTION dbo.GetPassword(@input VARCHAR(20))
RETURNS VARCHAR (20)
AS BEGIN
	DECLARE @PSSWRD VARCHAR (20)
	SET @PSSWRD = (SELECT DISTINCT(GEB_passwoord) FROM tblGebruiker WHERE GEB_first_name = @input)
RETURN @PSSWRD
END
GO
/*SELECT dbo.GetPassword('silvio');
GO*/
PRINT 'functions aangemaakt'

/* 
==================================================
					 VIEUWS
==================================================
*/

PRINT 'Views worden aangemaakt'

GO

CREATE VIEW vwEventsDocent
AS 
	SELECT EVE_titel, EVE_beschrijving, Geb_first_name, Geb_last_name
	FROM tblEvent e INNER JOIN tblDocent d ON e.EVE_docent_id = d.DOC_id
	INNER JOIN tblGebruiker g  ON d.DOC_gebruiker_id = g.GEB_id
GO

CREATE VIEW vwOpleidingsOnderdeelStudent
AS 
	 SELECT OPL_name, GEB_first_name, GEB_last_name
	 FROM tblOpleidingsgebied o INNER JOIN tblVakgebied v ON o.OPL_id = v.VAK_opleiding_id
	 INNER JOIN tblInschrijving i ON v.VAK_id = i.INS_vak_id
	 INNER JOIN tblStudent s ON i.INS_student_id = s.STU_id
	 INNER JOIN tblGebruiker g ON s.STU_gebruiker_id = g.GEB_id
GO

CREATE VIEW vwVakgebiedStudentA
AS 
	 SELECT VAK_name
	 FROM tblVakgebied v INNER JOIN tblInschrijving i ON v.VAK_id = i.INS_vak_id
	 INNER JOIN tblStudent s ON s.STU_id = i.INS_student_id
	 INNER JOIN tblGebruiker g ON s.STU_gebruiker_id = g.GEB_id 
GO

CREATE VIEW vwArchivedDoc
AS 
	SELECT GEB_first_name, GEB_last_name, DOC_name AS 'gearchiveerde documenten '
	FROM  tblArchive a INNER JOIN tblDocument d ON a.ARC_document_id = d.DOC_id
	INNER JOIN tblVakgebied v ON d.DOC_vakgebied_id = v.VAK_id
	INNER JOIN tblInschrijving i ON v.VAK_id = i.INS_vak_id
	INNER JOIN tblStudent s ON i.INS_student_id = s.STU_id
	INNER JOIN tblGebruiker g ON s.STU_gebruiker_id = g.GEB_id
GO

CREATE VIEW vwAantalLikesPerDoc
AS 
	 SELECT d.DOC_name, COUNT(l.LIKE_document_id) AS 'Aantal likes'
	 FROM tblLike l INNER JOIN tblDocument d ON l.LIKE_document_id = d.DOC_id
	 GROUP BY d.DOC_name
GO

CREATE VIEW vwLijstDocumenten
AS
	SELECT * FROM tblDocument
GO

CREATE VIEW vwLijstGebruikers
AS
	SELECT GEB_id, GEB_first_name, GEB_last_name, GEB_Rol  FROM tblGebruiker
GO

CREATE VIEW vwLijstDocenten
AS
	SELECT GEB_id, GEB_first_name, GEB_last_name, GEB_Rol FROM tblDocent d INNER JOIN tblGebruiker g
	ON d.DOC_gebruiker_id = g.GEB_id
GO

CREATE VIEW vwLijstStudenten
AS
	SELECT GEB_id, GEB_first_name, GEB_last_name, GEB_Rol, STU_like FROM tblStudent s INNER JOIN tblGebruiker g
	ON s.STU_gebruiker_id = g.GEB_id
GO

PRINT 'Views werden aangemaakt'
exec InsertTestgegevens
GO
exec InsertDocument 'silvio',3,2,'png','C:\Users\Acer\Desktop\Untitled Diagram.html - draw.io_files\glyphicons_github.png'
GO
exec InsertDocument 'silvio2',3,2,'docx','C:\Users\Acer\Desktop\Netwerkconcepts\Stanford design thinking.docx'
GO

select * from tblDocument




PRINT ''
PRINT '-!- END SCRIPT -!-'

