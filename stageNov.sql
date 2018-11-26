/
/* DATABASE stageProducten;*/

USE stageProducten;

CREATE TABLE stageProductTabel (
ProductId int unsigned primary key,
Titel varchar(100)  not null,
Locatie varchar(100) ,
Straat varchar(100),
nr int,
postCode int,
Gemeente varchar(50),
Land varchar(10),
Omschrijven varchar(200),
WikipediaLink varchar(100),
Website varchar(50),
Telefoon int,
Email varchar(100),
prijs int,
Persoon varchar(50)

);
