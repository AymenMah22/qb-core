-- ============================================================================
-- QB-CARGOHEIST DATABASE SCHEMA
-- Version: 1.0.0
-- Framework: QBCore
-- Description: Complete database schema for Cargo Plane Heist system
-- ============================================================================

-- ============================================================================
-- TABLE: cargo_heist_intel
-- Description: Stores available cargo intel that players can discover
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_intel` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `cargo_id` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Unique identifier for cargo',
  `cargo_type` VARCHAR(50) NOT NULL COMMENT 'Type: electronics, gold, weapons, etc.',
  `base_value` INT NOT NULL COMMENT 'Base payout value before multipliers',
  `current_value` INT NOT NULL COMMENT 'Current value (can change)',
  `location` VARCHAR(100) NOT NULL DEFAULT 'LSIA' COMMENT 'Airport code or location',
  `plane_model` VARCHAR(50) DEFAULT 'cargoplane' COMMENT 'Vehicle model name',
  `security_level` TINYINT DEFAULT 1 COMMENT 'Difficulty 1-5',
  `npc_guards` TINYINT DEFAULT 2 COMMENT 'Number of NPC guards',
  `available_start` TIMESTAMP NOT NULL COMMENT 'When cargo becomes available',
  `available_end` TIMESTAMP NOT NULL COMMENT 'When cargo expires/leaves',
  `is_active` TINYINT(1) DEFAULT 1 COMMENT '1=available, 0=expired/completed',
  `is_claimed` TINYINT(1) DEFAULT 0 COMMENT '1=heist in progress, 0=unclaimed',
  `flight_path` TEXT DEFAULT NULL COMMENT 'JSON array of coordinates for air approach',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_active` (`is_active`, `is_claimed`),
  INDEX `idx_expiry` (`available_end`),
  INDEX `idx_cargo_type` (`cargo_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Available cargo intel for heists';

-- ============================================================================
-- TABLE: cargo_heist_active
-- Description: Tracks currently active heists in progress
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_active` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `heist_id` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Unique heist instance ID',
  `cargo_id` VARCHAR(50) NOT NULL COMMENT 'Reference to cargo_heist_intel',
  `leader_citizenid` VARCHAR(50) NOT NULL COMMENT 'Heist leader',
  `crew_data` TEXT NOT NULL COMMENT 'JSON array of crew members with roles and cuts',
  `approach_method` ENUM('ground', 'air') NOT NULL COMMENT 'Approach type',
  `status` ENUM('planning', 'executing', 'escaping', 'delivering', 'completed', 'failed') DEFAULT 'planning',
  `cargo_condition` TINYINT DEFAULT 100 COMMENT 'Condition 0-100, affects payout',
  `police_notified` TINYINT(1) DEFAULT 0 COMMENT 'Whether police were alerted',
  `started_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  
  INDEX `idx_leader` (`leader_citizenid`),
  INDEX `idx_status` (`status`),
  INDEX `idx_cargo` (`cargo_id`),
  FOREIGN KEY (`cargo_id`) REFERENCES `cargo_heist_intel`(`cargo_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Active heists in progress';

-- ============================================================================
-- TABLE: cargo_heist_history
-- Description: Historical record of all completed/failed heists
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `heist_id` VARCHAR(50) NOT NULL COMMENT 'Unique heist instance ID',
  `cargo_id` VARCHAR(50) DEFAULT NULL COMMENT 'Cargo that was targeted',
  `cargo_type` VARCHAR(50) DEFAULT NULL COMMENT 'Type of cargo',
  `leader_citizenid` VARCHAR(50) NOT NULL COMMENT 'Heist leader',
  `crew_members` TEXT NOT NULL COMMENT 'JSON array of all crew members',
  `crew_size` TINYINT NOT NULL COMMENT 'Number of crew members',
  `approach_method` ENUM('ground', 'air') NOT NULL COMMENT 'Approach used',
  `success` TINYINT(1) NOT NULL COMMENT '1=success, 0=failed',
  `base_payout` INT DEFAULT 0 COMMENT 'Base payout before multipliers',
  `final_payout` INT DEFAULT 0 COMMENT 'Final payout after all modifiers',
  `multipliers_applied` TEXT DEFAULT NULL COMMENT 'JSON of multipliers applied',
  `cargo_condition` TINYINT DEFAULT 100 COMMENT 'Final cargo condition',
  `police_response` TINYINT DEFAULT 0 COMMENT 'Number of police who responded',
  `completion_time` INT DEFAULT 0 COMMENT 'Time in seconds to complete',
  `bonuses_earned` TEXT DEFAULT NULL COMMENT 'JSON of bonuses (speed, stealth, etc)',
  `failure_reason` VARCHAR(100) DEFAULT NULL COMMENT 'Why heist failed',
  `heist_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_leader` (`leader_citizenid`),
  INDEX `idx_success` (`success`),
  INDEX `idx_timestamp` (`heist_timestamp`),
  INDEX `idx_cargo_type` (`cargo_type`),
  INDEX `idx_approach` (`approach_method`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Complete heist history';

-- ============================================================================
-- TABLE: cargo_heist_cooldowns
-- Description: Player cooldowns to prevent spam
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_cooldowns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) NOT NULL COMMENT 'Player identifier',
  `heist_type` VARCHAR(50) NOT NULL DEFAULT 'cargo' COMMENT 'Type of heist',
  `last_attempt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When last heist was attempted',
  `cooldown_until` TIMESTAMP NOT NULL COMMENT 'When player can heist again',
  `attempts_today` TINYINT DEFAULT 1 COMMENT 'Number of heists today',
  `total_heists` INT DEFAULT 1 COMMENT 'Lifetime heist count',
  
  UNIQUE KEY `unique_player_heist` (`citizenid`, `heist_type`),
  INDEX `idx_citizenid` (`citizenid`),
  INDEX `idx_cooldown` (`cooldown_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player heist cooldowns';

-- ============================================================================
-- TABLE: cargo_heist_heat
-- Description: Player heat/wanted level from repeated heists
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_heat` (
  `citizenid` VARCHAR(50) PRIMARY KEY COMMENT 'Player identifier',
  `heat_level` TINYINT DEFAULT 0 COMMENT 'Heat level 0-5',
  `heat_points` INT DEFAULT 0 COMMENT 'Accumulated heat points',
  `last_heist` TIMESTAMP NULL DEFAULT NULL COMMENT 'Last heist timestamp',
  `total_heists` INT DEFAULT 0 COMMENT 'Total heists participated in',
  `successful_heists` INT DEFAULT 0 COMMENT 'Successful heists',
  `failed_heists` INT DEFAULT 0 COMMENT 'Failed heists',
  `total_earned` BIGINT DEFAULT 0 COMMENT 'Total money earned from heists',
  `heat_decay_at` TIMESTAMP NULL DEFAULT NULL COMMENT 'When heat will decay next',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_heat_level` (`heat_level`),
  INDEX `idx_decay` (`heat_decay_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Player heat and statistics';

-- ============================================================================
-- TABLE: cargo_heist_intel_acquired
-- Description: Tracks which players have acquired which intel
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_intel_acquired` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) NOT NULL COMMENT 'Player who acquired intel',
  `cargo_id` VARCHAR(50) NOT NULL COMMENT 'Cargo intel acquired',
  `intel_source` ENUM('hack', 'bribe', 'manifest', 'insider') NOT NULL COMMENT 'How intel was obtained',
  `intel_quality` TINYINT NOT NULL COMMENT 'Quality 0-100',
  `cost_paid` INT DEFAULT 0 COMMENT 'Money paid for intel',
  `acquired_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP NOT NULL COMMENT 'When intel expires',
  `used` TINYINT(1) DEFAULT 0 COMMENT 'Whether intel was used for heist',
  
  INDEX `idx_citizenid` (`citizenid`),
  INDEX `idx_cargo` (`cargo_id`),
  INDEX `idx_expires` (`expires_at`),
  FOREIGN KEY (`cargo_id`) REFERENCES `cargo_heist_intel`(`cargo_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Intel acquisition tracking';

-- ============================================================================
-- TABLE: cargo_heist_leaderboard
-- Description: Leaderboard for top heist crews
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_leaderboard` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Player identifier',
  `player_name` VARCHAR(100) NOT NULL COMMENT 'Character name',
  `total_heists` INT DEFAULT 0 COMMENT 'Total heists participated',
  `successful_heists` INT DEFAULT 0 COMMENT 'Successful heists',
  `failed_heists` INT DEFAULT 0 COMMENT 'Failed heists',
  `success_rate` DECIMAL(5,2) DEFAULT 0.00 COMMENT 'Success percentage',
  `total_earned` BIGINT DEFAULT 0 COMMENT 'Total earnings',
  `highest_single_payout` INT DEFAULT 0 COMMENT 'Biggest single heist payout',
  `fastest_completion` INT DEFAULT 999999 COMMENT 'Fastest heist time in seconds',
  `times_as_leader` INT DEFAULT 0 COMMENT 'Times led a heist',
  `times_as_pilot` INT DEFAULT 0 COMMENT 'Times as pilot',
  `times_as_hacker` INT DEFAULT 0 COMMENT 'Times as hacker',
  `air_heists` INT DEFAULT 0 COMMENT 'Air approach heists',
  `ground_heists` INT DEFAULT 0 COMMENT 'Ground approach heists',
  `last_heist` TIMESTAMP NULL DEFAULT NULL,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_total_earned` (`total_earned` DESC),
  INDEX `idx_success_rate` (`success_rate` DESC),
  INDEX `idx_successful` (`successful_heists` DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Heist leaderboard and player stats';

-- ============================================================================
-- TABLE: cargo_heist_config
-- Description: Dynamic server-side configuration (optional, for advanced setups)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_config` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `config_key` VARCHAR(100) UNIQUE NOT NULL COMMENT 'Configuration key',
  `config_value` TEXT NOT NULL COMMENT 'Configuration value (can be JSON)',
  `value_type` ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
  `description` VARCHAR(255) DEFAULT NULL COMMENT 'What this config does',
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` VARCHAR(50) DEFAULT NULL COMMENT 'Admin who updated',
  
  INDEX `idx_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Dynamic configuration storage';

-- ============================================================================
-- TABLE: cargo_heist_blacklist
-- Description: Blacklisted players (banned from heists)
-- ============================================================================
CREATE TABLE IF NOT EXISTS `cargo_heist_blacklist` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) UNIQUE NOT NULL COMMENT 'Blacklisted player',
  `reason` VARCHAR(255) NOT NULL COMMENT 'Why they were blacklisted',
  `banned_by` VARCHAR(50) NOT NULL COMMENT 'Admin who banned',
  `banned_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `expires_at` TIMESTAMP NULL DEFAULT NULL COMMENT 'NULL = permanent',
  `is_active` TINYINT(1) DEFAULT 1 COMMENT 'Active ban',
  
  INDEX `idx_citizenid` (`citizenid`),
  INDEX `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Blacklisted players';

-- ============================================================================
-- VIEWS (Optional but useful for queries)
-- ============================================================================

-- View: Active heists summary
CREATE OR REPLACE VIEW `v_active_heists` AS
SELECT 
  ah.heist_id,
  ah.leader_citizenid,
  ah.approach_method,
  ah.status,
  ah.cargo_condition,
  ci.cargo_type,
  ci.current_value,
  ci.security_level,
  TIMESTAMPDIFF(MINUTE, ah.started_at, NOW()) as duration_minutes
FROM cargo_heist_active ah
LEFT JOIN cargo_heist_intel ci ON ah.cargo_id = ci.cargo_id
WHERE ah.status NOT IN ('completed', 'failed');

-- View: Top earners
CREATE OR REPLACE VIEW `v_top_earners` AS
SELECT 
  citizenid,
  player_name,
  total_earned,
  successful_heists,
  success_rate,
  highest_single_payout
FROM cargo_heist_leaderboard
ORDER BY total_earned DESC
LIMIT 100;

-- View: Recent heists
CREATE OR REPLACE VIEW `v_recent_heists` AS
SELECT 
  heist_id,
  cargo_type,
  leader_citizenid,
  approach_method,
  success,
  final_payout,
  completion_time,
  heist_timestamp
FROM cargo_heist_history
ORDER BY heist_timestamp DESC
LIMIT 50;

-- ============================================================================
-- STORED PROCEDURES (Optional but helpful for common operations)
-- ============================================================================

DELIMITER $$

-- Procedure: Clean up expired intel
CREATE PROCEDURE IF NOT EXISTS `sp_cleanup_expired_intel`()
BEGIN
  -- Mark expired intel as inactive
  UPDATE cargo_heist_intel
  SET is_active = 0
  WHERE available_end < NOW() AND is_active = 1;
  
  -- Delete very old intel (older than 7 days)
  DELETE FROM cargo_heist_intel
  WHERE available_end < DATE_SUB(NOW(), INTERVAL 7 DAY);
  
  SELECT ROW_COUNT() as rows_affected;
END$$

-- Procedure: Update player heat decay
CREATE PROCEDURE IF NOT EXISTS `sp_decay_player_heat`()
BEGIN
  -- Decay heat for players who are due
  UPDATE cargo_heist_heat
  SET 
    heat_level = GREATEST(0, heat_level - 1),
    heat_points = GREATEST(0, heat_points - 100),
    heat_decay_at = DATE_ADD(NOW(), INTERVAL 30 MINUTE)
  WHERE heat_decay_at IS NOT NULL 
    AND heat_decay_at <= NOW()
    AND heat_level > 0;
    
  SELECT ROW_COUNT() as rows_decayed;
END$$

-- Procedure: Get player stats
CREATE PROCEDURE IF NOT EXISTS `sp_get_player_stats`(IN p_citizenid VARCHAR(50))
BEGIN
  SELECT 
    h.heat_level,
    h.heat_points,
    h.total_heists,
    h.successful_heists,
    h.failed_heists,
    h.total_earned,
    l.success_rate,
    l.highest_single_payout,
    l.fastest_completion,
    c.cooldown_until
  FROM cargo_heist_heat h
  LEFT JOIN cargo_heist_leaderboard l ON h.citizenid = l.citizenid
  LEFT JOIN cargo_heist_cooldowns c ON h.citizenid = c.citizenid
  WHERE h.citizenid = p_citizenid;
END$$

-- Procedure: Complete heist and update all stats
CREATE PROCEDURE IF NOT EXISTS `sp_complete_heist`(
  IN p_heist_id VARCHAR(50),
  IN p_success TINYINT(1),
  IN p_final_payout INT,
  IN p_completion_time INT
)
BEGIN
  DECLARE v_cargo_id VARCHAR(50);
  DECLARE v_leader VARCHAR(50);
  DECLARE v_approach VARCHAR(10);
  DECLARE v_cargo_type VARCHAR(50);
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_citizenid VARCHAR(50);
  DECLARE crew_cursor CURSOR FOR 
    SELECT JSON_UNQUOTE(JSON_EXTRACT(crew_data, CONCAT('$[', idx, '].citizenid')))
    FROM cargo_heist_active,
    JSON_TABLE(
      CONCAT('[', REPLACE(JSON_LENGTH(crew_data)-1, JSON_LENGTH(crew_data)-1, 
      REPEAT(',0', JSON_LENGTH(crew_data)-1)), ']'),
      '$[*]' COLUMNS (idx INT PATH '$')
    ) AS jt
    WHERE heist_id = p_heist_id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  
  START TRANSACTION;
  
  -- Get heist details
  SELECT cargo_id, leader_citizenid, approach_method
  INTO v_cargo_id, v_leader, v_approach
  FROM cargo_heist_active
  WHERE heist_id = p_heist_id;
  
  -- Get cargo type
  SELECT cargo_type INTO v_cargo_type
  FROM cargo_heist_intel
  WHERE cargo_id = v_cargo_id;
  
  -- Move to history
  INSERT INTO cargo_heist_history (
    heist_id, cargo_id, cargo_type, leader_citizenid, crew_members,
    crew_size, approach_method, success, final_payout, completion_time,
    heist_timestamp
  )
  SELECT 
    heist_id, cargo_id, v_cargo_type, leader_citizenid, crew_data,
    JSON_LENGTH(crew_data), approach_method, p_success, p_final_payout,
    p_completion_time, NOW()
  FROM cargo_heist_active
  WHERE heist_id = p_heist_id;
  
  -- Update all crew member stats
  OPEN crew_cursor;
  read_loop: LOOP
    FETCH crew_cursor INTO v_citizenid;
    IF done THEN
      LEAVE read_loop;
    END IF;
    
    -- Update heat
    INSERT INTO cargo_heist_heat (citizenid, heat_level, total_heists, successful_heists, failed_heists, total_earned, last_heist)
    VALUES (v_citizenid, 1, 1, p_success, 1-p_success, p_final_payout, NOW())
    ON DUPLICATE KEY UPDATE
      heat_level = LEAST(5, heat_level + 1),
      heat_points = heat_points + 100,
      total_heists = total_heists + 1,
      successful_heists = successful_heists + p_success,
      failed_heists = failed_heists + (1-p_success),
      total_earned = total_earned + p_final_payout,
      last_heist = NOW();
    
    -- Update leaderboard
    INSERT INTO cargo_heist_leaderboard (citizenid, player_name, total_heists, successful_heists, failed_heists, total_earned, last_heist)
    VALUES (v_citizenid, 'Unknown', 1, p_success, 1-p_success, p_final_payout, NOW())
    ON DUPLICATE KEY UPDATE
      total_heists = total_heists + 1,
      successful_heists = successful_heists + p_success,
      failed_heists = failed_heists + (1-p_success),
      success_rate = (successful_heists + p_success) / (total_heists + 1) * 100,
      total_earned = total_earned + p_final_payout,
      last_heist = NOW();
  END LOOP;
  CLOSE crew_cursor;
  
  -- Clean up active heist
  DELETE FROM cargo_heist_active WHERE heist_id = p_heist_id;
  
  -- Mark cargo as completed
  UPDATE cargo_heist_intel SET is_active = 0, is_claimed = 0 WHERE cargo_id = v_cargo_id;
  
  COMMIT;
END$$

DELIMITER ;

-- ============================================================================
-- EVENTS (Automatic cleanup tasks)
-- ============================================================================

-- Enable event scheduler (make sure this is on in your MySQL config)
SET GLOBAL event_scheduler = ON;

-- Event: Auto-cleanup expired intel every 15 minutes
CREATE EVENT IF NOT EXISTS `evt_cleanup_intel`
ON SCHEDULE EVERY 15 MINUTE
DO CALL sp_cleanup_expired_intel();

-- Event: Auto-decay heat every 30 minutes
CREATE EVENT IF NOT EXISTS `evt_decay_heat`
ON SCHEDULE EVERY 30 MINUTE
DO CALL sp_decay_player_heat();

-- Event: Cleanup old history (keep only last 30 days)
CREATE EVENT IF NOT EXISTS `evt_cleanup_old_history`
ON SCHEDULE EVERY 1 DAY
DO DELETE FROM cargo_heist_history WHERE heist_timestamp < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- ============================================================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================================================

-- Sample cargo intel (uncomment for testing)
/*
INSERT INTO cargo_heist_intel (cargo_id, cargo_type, base_value, current_value, location, security_level, npc_guards, available_start, available_end, flight_path) VALUES
('CARGO_001', 'electronics', 100000, 100000, 'LSIA', 1, 2, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR), NULL),
('CARGO_002', 'gold_bars', 200000, 200000, 'LSIA', 3, 4, NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), NULL),
('CARGO_003', 'weapons', 150000, 150000, 'LSIA', 3, 5, NOW(), DATE_ADD(NOW(), INTERVAL 1 HOUR), NULL);
*/

-- Sample config entries
INSERT INTO cargo_heist_config (config_key, config_value, value_type, description) VALUES
('server_wide_cooldown', '30', 'number', 'Cooldown in minutes between server heists'),
('max_simultaneous_heists', '3', 'number', 'Maximum heists that can run at once'),
('heat_decay_rate', '30', 'number', 'Minutes between heat decay ticks'),
('require_cops', '3', 'number', 'Minimum cops required online')
ON DUPLICATE KEY UPDATE config_value = VALUES(config_value);

-- ============================================================================
-- INDEXES FOR OPTIMIZATION (Additional)
-- ============================================================================

-- Add composite indexes for common queries
ALTER TABLE cargo_heist_history 
  ADD INDEX `idx_leader_success` (`leader_citizenid`, `success`),
  ADD INDEX `idx_type_success` (`cargo_type`, `success`),
  ADD INDEX `idx_timestamp_success` (`heist_timestamp`, `success`);

ALTER TABLE cargo_heist_intel
  ADD INDEX `idx_active_claimed` (`is_active`, `is_claimed`, `available_end`);

-- ============================================================================
-- PERMISSIONS (Optional - for security)
-- ============================================================================

/*
-- Create a dedicated user for the heist script
CREATE USER IF NOT EXISTS 'qb_cargoheist'@'localhost' IDENTIFIED BY 'your_secure_password';

-- Grant necessary permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database.cargo_heist_* TO 'qb_cargoheist'@'localhost';
GRANT EXECUTE ON PROCEDURE your_database.sp_cleanup_expired_intel TO 'qb_cargoheist'@'localhost';
GRANT EXECUTE ON PROCEDURE your_database.sp_decay_player_heat TO 'qb_cargoheist'@'localhost';
GRANT EXECUTE ON PROCEDURE your_database.sp_get_player_stats TO 'qb_cargoheist'@'localhost';
GRANT EXECUTE ON PROCEDURE your_database.sp_complete_heist TO 'qb_cargoheist'@'localhost';

FLUSH PRIVILEGES;
*/

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Run these to verify installation
-- SELECT COUNT(*) as intel_count FROM cargo_heist_intel;
-- SELECT COUNT(*) as active_count FROM cargo_heist_active;
-- SELECT COUNT(*) as history_count FROM cargo_heist_history;
-- SELECT COUNT(*) as cooldown_count FROM cargo_heist_cooldowns;
-- SELECT COUNT(*) as heat_count FROM cargo_heist_heat;

-- Check if events are enabled
-- SHOW EVENTS LIKE 'evt_%';

-- Check if procedures exist
-- SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name LIKE 'sp_%';

-- ============================================================================
-- INSTALLATION COMPLETE
-- ============================================================================

SELECT 'QB-CargoHeist database schema installed successfully!' as message;
SELECT 'Tables created: 9' as info;
SELECT 'Views created: 3' as info;
SELECT 'Stored Procedures created: 4' as info;
SELECT 'Events created: 3' as info;
SELECT 'Remember to configure your database connection in the script!' as reminder;
