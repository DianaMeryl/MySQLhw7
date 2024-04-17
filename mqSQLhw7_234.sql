CREATE DATABASE myFunkDB;
USE myFunkDB;

CREATE TABLE family(
family_id INT auto_increment NOT NULL,
family varchar(15),
PRIMARY KEY (family_id)
);

CREATE TABLE job_info(
job_info_id INT auto_increment NOT NULL,
position varchar(30),
salary DECIMAL(7, 2) NOT NULL,
PRIMARY KEY (job_info_id)
);

CREATE TABLE employee_info(
employee_info_id INT auto_increment NOT NULL,
name VARCHAR(30) NOT NULL,
phone varchar(15),
birthday DATE,
address varchar(50),
family_id int,
job_info_id int,
CONSTRAINT fk_family_id FOREIGN KEY (family_id) REFERENCES family(family_id),
CONSTRAINT fk_job_info_id FOREIGN KEY (job_info_id) REFERENCES job_info(job_info_id),
PRIMARY KEY (employee_info_id)
);

INSERT INTO family(family)
VALUES
    ('married'),
    ('unmarried');
    
INSERT INTO job_info( position, salary)
VALUES
    ('director', 10000),
    ('manager', 5000),
    ('worker', 2000);
    
INSERT INTO employee_info(name, phone, birthday, address, family_id, job_info_id)
VALUES
    ('Ben', '1234578', '1976-07-19', 'London', 1, 1),
    ('Tony', '5645789', '1976-04-15', 'Paris', 1, 2),
    ('John', '3234578', '1977-05-15', 'Tokio', 2, 3),
    ('Mary', '3645783', '1978-04-18', 'London', 1, 2),
    ('Jack', '4545678', '1975-06-15', 'Rome', 2, 3);
	
    
/* Дозаповнення таблиці employee_info випадковими даними:*/
    
INSERT INTO employee_info (name, phone, birthday, address, family_id, job_info_id)
SELECT 
    CONCAT(name, LPAD(CONV(FLOOR(RAND()*POW(36,6)), 10, 36), 6, 0)) AS name,
    phone,
    MAKEDATE(1976, 1 + FLOOR(RAND()*12)) AS birthday,
    address,
    ROUND(RAND()) + 1 AS family_id,
    ROUND(RAND()) + 1 AS job_info_id
FROM employee_info;



/* Створення процедури без параметрів:*/

DELIMITER |
CREATE PROCEDURE getPhoneAddress()
BEGIN
	SELECT name, phone, address FROM employee_info;
END|
DELIMITER ; 



/* Створення процедури з параметрами:*/

DELIMITER |
CREATE PROCEDURE getUnmarriedInfo(IN familyStatus VARCHAR(20))
BEGIN
	IF (familyStatus IS NOT NULL)
	THEN
		SELECT name, birthday, phone FROM employee_info
			JOIN family
			ON employee_info.family_id = family.family_id
			WHERE family.family = familyStatus;
	ELSE
		SELECT 'ERROR';
	END IF;
END|
DELIMITER ; 



/* Створення функції з параметрами:*/

DELIMITER |
CREATE FUNCTION getManagerInfo(birth VARCHAR(20), tel VARCHAR(20))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE description VARCHAR (100) DEFAULT 'Unknown person';
		SET description = CONCAT(' Birthday - ', birth, ' Phone Number - ', tel);
    RETURN description;
END|
DELIMITER ; 


/*Виклик процедур:*/

CALL getPhoneAddress();
CALL getUnmarriedInfo('unmarried');


/*Виклик функції:*/

SELECT name, getManagerInfo(birthday, phone) FROM employee_info
JOIN job_info
			ON employee_info.job_info_id = job_info.job_info_id
			WHERE job_info.position = 'manager';



















