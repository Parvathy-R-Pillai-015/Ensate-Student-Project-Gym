# SQL Server Setup for GymFit Backend

## Prerequisites
✅ You already have SQL Server Management Studio (SSMS) installed!

## Step 1: Create Database in SQL Server

1. **Open SQL Server Management Studio (SSMS)**

2. **Connect to your SQL Server instance**
   - Server name: `localhost` or `(local)` or `.\SQLEXPRESS`
   - Authentication: Windows Authentication (or SQL Server Authentication if configured)

3. **Create the Database**
   
   Run this query in SSMS:
   ```sql
   -- Create database
   CREATE DATABASE gymfit_db;
   GO
   
   -- Verify
   SELECT name FROM sys.databases WHERE name = 'gymfit_db';
   ```

## Step 2: Enable SQL Server Authentication (if needed)

If using SQL Server Authentication with 'sa' user:

```sql
-- Enable SQL Server Authentication
USE master;
GO

-- Set sa password (change 'YourStrongPassword123!' to your password)
ALTER LOGIN sa WITH PASSWORD = 'YourStrongPassword123!';
ALTER LOGIN sa ENABLE;
GO
```

Or create a new user specifically for the app:

```sql
USE master;
GO

-- Create login
CREATE LOGIN gymfit_user WITH PASSWORD = 'GymFit@2026!';
GO

-- Switch to database
USE gymfit_db;
GO

-- Create user and grant permissions
CREATE USER gymfit_user FOR LOGIN gymfit_user;
ALTER ROLE db_owner ADD MEMBER gymfit_user;
GO
```

## Step 3: Install ODBC Driver

**Check if ODBC Driver 17 is installed:**

Run in PowerShell:
```powershell
Get-OdbcDriver | Where-Object {$_.Name -like "*SQL Server*"}
```

**If not installed, download:**
- ODBC Driver 17: https://docs.microsoft.com/en-us/sql/connect/odbc/download-odbc-driver-for-sql-server
- Or ODBC Driver 18 (latest): https://go.microsoft.com/fwlink/?linkid=2249004

## Step 4: Install Python Packages

```powershell
cd "c:\GYM PROJECT\gymfit-backend"
.\venv\Scripts\Activate.ps1
pip install mssql-django pyodbc
```

## Step 5: Create .env File

Copy `.env.example` to `.env`:
```powershell
copy .env.example .env
```

Edit `.env` with your SQL Server credentials:

**For Windows Authentication:**
```env
DB_NAME=gymfit_db
DB_USER=
DB_PASSWORD=
DB_HOST=localhost
DB_PORT=1433
DB_DRIVER=ODBC Driver 17 for SQL Server
```

**For SQL Server Authentication (sa or custom user):**
```env
DB_NAME=gymfit_db
DB_USER=sa
DB_PASSWORD=YourStrongPassword123!
DB_HOST=localhost
DB_PORT=1433
DB_DRIVER=ODBC Driver 17 for SQL Server
```

## Step 6: Test Connection

In SSMS, verify you can connect to the database:
```sql
USE gymfit_db;
GO

SELECT DB_NAME() AS CurrentDatabase;
```

## Common SQL Server Instance Names

Your server name might be:
- `localhost`
- `(local)`
- `.\SQLEXPRESS` (if using SQL Server Express)
- `localhost\SQLEXPRESS`
- Your computer name: `COMPUTERNAME\SQLEXPRESS`

## Troubleshooting

### Connection Issues

1. **SQL Server Browser Service**
   - Open Services (Win + R → `services.msc`)
   - Find "SQL Server Browser"
   - Set to "Automatic" and Start it

2. **TCP/IP Protocol**
   - Open SQL Server Configuration Manager
   - SQL Server Network Configuration → Protocols
   - Enable TCP/IP
   - Restart SQL Server service

3. **Firewall**
   ```powershell
   New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
   ```

### Check ODBC Drivers

```powershell
# List all ODBC drivers
Get-OdbcDriver

# Should see something like:
# ODBC Driver 17 for SQL Server
# ODBC Driver 18 for SQL Server
```

## Next Steps

After database is created:
1. Run Django migrations: `python manage.py migrate`
2. Create superuser: `python manage.py createsuperuser`
3. Run server: `python manage.py runserver`
