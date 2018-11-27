DROP DATABASE   IF     EXISTS stageProduct;
CREATE DATABASE IF NOT EXISTS stageProduct;
USE stageProduct;
CREATE TABLE stageProductTabel (

ProductId 		int 	primary key		NOT NULL,
Titel 			nvarchar(100)  			not null,
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


