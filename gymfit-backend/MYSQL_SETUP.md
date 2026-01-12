# MySQL Setup for GymFit Backend

## ✅ MySQL is already installed and running!

## Step 1: Access MySQL

Try these methods to access MySQL:

### Method 1: MySQL Workbench (GUI)
1. Search for "MySQL Workbench" in Windows Start Menu
2. If installed, open it and connect to localhost
3. Run this query:
```sql
CREATE DATABASE IF NOT EXISTS gymfit_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### Method 2: Command Line (Find MySQL Path)

MySQL might be installed at one of these locations:
- `C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`
- `C:\Program Files (x86)\MySQL\MySQL Server 8.0\bin\mysql.exe`
- `C:\ProgramData\MySQL\MySQL Server 8.0\bin\mysql.exe`

Try running (replace with actual path):
```powershell
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p
```

Then enter:
```sql
CREATE DATABASE gymfit_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SHOW DATABASES;
```

## Step 2: Find MySQL Root Password

If you don't remember the password:
1. Check if password is empty (just press Enter when prompted)
2. Or check MySQL installation notes
3. Or reset password following MySQL documentation

## Step 3: Create .env File

```powershell
cd "c:\GYM PROJECT\gymfit-backend"
copy .env.example .env
```

Edit `.env` file:
```env
DB_NAME=gymfit_db
DB_USER=root
DB_PASSWORD=your_mysql_root_password
DB_HOST=localhost
DB_PORT=3306
```

## Step 4: Test Connection

```powershell
cd "c:\GYM PROJECT\gymfit-backend"
.\venv\Scripts\Activate.ps1
python -c "import MySQLdb; print('MySQL client installed successfully!')"
```

## Step 5: Run Django Migrations

After database is created:
```powershell
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

## Quick Database Creation SQL

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS gymfit_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Verify
SHOW DATABASES LIKE 'gymfit_db';

-- Use it
USE gymfit_db;

-- Show tables (should be empty initially)
SHOW TABLES;
```
