create database carsshop;
USE carsshop; 

CREATE TABLE clients					
(                                      
	id int auto_increment NOT NULL,  
	name varchar(25) NOT NULL,   
	age varchar(25) NOT NULL,
	phone varchar(25) DEFAULT 'Unknown',
    PRIMARY KEY (id)
);

CREATE TABLE cars
(
	id int auto_increment NOT NULL,
	client_id int NOT NULL, 
	mark varchar(30) NOT NULL,
	model varchar(30) NOT NULL,
    primary key(id)
);	
	
ALTER TABLE cars
ADD CONSTRAINT fk_client_id
FOREIGN KEY (client_id) REFERENCES clients(id);


INSERT INTO clients																			   
(name, age, phone)
VALUES
('Petrenko Petro Petrovich', '25',  '(093)1231212'),
('Ivanenko Ivan Ivanovich', '18',  '(095)2313244');	

INSERT INTO cars
(client_id, mark, model)
VALUES
(1, 'Audi', 'A5'),
(2, 'Ford', 'Fiesta'),
(1, 'Suzuki', 'Jimmy');


DELIMITER |
CREATE FUNCTION getMinAge()
RETURNS int
DETERMINISTIC
BEGIN
	RETURN (SELECT MIN(clients.age) FROM clients);
END |
DELIMITER ;


SELECT name, mark FROM cars 
JOIN clients 
ON clients.id = cars.client_id
WHERE clients.age = getMinAge();
        