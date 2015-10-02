use `dti`;

DROP TABLE IF EXISTS `expense_or_incomes`,  `survey_result_answers`, `survey_results`, `survey_invitations`, 
`survey_questions`, `survey_questionnaire`, `users`, `entrepreneur_funds`, `entrepreneurs`, `user_types`, 
`questionnaire_types`, `question_types`, `receipt_doc_types`, `survey_invitation_status_types`, `countries`, `currencies`;

CREATE TABLE `countries` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'USA, GUINEA, BENIN',
  PRIMARY KEY (`id`)
);

CREATE TABLE `currencies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'USD, GNF, CFA',
  PRIMARY KEY (`id`)
);

CREATE TABLE `user_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Admin, Entrepreneur, Strategic Advisor, BoD etc.',
  PRIMARY KEY (`id`)
);

CREATE TABLE `questionnaire_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Daily, Monthly Quarterly, Ad-hoc etc.',
  PRIMARY KEY (`id`)
);

CREATE TABLE `question_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Multi-select, Multi-choice, Open-answer etc.',
  PRIMARY KEY (`id`)
);

CREATE TABLE `receipt_doc_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Type like JPEG or PDF etc',
  PRIMARY KEY (`id`)
);

CREATE TABLE `survey_invitation_status_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Draft, Invited, Completed etc',
  PRIMARY KEY (`id`)
);

CREATE TABLE `entrepreneurs` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL COMMENT 'Business name',
  `owner_name` VARCHAR(200) NOT NULL,
  `full_address` VARCHAR(2000) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  `country_id` INT(11) NOT NULL,
  `start_date` DATE NOT NULL,
  `yetp_session_notes` VARCHAR(10000),
  `currency_id` INT(11) NOT NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 0,
  `description` TEXT NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `ef_country_id_fk` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ef_currency_id_fk` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
  
  
CREATE TABLE `entrepreneur_funds` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `entrepreneur_id` INT(11) NOT NULL,
  `date` DATE NOT NULL,
  `amount` NUMERIC(10,2) NOT NULL,
  `amount_in_usd` NUMERIC(10,2) NOT NULL,
  `description` TEXT NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `ef_entrepreneurs_id_fk` FOREIGN KEY (`entrepreneur_id`) REFERENCES `entrepreneurs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;  
  
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(45) NOT NULL,
  `password` varchar(200) NOT NULL Comment 'Encrypted than hashed',
  `user_type_id` int(11) NOT NULL,
  `entrepreneur_id` INT(11) NULL,
  `email` VARCHAR(100) NULL,
  `is_active` TINYINT(1) NOT NULL DEFAULT 0,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `user_entrepreneurs_id_fk` FOREIGN KEY (`entrepreneur_id`) REFERENCES `entrepreneurs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `user_user_type_id_fk` FOREIGN KEY (`user_type_id`) REFERENCES `user_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



CREATE TABLE `expense_or_incomes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrepreneur_id` INT(11) NOT NULL,
  `is_expense` TINYINT(1) NOT NULL DEFAULT '1' COMMENT 'true means expense, else income',
  `date` DATE NOT NULL,
  `category` VARCHAR(30) NOT NULL,
  `description` TEXT NULL,
  `currency_id` INT(11) NOT NULL,
  `amount` NUMERIC(10, 2) NOT NULL,
  `paid_to_or_received_from` VARCHAR(1000) NULL,
  `invoce_or_reference_or_item_number` VARCHAR(1000) NULL,
  `picture_receipt` blob  null COMMENT 'Actual image stored in DB',
  `receipt_name` VARCHAR(200)  null COMMENT 'Name of the document of actual image stored in DB',
  `receipt_doc_type_id` INT(11) null,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `eoi_entrepreneurs_id_fk` FOREIGN KEY (`entrepreneur_id`) REFERENCES `entrepreneurs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eoi_receipt_doc_type_id_fk` FOREIGN KEY (`receipt_doc_type_id`) REFERENCES `receipt_doc_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eoi_currency_id_fk` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `survey_questionnaire` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(2000) NOT NULL,
  `questionnaire_type_id` int(11) NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `sq_questionnaire_type_id_fk` FOREIGN KEY (`questionnaire_type_id`) REFERENCES `questionnaire_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `survey_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_questionnaire_id` INT(11) NOT NULL,
  `question` varchar(1000) NOT NULL,
  `question_type_id` INT(11) NOT NULL,
  `answer_options_scsv` varchar(100) DEFAULT NULL,
  `display_order` int(11) NOT NULL DEFAULT 1,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `sq_questionnaire_id_fk` FOREIGN KEY (`survey_questionnaire_id`) REFERENCES `survey_questionnaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sq_question_type_id_fk` FOREIGN KEY (`question_type_id`) REFERENCES `question_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `survey_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(2000) NOT NULL,
  `entrepreneur_id` INT(11) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `survey_questionnaire_id` INT(11) NOT NULL,
  `survey_invitation_status_type_id` INT(11) NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `si_entrepreneurs_id_fk` FOREIGN KEY (`entrepreneur_id`) REFERENCES `entrepreneurs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `si_questionnaire_id_fk` FOREIGN KEY (`survey_questionnaire_id`) REFERENCES `survey_questionnaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `si_survey_invitation_status_type_id_fk` FOREIGN KEY (`survey_invitation_status_type_id`) REFERENCES `survey_invitation_status_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `survey_results` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entrepreneur_id` INT(11) NOT NULL,
  `entered_by_user_id` INT(11),
  `description` TEXT DEFAULT NULL,
  `survey_invitation_id` INT(11) NOT NULL,
  `survey_questionnaire_id` INT(11) NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `sr_entrepreneurs_id_fk` FOREIGN KEY (`entrepreneur_id`) REFERENCES `entrepreneurs` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sr_entered_by_user_id_fk` FOREIGN KEY (`entered_by_user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sr_invitation_id_fk` FOREIGN KEY (`survey_invitation_id`) REFERENCES `survey_invitations` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sr_questionnaire_id_fk` FOREIGN KEY (`survey_questionnaire_id`) REFERENCES `survey_questionnaire` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `survey_result_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_result_id` INT(11) NOT NULL,
  `survey_question_id` INT(11) NOT NULL,
  `answer` TEXT NOT NULL,
  `ins_ts` datetime DEFAULT CURRENT_TIMESTAMP,
  `upd_ts` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `sra_survey_result_id_fk` FOREIGN KEY (`survey_result_id`) REFERENCES `survey_results` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `sra_survey_question_id_fk` FOREIGN KEY (`survey_question_id`) REFERENCES `survey_questions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `user_types` values(1, 'Admin'), (2, 'Entrepreneur.'), (3, 'S.A.'), (4, 'B.O.D.');

INSERT INTO `questionnaire_types` values(1, 'Daily'), (2, 'Monthly'), (3, 'Quarterly'), (4, 'Ad-hoc');

INSERT INTO `question_types` values(1, 'Multi-select'), (2, 'Multi-choice'), (3, 'Open-answer');

INSERT INTO `receipt_doc_types` values(1, 'PDF'), (2, 'JPEG'), (3, 'JPG'), (4, 'PNG'), (5, 'TIFF');

INSERT INTO `survey_invitation_status_types` values(1, 'Draft'), (2, 'Invited'), (3, 'Completed');

INSERT INTO `countries` values(1, 'USA'), (2, 'Guinea'), (3, 'Benin');

INSERT INTO `currencies` values(1, 'USD'), (2, 'GNF'), (3, 'CFA');

INSERT INTO `users` (`id`, `login`, `password`, `user_type_id`, `email`) VALUES (1, 'admin', 'admin', 1, 'admin@daretoinnovate.org');
