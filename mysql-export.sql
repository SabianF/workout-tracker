-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema sabian_eg_workout
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema sabian_eg_workout
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sabian_eg_workout` DEFAULT CHARACTER SET utf8 ;
USE `sabian_eg_workout` ;

-- -----------------------------------------------------
-- Table `sabian_eg_workout`.`type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`type` (
  `id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `diff` TINYINT UNSIGNED NOT NULL,
  `desc` VARCHAR(150) NULL,
  `added` TIMESTAMP GENERATED ALWAYS AS () STORED,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sabian_eg_workout`.`log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` TIMESTAMP GENERATED ALWAYS AS (SELECT NOW()) STORED,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sabian_eg_workout`.`log_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`log_type` (
  `log_id` INT UNSIGNED NOT NULL,
  `type_id` TINYINT UNSIGNED NOT NULL,
  `count` TINYINT NULL,
  PRIMARY KEY (`log_id`, `type_id`),
  INDEX `fk_log_has_type_type1_idx` (`type_id` ASC) VISIBLE,
  INDEX `fk_log_has_type_log_idx` (`log_id` ASC) VISIBLE,
  CONSTRAINT `fk_log_has_type_log`
    FOREIGN KEY (`log_id`)
    REFERENCES `sabian_eg_workout`.`log` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_log_has_type_type1`
    FOREIGN KEY (`type_id`)
    REFERENCES `sabian_eg_workout`.`type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `sabian_eg_workout` ;

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`overview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`overview` (`'Date'` INT, `'Type'` INT, `'Count'` INT, `'Points'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`overview_today`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`overview_today` (`name` INT, `count` INT, `'Points'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`reps_pts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`reps_pts` (`date` INT, `'Reps (Day)'` INT, `'Points (Day)'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`totals`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`totals` (`'Reps (Grand Total)'` INT, `'Points (Grand Total)'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`type_counts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`type_counts` (`'Type'` INT, `'Days'` INT, `'Reps (Total)'` INT, `'Points'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `sabian_eg_workout`.`log_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sabian_eg_workout`.`log_view` (`'Date'` INT, `'Type'` INT, `'Count'` INT, `'Points'` INT);

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`overview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`overview`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `overview` AS
SELECT
	date 		AS 'Date'
	,type.name	AS 'Type'
	,count 		AS 'Count'
	,log.count * type.diff AS 'Points'
FROM
	log
JOIN
	type
ON
	type.id = log.type;

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`overview_today`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`overview_today`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `overview_today` AS
SELECT
	type.name
	,log.count
	,log.count * type.diff AS 'Points'
FROM
	log
	,type
WHERE
	log.type_id = type.id
	AND
	log.date = CURDATE();

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`reps_pts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`reps_pts`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `reps_pts` AS
SELECT
	date
	,SUM(Count)		AS 'Reps (Day)'
	,SUM(Points)	AS 'Points (Day)'
FROM
	overview
GROUP BY
	date;

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`totals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`totals`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `totals` AS
SELECT
	SUM(Reps (Total))	AS 'Reps (Grand Total)'
	,SUM(Points)		AS 'Points (Grand Total)'
FROM
	type_counts;

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`type_counts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`type_counts`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `type_counts` AS
SELECT
	type.name AS 'Type'

	,COUNT(type)	AS 'Days'
	,SUM(count)		AS 'Reps (Total)'
	,SUM(count) *	(
						SELECT
							diff
						FROM
							type
						WHERE
							type.id = Log.type
					) AS 'Points'
FROM
	log
JOIN
	type
ON
	type.id = type
GROUP BY
	type.name;

-- -----------------------------------------------------
-- View `sabian_eg_workout`.`log_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `sabian_eg_workout`.`log_view`;
USE `sabian_eg_workout`;
CREATE  OR REPLACE VIEW `log_view` AS
SELECT
	date 			AS 'Date'
	,type.name		AS 'Type'
	,log_type.count AS 'Count'
	,log_type.count * Type.diff AS 'Points'
FROM
	log
JOIN
	type
ON
	type.id = log_type.type_id
    AND
    log.id = log_type.log_id;
CREATE USER 'test';

GRANT SELECT ON TABLE `sabian_eg_workout`.* TO 'test';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
