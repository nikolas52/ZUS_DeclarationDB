USE [master]
GO

IF DB_ID(N'ZUS_Pustelnik') IS NOT NULL
DROP DATABASE ZUS_Pustelnik;
GO

CREATE DATABASE ZUS_Pustelnik
ON
(
    NAME = N'ZUS_Pustelnik',
    FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ZUS_Pustelnik.mdf',
    SIZE = 10MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 5MB
)
LOG ON (
    NAME = N'ZUS_Pustelnik_log',
    FILENAME='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\ZUS_Pustelnik_log.ldf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
);
GO 

USE [ZUS_Pustelnik]
GO

SET XACT_ABORT ON

CREATE TABLE [Uzytkownicy] (
    [ID_Uzytkownika] int  NOT NULL PRIMARY KEY,
    [Nazwa] Varchar(25)  NOT NULL ,
    [Haslo] Varchar(50)  NOT NULL 
)

CREATE TABLE [Pracownicy] (
    [ID_pracownika] int  NOT NULL PRIMARY KEY,
    [ID_Uzytkownika] int  NOT NULL ,
    [ID_przedsiebiorstwa] int  NOT NULL ,
    [ID_konto_bankowe] int  NOT NULL ,
    [ID_deklaracjiZUS] int  NOT NULL ,
    [Imie] Varchar(30)  NOT NULL ,
    [Nazwisko] Varchar(50)  NOT NULL ,
    [Rola] Varchar(25)  NOT NULL ,
    [Email] Varchar(50)  NOT NULL ,
    [Telefon] varchar(13)  NOT NULL 
)

CREATE TABLE [Przedsiebiorstwo] (
    [ID_przedsiebiorstwa] int  NOT NULL PRIMARY KEY,
    [Imiê_W³asciciela] Varchar(30)  NOT NULL ,
    [Nazwisko_W³aœciciela] Varchar(50)  NOT NULL ,
    [Nazwa_firmy] Varchar(255)  NOT NULL ,
    [NIP] Varchar(10)  NOT NULL ,
    [Adres] Varchar(100)  NOT NULL ,
    [Email] Varchar(50)  NOT NULL 
)

CREATE TABLE [Konto_Bankowe] (
    [ID_konto_bankowe] int  NOT NULL PRIMARY KEY,
    [Numer_konta] int  NOT NULL ,
    [Nazwa_Banku] Varchar(255)  NOT NULL ,
    [Numer_rachunku] int  NOT NULL 
)

CREATE TABLE [Deklaracje_ZUS] (
    [ID_deklaracjiZUS] int  NOT NULL PRIMARY KEY,
    [ID_status_deklaracji] int  NOT NULL ,
    [ID_historia_deklaracji] int  NOT NULL ,
    [ID_dokumenty_ZUS] int  NOT NULL ,
    [Numer_deklaracji] int  NOT NULL ,
    [Data_z³o¿enia] Date  NOT NULL ,
    [Kwota_emerytalna] int  NOT NULL ,
    [Kwota_zdrowotna] int  NOT NULL ,
    [Kwota_chorobowa] int  NOT NULL ,
    [Kwota_wypadkowa] int  NOT NULL 
)

CREATE TABLE [Status_Deklaracji] (
    [ID_status_deklaracji] int  NOT NULL PRIMARY KEY,
    [Data_zmiany_statusu] Date  NULL 
)

CREATE TABLE [Historia_deklaracji] (
    [ID_historia_deklaracji] int  NOT NULL PRIMARY KEY,
    [Kwota_emerytalna] int  NOT NULL ,
    [Kwota_zdrowotna] int  NOT NULL ,
    [Kwota_chorobowa] int  NOT NULL ,
    [Kwota_wypadkowa] int  NOT NULL ,
    [Data_modyfikacji] Date  NOT NULL 
)

CREATE TABLE [Dokumenty_ZUS] (
    [ID_dokumenty_ZUS] int  NOT NULL PRIMARY KEY,
    [Nazwa] Varchar(255)  NOT NULL ,
    [Œcie¿ka] Varchar(255)  NULL 
)

ALTER TABLE [Pracownicy] ADD CONSTRAINT FK_Pracownicy_ID_Uzytkownika FOREIGN KEY ([ID_Uzytkownika]) REFERENCES [Uzytkownicy]([ID_Uzytkownika])
ALTER TABLE [Pracownicy] ADD CONSTRAINT FK_Pracownicy_ID_przedsiebiorstwa FOREIGN KEY ([ID_przedsiebiorstwa]) REFERENCES [Przedsiebiorstwo]([ID_przedsiebiorstwa])
ALTER TABLE [Pracownicy] ADD CONSTRAINT FK_Pracownicy_ID_konto_bankowe FOREIGN KEY ([ID_konto_bankowe]) REFERENCES [Konto_Bankowe]([ID_konto_bankowe])
ALTER TABLE [Pracownicy] ADD CONSTRAINT FK_Pracownicy_ID_deklaracjiZUS FOREIGN KEY ([ID_deklaracjiZUS]) REFERENCES [Deklaracje_ZUS]([ID_deklaracjiZUS])
ALTER TABLE [Deklaracje_ZUS] ADD CONSTRAINT FK_Deklaracje_ZUS_ID_status_deklaracji FOREIGN KEY ([ID_status_deklaracji]) REFERENCES [Status_Deklaracji]([ID_status_deklaracji])
ALTER TABLE [Deklaracje_ZUS] ADD CONSTRAINT FK_Deklaracje_ZUS_ID_historia_deklaracji FOREIGN KEY ([ID_historia_deklaracji]) REFERENCES [Historia_deklaracji]([ID_historia_deklaracji])
ALTER TABLE [Deklaracje_ZUS] ADD CONSTRAINT FK_Deklaracje_ZUS_ID_dokumenty_ZUS FOREIGN KEY ([ID_dokumenty_ZUS]) REFERENCES [Dokumenty_ZUS]([ID_dokumenty_ZUS])





--Widoki

CREATE VIEW vw_PracownicyInfo AS
SELECT 
    p.ID_pracownika,
    p.Imie,
    p.Nazwisko,
    p.Rola,
    p.Email,
    p.Telefon,
    u.Nazwa AS NazwaUzytkownika,
    prz.Nazwa_firmy,
    prz.Imiê_W³asciciela,
    prz.Nazwisko_W³aœciciela,
    kb.Nazwa_Banku,
    kb.Numer_konta,
    kb.Numer_rachunku
FROM 
    Pracownicy p
JOIN 
    Uzytkownicy u ON p.ID_Uzytkownika = u.ID_Uzytkownika
JOIN 
    Przedsiebiorstwo prz ON p.ID_przedsiebiorstwa = prz.ID_przedsiebiorstwa
JOIN 
    Konto_Bankowe kb ON p.ID_konto_bankowe = kb.ID_konto_bankowe;



---------------------------------------

CREATE VIEW vw_PrzedsiebiorstwoDeklaracje AS
SELECT 
    prz.ID_przedsiebiorstwa,
    prz.Nazwa_firmy,
    prz.Imiê_W³asciciela,
    prz.Nazwisko_W³aœciciela,
    prz.NIP,
    prz.Adres,
    prz.Email,
    p.ID_deklaracjiZUS,
    dz.Numer_deklaracji,
    dz.Data_z³o¿enia,
    dz.Kwota_emerytalna,
    dz.Kwota_zdrowotna,
    dz.Kwota_chorobowa,
    dz.Kwota_wypadkowa
FROM 
    Przedsiebiorstwo prz
JOIN 
    Pracownicy p ON prz.ID_przedsiebiorstwa = p.ID_przedsiebiorstwa
JOIN 
    Deklaracje_ZUS dz ON p.ID_deklaracjiZUS = dz.ID_deklaracjiZUS;


---------------------------------------------

CREATE VIEW vw_DeklaracjeZUSInfo AS
SELECT 
    dz.ID_deklaracjiZUS,
    dz.Numer_deklaracji,
    dz.Data_z³o¿enia,
    dz.Kwota_emerytalna,
    dz.Kwota_zdrowotna,
    dz.Kwota_chorobowa,
    dz.Kwota_wypadkowa,
    hd.Kwota_emerytalna AS HistoriaKwotaEmerytalna,
    hd.Kwota_zdrowotna AS HistoriaKwotaZdrowotna,
    hd.Kwota_chorobowa AS HistoriaKwotaChorobowa,
    hd.Kwota_wypadkowa AS HistoriaKwotaWypadkowa,
    hd.Data_modyfikacji,
    sd.Data_zmiany_statusu,
    dz.ID_status_deklaracji,
    dz.ID_historia_deklaracji
FROM 
    Deklaracje_ZUS dz
JOIN 
    Historia_deklaracji hd ON dz.ID_historia_deklaracji = hd.ID_historia_deklaracji
JOIN 
    Status_Deklaracji sd ON dz.ID_status_deklaracji = sd.ID_status_deklaracji;


---------------------------------------------

CREATE VIEW vw_DokumentyZUS AS
SELECT
	dz.ID_dokumenty_ZUS,
	dz.Nazwa,
	dz.Œcie¿ka
from
	Dokumenty_ZUS dz;

--procedury


CREATE PROCEDURE AddUzytkownik
    @Nazwa VARCHAR(25),
    @Haslo VARCHAR(50)
AS
BEGIN
    INSERT INTO Uzytkownicy (Nazwa, Haslo)
    VALUES (@Nazwa, @Haslo);
END;

----------------------------------------------------

CREATE PROCEDURE AddPracownik
    @ID_Uzytkownika INT,
    @ID_przedsiebiorstwa INT,
    @ID_konto_bankowe INT,
    @ID_deklaracjiZUS INT,
    @Imie VARCHAR(30),
    @Nazwisko VARCHAR(50),
    @Rola VARCHAR(25),
    @Email VARCHAR(50),
    @Telefon VARCHAR(13)
AS
BEGIN
    INSERT INTO Pracownicy (ID_Uzytkownika, ID_przedsiebiorstwa, ID_konto_bankowe, ID_deklaracjiZUS, Imie, Nazwisko, Rola, Email, Telefon)
    VALUES (@ID_Uzytkownika, @ID_przedsiebiorstwa, @ID_konto_bankowe, @ID_deklaracjiZUS, @Imie, @Nazwisko, @Rola, @Email, @Telefon);
END;

------------------------------------------------


CREATE PROCEDURE DeletePracownik
    @ID_pracownika INT
AS
BEGIN
    DELETE FROM Pracownicy
    WHERE ID_pracownika = @ID_pracownika;
END;

-----------------------------------------------------


CREATE PROCEDURE AddPrzedsiebiorstwo
    @Imiê_W³asciciela VARCHAR(30),
    @Nazwisko_W³aœciciela VARCHAR(50),
    @Nazwa_firmy VARCHAR(255),
    @NIP VARCHAR(10),
    @Adres VARCHAR(100),
    @Email VARCHAR(50)
AS
BEGIN
    INSERT INTO Przedsiebiorstwo (Imiê_W³asciciela, Nazwisko_W³aœciciela, Nazwa_firmy, NIP, Adres, Email)
    VALUES (@Imiê_W³asciciela, @Nazwisko_W³aœciciela, @Nazwa_firmy, @NIP, @Adres, @Email);
END;


--------------------------------------------------

CREATE PROCEDURE DeletePrzedsiebiorstwo
    @ID_przedsiebiorstwa INT
AS
BEGIN
    DELETE FROM Przedsiebiorstwo
    WHERE ID_przedsiebiorstwa = @ID_przedsiebiorstwa;
END;

-------------------------------------------------------------

--triggery

CREATE OR ALTER TRIGGER trg_CheckNazwiskoPracownika
ON Pracownicy
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Nazwisko
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Nazwisko IS NOT NULL
          AND (
                -- Nazwisko musi zaczynaæ siê z du¿ej litery
                NOT (LEFT(inserted.Nazwisko, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]') OR
                -- Nazwisko nie mo¿e zawieraæ cyfr
                PATINDEX('%[0-9]%', inserted.Nazwisko) > 0 OR
                -- Nazwisko nie mo¿e zawieraæ znaków specjalnych
                PATINDEX('%[^a-zA-Z]%', inserted.Nazwisko) > 0
              )
    )
    BEGIN
        RAISERROR ('Nazwisko pracownika musi zaczynaæ siê wielk¹ liter¹ i sk³adaæ siê z samych liter.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
-----------------------------------------------------------------------------------


CREATE OR ALTER TRIGGER CheckImiePracownika
ON Pracownicy
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Imie
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Imie IS NOT NULL
          AND (
                -- Imie musi zaczynaæ siê z du¿ej litery
                NOT (LEFT(inserted.Imie, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]') OR
                -- Imie nie mo¿e zawieraæ cyfr
                PATINDEX('%[0-9]%', inserted.Imie) > 0 OR
                -- Imie nie mo¿e zawieraæ znaków specjalnych
                PATINDEX('%[^a-zA-Z]%', inserted.Imie) > 0
              )
    )
    BEGIN
        RAISERROR ('Imiê pracownika musi zaczynaæ siê wielk¹ liter¹ i sk³adaæ siê z samych liter.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


----------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckEmailPracownika
ON Pracownicy
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Email
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Email IS NOT NULL
          AND (
                -- Email musi zawieraæ znak '@'
                CHARINDEX('@', inserted.Email) = 0 OR
                -- Email nie mo¿e zawieraæ wiêcej ni¿ jednego '@'
                (LEN(inserted.Email) - LEN(REPLACE(inserted.Email, '@', '')) > 1) OR
                -- Email nie mo¿e zaczynaæ siê od znaku '@'
                LEFT(inserted.Email, 1) = '@' OR
                -- Email nie mo¿e koñczyæ siê znakiem '@'
                RIGHT(inserted.Email, 1) = '@'
              )
    )
    BEGIN
        RAISERROR ('Nieprawid³owy format adresu email.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-----------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckTelefonPracownika
ON Pracownicy
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Telefon
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Telefon IS NOT NULL
          AND (
                -- Telefon musi sk³adaæ siê wy³¹cznie z cyfr
                ISNUMERIC(inserted.Telefon + 'e0') = 0 OR
                -- Telefon musi mieæ dok³adnie 9 cyfr
                LEN(inserted.Telefon) <> 9
              )
    )
    BEGIN
        RAISERROR ('Numer telefonu musi sk³adaæ siê z dok³adnie 9 cyfr.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


--------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckNazwaDokumentuZUS
ON Dokumenty_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Nazwa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Nazwa IS NOT NULL
          AND (
                -- Nazwa dokumentu nie mo¿e zawieraæ cyfr
                PATINDEX('%[0-9]%', inserted.Nazwa) > 0 OR
                -- Nazwa dokumentu nie mo¿e zawieraæ znaków specjalnych (poza '-')
                PATINDEX('%[^a-zA-Z- ]%', inserted.Nazwa) > 0
              )
    )
    BEGIN
        RAISERROR ('Nazwa dokumentu musi sk³adaæ siê z samych liter (z mo¿liwoœci¹ u¿ycia myœlnika) i nie mo¿e zawieraæ cyfr ani innych znaków specjalnych.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


----------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckNazwaDokumentuZUS
ON Dokumenty_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Nazwa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Nazwa IS NOT NULL
          AND (
                -- Nazwa dokumentu musi zawieraæ co najmniej jedn¹ literê
                PATINDEX('%[a-zA-Z]%', inserted.Nazwa) = 0 OR
                -- Nazwa dokumentu nie mo¿e zawieraæ cyfr
                PATINDEX('%[0-9]%', inserted.Nazwa) > 0 OR
                -- Nazwa dokumentu nie mo¿e zawieraæ znaków specjalnych oprócz myœlnika '-'
                PATINDEX('%[^a-zA-Z- ]%', inserted.Nazwa) > 0 OR
                -- Nazwa dokumentu nie mo¿e zaczynaæ siê od myœlnika '-'
                LEFT(inserted.Nazwa, 1) = '-' OR
                -- Nazwa dokumentu nie mo¿e koñczyæ siê myœlnikiem '-'
                RIGHT(inserted.Nazwa, 1) = '-'
              )
    )
    BEGIN
        RAISERROR ('Nazwa dokumentu musi zawieraæ co najmniej jedn¹ literê, nie mo¿e zawieraæ cyfr, ani znaków specjalnych (poza myœlnikiem "-"), ani zaczynaæ siê ani koñczyæ myœlnikiem "-".', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


---------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckImieWlasciciela
ON Przedsiebiorstwo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Imiê_W³asciciela
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Imiê_W³asciciela IS NOT NULL
          AND (
                -- Imiê w³aœciciela musi zaczynaæ siê wielk¹ liter¹
                LOWER(LEFT(inserted.Imiê_W³asciciela, 1)) = LEFT(inserted.Imiê_W³asciciela, 1) OR
                -- Imiê w³aœciciela mo¿e zawieraæ tylko litery
                PATINDEX('%[^a-zA-Z]%', inserted.Imiê_W³asciciela) > 0
              )
    )
    BEGIN
        RAISERROR ('Imiê w³aœciciela musi zaczynaæ siê wielk¹ liter¹ i sk³adaæ siê wy³¹cznie z liter.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckNazwiskoWlasciciela
ON Przedsiebiorstwo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Nazwisko_W³asciciela
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Nazwisko_W³aœciciela IS NOT NULL
          AND (
                -- Nazwisko w³aœciciela musi zaczynaæ siê wielk¹ liter¹
                LOWER(LEFT(inserted.Nazwisko_W³aœciciela, 1)) = LEFT(inserted.Nazwisko_W³aœciciela, 1) OR
                -- Nazwisko w³aœciciela mo¿e zawieraæ tylko litery
                PATINDEX('%[^a-zA-Z]%', inserted.Nazwisko_W³aœciciela) > 0
              )
    )
    BEGIN
        RAISERROR ('Nazwisko w³aœciciela musi zaczynaæ siê wielk¹ liter¹ i sk³adaæ siê wy³¹cznie z liter.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


---------------------------------------------------------------------------------


CREATE OR ALTER TRIGGER trg_CheckNIP
ON Przedsiebiorstwo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola NIP
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.NIP IS NOT NULL
          AND (
                -- NIP musi zawieraæ dok³adnie 10 cyfr
                LEN(inserted.NIP) != 10 OR
                -- NIP musi sk³adaæ siê tylko z cyfr
                ISNUMERIC(inserted.NIP + 'e0') = 0
              )
    )
    BEGIN
        RAISERROR ('NIP musi zawieraæ dok³adnie 10 cyfr.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

---------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckAdres
ON Przedsiebiorstwo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Adres
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Adres IS NOT NULL
          AND (
                -- Adres musi byæ w formacie: Kraj, Miasto, Ulica, Kod pocztowy XX-XXX
                PATINDEX('%[A-Za-z¿Ÿæñó³ê¹œ¯Æ¥ŒÊ£ÓÑ0-9 ]+,[A-Za-z¿Ÿæñó³ê¹œ¯Æ¥ŒÊ£ÓÑ0-9 ]+,[A-Za-z¿Ÿæñó³ê¹œ¯Æ¥ŒÊ£ÓÑ0-9 ]+,[0-9]{2}-[0-9]{3}%', inserted.Adres) = 0
              )
    )
    BEGIN
        RAISERROR ('Adres musi byæ w formacie: Kraj, Miasto, Ulica, Kod pocztowy XX-XXX.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckEmail
ON Przedsiebiorstwo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Email
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Email IS NOT NULL
          AND (
                -- Email musi zawieraæ znak '@'
                CHARINDEX('@', inserted.Email) = 0 OR
                -- Email musi zawieraæ co najmniej jeden znak przed '@'
                CHARINDEX('@', inserted.Email) = 1 OR
                -- Email musi zawieraæ co najmniej jeden znak po '@'
                CHARINDEX('@', inserted.Email) = LEN(inserted.Email) OR
                -- Email nie mo¿e mieæ dwóch znaków '@'
                CHARINDEX('@', inserted.Email, CHARINDEX('@', inserted.Email) + 1) > 0 OR
                -- Email nie mo¿e zaczynaæ siê od kropki '.'
                LEFT(inserted.Email, 1) = '.' OR
                -- Email nie mo¿e koñczyæ siê kropk¹ '.'
                RIGHT(inserted.Email, 1) = '.'
              )
    )
    BEGIN
        RAISERROR ('Nieprawid³owy format adresu email.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


-------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckNumerDeklaracji
ON Deklaracje_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Numer_deklaracji
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Numer_deklaracji IS NOT NULL
          AND (
                -- Numer_deklaracji musi sk³adaæ siê tylko z cyfr
                ISNUMERIC(inserted.Numer_deklaracji + 'e0') = 0
              )
    )
    BEGIN
        RAISERROR ('Numer deklaracji musi sk³adaæ siê tylko z cyfr.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckKwotaEmerytalna
ON Deklaracje_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_emerytalna
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_emerytalna IS NOT NULL
          AND (
                -- Kwota_emerytalna musi byæ dodatni¹ liczb¹ ca³kowit¹
                inserted.Kwota_emerytalna <= 0 OR
                -- Kwota_emerytalna musi zawieraæ liczby z koñcówk¹ „z³”
                RIGHT(CAST(inserted.Kwota_emerytalna AS VARCHAR), 2) != ' z³'
              )
    )
    BEGIN
        RAISERROR ('Kwota emerytalna musi byæ dodatni¹ liczb¹ z koñcówk¹ „z³”.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


-------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckKwotaZdrowotna
ON Deklaracje_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_zdrowotna
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_zdrowotna IS NOT NULL
          AND (
                -- Kwota_zdrowotna musi byæ dodatni¹ liczb¹ ca³kowit¹
                inserted.Kwota_zdrowotna <= 0 OR
                -- Kwota_zdrowotna musi zawieraæ liczby z koñcówk¹ „z³”
                RIGHT(CAST(inserted.Kwota_zdrowotna AS VARCHAR), 2) != ' z³'
              )
    )
    BEGIN
        RAISERROR ('Kwota zdrowotna musi byæ dodatni¹ liczb¹ z koñcówk¹ „z³”.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;


----------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckKwotaChorobowa
ON Deklaracje_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_chorobowa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_chorobowa IS NOT NULL
          AND (
                -- Kwota_chorobowa musi byæ dodatni¹ liczb¹ ca³kowit¹
                inserted.Kwota_chorobowa <= 0 OR
                -- Kwota_chorobowa musi zawieraæ liczby z koñcówk¹ „z³”
                RIGHT(CAST(inserted.Kwota_chorobowa AS VARCHAR), 2) != ' z³'
              )
    )
    BEGIN
        RAISERROR ('Kwota chorobowa musi byæ dodatni¹ liczb¹ z koñcówk¹ „z³”.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

------------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckKwotaWypadkowa
ON Deklaracje_ZUS
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_wypadkowa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_wypadkowa IS NOT NULL
          AND (
                -- Kwota_wypadkowa musi byæ dodatni¹ liczb¹ ca³kowit¹
                inserted.Kwota_wypadkowa <= 0 OR
                -- Kwota_wypadkowa musi zawieraæ liczby z koñcówk¹ „z³”
                RIGHT(CAST(inserted.Kwota_wypadkowa AS VARCHAR), 2) != ' z³'
              )
    )
    BEGIN
        RAISERROR ('Kwota wypadkowa musi byæ dodatni¹ liczb¹ z koñcówk¹ „z³”.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

----------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckKwotaEmerytalnaa
ON Historia_deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_emerytalna
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_emerytalna IS NULL
          OR TRY_CONVERT(INT, inserted.Kwota_emerytalna) IS NULL
    )
    BEGIN
        RAISERROR ('Kwota emerytalna musi byæ liczb¹ ca³kowit¹.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

--------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckKwotaZdrowotnaa
ON Historia_deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_zdrowotna
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_zdrowotna IS NULL
          OR TRY_CONVERT(INT, inserted.Kwota_zdrowotna) IS NULL
    )
    BEGIN
        RAISERROR ('Kwota zdrowotna musi byæ liczb¹ ca³kowit¹.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

--------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckKwotaChorobowaa
ON Historia_deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_chorobowa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_chorobowa IS NULL
          OR TRY_CONVERT(INT, inserted.Kwota_chorobowa) IS NULL
    )
    BEGIN
        RAISERROR ('Kwota chorobowa musi byæ liczb¹ ca³kowit¹.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

----------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckKwotaWypadkowaa
ON Historia_deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Kwota_wypadkowa
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Kwota_wypadkowa IS NULL
          OR TRY_CONVERT(INT, inserted.Kwota_wypadkowa) IS NULL
    )
    BEGIN
        RAISERROR ('Kwota wypadkowa musi byæ liczb¹ ca³kowit¹.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckDataModyfikacji
ON Historia_deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Data_modyfikacji
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Data_modyfikacji IS NULL
          OR TRY_CONVERT(DATE, inserted.Data_modyfikacji, 126) IS NULL
    )
    BEGIN
        RAISERROR ('Data modyfikacji musi byæ w formacie YYYY-MM-DD.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

--------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckDataZmianyStatusu
ON Status_Deklaracji
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Data_zmiany_statusu
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Data_zmiany_statusu IS NOT NULL
          AND TRY_CONVERT(DATE, inserted.Data_zmiany_statusu, 126) IS NULL
    )
    BEGIN
        RAISERROR ('Data zmiany statusu musi byæ w formacie YYYY-MM-DD.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

---------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckNumerKonta
ON Konto_Bankowe
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Numer_konta
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE TRY_CONVERT(BIGINT, inserted.Numer_konta) IS NULL
          OR LEN(inserted.Numer_konta) > 30
    )
    BEGIN
        RAISERROR ('Numer konta musi zawieraæ tylko liczby i mieæ d³ugoœæ do 30 znaków.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_CheckNazwaBanku
ON Konto_Bankowe
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Nazwa_Banku
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE inserted.Nazwa_Banku IS NULL
          OR inserted.Nazwa_Banku = ''
    )
    BEGIN
        RAISERROR ('Nazwa banku nie mo¿e byæ pusta.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-------------------------------------------------------------------------------------------
CREATE OR ALTER TRIGGER trg_CheckNumerRachunku
ON Konto_Bankowe
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sprawdzenie warunków dla pola Numer_rachunku
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE TRY_CONVERT(BIGINT, inserted.Numer_rachunku) IS NULL
          OR LEN(inserted.Numer_rachunku) > 30
    )
    BEGIN
        RAISERROR ('Numer rachunku musi zawieraæ tylko liczby i mieæ d³ugoœæ do 30 znaków.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;

-----------------------------------------------------------------------------------------




INSERT INTO Przedsiebiorstwo (ID_przedsiebiorstwa, Imiê_W³asciciela, Nazwisko_W³aœciciela, Nazwa_firmy, NIP, Adres, Email) VALUES
(1, 'Jan', 'Kowalski', 'Firma Kowalski', '1234567890', 'Polska Warszawa Ulica Przykladowa  01-234', 'jan.kowalski@firmakowalski.pl'),
(2, 'Anna', 'Nowak', 'Firma Nowak', '2345678901', 'Polska Warszawa Ulica Przyk³ad 2 01-234', 'anna.nowak@firmanowak.pl'),
(3, 'Piotr', 'Wiœniewski', 'Firma Wiœniewski', '3456789012', 'Polska Warszawa Ulica Przyk³ad 3,  01-234', 'piotr.wisniewski@firmawisniewski.pl'),
(4, 'Katarzyna', 'Wójcik', 'Firma Wójcik', '4567890123', 'Polska Warszawa, Ulica Przyk³ad 4,   01-234', 'katarzyna.wojcik@firmawojcik.pl'),
(5, 'Tomasz', 'Kowalczyk', 'Firma Kowalczyk', '5678901234', 'Polska Warszawa Ulica Przyk³ad 5   01-234', 'tomasz.kowalczyk@firmakowalczyk.pl');



INSERT INTO Pracownicy (ID_pracownika, ID_Uzytkownika, ID_przedsiebiorstwa, ID_konto_bankowe, ID_deklaracjiZUS, Imie, Nazwisko, Rola, Email, Telefon)
VALUES (1, 1, 1, 1, 1, 'Adam', 'Nowak', 'Manager', 'adam.nowak@example.com', '123456789'),
       (2, 2, 2, 2, 2, 'Ewa', 'Kowalska', 'HR', 'ewa.kowalska@example.com', '234567890'),
       (3, 3, 3, 3, 3, 'Piotr', 'Wiœniewski', 'IT', 'piotr.wisniewski@example.com', '345678901'),
       (4, 4, 4, 4, 4, 'Anna', 'Wójcik', 'Finance', 'anna.wojcik@example.com', '456789012'),
       (5, 5, 5, 5, 5, 'Tomasz', 'Kowalczyk', 'Admin', 'tomasz.kowalczyk@example.com', '567890123');




INSERT INTO Konto_Bankowe (ID_konto_bankowe, Numer_konta, Nazwa_Banku, Numer_rachunku)
VALUES (1, '12345678901234567890123456', 'Bank A', '123456'),
       (2, '22345678901234567890123456', 'Bank B', '223456'),
       (3, '32345678901234567890123456', 'Bank C', '323456'),
       (4, '42345678901234567890123456', 'Bank D', '423456'),
       (5, '52345678901234567890123456', 'Bank E', '523456');


INSERT INTO Deklaracje_ZUS (ID_deklaracjiZUS, ID_status_deklaracji, ID_historia_deklaracji, ID_dokumenty_ZUS, Numer_deklaracji, Data_z³o¿enia, Kwota_emerytalna, Kwota_zdrowotna, Kwota_chorobowa, Kwota_wypadkowa) VALUES
(1, 1, 1, 1, 101, '2024-01-01', 1000, 500, 200, 100),
(2, 2, 2, 2, 102, '2024-02-01', 1100, 550, 220, 110),
(3, 3, 3, 3, 103, '2024-03-01', 1200, 600, 240, 120),
(4, 4, 4, 4, 104, '2024-04-01', 1300, 650, 260, 130),
(5, 5, 5, 5, 105, '2024-05-01', 1400, 700, 280, 140);

INSERT INTO Dokumenty_ZUS (ID_dokumenty_ZUS, Nazwa, Œcie¿ka) VALUES
(1, 'Dokument A', 'C:\\Dokumenty\\DokumentA.pdf'),
(2, 'Dokument B', 'C:\\Dokumenty\\DokumentB.pdf'),
(3, 'Dokument C', 'C:\\Dokumenty\\DokumentC.pdf'),
(4, 'Dokument D', 'C:\\Dokumenty\\DokumentD.pdf'),
(5, 'Dokument E', 'C:\\Dokumenty\\DokumentE.pdf');


INSERT INTO Historia_deklaracji (ID_historia_deklaracji, Kwota_emerytalna, Kwota_zdrowotna, Kwota_chorobowa, Kwota_wypadkowa, Data_modyfikacji) VALUES
(1, 1000, 500, 200, 100, '2024-01-01'),
(2, 1100, 550, 220, 110, '2024-02-01'),
(3, 1200, 600, 240, 120, '2024-03-01'),
(4, 1300, 650, 260, 130, '2024-04-01'),
(5, 1400, 700, 280, 140, '2024-05-01');

INSERT INTO Status_Deklaracji (ID_status_deklaracji, Data_zmiany_statusu) VALUES
(1, '2024-01-01'),
(2, '2024-02-01'),
(3, '2024-03-01'),
(4, '2024-04-01'),
(5, '2024-05-01');

INSERT INTO Uzytkownicy (ID_Uzytkownika, Nazwa, Haslo) VALUES
(1, 'user1', 'password1'),
(2, 'user2', 'password2'),
(3, 'user3', 'password3'),
(4, 'user4', 'password4'),
(5, 'user5', 'password5');