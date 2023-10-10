-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`food_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`food_groups` ;

CREATE TABLE IF NOT EXISTS `mydb`.`food_groups` (
  `food_group_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `foodGroupType` ENUM('carb', 'veggie', 'fruit', 'dairy', 'protein', 'fat') NOT NULL,
  PRIMARY KEY (`food_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`foods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`foods` ;

CREATE TABLE IF NOT EXISTS `mydb`.`foods` (
  `food_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `serving` VARCHAR(45) NOT NULL,
  `calorie` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NULL,
  `food_group_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`food_id`, `food_group_id`),
  CONSTRAINT `fk_foods_foodGroups1`
    FOREIGN KEY (`food_group_id`)
    REFERENCES `mydb`.`food_groups` (`food_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_foods_foodGroups1_idx` ON `mydb`.`foods` (`food_group_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`liquid_groups`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`liquid_groups` ;

CREATE TABLE IF NOT EXISTS `mydb`.`liquid_groups` (
  `liquid_group_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `liquid_group_type` ENUM('water', 'dairy', 'noncaloric', 'juice') NOT NULL,
  PRIMARY KEY (`liquid_group_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`liquids`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`liquids` ;

CREATE TABLE IF NOT EXISTS `mydb`.`liquids` (
  `liquid_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `serving` VARCHAR(45) NOT NULL,
  `calorie` VARCHAR(45) NOT NULL,
  `liquid_group_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`liquid_id`, `liquid_group_id`),
  CONSTRAINT `fk_liquids_liquidGroups1`
    FOREIGN KEY (`liquid_group_id`)
    REFERENCES `mydb`.`liquid_groups` (`liquid_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_liquids_liquidGroups1_idx` ON `mydb`.`liquids` (`liquid_group_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`date_times`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`date_times` ;

CREATE TABLE IF NOT EXISTS `mydb`.`date_times` (
  `date_time_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `when_ate` DATETIME NOT NULL,
  PRIMARY KEY (`date_time_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`meals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`meals` ;

CREATE TABLE IF NOT EXISTS `mydb`.`meals` (
  `meal_id` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `date_time_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`meal_id`, `date_time_id`),
  CONSTRAINT `fk_meals_dateTime`
    FOREIGN KEY (`date_time_id`)
    REFERENCES `mydb`.`date_times` (`date_time_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_meals_dateTime_idx` ON `mydb`.`meals` (`date_time_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`foods_has_meals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`foods_has_meals` ;

CREATE TABLE IF NOT EXISTS `mydb`.`foods_has_meals` (
  `food_id` INT UNSIGNED NOT NULL,
  `food_group_id` INT UNSIGNED NOT NULL,
  `meal_id` INT UNSIGNED NOT NULL,
  `date_time_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`food_id`, `food_group_id`, `meal_id`, `date_time_id`),
  CONSTRAINT `fk_foods_has_meals_foods1`
    FOREIGN KEY (`food_id` , `food_group_id`)
    REFERENCES `mydb`.`foods` (`food_id` , `food_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_foods_has_meals_meals1`
    FOREIGN KEY (`meal_id` , `date_time_id`)
    REFERENCES `mydb`.`meals` (`meal_id` , `date_time_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_foods_has_meals_meals1_idx` ON `mydb`.`foods_has_meals` (`meal_id` ASC, `date_time_id` ASC) VISIBLE;

CREATE INDEX `fk_foods_has_meals_foods1_idx` ON `mydb`.`foods_has_meals` (`food_id` ASC, `food_group_id` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `mydb`.`meals_has_liquids`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`meals_has_liquids` ;

CREATE TABLE IF NOT EXISTS `mydb`.`meals_has_liquids` (
  `meal_id` INT NOT NULL,
  `date_time_id` INT UNSIGNED NOT NULL,
  `liquid_id` INT UNSIGNED NOT NULL,
  `liquid_group_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`meal_id`, `date_time_id`, `liquid_id`, `liquid_group_id`),
  CONSTRAINT `fk_meals_has_liquids_meals1`
    FOREIGN KEY (`meal_id` , `date_time_id`)
    REFERENCES `mydb`.`meals` (`meal_id` , `date_time_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_meals_has_liquids_liquids1`
    FOREIGN KEY (`liquid_id` , `liquid_group_id`)
    REFERENCES `mydb`.`liquids` (`liquid_id` , `liquid_group_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_meals_has_liquids_liquids1_idx` ON `mydb`.`meals_has_liquids` (`liquid_id` ASC, `liquid_group_id` ASC) VISIBLE;

CREATE INDEX `fk_meals_has_liquids_meals1_idx` ON `mydb`.`meals_has_liquids` (`meal_id` ASC, `date_time_id` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
