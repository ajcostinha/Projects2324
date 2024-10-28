
Use project;
-- 
/* Part E */

INSERT INTO `city` (`city_name`) VALUES
    ('Lisbon'),('Porto'),('Faro'),('Coimbra'),('Braga'),('Aveiro'),('Évora'),('Viseu'),
    ('Guimarães'),('Setúbal');
    
INSERT INTO `postal_code` (`postal_code`, `city_id`) VALUES
('1100-001', 1),('1100-002', 1),('1100-003', 1),
 -- Lisbon
 
('4000-001', 2), ('4000-002', 2), ('4000-003', 2), 
-- Porto

('8000-001', 3), ('8000-002', 3),('8000-003', 3),
-- Faro

('3000-001', 4),('3000-002', 4),('3000-003', 4),
 -- Coimbra
 
('4700-001', 5), ('4700-002', 5), ('4700-003', 5), 
-- Braga
('3800-001', 6), ('3800-002', 6),('3800-003', 6),
-- Aveiro

('7000-001', 7), ('7000-002', 7),('7000-003', 7),
-- Évora

('3500-001', 8), ('3500-002', 8),('3500-003', 8),
-- Viseu

('4810-001', 9), ('4810-002', 9),('4810-003', 9),
-- Guimarães

('2900-001', 10), ('2900-002', 10),('2900-003', 10)
-- Setúbal
; 

--
INSERT INTO `address` (  `street_name`, `door_number`, `postal_code`) VALUES
('Rua Augusta', 10, '1100-001'), ('Avenida da Liberdade', 20, '1100-002'), ('Rua Garrett', 30, '1100-003'), -- Lisbon

('Rua Santa Catarina', 40, '4000-001'), ('Avenida dos Aliados', 50, '4000-002'), ('Rua de Cedofeita', 60, '4000-003'), -- Porto

('Avenida da República', 70, '8000-001'), ('Rua de Santo António', 80, '8000-002'), ('Rua Conselheiro Bívar', 90, '8000-003'), -- Faro 

('Rua da Sofia', 5, '3000-001'), ('Rua Larga', 15, '3000-002'), ('Avenida Sá da Bandeira', 25, '3000-003'), -- Coimbra

('Rua do Souto', 8, '4700-001'), ('Avenida Central', 18, '4700-002'), ('Rua do Castelo', 28, '4700-003'),  -- Braga

('Avenida Lourenço Peixinho', 7, '3800-001'), ('Rua João Mendonça', 17, '3800-002'), ('Avenida Dr. Lourenço Peixinho', 27, '3800-003'), -- Aveiro

('Rua Serpa Pinto', 9, '7000-001'), ('Rua de Aviz', 19, '7000-002'), ('Avenida Túlio Espanca', 29, '7000-003'),-- Évora

('Rua Direita', 11, '3500-001'), ('Avenida da Bélgica', 21, '3500-002'), ('Largo Mouzinho de Albuquerque', 31, '3500-003'),  -- Viseu

('Rua de Santa Maria', 11, '4810-001'), ('Largo do Toural', 21, '4810-002'), ('Rua Gil Vicente', 31, '4810-003'),--  Guimarães

('Avenida Luísa Todi', 13, '2900-001'), ('Rua dos Aranhas', 23, '2900-002'), ('Praceta Alves Redol', 33, '2900-003')  -- Setúbal
;

--
INSERT INTO `customer` (`first_name`, `last_name`, `date_of_birth` , `email`, `address_id`, `phone_number`, `gender`) VALUES
('Maria', 'Silva', '1980-10-30', 'maria.silva@hotmail.com', 1, 919701516, 'female'),
('Pedro', 'Lourenço', '1995-12-05', 'pedro.lourenço@outmail.com', 2, 916223344, 'male'),
('Sofia', 'Soares', '1980-03-15', 'sofia.soares@gmail.com', 3, 917334455, 'non-binary'),
('João', 'Silva', '1990-06-30', 'joao.silva90@outmail.com', 4, 919545566, 'male'),
('Inês', 'Dias', '1998-01-25', 'ines.dias@gmail.com', 5, 916556677, 'female'),
('Carolina', 'Gaspar', '2003-11-14', 'carolina.g@gmail.com', 6, 914778899, 'female'),
('Miguel', 'Almeida', '1997-07-10', 'miguel.almeida@outmail.com', 7, 913889900, 'non-binary'),
('Beatriz', 'Correia', '2001-02-07', 'beatriz.slc.@gmail.com', 8, 919001122, 'female'),
( 'Tiago', 'Teixeira', '1999-05-19', 'tiago.teixeira@outmail.com', 9, 918112233, 'male'),
( 'Maria', 'Silva', '1987-09-10', 'a.maria.silva@hotmail.com', 10, 917112233, 'female'),
( 'Ricardo', 'Oliveira', '1995-12-05', 'ricardo.oliveira@outmail.com', 11, 916223344, 'male'),
( 'Catarina', 'Pereira', '1997-03-05', 'catarina.pereira@gmail.com', 12, 917334455, 'female'),
( 'Catarina', 'Fernandes', '2002-06-19', 'catarina.fernandes@outmail.com', 13, 919545566, 'non-binary'),
( 'Mariana', 'Rocha', '1988-01-14', 'mariana.rocha@hotmail.com', 14, 916556677, 'female'),
( 'Gustavo', 'Santos', '200-04-05', 'gustavo.santos@outmail.com', 15, 915667788, 'male'), # Gustavo is Leonor´s sister ==> their address_id is the same
( 'Leonor', 'Santos', '2001-11-17', 'leonor.goncalves@gmail.com', 15, 914778899, 'female'),#Leonor is Gustavo's sistes => their address_id is the same
( 'Hugo', 'Pinto', '1999-05-24', 'hugo.ferreira.pinto@outmail.com', 16, 918112233, 'male');
--

INSERT INTO `employee` (`first_name`, `last_name`, `date_of_birth`, `email`, `address_id`, `phone_number`, `manager_id`, `hire_date`, `fire_date`, `salary`, `gender`)VALUES
    ('André', 'Sousa', '1990-05-15', 'andre.sousa@onceuponatime.pt', 17, 937654320, NULL, '2022-03-31' , NULL, 48000.00, 'male'), #CEO 4000.00 euros per month
    ('Alice', 'Gomes', '1988-08-22', 'alice.gomes@onceuponatime.pt', 18, 937654321, 1, '2022-03-31', NULL,  24000.00, 'female'),#manager 2000.00 euros per month
    ('Bernardo', 'Santos', '1995-04-10', 'bernardo.santos@onceuponatime.pt', 19, 937654325,2, CURRENT_DATE, NULL, 11400.00, 'male'), #new employee 950.00 per month
    ('Paulo', 'Pires', '1992-11-30', 'paulo.pires@onceuponatime.pt', 20, 937654322, 2, '2022-03-31', '2023-05-31', 11400.00, 'male'), #old employee
    ('José', 'Anastácio', '1998-07-05', 'jose.anastacio@onceuponatime.pt', 21, 937654323, 2, '2022-09-01', NULL, 11400.00, 'male'),
	('Ana', 'Duarte', '2000-04-05', 'ana.duarte@onceuponatime.pt', 22, 937654324, 2, '2023-06-01', NULL, 11400.00, 'female')
    ;
-- 
INSERT INTO `author` (`first_name`, `last_name`, `date_of_birth`, `gender`)VALUES
('José', 'Saramago', '1922-11-16', 'male'),
('Fernando', 'Pessoa', '1888-06-13', 'male'),
( 'Luís', 'de Camões', '1524-01-01', 'male'), # For Luís de Camões, since the exact birth date is unknown, we've used January 1st of the estimated year.
('Eça', 'de Queirós', '1845-11-25', 'male'),
('Sophia', 'Andresen', '1919-11-06', 'female'),
( 'Miguel', 'Torga', '1907-08-12', 'male'),
('António', 'Lobo Antunes', '1942-09-01', 'male'),
('William', 'Shakespeare', '1564-04-23', 'male'),
('Leo', 'Tolstoy', '1828-09-09', 'male'),
('Jane', 'Austen', '1775-12-16', 'female'),
('Mark', 'Twain', '1835-11-30', 'male'),
('George', 'Orwell', '1903-06-25', 'male'),
('J.K.', 'Rowling', '1965-07-31', 'female'),
('Fyodor', 'Dostoevsky', '1821-11-11', 'male'),
('Gabriel', 'García Márquez', '1927-03-06', 'male'),
('Harper', 'Lee', '1926-04-28', 'female')
;

--
INSERT INTO `publisher` ( `name`, `email`) VALUES
('Porto Editora', 'info@portoeditora.pt'),
('Assírio & Alvim', 'geral@assirio-alvim.pt'),
("Relógio d'Água", 'geral@relogiodagua.pt.'),
('Tinta da China', 'geral@tintadachina.pt'),
('Dom Quixote', 'info@domquixote.pt');

--
INSERT INTO `book` (`isbn`, `title`, `author_id`, `publisher_id`, `price`, `number_of_pages`)VALUES 
#For a reason of simplicity if a book has more than 400 pages it´s cost is 10.00  euros, otherwise is 5.00 euros
('9789720047895', 'Ensaio Sobre a Cegueira', 1, 1, 5.00, 346),
('9789720048380', 'O Envagelho Segundo Jesus Cristo', 1, 1, 10.00, 448),
('9789720049370', 'O Ano da Morte de Ricardo Reis', 1, 1, 10.00, 496),

('9789720049769', 'Livro do Desassossego', 2, 4, 10.00, 576),

('9789720019298', 'Os Lusíadas', 3, 1, 10.00, 648),

('9789720049264', 'Os Maias', 4, 1, 10.00, 736),
('9789720048427', 'O Crime do Padre Amaro', 4, 1, 10.00, 528),

('9789720048885', 'O Cavaleiro da Dinamarca', 5, 1, 5.00, 208),
('9789720030422', 'O Colar', 5, 1, 5.00, 160),

('9789720049226', 'Bichos', 6, 5, 5.00, 128),

('9789720048984', 'Que Farei Quando Tudo Arde?', 7, 5, 10.00, 640),


('9789720048540', 'Hamlet', 8, 2, 5.00, 448),

('9789720031788', 'Anna Karenina', 9, 3, 10.00, 800),


('9789720031887', 'Pride and Prejudice', 10, 3, 10.00, 416),

('9789720048700', 'The Adventures of Tom Sawyer', 11, 2, 5.00, 272),

('9789720031986', '1984', 12, 5, 5.00, 314),

('9789720048809', 'Harry Potter and the Philosopher\'s Stone', 13, 3, 5.00, 352),

('9789720032082', 'Crime and Punishment', 14, 2, 10.00, 608),

('9789720048908', 'One Hundred Years of Solitude', 15, 4, 10.00, 417),

('9789720032181', 'To Kill a Mockingbird', 16, 4, 5.00, 384);

-- 
#customer id 1..17
#adress id 1...30
#employee id  3,4,5,6 


# empresa existe desde 31-03- 2022
#em 2022  tinha os employees 1,2,4
#so o 4 trata de encomendas  pode tratar desde  '2022-03-31' até '2023-05-31'

#em 2022
# 4  faz tudo 
# 5 entra  a 1 de setembro

#em 2023
# 5  mantem
# 4 até 31 do 5
# 6 entra  em junho

#6 desde 01 de junho


INSERT INTO `sale` (`customer_id`, `address_id`, `employee_id`, `oder_date`, `shippment_date`, `total_amount`) VALUES
    #2022
    (1, 1, 4, '2022-04-01', '2022-04-04', 15.00),
	(2, 2, 4, '2022-04-10', '2022-04-12', 30.00),
	(3, 3, 4, '2022-04-15', NULL, 10.00),
	(4, 4, 4, '2022-04-20', '2022-04-23', 40.00),
	(5, 5, 4, '2022-04-25', NULL, 10.00),
	(5, 5, 4, '2022-05-01', '2022-05-04', 15.00),
	(3, 3, 4, '2022-05-20', '2022-05-23', 5.00),
	(6, 6, 4, '2022-05-25', NULL, 10.00),
	(7, 7, 4, '2022-06-01', '2022-06-04', 5.00),
	(8, 8, 4, '2022-06-10', '2022-06-12', 30.00),
	(9, 9, 4, '2022-06-15', NULL, 10.00),
	(10, 10, 4, '2022-06-20', '2022-06-23', 5.00),
	(11, 11, 4, '2022-06-25', NULL, 10.00),
	(5, 5, 4, '2022-07-01', '2022-07-04', 15.00),
	(8, 8, 4, '2022-07-10', '2022-07-12', 20.00),
	(12, 12, 4, '2022-07-15', NULL, 10.00),
	(13, 13, 4, '2022-07-20', '2022-07-23', 5.00),
	(14, 14, 4, '2022-07-25', NULL, 10.00),
    (15, 15, 5, '2022-09-01', '2022-09-04', 25.00),# first order of employee_id =5
    (16, 16, 4, '2022-09-10', '2022-09-12', 10.00),
    (6, 6, 5, '2022-09-15', NULL, 10.00),
    (3, 3, 4, '2022-10-20', '2022-10-23', 5.00),
    (17, 17, 5, '2022-11-25', NULL, 10.00),
    (7, 7, 4, '2022-11-25', NULL, 20.00),
    (5, 5, 5, '2022-12-05', NULL, 10.00),
	(13, 13, 4, '2022-12-05', '2022-12-08', 5.00),
	(10, 10, 5, '2022-12-20', NULL, 15.00),
    
    #2023
    (1, 1, 4, '2023-01-01', '2023-01-04', 15.00),
    (16, 16, 5, '2023-01-10', '2023-01-12', 30.00),
    (1, 1, 4, '2023-02-15', NULL, 10.00),
    (6, 6, 5, '2023-02-20', '2023-02-23', 40.00),
    (12, 12, 4, '2023-03-25', NULL, 10.00),
    (2, 2, 5, '2023-04-01', '2023-04-03', 15.00), 
    (7, 7, 4, '2023-04-10', '2023-04-13', 10.00),
    (9, 9, 5, '2023-04-10', '2023-04-13', 5.00),
    (6, 6, 4, '2023-04-20', '2023-04-23', 15.00),
    (10, 10, 4, '2023-05-28', '2023-05-31', 30.00), #last order of employee_id =5
	(7, 7, 5, '2023-06-01', '2022-06-04', 5.00), # first order of employee_id =6
    (8, 8, 5, '2023-06-10', '2023-06-12', 30.00),
	(9, 9, 6, '2023-06-15', NULL, 10.00),
	(10, 10, 5, '2023-06-20', '2023-06-23', 5.00),
	(11, 11, 6, '2023-06-25', NULL, 10.00),
	(5, 5, 5, '2023-07-01', '2023-07-04', 15.00),
	(8, 8, 6, '2023-07-10', '2023-07-12', 20.00),
	(12, 12, 5, '2023-07-15', NULL, 10.00),
	(13, 13, 6, '2023-07-20', '2023-07-23', 5.00),
	(14, 14, 5, '2023-07-25', NULL, 10.00),
	(15, 15, 6, '2023-09-01', '2023-09-04', 25.00),
	(16, 16, 5, '2023-09-10', '2023-09-12', 10.00),
	(4, 4, 6, '2023-09-15', NULL, 10.00),
	(3, 3, 5, '2023-10-20', '2023-10-23', 5.00),
	(2, 2, 5, '2023-11-25', NULL, 10.00),
	(1, 1, 6, '2023-12-05', NULL, 10.00),
	(13, 13, 5, '2023-12-05', '2023-12-08', 5.00),
	(17, 17, 6, '2023-12-08', NULL, 15.00)
    ;


INSERT INTO `sale_content` (`sale_id`, `isbn`, `quantity`) VALUES
(1,'9789720047895',1),(1,'9789720048380',1),
(2,'9789720048380',3),
(3,'9789720049370',1), 	
(4,'9789720019298',4),
(5,'9789720049370',1),
(6,'9789720047895',1),(6,'9789720048380',1),
(7,'9789720030422',1),
(8,'9789720030422',2),
(9,'9789720030422',1),
(10,'9789720030422',1), (10, '9789720047895', 1), (10,'9789720048380',1) ,(10,'9789720049370',1),
(11,'9789720049264',1),
(12,'9789720049226',1),
(13,'9789720049226',2),
(14,'9789720049226',1), (14,'9789720049264',1),
(15,'9789720049264',1), (15,'9789720048427',1),
(16,'9789720048427',1),
(17,'9789720048885',1),
(18,'9789720048885',2),
(19,'9789720048885',2), (19, '9789720030422',3),# first order of employee_id =5
(20,'9789720048540',2),
(21,'9789720048540',2),
(22,'9789720048540',1),
(23,'9789720048427',1),
(24,'9789720048427',1), (24, '9789720031788',1),
(25,'9789720031788',1),
(26,'9789720032181',1),
(27,'9789720048885',1), (27, '9789720030422',1), (27,'9789720048809',1), #last sale of 2023
(28,'9789720048885',1), (28, '9789720030422',1), (28,'9789720048700',1),
(29,'9789720048984',1), (29, '9789720031788',1), (29,'9789720031887',1),
(30,'9789720031887',1),
(31, '9789720031788',2), (31,'9789720031887',2), #40 euros
(32, '9789720031887',1),
(33, '9789720031887',1), (33, '9789720048700',1), 
(34, '9789720031986',2),
(35, '9789720031986',1),
(36, '9789720031986',1), (36, '9789720048809',1), (36, '9789720048700',1), 
(37, '9789720031887',3),
(38, '9789720048809',1),
(39, '9789720031887',2), (39, '9789720048908',1),  
(40, '9789720048908',1), 
(41, '9789720031986',1), 
(42, '9789720031986',2), 
(43, '9789720032181',2), (43, '9789720031986',1), 
(44, '9789720032082',2), 
(45, '9789720032082',1), 
(46, '9789720048540',1),
(47, '9789720032181',2), 
(48, '9789720032181',1), (48, '9789720048908',1),(48, '9789720032082',1),
(49, '9789720048809',2),
(50, '9789720048809',2),
(51, '9789720031986',1),
(52, '9789720031986',1), (52, '9789720048809',1),
(53, '9789720031986',1), (53, '9789720048809',1),
(54, '9789720048809',1), 
(55, '9789720048809',1), (55, '9789720048908',1)
;
-- 

INSERT INTO `author_book` (`isbn`, `author_id`) VALUES
('9789720047895', 1),('9789720048380', 1),('9789720049370', 1),

('9789720049769',  2),

('9789720019298', 3),

('9789720049264', 4),('9789720048427', 4),

('9789720048885', 5),('9789720030422', 5),

('9789720049226', 6),

('9789720048984',  7),

('9789720048540', 8),

('9789720031788', 9),

('9789720031887', 10),

('9789720048700', 11),

('9789720031986', 12),

('9789720048809', 13),

('9789720032082', 14),

('9789720048908', 15),

('9789720032181', 16)
;


INSERT INTO `rating` (`customer_id`, `isbn`, `rating`, `last_time`) VALUES
(1,'9789720047895',2, '2022-04-07'),(1,'9789720048380',3, '2022-04-07'),
(2,'9789720048380',5, '2022-04-15'),
(3,'9789720049370',5, '2022-04-18'),
(4,'9789720019298',4, '2022-04-25'),
(5,'9789720049370',1, '2022-04-28'),
(5,'9789720047895', NULL, NULL),(5,'9789720048380', NULL, NULL),
(3,'9789720030422',5, '2022-05-28'),
(6,'9789720030422',5, '2022-05-28'),
(7,'9789720030422',2, '2022-06-07'),
(8,'9789720030422',1, '2022-06-15'), (8, '9789720047895', 2, '2022-06-15'), (8,'9789720048380',3, '2022-06-15'),(8,'9789720049370',4, '2022-06-15'),
(9,'9789720049264',NULL, NULL),
(10,'9789720049226',3, '2022-06-25'),
(11,'9789720049226',NULL, NULL),
(5,'9789720049226',2,'2022-07-07'), (5,'9789720049264',3,'2022-07-04'),
(8,'9789720049264',3,'2022-07-15'), (8,'9789720048427',4, '2022-07-12'),
(12,'9789720048427',3,'2022-07-18'),
(13,'9789720048885',2,'2022-07-26'),
(14,'9789720048885',5, '2022-07-28'),
(15,'9789720048885',NULL, NULL), (15, '9789720030422',NULL, NULL),
(16,'9789720048540',2, '2022-09-15'),
(6,'9789720048540',NULL,NULL),
(3,'9789720048540',4,'2022-10-26'),
(17,'9789720048427',4,'2022-11-28'),
(7,'9789720048427',NULL,NULL), (7, '9789720031788',NULL,NULL),
(5,'9789720031788',2, '2022-12-08' ),
(13,'9789720032181',1, '2022-12-08' ),
(10,'9789720048885',2,'2022-12-23'), (10,'9789720030422',2,'2022-12-23'),(10,'9789720048809',2,'2022-12-23'), #27 é o consumidor 10
#2023
(1,'9789720048885', 2, '2023-01-08'), (1, '9789720030422',3, '2023-01-08'), (1,'9789720048700',3, '2023-01-08'),
(16,'9789720048984', 2, '2023-01-15'), (16, '9789720031788',3, '2023-01-15'), (16,'9789720031887',3, '2023-01-15'),
(1,'9789720031887',NULL, NULL),
(6, '9789720031788',4, '2023-02-26'), (6,'9789720031887',4, '2023-02-26'), 
(12, '9789720031887',3, '2023-03-28'),
(2, '9789720031887',NULL, NULL), (2, '9789720048700',NULL, NULL), 
(7, '9789720031986',5,'2023-04-16'),
(9, '9789720031986',5,'2023-04-16'),
(6, '9789720031986',1, '2023-04-25'), (6, '9789720048809',3, '2023-04-25'), (6, '9789720048700',4, '2023-04-25'), 
(10, '9789720031887',5, '2023-06-03'),
(7, '9789720048809',NULL, NULL),
(8, '9789720031887',5, '2023-06-15'), (8, '9789720048908', 5, '2023-06-15'),  
(9, '9789720048908',4, '2023-06-18'), 
(10, '9789720031986',1, '2023-06-25') ,
(11, '9789720031986',NULL, NULL),
(5, '9789720032181',2, '2023-07-08'), (5, '9789720031986',1, '2023-07-08'), 
(8, '9789720032082',5, '2023-07-15'), 
(12, '9789720032082',NULL,NULL), 
(13, '9789720048540',NULL,NULL),
(14, '9789720032181',5, '2023-07-28'), 
(15, '9789720032181',5, '2023-09-08'), (15, '9789720048908',2, '2023-09-08'),(15, '9789720032082',3, '2023-09-08'),
(16, '9789720048809',NULL,NULL ),
(4, '9789720048809',4, '2023-09-18'),
(3, '9789720031986',NULL, NULL),
(2, '9789720031986',5, '2023-11-28'), (2, '9789720048809',5, '2023-11-28'),
(1, '9789720031986',NULL,NULL), (1, '9789720048809',NULL, NULL),
(13, '9789720048809',5,'2023-12-10'), 
(17, '9789720048809',NULL, NULL), (17, '9789720048908',NULL,NULL)
;