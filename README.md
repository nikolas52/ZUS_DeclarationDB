# 📊 ZUS_Pustelnik Database

A Microsoft SQL Server–based system for managing companies, employees, bank accounts, and ZUS declarations, featuring views, triggers, and stored procedures for robust data operations and validation.

----------

## 📋 Project Overview

The `ZUS_Pustelnik` database is a comprehensive solution for handling:

-   Company and employee records
    
-   ZUS declaration lifecycle
    
-   Bank account and document metadata
    
-   Integrated data validation through triggers
    
-   Predefined views and stored procedures for rapid access
    

All logic is encapsulated within a single SQL script, enabling seamless setup and usage.

----------

## 🗂️ Database Structure

### 🧱 Tables

-   **Uzytkownicy** – User credentials (`ID_Uzytkownika`, `Nazwa`, `Haslo`)
    
-   **Pracownicy** – Employee details and roles
    
-   **Przedsiebiorstwo** – Company profiles with NIP, address, and contact info
    
-   **Konto_Bankowe** – Bank account identifiers and metadata
    
-   **Deklaracje_ZUS** – Main table for ZUS declarations with financial data
    
-   **Status_Deklaracji** – Declaration status tracking
    
-   **Historia_deklaracji** – Historical data log per declaration
    
-   **Dokumenty_ZUS** – Metadata for document attachments
    

### 👁️ Views

-   `vw_PracownicyInfo` – Employee with account, user, and company details
    
-   `vw_PrzedsiebiorstwoDeklaracje` – Company + ZUS declaration overview
    
-   `vw_DeklaracjeZUSInfo` – Complete declaration data (status + history)
    
-   `vw_DokumentyZUS` – Document listing and metadata
    

### ⚙️ Stored Procedures

-   `AddUzytkownik` – Add user
    
-   `AddPracownik` – Add employee
    
-   `DeletePracownik` – Remove employee
    
-   `AddPrzedsiebiorstwo` – Register company
    
-   `DeletePrzedsiebiorstwo` – Remove company
    

### 🚨 Triggers

Validation rules on insert/update:

-   Capitalized names, letters only
    
-   Proper email and phone number formatting
    
-   NIP must have exactly 10 digits
    
-   Postal code in format `XX-XXX`
    
-   Positive declaration amounts only
    
-   Valid account numbers and document naming enforced
    

----------

## 🧩 Installation & Setup

### 🔻 Download the Project

Option 1 – **Clone via Git**:
```bash
git clone https://github.com/your-username/ZUS_Pustelnik.git 
cd ZUS_Pustelnik` 
```
Option 2 – **Download ZIP**:

-   Go to the repository page on GitHub
    
-   Click **Code > Download ZIP**
    
-   Extract to your local drive
    

----------

### 🛠️ Execute the SQL Script

1.  Open `ZUS_Pustelnik.sql` in **SQL Server Management Studio (SSMS)**
    
2.  Ensure your SQL Server instance is running
    
3.  Update file paths in the `CREATE DATABASE` section:
    
   ```sql
FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ZUS_Pustelnik.mdf' 
FILENAME =  'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\ZUS_Pustelnik_log.ldf'
```
4.  Execute the full script (`Ctrl + F5`) to:
    
    -   Drop existing DB (if exists)
        
    -   Create `ZUS_Pustelnik` database
        
    -   Create schema, relationships, views, triggers
        
    -   Insert sample data
        
5.  Refresh your **Databases** list in SSMS
    
6.  Run test queries:
    
```sql
SELECT  *  FROM vw_PracownicyInfo; EXEC AddUzytkownik @ID_Uzytkownika  =  99, @Nazwa  =  'test', @Haslo  =  'pass123';
```
    

----------

## 🚀 Usage Examples

```sql

`-- Add a new user  EXEC AddUzytkownik @ID_Uzytkownika  =  10, @Nazwa  =  'admin', @Haslo  =  'securepass123'; -- Insert a company  EXEC AddPrzedsiebiorstwo @ID_przedsiebiorstwa  =  3, @Imię_Własciciela =  'Jan', @Nazwisko_Właściciela =  'Kowalski', @Nazwa_firmy  =  'Firma Z', @NIP  =  '1234567890', @Adres  =  'Polska, Warszawa, ul. Długa 12, 00-001', @Email  =  'kontakt@firmaZ.pl';` 
```
----------

## 🛠️ Requirements

-   Microsoft SQL Server 2019+
    
-   SSMS or compatible SQL client
    
-   Permissions to create/modify databases
    
-   Disk space: ~10MB data, 5MB log (initial)
    

----------

## ⚠️ Notes

-   File growth: fixed 5MB increments
    
-   All triggers validate data on `INSERT`/`UPDATE`
    
-   Transactions will be **rolled back** if data fails validation
    
-   Included sample data is for testing only
    

----------

## 📄 License

Licensed under the MIT License.
