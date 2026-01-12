import pyodbc

print("=" * 60)
print("SQL Server ODBC Driver Check")
print("=" * 60)

# List all available ODBC drivers
drivers = [driver for driver in pyodbc.drivers()]

print("\n✅ Available ODBC Drivers:")
for driver in drivers:
    if 'SQL Server' in driver:
        print(f"   • {driver}")

if not any('SQL Server' in d for d in drivers):
    print("   ⚠️  No SQL Server ODBC drivers found!")
    print("   📥 Download: https://go.microsoft.com/fwlink/?linkid=2249004")

print("\n" + "=" * 60)
print("Connection String Examples:")
print("=" * 60)

print("\n1️⃣  Windows Authentication:")
print("   DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=gymfit_db;Trusted_Connection=yes;")

print("\n2️⃣  SQL Server Authentication:")
print("   DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=gymfit_db;UID=sa;PWD=your_password;")

print("\n" + "=" * 60)
print("Next Steps:")
print("=" * 60)
print("1. Open SQL Server Management Studio (SSMS)")
print("2. Connect to your SQL Server instance")
print("3. Run: CREATE DATABASE gymfit_db;")
print("4. Copy .env.example to .env and update credentials")
print("5. Run: python manage.py migrate")
print("=" * 60)
