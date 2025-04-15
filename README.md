# ZUS Declaration Database

## 📘 Overview

The **ZUS** database is designed to manage information related to employees, companies, bank accounts, and ZUS (Polish Social Insurance Institution) declarations. It includes **tables**, **views**, **stored procedures**, and **triggers** to ensure data integrity and facilitate common operations.

---

## 🧱 Database Structure

### 📂 Tables

- **Uzytkownicy (Users)**  
  Stores user credentials.  
  Columns: `ID_Uzytkownika`, `Nazwa`, `Haslo`

- **Pracownicy (Employees)**  
  Stores employee details.  
  Columns: `ID_pracownika`, `ID_Uzytkownika`, `ID_przedsiebiorstwa`, `ID_konto_bankowe`, `ID_deklaracjiZUS`, `Imie`, `Nazwisko`, `Rola`, `Email`, `Telefon`

- **Przedsiebiorstwo (Companies)**  
  Stores company information.  
  Columns: `ID_przedsiebiorstwa`, `Imię_Własciciela`, `Nazwisko_Właściciela`, `Nazwa_firmy`, `NIP`, `Adres`, `Email`

- **Konto_Bankowe (Bank Accounts)**  
  Stores bank account details.  
  Columns: `ID_konto_bankowe`, `Numer_konta`, `Nazwa_Banku`, `Numer_rachunku`

- **Deklaracje_ZUS (ZUS Declarations)**  
  Stores ZUS declaration data.  
  Columns: `ID_deklaracjiZUS`, `ID_status_deklaracji`, `ID_historia_deklaracji`, `ID_dokumenty_ZUS`, `Numer_deklaracji`, `Data_złożenia`, `Kwota_emerytalna`, `Kwota_zdrowotna`, `Kwota_chorobowa`, `Kwota_wypadkowa`

- **Status_Deklaracji (Declaration Status)**  
  Tracks declaration status changes.  
  Columns: `ID_status_deklaracji`, `Data_zmiany_statusu`

- **Historia_deklaracji (Declaration History)**  
  Logs historical declaration data.  
  Columns: `ID_historia_deklaracji`, `Kwota_emerytalna`, `Kwota_zdrowotna`, `Kwota_chorobowa`, `Kwota_wypadkowa`, `Data_modyfikacji`

- **Dokumenty_ZUS (ZUS Documents)**  
  Stores document metadata.  
  Columns: `ID_dokumenty_ZUS`, `Nazwa`, `Ścieżka`

---

### 👁️ Views

- `vw_PracownicyInfo`: Combines employee, user, company, and bank account details  
- `vw_PrzedsiebiorstwoDeklaracje`: Links companies with their ZUS declarations  
- `vw_DeklaracjeZUSInfo`: Provides detailed ZUS declaration information, including history and status  
- `vw_DokumentyZUS`: Lists ZUS document details  

---

### ⚙️ Stored Procedures

- `AddUzytkownik`: Adds a new user  
- `AddPracownik`: Adds a new employee  
- `DeletePracownik`: Deletes an employee by ID  
- `AddPrzedsiebiorstwo`: Adds a new company  
- `DeletePrzedsiebiorstwo`: Deletes a company by ID  

---

### 🧪 Triggers

Triggers enforce data validation rules, including:

- Names must start with capital letters and contain only letters  
- Valid email formats  
- Phone numbers must be 9 digits  
- NIP must contain exactly 10 digits  
- Address format: _Country, City, Street, Postal Code XX-XXX_  
- Declaration amounts must be positive integers  
- Valid bank account numbers and document names  

---

## ⚙️ Setup Instructions

### 1. Create Database
Run the SQL script to create the `ZUS_Pustelnik` database.  
> 📌 Ensure the file paths for `.mdf` and `.ldf` are valid on your system.

### 2. Create Tables and Relationships
Execute the `CREATE TABLE` and `ALTER TABLE` statements to set up tables and foreign keys.

### 3. Create Views, Procedures, and Triggers
Run the appropriate SQL code blocks for views, procedures, and triggers.

### 4. Insert Sample Data
Use the provided `INSERT INTO` statements to populate tables for testing.

---

## 🚀 Usage

### Querying Data
Use views like `vw_PracownicyInfo` and `vw_PrzedsiebiorstwoDeklaracje` for common queries.

### Managing Data
Use stored procedures (e.g., `AddUzytkownik`, `AddPracownik`) for secure data manipulation.

### Data Validation
Triggers automatically enforce rules during `INSERT` and `UPDATE` operations.

---

## 🖥️ Requirements

- Microsoft SQL Server (e.g., SQL Server Express 2022 or later)  
- Sufficient disk space (initial: 10MB, max: 200MB for data, 100MB for log)  
- Permissions to create and manage databases  

---

## 📝 Notes

- The database uses **fixed file growth of 5MB** for efficient storage management  
- Triggers may **rollback transactions** if validation rules fail — ensure data conforms  
- Sample data is intended for testing; replace it with real data in production

---

## 📄 License

This project is licensed under the **MIT License**.
