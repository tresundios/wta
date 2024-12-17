/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 50714
 Source Host           : localhost:3306
 Source Schema         : sportsclub

 Target Server Type    : MySQL
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
`username` varchar(20),
`pass_key` varchar(20),
`securekey` varchar(20),
`Full_name` varchar(50),
PRIMARY KEY (`username`)
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('admin1', 'admin1', 'admin1', 'Sports Club Manager');
INSERT INTO `admin` VALUES ('admin2', 'admin2', 'admin2', 'Deputy Manager');



-- ----------------------------
-- Table structure for log_users
-- ----------------------------
DROP TABLE IF EXISTS `log_users`;
CREATE TABLE `log_users` (
`id` int(11) NOT NULL,
`users_userid` int(11) NOT NULL,
`action` varchar(20) NOT NULL,
`cdate` datetime NOT NULL
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;



-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`(
`userid` varchar(20),
`username` varchar(40),
`gender` varchar(8),
`mobile` varchar(20),
`email` varchar(20),
`dob` varchar(10),
`joining_date` varchar(10),
PRIMARY KEY (`userid`) USING BTREE,
UNIQUE INDEX `email`(`email`) USING BTREE,
INDEX `userid`(`userid`) USING BTREE
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1529336794', 'Christiana Mayberry', 'Male', '3362013747', 'christiani@gmail.com', '1968-04-13', '2018-06-18');
INSERT INTO `users` VALUES ('1529336795', 'Shreyansh Gupta', 'Male', '3362013747', 'shreyansh@gmail.com', '1998-12-12', '2020-06-10');


-- ----------------------------
-- Table structure for health_status
-- ----------------------------
DROP TABLE IF EXISTS `health_status`;
CREATE TABLE `health_status` (
`hid` int(5) NOT NULL AUTO_INCREMENT,
`calorie` varchar(8),
`height` varchar(8),
`weight` varchar(8),
`fat` varchar(8),
`remarks` varchar(200),
`uid` varchar(20),
PRIMARY KEY (`hid`) USING BTREE,
INDEX `userID_idx`(`uid`) USING BTREE,
CONSTRAINT `uID` FOREIGN KEY (`uid`) REFERENCES `users` (`userid`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;


-- ----------------------------
-- Records of health_status
-- ----------------------------
INSERT INTO `health_status` VALUES (1, NULL, NULL, NULL, NULL, NULL, '1529336794');
INSERT INTO `health_status` VALUES (2, NULL, NULL, NULL, NULL, NULL, '1529336795');



-- ----------------------------
-- Table structure for plan
-- ----------------------------
DROP TABLE IF EXISTS `plan`;
CREATE TABLE `plan` (
`pid` varchar(8),
`planName` varchar(20),
`description` varchar(200),
`validity` varchar(20),
`amount` int(10) NOT NULL,
`active` varchar(255),
PRIMARY KEY (`pid`) USING BTREE,
INDEX `pid`(`pid`) USING BTREE
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;


-- ----------------------------
-- Records of plan
-- ----------------------------
INSERT INTO `plan` VALUES ('FOQKJF', 'Football Plan', 'A monthly subscription that unlocks the members access to the football Plan and coach support on chat.', '1', 1000, 'yes');
INSERT INTO `plan` VALUES ('COQKJC', 'Cricket Plan', 'A monthly subscription that unlocks the members access to the Cricket Plan and coach support on chat.', '1', 1500, 'yes');
INSERT INTO `plan` VALUES ('BOQKJB', 'Badminton Plan', 'A monthly subscription that unlocks the members access to the Badminton Plan and coach support on chat.', '1', 800, 'yes');



-- ----------------------------
-- Table structure for enrolls_to
-- ----------------------------
DROP TABLE IF EXISTS `enrolls_to`;
CREATE TABLE `enrolls_to` (
`et_id` int(5) NOT NULL AUTO_INCREMENT,
`pid` varchar(8) ,
`uid` varchar(20),
`paid_date` varchar(15),
`expire` varchar(15),
`renewal` varchar(15),
PRIMARY KEY (`et_id`) USING BTREE,
INDEX `user_ID`(`uid`) USING BTREE,
INDEX `plan_ID_idx`(`pid`) USING BTREE,
CONSTRAINT `plan_ID` FOREIGN KEY (`pid`) REFERENCES `plan` (`pid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
CONSTRAINT `user_ID` FOREIGN KEY (`uid`) REFERENCES `users` (`userid`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of enrolls_to
-- ----------------------------
INSERT INTO `enrolls_to` VALUES (1, 'FOQKJF', '1529336794', '2018-06-18', '2018-07-18', 'yes');




-- ----------------------------
-- Table structure for timetable
-- ----------------------------
DROP TABLE IF EXISTS `sports_timetable`;
CREATE TABLE `sports_timetable` (
`tid` int(12) NOT NULL AUTO_INCREMENT,
`tname` varchar(45),
`day1` varchar(200),
`day2` varchar(200),
`day3` varchar(200),
`day4` varchar(200),
`day5` varchar(200),
`day6` varchar(200),
`pid` varchar(8),
PRIMARY KEY (`tid`) USING BTREE,
CONSTRAINT `pID` FOREIGN KEY (`pid`) REFERENCES `plan` (`pid`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;



-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address` (
`id` varchar(20),
`streetName` varchar(40),
`state` varchar(15),
`city` varchar(15),
`zipcode` varchar(20),
INDEX `userID`(`id`) USING BTREE,
CONSTRAINT `userID` FOREIGN KEY (`id`) REFERENCES `users` (`userid`) ON DELETE CASCADE ON UPDATE NO ACTION
)ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES ('1529336794', '2069  Quarry Drive', 'NC', 'Greensboro', '27409');



-- ----------------------------
-- Structure for Triggers in user table
-- ----------------------------

-- Trigger for deletion
CREATE TRIGGER `deletelog` BEFORE DELETE ON `users`
FOR EACH ROW insert into log_users values(null,old.userid,'deleted',now());

-- Trigger for insertion
CREATE TRIGGER `insertlog` AFTER INSERT ON `users`
FOR EACH ROW INSERT INTO log_users VALUES(null,NEW.userid,'inserted',now());

-- Trigger for updation
CREATE TRIGGER `updatelog` AFTER UPDATE ON `users`
FOR EACH ROW insert INTO log_users values(null,new.userid,'updated',now());



-- ----------------------------
-- Structure for Stored Procedure in user table
-- ----------------------------

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `countGender`()
SELECT gender , COUNT(*) from users group by gender$$
DELIMITER ;

-- --------------------------------

SET FOREIGN_KEY_CHECKS = 1;


DROP TABLE IF EXISTS `walk_activity`;
CREATE TABLE `walk_activity` (
    `activity_id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` VARCHAR(20) NOT NULL,
    `activity_date` DATE NOT NULL,
    `distance_walked` DECIMAL(8,2) NOT NULL, -- Distance in kilometers
    PRIMARY KEY (`activity_id`),
    INDEX `user_id_idx` (`user_id`),
    CONSTRAINT `user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`userid`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Example records for walk_activity
-- ----------------------------
INSERT INTO `walk_activity` (`user_id`, `activity_date`, `distance_walked`) VALUES
('1529336794', '2024-12-01', 5.00),
('1529336794', '2024-12-02', 4.50),
('1529336794', '2024-12-03', 6.30),
('1529336795', '2024-12-01', 3.00),
('1529336795', '2024-12-02', 5.20);

-- ----------------------------
-- View for 30-day cumulative walk tracking
-- ----------------------------
DROP VIEW IF EXISTS `cumulative_walk_stats`;
CREATE VIEW `cumulative_walk_stats` AS
SELECT
    `u`.`userid`,
    `u`.`username`,
    `u`.`gender`,
    SUM(`w`.`distance_walked`) AS `total_distance_walked`,
    COUNT(DISTINCT `w`.`activity_date`) AS `active_days`,
    CASE
        WHEN COUNT(DISTINCT `w`.`activity_date`) >= 30 THEN 'Completed 30 Days'
        ELSE CONCAT(30 - COUNT(DISTINCT `w`.`activity_date`), ' Days Remaining')
    END AS `status`
FROM
    `users` AS `u`
LEFT JOIN
    `walk_activity` AS `w` ON `u`.`userid` = `w`.`user_id`
WHERE
    `w`.`activity_date` >= CURDATE() - INTERVAL 30 DAY
GROUP BY
    `u`.`userid`, `u`.`username`, `u`.`gender`;



-- Example: To retrieve cumulative stats for all users:
-- SELECT * FROM `cumulative_walk_stats`;

-- ----------------------------
-- Procedure for gender-based walk assessment
-- ----------------------------
DELIMITER $$
CREATE PROCEDURE `gender_based_walk_stats`()
BEGIN
    SELECT
        `gender`,
        COUNT(*) AS `num_walkers`,
        AVG(`total_distance_walked`) AS `avg_distance_walked`,
        AVG(`active_days`) AS `avg_active_days`
    FROM
        `cumulative_walk_stats`
    GROUP BY `gender`;
END$$
DELIMITER ;
-- Example: To execute the procedure:
-- CALL `gender_based_walk_stats`();

SET FOREIGN_KEY_CHECKS = 1;
