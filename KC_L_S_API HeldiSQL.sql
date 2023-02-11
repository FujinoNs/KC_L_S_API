USE `essentialmode`;

CREATE TABLE `kc_launcher_service` (
	`identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
	`launcher_status` varchar(50) COLLATE utf8mb4_bin DEFAULT 'offline',
	`first_connect` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
	`last_connect` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
	`disconnect` varchar(50)  COLLATE utf8mb4_bin DEFAULT NULL,
	`messages` varchar(255)  COLLATE utf8mb4_bin DEFAULT NULL,
	PRIMARY KEY (`identifier`)
);