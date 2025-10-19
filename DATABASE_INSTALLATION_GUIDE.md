# Database Installation Guide - QB-CargoHeist

## 📋 Overview

This guide will help you install the database schema for the Cargo Plane Heist script. There are two versions available:

1. **Full Schema** (`qb-cargoheist_schema.sql`) - Complete with advanced features
2. **Simple Schema** (`qb-cargoheist_schema_simple.sql`) - Minimal, essential tables only

## 🎯 Which Version Should You Use?

### Use **Simple Schema** if:
- ✅ You want quick installation
- ✅ You're just testing the script
- ✅ You don't need leaderboards or advanced stats
- ✅ Your server has < 100 players
- ✅ You want minimal database overhead

### Use **Full Schema** if:
- ✅ You want all features (leaderboards, detailed stats)
- ✅ You plan to sell this script commercially
- ✅ Your server has 100+ players
- ✅ You want automatic cleanup and maintenance
- ✅ You want detailed analytics and logging

## 📦 What's Included in Each Version?

### Simple Schema (4 Tables)
| Table | Purpose |
|-------|---------|
| `cargo_heist_intel` | Available cargo for heists |
| `cargo_heist_history` | Completed heist records |
| `cargo_heist_cooldowns` | Player cooldown tracking |
| `cargo_heist_heat` | Player heat/wanted levels |

**Size**: ~5KB | **Complexity**: Low

---

### Full Schema (9 Tables + Extras)
| Table | Purpose |
|-------|---------|
| `cargo_heist_intel` | Available cargo (enhanced) |
| `cargo_heist_active` | Currently running heists |
| `cargo_heist_history` | Complete heist history |
| `cargo_heist_cooldowns` | Player cooldowns |
| `cargo_heist_heat` | Player heat & stats |
| `cargo_heist_intel_acquired` | Intel acquisition tracking |
| `cargo_heist_leaderboard` | Player leaderboard |
| `cargo_heist_config` | Dynamic configuration |
| `cargo_heist_blacklist` | Banned players |

**Plus**: 3 Views, 4 Stored Procedures, 3 Auto Events

**Size**: ~25KB | **Complexity**: Medium

---

## 🚀 Installation Methods

### Method 1: phpMyAdmin (Easiest)

1. **Login to phpMyAdmin**
   - Open your phpMyAdmin URL (usually `http://yourserver/phpmyadmin`)
   - Login with your database credentials

2. **Select Your Database**
   - Click on your QBCore database (usually `qbcore` or `es_extended`)

3. **Import SQL File**
   - Click the **"SQL"** tab at the top
   - Copy the entire contents of your chosen SQL file
   - Paste into the text area
   - Click **"Go"** button at the bottom

4. **Verify Installation**
   - Click **"Structure"** tab
   - You should see the new `cargo_heist_*` tables

---

### Method 2: HeidiSQL

1. **Connect to Database**
   - Open HeidiSQL
   - Connect to your MySQL server

2. **Select Database**
   - Choose your QBCore database from the left panel

3. **Run SQL**
   - Click **Query** tab (or press F9)
   - Click **"Load SQL file"** button
   - Select your chosen SQL file
   - Click **"Execute"** (F9)

4. **Check Results**
   - Refresh the database view
   - Verify tables appear in the list

---

### Method 3: MySQL Command Line

```bash
# Login to MySQL
mysql -u your_username -p

# Select your database
USE your_database_name;

# Run the SQL file
source /path/to/qb-cargoheist_schema.sql;

# Verify installation
SHOW TABLES LIKE 'cargo_heist_%';

# Exit
exit;
```

---

### Method 4: Terminal/SSH (Linux Server)

```bash
# Upload SQL file to server first, then:
mysql -u your_username -p your_database_name < qb-cargoheist_schema.sql

# Check if tables were created
mysql -u your_username -p -e "USE your_database_name; SHOW TABLES LIKE 'cargo_heist_%';"
```

---

## ✅ Post-Installation Verification

### Quick Check (Works for both versions)

Run these queries to verify installation:

```sql
-- Check if tables exist
SHOW TABLES LIKE 'cargo_heist_%';

-- Should return 4 tables (simple) or 9 tables (full)

-- Check table structure
DESCRIBE cargo_heist_intel;

-- Test insert (optional)
INSERT INTO cargo_heist_intel 
(cargo_id, cargo_type, base_value, current_value, location, security_level, available_start, available_end) 
VALUES 
('TEST_001', 'electronics', 100000, 100000, 'LSIA', 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR));

-- Verify insert
SELECT * FROM cargo_heist_intel WHERE cargo_id = 'TEST_001';

-- Clean up test data
DELETE FROM cargo_heist_intel WHERE cargo_id = 'TEST_001';
```

### Full Schema Verification

If you installed the full schema, also check:

```sql
-- Check views were created
SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';

-- Check stored procedures
SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name LIKE 'sp_%';

-- Check events are scheduled
SHOW EVENTS LIKE 'evt_%';

-- Test a procedure
CALL sp_cleanup_expired_intel();
```

---

## 🔧 Configuration

### Enable MySQL Event Scheduler (Full Schema Only)

The full schema uses MySQL events for automatic cleanup. Make sure events are enabled:

```sql
-- Check if event scheduler is ON
SHOW VARIABLES LIKE 'event_scheduler';

-- If it shows OFF, enable it:
SET GLOBAL event_scheduler = ON;
```

**Important**: To make this permanent, add to your `my.cnf` or `my.ini`:

```ini
[mysqld]
event_scheduler = ON
```

---

## 📊 Table Relationships

### Simple Schema
```
cargo_heist_intel (cargo_id)
         ↓
cargo_heist_history (references cargo_id)

cargo_heist_cooldowns (citizenid)
         ↓
players.citizenid (QBCore)

cargo_heist_heat (citizenid)
         ↓
players.citizenid (QBCore)
```

### Full Schema
```
cargo_heist_intel (cargo_id) ←── (foreign key)
         ↓                              ↑
cargo_heist_active                      │
         ↓                              │
cargo_heist_history ────────────────────┘

cargo_heist_intel_acquired ──→ cargo_heist_intel (FK)

cargo_heist_heat (citizenid)
         ↓
cargo_heist_leaderboard (citizenid)
         ↓
players.citizenid (QBCore)
```

---

## 🗑️ Automatic Cleanup (Full Schema Only)

The full schema includes automatic cleanup:

| Event | Frequency | What It Does |
|-------|-----------|--------------|
| `evt_cleanup_intel` | Every 15 min | Removes expired cargo intel |
| `evt_decay_heat` | Every 30 min | Reduces player heat levels |
| `evt_cleanup_old_history` | Daily | Deletes heists older than 30 days |

You can modify these intervals by editing the events:

```sql
-- Change cleanup frequency
ALTER EVENT evt_cleanup_intel 
ON SCHEDULE EVERY 30 MINUTE;

-- Change history retention period
DROP EVENT evt_cleanup_old_history;

CREATE EVENT evt_cleanup_old_history
ON SCHEDULE EVERY 1 DAY
DO DELETE FROM cargo_heist_history 
WHERE heist_timestamp < DATE_SUB(NOW(), INTERVAL 60 DAY); -- Keep 60 days instead
```

---

## 📈 Database Maintenance

### Regular Maintenance Tasks

```sql
-- Optimize tables (run weekly)
OPTIMIZE TABLE 
  cargo_heist_intel,
  cargo_heist_history,
  cargo_heist_cooldowns,
  cargo_heist_heat;

-- Check table sizes
SELECT 
  TABLE_NAME,
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS 'Size (MB)',
  TABLE_ROWS
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME LIKE 'cargo_heist_%'
ORDER BY (DATA_LENGTH + INDEX_LENGTH) DESC;

-- Clean up old cooldowns (if needed)
DELETE FROM cargo_heist_cooldowns 
WHERE cooldown_until < DATE_SUB(NOW(), INTERVAL 7 DAY);
```

---

## 🔐 Security Recommendations

### 1. Create Dedicated User (Optional but Recommended)

```sql
-- Create user for the heist script only
CREATE USER 'qb_cargoheist'@'localhost' IDENTIFIED BY 'secure_password_here';

-- Grant only necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database.cargo_heist_* TO 'qb_cargoheist'@'localhost';

-- If using full schema with procedures
GRANT EXECUTE ON your_database.* TO 'qb_cargoheist'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
```

Then update your script's database connection to use this user.

### 2. Backup Recommendations

```bash
# Backup just the heist tables
mysqldump -u username -p database_name \
  cargo_heist_intel \
  cargo_heist_history \
  cargo_heist_cooldowns \
  cargo_heist_heat \
  > cargoheist_backup_$(date +%Y%m%d).sql

# Restore from backup
mysql -u username -p database_name < cargoheist_backup_20241019.sql
```

---

## 🐛 Troubleshooting

### Problem: "Table already exists" error

**Solution**: Drop existing tables first:

```sql
DROP TABLE IF EXISTS cargo_heist_blacklist;
DROP TABLE IF EXISTS cargo_heist_leaderboard;
DROP TABLE IF EXISTS cargo_heist_intel_acquired;
DROP TABLE IF EXISTS cargo_heist_config;
DROP TABLE IF EXISTS cargo_heist_heat;
DROP TABLE IF EXISTS cargo_heist_cooldowns;
DROP TABLE IF EXISTS cargo_heist_history;
DROP TABLE IF EXISTS cargo_heist_active;
DROP TABLE IF EXISTS cargo_heist_intel;

-- Then run the installation script again
```

### Problem: Foreign key constraint errors

**Solution**: Disable foreign key checks temporarily:

```sql
SET FOREIGN_KEY_CHECKS = 0;
-- Run your installation script
SET FOREIGN_KEY_CHECKS = 1;
```

### Problem: Event scheduler not working

**Solution**: Check permissions and enable:

```sql
-- Check current status
SHOW VARIABLES LIKE 'event_scheduler';

-- Enable it
SET GLOBAL event_scheduler = ON;

-- Check if events are created
SHOW EVENTS;

-- If events don't exist, create them manually from the full schema file
```

### Problem: Views won't create

**Solution**: Views might fail if tables don't exist yet. Create tables first:

```sql
-- Drop any partially created views
DROP VIEW IF EXISTS v_active_heists;
DROP VIEW IF EXISTS v_top_earners;
DROP VIEW IF EXISTS v_recent_heists;

-- Re-run just the view creation part from the schema file
```

### Problem: Stored procedures syntax errors

**Solution**: Make sure delimiter is set correctly:

```sql
DELIMITER $$
-- Your procedure code here
DELIMITER ;
```

---

## 📊 Sample Queries for Testing

### Check Active Heists
```sql
SELECT * FROM cargo_heist_intel WHERE is_active = 1 AND is_claimed = 0;
```

### View Recent Completions
```sql
SELECT 
  heist_id,
  cargo_type,
  approach_method,
  success,
  final_payout,
  heist_timestamp
FROM cargo_heist_history
ORDER BY heist_timestamp DESC
LIMIT 10;
```

### Check Player Stats
```sql
SELECT 
  h.citizenid,
  h.heat_level,
  h.total_heists,
  h.successful_heists,
  h.total_earned
FROM cargo_heist_heat h
ORDER BY h.total_earned DESC
LIMIT 10;
```

### Get Leaderboard (Full Schema)
```sql
SELECT * FROM v_top_earners LIMIT 10;
```

---

## 🔄 Upgrading from Simple to Full Schema

If you start with simple and want to upgrade later:

1. **Backup your data**:
```sql
CREATE TABLE cargo_heist_history_backup AS SELECT * FROM cargo_heist_history;
CREATE TABLE cargo_heist_heat_backup AS SELECT * FROM cargo_heist_heat;
```

2. **Run the full schema** - it will add new tables without affecting existing ones

3. **Verify** old data is intact:
```sql
SELECT COUNT(*) FROM cargo_heist_history;
SELECT COUNT(*) FROM cargo_heist_heat;
```

---

## 🗑️ Complete Uninstallation

If you need to remove everything:

```sql
-- Drop all tables (simple schema)
DROP TABLE IF EXISTS cargo_heist_heat;
DROP TABLE IF EXISTS cargo_heist_cooldowns;
DROP TABLE IF EXISTS cargo_heist_history;
DROP TABLE IF EXISTS cargo_heist_intel;

-- Additional for full schema
DROP TABLE IF EXISTS cargo_heist_blacklist;
DROP TABLE IF EXISTS cargo_heist_leaderboard;
DROP TABLE IF EXISTS cargo_heist_intel_acquired;
DROP TABLE IF EXISTS cargo_heist_config;
DROP TABLE IF EXISTS cargo_heist_active;

-- Drop views
DROP VIEW IF EXISTS v_active_heists;
DROP VIEW IF EXISTS v_top_earners;
DROP VIEW IF EXISTS v_recent_heists;

-- Drop procedures
DROP PROCEDURE IF EXISTS sp_cleanup_expired_intel;
DROP PROCEDURE IF EXISTS sp_decay_player_heat;
DROP PROCEDURE IF EXISTS sp_get_player_stats;
DROP PROCEDURE IF EXISTS sp_complete_heist;

-- Drop events
DROP EVENT IF EXISTS evt_cleanup_intel;
DROP EVENT IF EXISTS evt_decay_heat;
DROP EVENT IF EXISTS evt_cleanup_old_history;
```

---

## 📞 Support

If you encounter issues:

1. Check MySQL error log
2. Verify MySQL version (5.7+ or 8.0+ recommended)
3. Ensure proper permissions
4. Check database collation (utf8mb4 recommended)

---

## ✅ Installation Complete!

After successful installation, you should have:

- ✅ All required tables created
- ✅ Indexes applied for performance
- ✅ (Full schema) Views, procedures, and events active
- ✅ Ready to connect from your FiveM script

**Next Steps**: Configure your FiveM resource to connect to these tables!
