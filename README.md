# ZUS_Pustelnik Database

## Overview

The `ZUS_Pustelnik` database is designed to manage information related to employees, companies, bank accounts, and ZUS (Polish Social Insurance Institution) declarations. It includes tables, views, stored procedures, and triggers to ensure data integrity and facilitate common operations.

## Database Structure

### Tables

1. **Uzytkownicy (Users)**: Stores user credentials.
   - Columns: `ID_Uzytkownika`, `Nazwa`, `Haslo`
2. **Pracownicy (Employees)**: Stores employee details.
   - Columns: `ID_pracownika`, `ID_Uzytkownika`, `ID_przedsiebiorstwa`, `ID_konto_bankowe`, `ID_deklaracjiZUS`, `Imie`, `Nazwisko`, `Rola`, `Email`, `Telefon`
3. **Przedsiebiorstwo (Companies)**: Stores company information.
   - Columns: `ID_przedsiebiorstwa`, `Imię_Własciciela`, `Nazwisko_Właściciela`, `Nazwa_firmy`, `NIP`, `Adres`, `Email`
4. **Konto_Bankowe (Bank Accounts)**: Stores bank account details.
   - Columns: `ID_konto_bankowe`, `Numer_konta`, `Nazwa_Banku`, `Numer_rachunku`
5. **Deklaracje_ZUS (ZUS Declarations)**: Stores ZUS declaration data.
   - Columns: `ID_deklaracjiZUS`, `ID_status_deklaracji`, `ID_historia_deklaracji`, `ID_dokumenty_ZUS`, `Numer_deklaracji`, `Data_złożenia`, `Kwota_emerytalna`, `Kwota_zdrowotna`, `Kwota_chorobowa`, `Kwota_wypadkowa`
6. **Status_Deklaracji (Declaration Status)**: Tracks declaration status changes.
   - Columns: `ID_status_deklaracji`, `Data_zmiany_statusu`
7. **Historia_deklaracji (Declaration History)**: Logs historical declaration data.
   - Columns: `ID_historia_deklaracji`, `Kwota_emerytalna`, `Kwota_zdrowotna`, `Kwota_chorobowa`, `Kwota_wypadkowa`, `Data_modyfikacji`
8. **Dokumenty_ZUS (ZUS Documents)**: Stores document metadata.
   - Columns: `ID_dokumenty_ZUS`, `Nazwa`, `Ścieżka`

### Views

- **vw_PracownicyInfo**: Combines employee, user, company, and bank account details.
- **vw_PrzedsiebiorstwoDeklaracje**: Links companies with their ZUS declarations.
- **vw_DeklaracjeZUSInfo**: Provides detailed ZUS declaration information, including history and status.
- **vw_DokumentyZUS**: Lists ZUS document details.

### Stored Procedures

- **AddUzytkownik**: Adds a new user.
- **AddPracownik**: Adds a new employee.
- **DeletePracownik**: Deletes an employee by ID.
- **AddPrzedsiebiorstwo**: Adds a new company.
- **DeletePrzedsiebiorstwo**: Deletes a company by ID.

### Triggers

Triggers enforce data validation rules, including:

- Ensuring names start with capital letters and contain only letters.
- Validating email formats.
- Checking phone numbers (9 digits).
- Ensuring NIP contains exactly 10 digits.
- Validating address format (Country, City, Street, Postal Code XX-XXX).
- Ensuring declaration amounts are positive integers.
- Validating bank account numbers and document names.

## Setup Instructions

1. **Create Database**:
   - Run the SQL script to create the `ZUS_Pustelnik` database.
   - Ensure the file paths for `.mdf` and `.ldf` files are valid on your system.
2. **Create Tables and Relationships**:
   - Execute the table creation and `ALTER TABLE` statements to set up foreign key constraints.
3. **Create Views, Procedures, and Triggers**:
   - Run the respective sections to create views, stored procedures, and triggers.
4. **Insert Sample Data**:
   - Use the provided `INSERT` statements to populate the database with sample data.

## Usage

- **Querying Data**:
  - Use the views (`vw_PracownicyInfo`, `vw_PrzedsiebiorstwoDeklaracje`, etc.) for common queries.
- **Managing Data**:
  - Use stored procedures (`AddUzytkownik`, `AddPracownik`, etc.) for safe data insertion and deletion.
- **Data Validation**:
  - Triggers automatically enforce data integrity rules during `INSERT` and `UPDATE` operations.

## Requirements

- Microsoft SQL Server (e.g., SQL Server Express 2022 or later).
- Sufficient disk space for database files (initial size: 10MB, max: 200MB for data, 100MB for log).
- Proper permissions to create and manage databases.

## Notes

- The database is configured with a fixed file growth of 5MB to manage storage efficiently.
- Triggers may roll back transactions if validation rules are violated, so ensure input data complies with constraints.
- Sample data is provided for testing purposes and should be replaced with real data in production.

## License

This project is licensed under the MIT License.
