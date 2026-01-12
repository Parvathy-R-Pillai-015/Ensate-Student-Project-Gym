# MySQL Installation Guide for Windows

## Option 1: MySQL Installer (Recommended)

1. **Download MySQL Installer**
   - Visit: https://dev.mysql.com/downloads/installer/
   - Download: mysql-installer-community-8.0.x.x.msi (larger file ~400MB)

2. **Run the Installer**
   - Choose "Custom" installation type
   - Select these products:
     * MySQL Server 8.0.x
     * MySQL Workbench (optional GUI tool)
     * MySQL Shell (optional)

3. **Configure MySQL Server**
   - Type and Networking: Default (Port 3306)
   - Authentication: Use Strong Password Encryption
   - Set Root Password: Remember this password!
   - Windows Service: Yes, start at system startup
   - Service Name: MySQL80

4. **Complete Installation**
   - Execute the configuration
   - Finish the installation

## Option 2: Using Chocolatey (Package Manager)

If you have Chocolatey installed:

```powershell
choco install mysql
```

## After Installation

### Verify Installation

```powershell
mysql --version
```

### Access MySQL

```powershell
mysql -u root -p
```
(Enter the root password you set during installation)

## Create GymFit Database

Once MySQL is installed, run these commands in MySQL:

```sql
-- Create database
CREATE DATABASE gymfit_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user (optional, or use root)
CREATE USER 'gymfit_user'@'localhost' IDENTIFIED BY 'GymFit@123';

-- Grant permissions
GRANT ALL PRIVILEGES ON gymfit_db.* TO 'gymfit_user'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;
```

## Update .env File

After creating the database, create `.env` file in backend folder:

```env
DB_NAME=gymfit_db
DB_USER=root
DB_PASSWORD=your_mysql_root_password
DB_HOST=localhost
DB_PORT=3306
```

## Install MySQL Python Client

```powershell
cd "c:\GYM PROJECT\gymfit-backend"
.\venv\Scripts\Activate.ps1
pip install mysqlclient
```

## Troubleshooting

### mysqlclient installation fails?

Install Microsoft Visual C++ 14.0 or use wheel:
```powershell
pip install https://download.lfd.uci.edu/pythonlibs/archived/mysqlclient-2.2.0-cp312-cp312-win_amd64.whl
```

Or use PyMySQL as alternative:
```powershell
pip install pymysql
```

Then add to gymfit/settings.py:
```python
import pymysql
pymysql.install_as_MySQLdb()
```
