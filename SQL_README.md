# QB-CargoHeist Database Files

## 📁 Files Included

| File | Purpose | Size | Complexity |
|------|---------|------|------------|
| `qb-cargoheist_schema.sql` | Full database schema with all features | ~25KB | Advanced |
| `qb-cargoheist_schema_simple.sql` | Minimal schema with essential tables only | ~5KB | Basic |
| `ADMIN_QUERIES.sql` | Useful queries for server administration | ~12KB | Reference |
| `DATABASE_INSTALLATION_GUIDE.md` | Complete installation instructions | - | Documentation |

---

## 🚀 Quick Start

### For Beginners (Recommended)
1. Use **`qb-cargoheist_schema_simple.sql`**
2. Import it to your database via phpMyAdmin
3. Done! Ready to use with the script

### For Advanced Users
1. Use **`qb-cargoheist_schema.sql`**
2. Import it to your database
3. Verify events are enabled: `SET GLOBAL event_scheduler = ON;`
4. Enjoy automatic cleanup and advanced features

---

## 📊 Feature Comparison

| Feature | Simple Schema | Full Schema |
|---------|---------------|-------------|
| **Core Heist Functionality** | ✅ | ✅ |
| Intel System | ✅ | ✅ |
| History Tracking | ✅ | ✅ Advanced |
| Cooldowns | ✅ | ✅ |
| Heat System | ✅ | ✅ Enhanced |
| Active Heist Tracking | ❌ | ✅ |
| Intel Acquisition Tracking | ❌ | ✅ |
| Leaderboards | ❌ | ✅ |
| Dynamic Configuration | ❌ | ✅ |
| Player Blacklist | ❌ | ✅ |
| Automatic Cleanup | ❌ | ✅ |
| Stored Procedures | ❌ | ✅ |
| Database Views | ❌ | ✅ |
| Scheduled Events | ❌ | ✅ |

---

## 💾 Database Tables

### Simple Schema (4 Tables)
```
cargo_heist_intel          - Available cargo
cargo_heist_history        - Completed heists
cargo_heist_cooldowns      - Player cooldowns
cargo_heist_heat           - Player heat levels
```

### Full Schema (9 Tables + Extras)
```
All simple schema tables PLUS:

cargo_heist_active         - Currently running heists
cargo_heist_intel_acquired - Intel tracking
cargo_heist_leaderboard    - Player rankings
cargo_heist_config         - Dynamic settings
cargo_heist_blacklist      - Banned players

PLUS:
- 3 Database Views for reporting
- 4 Stored Procedures for automation
- 3 Scheduled Events for maintenance
```

---

## 🎯 Which Schema Should I Use?

### Use **Simple** if:
- ⚡ You want quick setup
- 🧪 You're testing the script
- 👥 Server has < 100 players
- 💻 You prefer manual maintenance
- 📊 You don't need detailed stats

### Use **Full** if:
- 🏆 You want leaderboards
- 📈 You need detailed analytics
- 👥 Server has 100+ players
- 🤖 You want automatic cleanup
- 💼 You're selling this commercially
- 🔧 You want advanced features

---

## 📋 Installation Steps

1. **Choose your schema** (simple or full)
2. **Backup your database** (always!)
3. **Open phpMyAdmin or HeidiSQL**
4. **Select your QBCore database**
5. **Run the SQL file**
6. **Verify tables created** (check structure tab)
7. **(Full only)** Enable event scheduler
8. **Done!** Connect your script

See `DATABASE_INSTALLATION_GUIDE.md` for detailed instructions.

---

## 🔧 Post-Installation

### Verify Installation
```sql
-- Check tables exist
SHOW TABLES LIKE 'cargo_heist_%';

-- Test insert
INSERT INTO cargo_heist_intel 
(cargo_id, cargo_type, base_value, current_value, location, security_level, available_start, available_end) 
VALUES 
('TEST001', 'electronics', 100000, 100000, 'LSIA', 1, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR));

-- Verify
SELECT * FROM cargo_heist_intel WHERE cargo_id = 'TEST001';

-- Clean up
DELETE FROM cargo_heist_intel WHERE cargo_id = 'TEST001';
```

### Enable Events (Full Schema Only)
```sql
SET GLOBAL event_scheduler = ON;
SHOW EVENTS;
```

---

## 📖 Admin Queries

The `ADMIN_QUERIES.sql` file contains useful queries for:

- 👤 **Player Management**: View stats, reset cooldowns, ban players
- 🎯 **Heist Monitoring**: Track active heists, view completions
- 📊 **Statistics**: Leaderboards, success rates, earnings
- 💰 **Economy**: Payout analysis, balancing data
- 🧹 **Maintenance**: Cleanup, optimization
- 🐛 **Debugging**: Test data, orphaned records
- 📈 **Reports**: Daily activity, player reports

**Example uses:**
```sql
-- View top 10 earners
SELECT citizenid, total_earned FROM cargo_heist_heat ORDER BY total_earned DESC LIMIT 10;

-- Reset a player's cooldown
DELETE FROM cargo_heist_cooldowns WHERE citizenid = 'ABC12345';

-- Today's heist statistics
SELECT COUNT(*) FROM cargo_heist_history WHERE DATE(heist_timestamp) = CURDATE();
```

---

## 🗄️ Storage Requirements

| Schema | Empty | After 1000 Heists | After 10,000 Heists |
|--------|-------|-------------------|---------------------|
| Simple | ~500KB | ~5MB | ~25MB |
| Full | ~1MB | ~10MB | ~50MB |

*Note: Actual size depends on crew size, cargo types, and retention period*

---

## 🔐 Security

### Create Dedicated User (Recommended)
```sql
CREATE USER 'qb_cargoheist'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON database.cargo_heist_* TO 'qb_cargoheist'@'localhost';
FLUSH PRIVILEGES;
```

### Regular Backups
```bash
# Backup heist tables
mysqldump -u username -p database cargo_heist_* > backup.sql

# Restore
mysql -u username -p database < backup.sql
```

---

## 🧹 Maintenance

### Weekly Tasks
```sql
-- Cleanup expired intel
DELETE FROM cargo_heist_intel WHERE available_end < DATE_SUB(NOW(), INTERVAL 7 DAY);

-- Cleanup old cooldowns
DELETE FROM cargo_heist_cooldowns WHERE cooldown_until < NOW();
```

### Monthly Tasks
```sql
-- Optimize tables
OPTIMIZE TABLE cargo_heist_intel, cargo_heist_history, cargo_heist_cooldowns, cargo_heist_heat;

-- Archive old history (optional)
CREATE TABLE cargo_heist_history_archive AS 
SELECT * FROM cargo_heist_history WHERE heist_timestamp < DATE_SUB(NOW(), INTERVAL 90 DAY);

DELETE FROM cargo_heist_history WHERE heist_timestamp < DATE_SUB(NOW(), INTERVAL 90 DAY);
```

---

## 🔄 Upgrading

### From Simple to Full
1. Backup your data
2. Run the full schema SQL file
3. It will add new tables without affecting existing ones
4. Enable event scheduler
5. Done!

### Downgrading (Not Recommended)
If you must downgrade from full to simple:
1. **Backup everything first**
2. The simple tables already exist, so just drop the extra tables
3. Data in `cargo_heist_history` and `cargo_heist_heat` will be preserved

---

## 🐛 Troubleshooting

### Tables already exist
```sql
-- Drop all tables first
DROP TABLE IF EXISTS cargo_heist_blacklist, cargo_heist_leaderboard, 
cargo_heist_intel_acquired, cargo_heist_config, cargo_heist_active,
cargo_heist_heat, cargo_heist_cooldowns, cargo_heist_history, cargo_heist_intel;

-- Then re-run installation
```

### Foreign key errors
```sql
SET FOREIGN_KEY_CHECKS = 0;
-- Run installation
SET FOREIGN_KEY_CHECKS = 1;
```

### Events not working
```sql
-- Check status
SHOW VARIABLES LIKE 'event_scheduler';

-- Enable
SET GLOBAL event_scheduler = ON;

-- Make permanent: Add to my.cnf
[mysqld]
event_scheduler = ON
```

---

## 📞 Support

For issues with:
- **SQL syntax**: Check MySQL version (5.7+ or 8.0+ recommended)
- **Permissions**: Verify database user has proper grants
- **Performance**: Check indexes are created, optimize tables
- **Storage**: Monitor table sizes, archive old data

---

## 📝 Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024 | Initial release |

---

## ✅ Checklist

Before connecting your script:

- [ ] Database schema installed (simple or full)
- [ ] Tables verified with `SHOW TABLES LIKE 'cargo_heist_%'`
- [ ] (Full) Event scheduler enabled
- [ ] Test insert/select works
- [ ] Database credentials configured in script
- [ ] Backup created
- [ ] Admin queries tested

---

## 🎓 Need Help?

1. Read `DATABASE_INSTALLATION_GUIDE.md` for detailed instructions
2. Check `ADMIN_QUERIES.sql` for useful queries
3. Test with sample data before going live
4. Monitor database performance after launch

---

**Installation Time:**
- Simple Schema: ~2 minutes
- Full Schema: ~5 minutes
- Testing: ~10 minutes

**Total: 15-20 minutes for complete setup** ✨

---

Made with ❤️ for QBCore Framework
