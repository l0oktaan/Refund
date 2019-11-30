-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.3.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for refund2
CREATE DATABASE IF NOT EXISTS `refund2` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `refund2`;

-- Dumping structure for table refund2.10_form_rules
CREATE TABLE IF NOT EXISTS `10_form_rules` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `order` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_of` int(11) NOT NULL,
  `rule_type` int(11) NOT NULL,
  `result_type` int(11) DEFAULT NULL,
  `condition` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `condition_type` int(11) DEFAULT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `10_form_rules_form_id_index` (`form_id`),
  CONSTRAINT `10_form_rules_form_id_foreign` FOREIGN KEY (`form_id`) REFERENCES `9_forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.112_considers
CREATE TABLE IF NOT EXISTS `112_considers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_rule_id` int(10) unsigned NOT NULL,
  `order` int(11) NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` int(11) NOT NULL,
  `oper` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `var1` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `var2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `112_considers_form_rule_id_index` (`form_rule_id`),
  CONSTRAINT `112_considers_form_rule_id_foreign` FOREIGN KEY (`form_rule_id`) REFERENCES `10_form_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.11_form_conditions
CREATE TABLE IF NOT EXISTS `11_form_conditions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_rule_id` int(10) unsigned NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `condition_type` int(11) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `11_form_conditions_form_rule_id_index` (`form_rule_id`),
  CONSTRAINT `11_form_conditions_form_rule_id_foreign` FOREIGN KEY (`form_rule_id`) REFERENCES `10_form_rules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.12_refund_forms
CREATE TABLE IF NOT EXISTS `12_refund_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `refund_id` int(10) unsigned NOT NULL,
  `result` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `12_refund_forms_form_id_index` (`form_id`),
  KEY `12_refund_forms_refund_id_index` (`refund_id`),
  CONSTRAINT `12_refund_forms_form_id_foreign` FOREIGN KEY (`form_id`) REFERENCES `9_forms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `12_refund_forms_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.13_refund_details
CREATE TABLE IF NOT EXISTS `13_refund_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_form_id` int(10) unsigned NOT NULL,
  `consider_id` int(10) unsigned NOT NULL,
  `result_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `13_refund_details_refund_form_id_index` (`refund_form_id`),
  KEY `13_refund_details_consider_id_index` (`consider_id`),
  CONSTRAINT `13_refund_details_consider_id_foreign` FOREIGN KEY (`consider_id`) REFERENCES `112_considers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `13_refund_details_refund_form_id_foreign` FOREIGN KEY (`refund_form_id`) REFERENCES `12_refund_forms` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.1_offices
CREATE TABLE IF NOT EXISTS `1_offices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contact_name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `1_offices_code_unique` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.2_refunds
CREATE TABLE IF NOT EXISTS `2_refunds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `office_id` int(10) unsigned NOT NULL,
  `approve_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_date` date NOT NULL,
  `sent_date` date DEFAULT NULL,
  `complete_date` date DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `2_refunds_id_unique` (`id`),
  KEY `2_refunds_office_id_index` (`office_id`),
  CONSTRAINT `2_refunds_office_id_foreign` FOREIGN KEY (`office_id`) REFERENCES `1_offices` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.3_contracts
CREATE TABLE IF NOT EXISTS `3_contracts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `contract_party` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contract_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contract_date` date NOT NULL,
  `budget` decimal(15,2) NOT NULL,
  `penalty_per_day` decimal(10,2) NOT NULL,
  `contract_start` date NOT NULL,
  `contract_end` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `3_contracts_refund_id_index` (`refund_id`),
  CONSTRAINT `3_contracts_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.4_contract_budget_edits
CREATE TABLE IF NOT EXISTS `4_contract_budget_edits` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `budget_new` decimal(15,2) NOT NULL,
  `penalty_new` decimal(10,2) NOT NULL,
  `contract_edit_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `4_contract_budget_edits_refund_id_index` (`refund_id`),
  CONSTRAINT `4_contract_budget_edits_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.5_contract_time_edits
CREATE TABLE IF NOT EXISTS `5_contract_time_edits` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `approve_date` date NOT NULL,
  `edit_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `edit_detail` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `edit_days` int(11) NOT NULL,
  `edit_budget` decimal(15,2) NOT NULL,
  `contract_end_date` date NOT NULL,
  `approve_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `approve_case` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `problem_end_date` date NOT NULL,
  `book_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `5_contract_time_edits_refund_id_index` (`refund_id`),
  CONSTRAINT `5_contract_time_edits_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.6_delivers
CREATE TABLE IF NOT EXISTS `6_delivers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `delivery` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `detail` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_date` date NOT NULL,
  `overdue_days` int(11) NOT NULL,
  `penalty` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `6_delivers_refund_id_index` (`refund_id`),
  CONSTRAINT `6_delivers_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.7_deposit_penalties
CREATE TABLE IF NOT EXISTS `7_deposit_penalties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `deposit_no` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deposit_date` date NOT NULL,
  `amount` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `7_deposit_penalties_refund_id_index` (`refund_id`),
  CONSTRAINT `7_deposit_penalties_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.8_approve_refunds
CREATE TABLE IF NOT EXISTS `8_approve_refunds` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `refund_id` int(10) unsigned NOT NULL,
  `receive_date` date NOT NULL,
  `refund_days` int(11) NOT NULL,
  `refund_amount` double(15,2) NOT NULL,
  `approve_amount` double(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `8_approve_refunds_refund_id_unique` (`refund_id`),
  CONSTRAINT `8_approve_refunds_refund_id_foreign` FOREIGN KEY (`refund_id`) REFERENCES `2_refunds` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.9_forms
CREATE TABLE IF NOT EXISTS `9_forms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name1` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name2` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name3` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order` tinyint(4) NOT NULL,
  `create_by` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.migrations
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.password_resets
CREATE TABLE IF NOT EXISTS `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  KEY `password_resets_email_index` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table refund2.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
