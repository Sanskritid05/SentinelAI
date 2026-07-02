-- =====================================================
-- SentinelAI Database Schema
-- AI-Powered Industrial Safety Intelligence Platform
-- Database: MySQL 8.x
-- Author: Sanskriti Dutta
-- =====================================================

-- -----------------------------------------------------
-- Table `sentinelai_db`.`zones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`zones` (
  `zone_id` VARCHAR(20) NOT NULL,
  `plant_id` VARCHAR(20) NOT NULL,
  `zone_name` VARCHAR(100) NOT NULL,
  `zone_type` VARCHAR(100) NOT NULL,
  `hazard_class` VARCHAR(30) NOT NULL,
  `operating_status` VARCHAR(30) NOT NULL,
  `parent_zone` VARCHAR(100) NOT NULL,
  `latitude` DECIMAL(10,6) NOT NULL,
  `longitude` DECIMAL(10,6) NOT NULL,
  PRIMARY KEY (`zone_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_zone_plant` ON `sentinelai_db`.`zones` (`plant_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`equipment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`equipment` (
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `equipment_name` VARCHAR(150) NOT NULL,
  `equipment_type` VARCHAR(100) NOT NULL,
  `equipment_category` VARCHAR(100) NOT NULL,
  `manufacturer` VARCHAR(100) NOT NULL,
  `installation_date` DATE NOT NULL,
  `criticality` VARCHAR(30) NOT NULL,
  `health_score` INT NOT NULL,
  `remaining_useful_life_days` INT NOT NULL,
  `maintenance_due_days` INT NOT NULL,
  `maintenance_history_count` INT NOT NULL,
  `operational_state` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`equipment_id`),
  CONSTRAINT `fk_equipment_zone`
    FOREIGN KEY (`zone_id`)
    REFERENCES `sentinelai_db`.`zones` (`zone_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_equipment_zone` ON `sentinelai_db`.`equipment` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`alerts` (
  `alert_id` VARCHAR(20) NOT NULL,
  `sensor_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `alert_type` VARCHAR(100) NOT NULL,
  `severity` VARCHAR(30) NOT NULL,
  `triggered_at` DATETIME NOT NULL,
  `threshold_value` DOUBLE NOT NULL,
  `observed_value` DOUBLE NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  `generated_by` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`alert_id`),
  CONSTRAINT `fk_alert_equipment`
    FOREIGN KEY (`equipment_id`)
    REFERENCES `sentinelai_db`.`equipment` (`equipment_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_alert_sensor` ON `sentinelai_db`.`alerts` (`sensor_id` ASC) VISIBLE;

CREATE INDEX `idx_alert_equipment` ON `sentinelai_db`.`alerts` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_alert_zone` ON `sentinelai_db`.`alerts` (`zone_id` ASC) VISIBLE;

CREATE INDEX `idx_alert_time` ON `sentinelai_db`.`alerts` (`triggered_at` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`event_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`event_logs` (
  `event_id` VARCHAR(20) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `entity_type` VARCHAR(50) NOT NULL,
  `entity_id` VARCHAR(20) NOT NULL,
  `event_type` VARCHAR(100) NOT NULL,
  `old_status` VARCHAR(50) NULL DEFAULT NULL,
  `new_status` VARCHAR(50) NOT NULL,
  `generated_by` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`event_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_event_entity` ON `sentinelai_db`.`event_logs` (`entity_type` ASC, `entity_id` ASC) VISIBLE;

CREATE INDEX `idx_event_time` ON `sentinelai_db`.`event_logs` (`timestamp` ASC) VISIBLE;

CREATE INDEX `idx_event_timestamp` ON `sentinelai_db`.`event_logs` (`timestamp` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`incidents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`incidents` (
  `incident_id` VARCHAR(20) NOT NULL,
  `alert_id` VARCHAR(20) NOT NULL,
  `risk_assessment_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `occurred_at` DATETIME NOT NULL,
  `incident_type` VARCHAR(100) NOT NULL,
  `incident_category` VARCHAR(100) NOT NULL,
  `severity` VARCHAR(30) NOT NULL,
  `lost_time_hours` INT NOT NULL,
  `root_cause` VARCHAR(255) NOT NULL,
  `corrective_action_status` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`incident_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_incident_alert` ON `sentinelai_db`.`incidents` (`alert_id` ASC) VISIBLE;

CREATE INDEX `idx_incident_risk` ON `sentinelai_db`.`incidents` (`risk_assessment_id` ASC) VISIBLE;

CREATE INDEX `idx_incident_equipment` ON `sentinelai_db`.`incidents` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_incident_zone` ON `sentinelai_db`.`incidents` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`workers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`workers` (
  `worker_id` VARCHAR(20) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `department` VARCHAR(100) NOT NULL,
  `role` VARCHAR(100) NOT NULL,
  `shift` VARCHAR(20) NOT NULL,
  `experience_years` INT NOT NULL,
  `certifications` VARCHAR(255) NOT NULL,
  `assigned_zone_id` VARCHAR(20) NOT NULL,
  `employment_status` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`worker_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_worker_zone` ON `sentinelai_db`.`workers` (`assigned_zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`maintenance_jobs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`maintenance_jobs` (
  `maintenance_job_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `worker_id` VARCHAR(20) NOT NULL,
  `maintenance_type` VARCHAR(50) NOT NULL,
  `maintenance_priority` VARCHAR(30) NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  `planned_start` DATETIME NOT NULL,
  `completed_at` DATETIME NOT NULL,
  `health_score_before` INT NOT NULL,
  `health_score_after` INT NOT NULL,
  `work_summary` TEXT NOT NULL,
  PRIMARY KEY (`maintenance_job_id`),
  CONSTRAINT `fk_maintenance_worker`
    FOREIGN KEY (`worker_id`)
    REFERENCES `sentinelai_db`.`workers` (`worker_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_maintenance_equipment` ON `sentinelai_db`.`maintenance_jobs` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_maintenance_worker` ON `sentinelai_db`.`maintenance_jobs` (`worker_id` ASC) VISIBLE;

CREATE INDEX `idx_maintenance_zone` ON `sentinelai_db`.`maintenance_jobs` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`permits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`permits` (
  `permit_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `worker_id` VARCHAR(20) NOT NULL,
  `permit_type` VARCHAR(50) NOT NULL,
  `valid_from` DATETIME NOT NULL,
  `valid_to` DATETIME NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  `risk_level` VARCHAR(30) NOT NULL,
  `issued_by` VARCHAR(20) NOT NULL,
  `approved_by` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`permit_id`),
  CONSTRAINT `fk_permit_equipment`
    FOREIGN KEY (`equipment_id`)
    REFERENCES `sentinelai_db`.`equipment` (`equipment_id`),
  CONSTRAINT `fk_permit_worker`
    FOREIGN KEY (`worker_id`)
    REFERENCES `sentinelai_db`.`workers` (`worker_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_permit_equipment` ON `sentinelai_db`.`permits` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_permit_worker` ON `sentinelai_db`.`permits` (`worker_id` ASC) VISIBLE;

CREATE INDEX `idx_permit_zone` ON `sentinelai_db`.`permits` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`plants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`plants` (
  `plant_id` VARCHAR(20) NOT NULL,
  `plant_name` VARCHAR(150) NOT NULL,
  `company` VARCHAR(150) NOT NULL,
  `plant_type` VARCHAR(100) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `state` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `commissioning_year` YEAR NOT NULL,
  `installed_capacity_mtpa` DECIMAL(5,2) NOT NULL,
  `timezone` VARCHAR(50) NOT NULL,
  `data_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`plant_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`recommendations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`recommendations` (
  `recommendation_id` VARCHAR(20) NOT NULL,
  `alert_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `generated_at` DATETIME NOT NULL,
  `recommendation_type` VARCHAR(100) NOT NULL,
  `priority` VARCHAR(20) NOT NULL,
  `recommended_action` TEXT NOT NULL,
  `expected_risk_reduction` DOUBLE NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`recommendation_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_rec_alert` ON `sentinelai_db`.`recommendations` (`alert_id` ASC) VISIBLE;

CREATE INDEX `idx_rec_equipment` ON `sentinelai_db`.`recommendations` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_rec_zone` ON `sentinelai_db`.`recommendations` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`risk_assessments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`risk_assessments` (
  `risk_assessment_id` VARCHAR(20) NOT NULL,
  `alert_id` VARCHAR(20) NOT NULL,
  `recommendation_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `assessed_at` DATETIME NOT NULL,
  `previous_risk_score` DOUBLE NOT NULL,
  `current_risk_score` DOUBLE NOT NULL,
  `risk_delta` DOUBLE NOT NULL,
  `confidence` DOUBLE NOT NULL,
  `risk_band` VARCHAR(30) NOT NULL,
  `contributing_sensor_ids` TEXT NOT NULL,
  `top_contributing_factor` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`risk_assessment_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_risk_alert` ON `sentinelai_db`.`risk_assessments` (`alert_id` ASC) VISIBLE;

CREATE INDEX `idx_risk_recommendation` ON `sentinelai_db`.`risk_assessments` (`recommendation_id` ASC) VISIBLE;

CREATE INDEX `idx_risk_equipment` ON `sentinelai_db`.`risk_assessments` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_risk_zone` ON `sentinelai_db`.`risk_assessments` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`sensors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`sensors` (
  `sensor_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `sensor_type` VARCHAR(50) NOT NULL,
  `sensor_category` VARCHAR(50) NOT NULL,
  `unit` VARCHAR(30) NOT NULL,
  `min_value` DOUBLE NOT NULL,
  `max_value` DOUBLE NOT NULL,
  `warning_threshold` DOUBLE NOT NULL,
  `critical_threshold` DOUBLE NOT NULL,
  `baseline_value` DOUBLE NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`sensor_id`),
  CONSTRAINT `fk_sensor_equipment`
    FOREIGN KEY (`equipment_id`)
    REFERENCES `sentinelai_db`.`equipment` (`equipment_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_sensor_equipment` ON `sentinelai_db`.`sensors` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_sensor_zone` ON `sentinelai_db`.`sensors` (`zone_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`sensor_readings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`sensor_readings` (
  `reading_id` VARCHAR(25) NOT NULL,
  `sensor_id` VARCHAR(20) NOT NULL,
  `equipment_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `reading_value` DOUBLE NOT NULL,
  `quality_flag` VARCHAR(20) NOT NULL,
  `operating_state` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`reading_id`),
  CONSTRAINT `fk_reading_sensor`
    FOREIGN KEY (`sensor_id`)
    REFERENCES `sentinelai_db`.`sensors` (`sensor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_reading_sensor` ON `sentinelai_db`.`sensor_readings` (`sensor_id` ASC) VISIBLE;

CREATE INDEX `idx_reading_equipment` ON `sentinelai_db`.`sensor_readings` (`equipment_id` ASC) VISIBLE;

CREATE INDEX `idx_reading_zone` ON `sentinelai_db`.`sensor_readings` (`zone_id` ASC) VISIBLE;

CREATE INDEX `idx_reading_time` ON `sentinelai_db`.`sensor_readings` (`timestamp` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`shift_logs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`shift_logs` (
  `shift_id` VARCHAR(20) NOT NULL,
  `shift_name` VARCHAR(20) NOT NULL,
  `supervisor_id` VARCHAR(20) NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `worker_count` INT NOT NULL,
  `handover_status` VARCHAR(30) NOT NULL,
  `remarks` TEXT NOT NULL,
  PRIMARY KEY (`shift_id`),
  CONSTRAINT `fk_shift_supervisor`
    FOREIGN KEY (`supervisor_id`)
    REFERENCES `sentinelai_db`.`workers` (`worker_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_shift_supervisor` ON `sentinelai_db`.`shift_logs` (`supervisor_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sentinelai_db`.`worker_locations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sentinelai_db`.`worker_locations` (
  `location_id` VARCHAR(20) NOT NULL,
  `worker_id` VARCHAR(20) NOT NULL,
  `zone_id` VARCHAR(20) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `entry_time` DATETIME NOT NULL,
  `exit_time` DATETIME NOT NULL,
  `location_source` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`location_id`),
  CONSTRAINT `fk_location_worker`
    FOREIGN KEY (`worker_id`)
    REFERENCES `sentinelai_db`.`workers` (`worker_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE INDEX `idx_location_worker` ON `sentinelai_db`.`worker_locations` (`worker_id` ASC) VISIBLE;

CREATE INDEX `idx_location_zone` ON `sentinelai_db`.`worker_locations` (`zone_id` ASC) VISIBLE;

CREATE INDEX `idx_location_time` ON `sentinelai_db`.`worker_locations` (`timestamp` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
