/* Part B*/
#Database creation
-- drop database project;
create database if not exists project;
use project;
--

#Tables creation
create table if not exists `city` (
	`city_id`  integer unsigned not null auto_increment,
    `city_name` varchar(20) not null,
    primary key (`city_id`));
 --  
 create table if not exists  `postal_code`(
 `postal_code` varchar(8) not null,
 `city_id`  integer unsigned not null ,
 foreign key (`city_id` ) references city(`city_id` )
	on update cascade
    on delete  restrict,
 primary key (`postal_code`)
 );
--
create table if not exists `address` (
	`address_id` int unsigned not null auto_increment,
    `street_name` varchar(128) not null,
    `door_number` int unsigned default null,
    `postal_code` varchar(8) not null,
    foreign key (`postal_code`) references postal_code(`postal_code`)
	on delete restrict
    on update cascade,
    primary key (`address_id`)
    );
--
create table if not exists `customer` (
	`customer_id` int unsigned not null auto_increment,
    `first_name` varchar(45) not null,
    `last_name` varchar(45) not null,
    `date_of_birth` date default null,
    `email` varchar(128) default null,
    `address_id` int unsigned not null,
    `phone_number` int unsigned default null,
    `gender` enum("male","female","non-binary") default null,
    foreign key ( `address_id`) references  address(`address_id`)
		on update cascade 
        on delete restrict,
    primary key (`customer_id`)
    );
--
CREATE TABLE IF NOT EXISTS `employee` (
    `employee_id` int unsigned not null auto_increment,
    `first_name` varchar(45) not null,
    `last_name` varchar(45) not null,
    `date_of_birth` date default null,
    `email` varchar(128) default null,
    `address_id` int unsigned not null,
    `phone_number` int unsigned default null,
    `manager_id` int unsigned default null,
    `hire_date` date default (CURRENT_DATE), -- Use CURRENT_DATE directly as default
    `fire_date` date default null,
    `salary` decimal(10,2) not null default 0.00,
    `gender` enum("male","female","non-binary") default null,
    foreign key (`manager_id`) references employee(`employee_id`)
        on update cascade
        on delete set null,
    foreign key ( `address_id`) references  address ( `address_id`)
		on update cascade 
        on delete restrict,
    primary key (`employee_id`)
);
--
create table if not exists `author` (
	`author_id` int unsigned not null auto_increment,
    `first_name` varchar(45) default null,
    `last_name` varchar(45) default null,
    `date_of_birth` date default null,
    `gender` enum("male","female","non-binary") default null,
    primary key (`author_id`)
);
--
create table if not exists `publisher` (
	`publisher_id` int unsigned not null auto_increment,
    `name` varchar(45) not null,
    `email`  varchar(128) not null,
    primary key (`publisher_id`)
);
--
create table if not exists `book` (
	`isbn` varchar(17) not null,
    `title` varchar(128) not null,
    `author_id` int unsigned not null,
    `publisher_id` int unsigned not null,
    `price` decimal(10,2)  unsigned not null,
    `number_of_pages` int unsigned default null,
    foreign key (`publisher_id`) references publisher(`publisher_id`)
    on delete restrict # because we can still have books in store
    on update cascade,
    primary key (`isbn`)
);
--
create table if not exists `sale` (
	`sale_id` int unsigned not null auto_increment,
    `customer_id` int unsigned not null,
    `address_id` int unsigned not null,
    `employee_id` int unsigned not null,
    `oder_date` datetime not null,
    `shippment_date` datetime default null,
    `total_amount` decimal(10,2) not null, 
    foreign key (`customer_id`) references customer(`customer_id`)
    on update cascade
    on delete restrict,
    foreign key (`address_id`) references address(`address_id`)
    on update cascade
    on delete restrict,
    foreign key (`employee_id`) references employee(`employee_id`)
    on update cascade
    on delete restrict, #if an employee is not working with us anymore 
    primary key (`sale_id`)
);
--
create table if not exists `sale_content` (
	`sale_id` int unsigned not null,
    `isbn` varchar(17) not null,
    `quantity` int unsigned default 0,
    foreign key (`sale_id`) references sale(`sale_id`)
    on update cascade
    on delete cascade,
    foreign key (`isbn`) references book(`isbn`)
    on update cascade
    on delete no action,
    primary key (`sale_id`,`isbn`)
);
--
create table if not exists `author_book` (
    `isbn` varchar(17) not null,
    `author_id` int unsigned not null,
    foreign key (`author_id`) references author(`author_id`)
    on update cascade
    on delete cascade,
    foreign key (`isbn`) references book(`isbn`)
    on delete cascade
    on update cascade,
    primary key (`author_id`,`isbn`)
);
--
create table if not exists `rating` (
	`customer_id` int unsigned not null,
    `isbn` varchar(17) not null,
    `rating` enum("1","2","3","4","5") default null,
    `last_time` datetime,
    foreign key (`customer_id`) references customer(`customer_id`)
    on update cascade
    on delete cascade,
    foreign key (`isbn`) references book(`isbn`)
    on delete cascade
    on update cascade,
    primary key (`customer_id`,`isbn`)
);
--
create table if not exists `log` (
	`log_id` int unsigned not null auto_increment,
    `log_time` datetime not null,
    `user` varchar(45) not null,
    `table` varchar(45) not null,
    `event` enum("insert","update","delete") not null,
    `id` varchar(45) not null,
    `message` blob default null,
    primary key (`log_id`)
);



-- triggers:

delimiter $$
create trigger `sale_after_termination` before insert on `sale`
for each row
begin
	if (select e.fire_date from employee e where e.employee_id = new.employee_id) is not null then
		signal sqlstate '45000'
		set message_text = 'Employee has a terminated contract. Cannot make new sales.';
	end if;
end $$
delimiter ;


delimiter $$
create trigger ‘rating_insert’ after update on ‘rating’
for each row
begin
 -- comprou o livro (customer_id tem uma sale c/ o mesmo isbn)? já tem shipment date? 
end$$
delimiter;