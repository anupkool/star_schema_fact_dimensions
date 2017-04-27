# Create table for Source Tables

USE source_db;

DROP TABLE IF EXISTS source_db.`adm_decision`;

CREATE TABLE source_db.`adm_decision` (
  `applicant_client_id` VARCHAR(8) NOT NULL DEFAULT '',
  `admission_decision` VARCHAR(12) DEFAULT NULL,
  `term_code_admitted_to` VARCHAR(4) DEFAULT NULL,
  PRIMARY KEY (`applicant_client_id`),
  KEY `FK_adm_decision_term` (`term_code_admitted_to`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`adm_department`;

CREATE TABLE source_db.`adm_department` (
  `department_code` CHAR(7) NOT NULL DEFAULT '',
  `department_name` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`department_code`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`adm_messages`;

CREATE TABLE source_db.`adm_messages` (
  `id` INT(11) UNSIGNED NOT NULL DEFAULT '0',
  `applicant_client_id` VARCHAR(8) NOT NULL DEFAULT '',
  `sender_type` CHAR(3) NOT NULL COMMENT 'APP:Sent by Applicant, SCH: Sent by School',
  `message_subject` VARCHAR(27) NOT NULL DEFAULT '',
  `message_body` VARCHAR(24) NOT NULL DEFAULT '',
  `reply_to_id` INT(11) UNSIGNED DEFAULT NULL,
  `datetime_message_sent` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datetime_message_read` TIMESTAMP NULL DEFAULT NULL,
  KEY `idx_msg_appid` (`applicant_client_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`adm_program`;

CREATE TABLE source_db.`adm_program` (
  `program_code` VARCHAR(128) NOT NULL DEFAULT '',
  `department_code` CHAR(7) NOT NULL,
  PRIMARY KEY (`program_code`),
  KEY `FK_adm_program_deptcode` (`department_code`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`adm_review`;

CREATE TABLE source_db.`adm_review` (
  `reviewer_id` VARCHAR(16) NOT NULL,
  `applicant_client_id` VARCHAR(8) NOT NULL,
  `review_score` FLOAT DEFAULT NULL,
  `review_complete` TINYINT(1) DEFAULT '0',
  PRIMARY KEY (`reviewer_id`,`applicant_client_id`),
  KEY `NewIndex1` (`applicant_client_id`),
  KEY `idx_adm_review_appid` (`applicant_client_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 CHECKSUM=1 DELAY_KEY_WRITE=1 ROW_FORMAT=DYNAMIC;



DROP TABLE IF EXISTS source_db.`adm_tag`;

CREATE TABLE source_db.`adm_tag` (
  `applicant_client_id` VARCHAR(7) NOT NULL,
  `tag_name` VARCHAR(32) NOT NULL,
  KEY `idx_adm_tag_appid` (`applicant_client_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`adm_term`;

CREATE TABLE source_db.`adm_term` (
  `term_code` VARCHAR(4) NOT NULL DEFAULT '',
  `term_name` VARCHAR(13) NOT NULL DEFAULT '',
  PRIMARY KEY (`term_code`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`app_college`;

CREATE TABLE source_db.`app_college` (
  `id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `applicant_client_id` VARCHAR(7) DEFAULT NULL,
  `type` INT(4) DEFAULT NULL,
  `college_name` VARCHAR(128) DEFAULT NULL,
  `college_degree` VARCHAR(32) DEFAULT NULL,
  `college_country` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_app_college_appid` (`applicant_client_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



DROP TABLE IF EXISTS source_db.`app_profile`;

CREATE TABLE source_db.`app_profile` (
  `applicant_client_id` VARCHAR(7) NOT NULL,
  `printed_date` DATE  DEFAULT NULL,
  `submitted_date` DATE DEFAULT NULL,
  `last_accessed_date` DATE DEFAULT NULL,
  `fee_status` VARCHAR(32) DEFAULT NULL,
  `fee_payment_type` VARCHAR(16) DEFAULT NULL,
  `payment_card_type` VARCHAR(16) DEFAULT NULL,
  `applicant_last_name` VARCHAR(32) DEFAULT NULL,
  `applicant_first_name` VARCHAR(32) DEFAULT NULL,
  `applicant_middle_name` VARCHAR(32) DEFAULT NULL,
  `current_state_province` VARCHAR(32) DEFAULT NULL,
  `current_country` VARCHAR(128) DEFAULT NULL,
  `province` VARCHAR(32) DEFAULT NULL,
  `country_of_citizenship` VARCHAR(32) DEFAULT NULL,
  `hispanic_ethnicity` VARCHAR(32) DEFAULT NULL,
  `ethnicity_indian` VARCHAR(32) DEFAULT NULL,
  `ethnicity_asian` VARCHAR(32) DEFAULT NULL,
  `ethnicity_black` VARCHAR(32) DEFAULT NULL,
  `ethnicity_hawaiian` VARCHAR(64) DEFAULT NULL,
  `ethnicity_white` VARCHAR(32) DEFAULT NULL,
  `ethnicity` VARCHAR(32) DEFAULT NULL,
  `gender` VARCHAR(8) DEFAULT NULL,
  `attendance_status` VARCHAR(16) DEFAULT NULL,
  `degree_objective` VARCHAR(64) DEFAULT NULL,
  `program_code` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`applicant_client_id`),
  KEY `idx_app_profile_prgcode` (`program_code`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS source_db.`app_recommender`;

CREATE TABLE source_db.`app_recommender` (
  `id` INT(10) UNSIGNED NOT NULL DEFAULT '0',
  `applicant_client_id` VARCHAR(8) DEFAULT NULL,
  `type` INT(4) DEFAULT NULL,
  `recommender_fname` VARCHAR(22) NOT NULL DEFAULT '',
  `recommender_lname` VARCHAR(21) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_app_recommender_appid` (`applicant_client_id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;



# Create table for Dimension Tables

USE datamart_db;

DROP TABLE IF EXISTS datamart_db.dim_program;

CREATE TABLE datamart_db.dim_program (
program_skey INT NOT NULL AUTO_INCREMENT,
`program_code` VARCHAR(200) NOT NULL DEFAULT '', 
`department_name` VARCHAR(100) NOT NULL DEFAULT '',
  VERSION INT(100) DEFAULT NULL,
  date_from DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_to DATETIME DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY(program_skey)
);

DROP TABLE IF EXISTS datamart_db.`dim_applicant`;

CREATE TABLE datamart_db.`dim_applicant`(
   applicant_skey INT(50) NOT NULL AUTO_INCREMENT,
  `applicant_client_id` VARCHAR(7) NOT NULL DEFAULT '0',
  `applicant_last_name` VARCHAR(32) DEFAULT NULL,
  `applicant_first_name` VARCHAR(32) DEFAULT NULL,
  `applicant_middle_name` VARCHAR(32) DEFAULT NULL,
  `current_state_province` VARCHAR(32) DEFAULT NULL,
  `current_country` VARCHAR(128) DEFAULT NULL,
  `province` VARCHAR(32) DEFAULT NULL,
  `country_of_citizenship` VARCHAR(32) DEFAULT NULL,
  `gender` VARCHAR(8) DEFAULT NULL,
  `attendance_status` VARCHAR(16) DEFAULT NULL,
  `degree_objective` VARCHAR(64) DEFAULT NULL,
  `program_code` VARCHAR(64) DEFAULT NULL,
  `admission_decision` VARCHAR(12) DEFAULT NULL,
  modified_date DATETIME DEFAULT NULL COMMENT 'Date and time the record was last updated.',
  VERSION BIGINT(20) DEFAULT NULL,
  date_from DATETIME DEFAULT CURRENT_TIMESTAMP,
  date_to DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`applicant_skey`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS datamart_db.dim_ethnicity;

CREATE TABLE datamart_db.dim_ethnicity
  (
    ethnicity_skey     INT(50) NOT NULL AUTO_INCREMENT,
    junk_id           VARCHAR(50),
    ethnicity_indian   VARCHAR(50) NOT NULL DEFAULT ' ',
    ethnicity_asian    VARCHAR(50) NOT NULL DEFAULT ' ',
    ethnicity_black    VARCHAR(50) NOT NULL DEFAULT ' ',
    ethnicity_hawaiian VARCHAR(50) NOT NULL DEFAULT ' ',
    ethnicity_white    VARCHAR(50) NOT NULL DEFAULT ' ',
    ethnicity_hispanic VARCHAR(50) NOT NULL DEFAULT ' ',
    PRIMARY KEY (ethnicity_skey),
    UNIQUE KEY (junk_id)
  );
  
  DROP TABLE IF EXISTS datamart_db.dim_date;
CREATE TABLE datamart_db.dim_date (
  date_skey INT(11) NOT NULL DEFAULT '0',
  the_date DATE DEFAULT NULL,
  the_year SMALLINT(6) DEFAULT NULL,
  the_quarter TINYINT(4) DEFAULT NULL,
  the_month TINYINT(4) DEFAULT NULL,
  the_week TINYINT(4) DEFAULT NULL,
  day_of_year SMALLINT(6) DEFAULT NULL,
  day_of_month TINYINT(4) DEFAULT NULL,
  day_of_week TINYINT(4) DEFAULT NULL,
  PRIMARY KEY (date_skey)
) ENGINE=MYISAM DEFAULT CHARSET=utf8;

# Create Statement for Fact Table
DROP TABLE IF EXISTS datamart_db.fact_applicant;

CREATE TABLE datamart_db.fact_applicant(
   applicant_skey INT(50) NOT NULL ,
   program_skey INT(50) NOT NULL ,
   ethnicity_skey INT(50) NOT NULL ,
   submitted_date_skey INT(50) NOT NULL ,
   printed_date_skey INT(50) NOT NULL ,
   last_accessed_date_skey INT(50) NOT NULL ,
   cnt_msg_app INT(50),
   cnt_msg_sch INT(50),
   IS_APPLIED INT(1),
   IS_ADMITTED INT(1),
   IS_ACCEPTED INT(1)
   ) ENGINE=INNODB DEFAULT CHARSET=utf8;