#!/bin/bash

# === Configuration ===
DB_NAME="ignite_db"
DB_USER="jonasgacayan"
SQL_FILE="/Users/jonasgacayan/Documents/INFOMAN-2026/employees.sql"
QUERY_VALUE="John"

# === Step 1: Connect to DB and create table ===
psql -U $DB_USER -d $DB_NAME <<EOF
CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE
);
EOF

# === Step 2: Insert mock data 10 times ===
echo "Inserting mock data 10 times..."
for i in {1..10}
do
    echo "Batch $i..."
    psql -U $DB_USER -d $DB_NAME -f $SQL_FILE
done

# === Step 3: Verify row count ===
echo "Total rows in employees table:"
psql -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM employees;"

# === Step 4: Query without index ===
echo "EXPLAIN ANALYZE without index:"
psql -U $DB_USER -d $DB_NAME -c "EXPLAIN ANALYZE SELECT * FROM employees WHERE first_name = '$QUERY_VALUE';"

# === Step 5: Create index ===
echo "Creating index on first_name..."
psql -U $DB_USER -d $DB_NAME -c "CREATE INDEX IF NOT EXISTS idx_first_name ON employees(first_name);"

# === Step 6: Query with index ===
echo "EXPLAIN ANALYZE with index:"
psql -U $DB_USER -d $DB_NAME -c "EXPLAIN ANALYZE SELECT * FROM employees WHERE first_name = '$QUERY_VALUE';"

# === Step 7: Insert a single row ===
echo "Inserting a single row..."
psql -U $DB_USER -d $DB_NAME -c "INSERT INTO employees (first_name, salary, hire_date) VALUES ('Alice', 50000, '2026-01-01');"