-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Jan  5 20:01:57 2014
-- 
;
SET foreign_key_checks=0;
--
-- Table: `jedi_auth_roles`
--
CREATE TABLE `jedi_auth_roles` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `uniq_name` (`name`)
) ENGINE=InnoDB;
--
-- Table: `jedi_auth_users`
--
CREATE TABLE `jedi_auth_users` (
  `id` integer NOT NULL AUTO_INCREMENT,
  `user` VARCHAR(80) NOT NULL,
  `password` CHAR(40) NOT NULL,
  `uuid` CHAR(36) NOT NULL,
  `info` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `uniq_user` (`user`),
  UNIQUE `uuid` (`uuid`)
) ENGINE=InnoDB;
--
-- Table: `jedi_auth_users_roles`
--
CREATE TABLE `jedi_auth_users_roles` (
  `user_id` integer NOT NULL,
  `role_id` integer NOT NULL,
  INDEX `jedi_auth_users_roles_idx_role_id` (`role_id`),
  INDEX `jedi_auth_users_roles_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `role_id`),
  CONSTRAINT `jedi_auth_users_roles_fk_role_id` FOREIGN KEY (`role_id`) REFERENCES `jedi_auth_roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `jedi_auth_users_roles_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `jedi_auth_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1;
