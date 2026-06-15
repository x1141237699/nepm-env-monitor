# -*- coding: utf-8 -*-
import subprocess
import os
import sys

MYSQL = r"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def run_sql_file(filename):
    path = os.path.join(BASE, "sql", filename)
    with open(path, "r", encoding="utf-8") as f:
        sql = f.read()
    result = subprocess.run(
        [MYSQL, "-u", "root", "-proot", "--default-character-set=utf8mb4"],
        input=sql.encode("utf-8"),
        capture_output=True,
    )
    if result.returncode != 0:
        sys.stderr.write(result.stderr.decode("utf-8", errors="replace"))
        raise SystemExit(result.returncode)
    print(f"OK: {filename}")

def verify():
    result = subprocess.run(
        [MYSQL, "-u", "root", "-proot", "--default-character-set=utf8mb4", "-N", "-e",
         "USE nepm_db; "
         "SELECT CONCAT('supervisor=', supervisor_name) FROM supervisor LIMIT 1; "
         "SELECT CONCAT('province=', province_name) FROM grid_province LIMIT 1; "
         "SELECT CONCAT('city=', city_name) FROM grid_city LIMIT 1; "
         "SELECT CONCAT('member=', member_name) FROM grid_member LIMIT 1; "
         "SELECT CONCAT('feedback=', grid_address) FROM supervisor_feedback LIMIT 1;"],
        capture_output=True,
    )
    print(result.stdout.decode("utf-8"))

if __name__ == "__main__":
    run_sql_file(sys.argv[1] if len(sys.argv) > 1 else "fix-encoding.sql")
    verify()
