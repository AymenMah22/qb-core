-- ============================================================================
-- QB-CARGOHEIST DATABASE SCHEMA (SIMPLIFIED)
-- Version: 1.0.0 - Basic Installation
-- Framework: QBCore
-- Description: Minimal schema for Cargo Plane Heist (no advanced features)
-- ============================================================================

-- Core table: Available cargo intel
CREATE TABLE IF NOT EXISTS `cargo_heist_intel` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `cargo_id` VARCHAR(50) UNIQUE NOT NULL,
  `cargo_type` VARCHAR(50) NOT NULL,
  `base_value` INT NOT NULL,
  `current_value` INT NOT NULL,
  `location` VARCHAR(100) NOT NULL DEFAULT 'LSIA',
  `security_level` TINYINT DEFAULT 1,
  `available_start` TIMESTAMP NOT NULL,
  `available_end` TIMESTAMP NOT NULL,
  `is_active` TINYINT(1) DEFAULT 1,
  `is_claimed` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_active` (`is_active`, `is_claimed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Core table: Heist history
CREATE TABLE IF NOT EXISTS `cargo_heist_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `heist_id` VARCHAR(50) NOT NULL,
  `cargo_id` VARCHAR(50) DEFAULT NULL,
  `cargo_type` VARCHAR(50) DEFAULT NULL,
  `leader_citizenid` VARCHAR(50) NOT NULL,
  `crew_members` TEXT NOT NULL,
  `approach_method` ENUM('ground', 'air') NOT NULL,
  `success` TINYINT(1) NOT NULL,
  `final_payout` INT DEFAULT 0,
  `completion_time` INT DEFAULT 0,
  `heist_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX `idx_leader` (`leader_citizenid`),
  INDEX `idx_timestamp` (`heist_timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Core table: Player cooldowns
CREATE TABLE IF NOT EXISTS `cargo_heist_cooldowns` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `citizenid` VARCHAR(50) NOT NULL,
  `heist_type` VARCHAR(50) NOT NULL DEFAULT 'cargo',
  `cooldown_until` TIMESTAMP NOT NULL,
  
  UNIQUE KEY `unique_player_heist` (`citizenid`, `heist_type`),
  INDEX `idx_cooldown` (`cooldown_until`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Core table: Player heat level
CREATE TABLE IF NOT EXISTS `cargo_heist_heat` (
  `citizenid` VARCHAR(50) PRIMARY KEY,
  `heat_level` TINYINT DEFAULT 0,
  `total_heists` INT DEFAULT 0,
  `successful_heists` INT DEFAULT 0,
  `total_earned` BIGINT DEFAULT 0,
  `last_updated` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  INDEX `idx_heat_level` (`heat_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT 'QB-CargoHeist basic schema installed successfully!' as message;
