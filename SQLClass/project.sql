-- Storing and Retrieving Data – Final project - NOVA IMS
-- Group 31: 
	# Alexandre Marques        - 20230976 - 20230976@novaims.unl.pt
    # Ana Filipa Silva         - 20230577 - 20230577@novaims.unl.pt
    # Mariana Rodrigues Cabral - 20230532 - 20230532@novaims.unl.pt
    # Adriana Judite Costinha  - 20230567 - 20230567@novaims.unl.pt
    # Alicia Pinho Santos      - 20230525 - 20230525@novaims.unl.pt

/*-----------------------------Part A---------------------------------------------------
	The present project was developed under the scope of Storing and Retrieving Data, a 
curricular unit of the Master’s Degree in Data Science and Advanced Analytics at NOVA IMS.
    We decided on designing the business process of a online bookshop since this kind of 
business might rely heavily on a relational database to manage its extensive inventory, 
streamline customer interactions, process transactions, and ensure efficient order 
fulfillment.
	"OnceUponATime" is the name of the fictitious company for which we developed this 
database. It's an online platform with an extensive catalog of books from different 
authors and publishers. Its biggest challenge is trying to replicate the experience of 
buying books in a physical store. As a result of that the company puts all its efforts 
into making the consumer experience as personalized as possible.
	More concretely, apart from providing customers with an extensive catalog of books 
from different authors that they could explore, the platform also enables the customers to 
create an account, granting access to their wishlist and recent purchases. 
Additionally, it provides personalized recommendations and includes a review section where 
customers can leave their feedback and ratings for books they've read, offering valuable 
insightsfor other potential buyers. 
*/

/*-----------------------------Part B and D------------------------------------------------
	Following the professor's advice, we are only attempting to recreate the database 
requirements for the frontend of our business, ignoring sellers and book's stock. The
introduction of this entities would add too much complexity and it is outside of the 
project's scope.
	Following Part B's instruction, we brainstormed our business' data needs and 
created a ERD's sketch in MySQL Workbench, which is contained in this project folder as
"erd_sketch.mwb" or "erd_sketch.png".
	We identified 7 main entity types while trying to understand the business' frontend 
data model, an address, a customer, an employee, an author, a publisher, a book, and a sale.
	Our entity realtionship model must comply with the three normal forms in order to 
minimize data redundancy and insertion, deletion and update anomalies.
	We should note beforehand that we are assuming that our business will only operate 
in Portugal, and hence we will only be considering Portuguese adresses.
	After atomizing the constituents of a portuguese address (door number, street name, 
postal code, and city), and providing an unique identifying key to each address, we are 
still left with a transitive dependency between the postal code and the city, and therefore,
to comply with the third normal form, we must create a new entity type, postal code.
	An author can write many books, and a book can be written by many authors, so their 
relationship is many-to-many. The way an entity relationship model solves many-to-many
realtionships is by creating a linking table between the two entities, which in this case 
will be called `author_book`.
	The same thing happens between sale and book, a sale can contain many books, and the 
same book can be sold in many sales. So we also create a linking table called `sale_content`, 
which not only links books and sales but also identifies the number of units of a specific book
occurs in each sale.
	Any book has a single publisher, this many-to-one relationship is done a foreign key from 
the book table to the publisher's table.
	For many of the tables which do not have an standard specified primary key (ISBN), we chose 
to use auto increment as a way to generate primary keys. Most of the entries we are going to fill 
in our tables are not suppose to be deleted, for example, if we sell a book, we will be adding an 
instance of a sale referencing this book, and even if eventually the business no longer sells this 
specific book the database will still need to have its entry because it was already referenced 
somewhere else. So deletion will be rare, and therefore the best course of action is to populate
the key space in a uniform and dense way.
	In an attempt to optimize memory we decided to create a `city` table. Since there are no 
repeated city names in Portugal, we could simply set the city name as an atribute of a postal code.
Nevertheless, the number of cities in Portugal is small (156), and a tinyint (one byte) representation 
of a city name is better than many characters (many bytes), so we decided to create a city table which
stores city names identified by an unsigned tinyint key.
	In the entity relationship diagram, and in compliance with the crow's foot notation, we paid 
attention to which relationships are not mandatory. In essence, only the relationships 
author - author_book - book, customer - sale, sale - sale_content, publisher - book are mandatory. 
The definition of a customer is someone who has made a purchase. Any book, by definition, must have 
at least one author, and vice-versa. Also, a sale must have contents, and a publisher, by definition, 
must publish at least a book. Any other relationship is optional. For example, it can happen that an 
employee is not a manager. 
*/
# drop database project;
create database if not exists project;
use project;
--
create table if not exists `city` (
	# we choose tinyint because there are only 156 cities in Portugal,
    # and the maximum bound of an unsigned tiny int is 255
	`city_id`  tinyint unsigned not null auto_increment,
    # as a standard for single names of variable length we choose a
    # maximum bound of 45 characters.
    `city_name` varchar(45) not null,
    primary key (`city_id`));
--  
create table if not exists  `postal_code`(
	# each portuguese postal code has exactly 8 characters. 
	`postal_code` char(8) not null,
	`city_id`  tinyint unsigned not null,
    # a foreign key refers to the atribute of another parent table
	foreign key (`city_id` ) references city(`city_id`)
		# if there is an update on the city_id, 
        # the update is reflected into this child table
		on update cascade
        # if we attempt to delete an instance of parent city entity which
        # is used by this child table, an error is raised
        # and doesn't allow the deletion
		on delete  restrict,
        # we will use this set of on update, and, on delete policy
        # on other tables
	primary key (`postal_code`));
--
create table if not exists `address`(
	`address_id` int unsigned not null auto_increment,
    # for fields with a few words we selected a variable character type 
    # of 128 length.
    `street_name` varchar(128) not null,
    # we also think that there are no door numbers in Portugal
    # which are over 999. The max bound of small int unsigned is 65535
    `door_number` smallint unsigned default null
		# Besides the smallint max bound  we have also added a check 
        # statement, which raises an error if any of the data inserted 
        # fails the verify the logical clause.
		check(length(`door_number`) <= 4 or `door_number` is null),
    `postal_code` char(8) not null,
    foreign key (`postal_code`) references postal_code(`postal_code`)
		on update cascade
		on delete restrict,
    primary key (`address_id`));
--
create table if not exists `customer`(
	`customer_id` int unsigned not null auto_increment,
    `first_name` varchar(45) not null,
    `last_name` varchar(45) not null,
    `date_of_birth` date default null,
    `email` varchar(128) not null,
    `address_id` int unsigned not null,
    # portuguese phone numbers have exactly 9 digits, 
	# the right integer type for this is a regular 4 byte int
    # besides the type bounds we also define the a check statement
    # that enforces an exact number of digits.
    `phone_number` int unsigned default null
		check(length(`phone_number`) = 9 or `phone_number` is null),
	# we consider that gender can only have 3 categories
    `gender` enum("male","female","non-binary") default null,
    foreign key (`address_id`) references address(`address_id`)
		on update cascade
		on delete restrict,
    primary key (`customer_id`));
--
create table if not exists `employee`(
    `employee_id` int unsigned not null auto_increment,
    `first_name` varchar(45) not null,
    `last_name` varchar(45) not null,
    `date_of_birth` date not null,
    `email` varchar(128) not null,
    `address_id` int unsigned not null,
    `phone_number` int unsigned default null 
		check(length(`phone_number`) = 9 or `phone_number` is null),
    `manager_id` int unsigned default null,
    # if a hire date isn't specified, it defaults to the insertion date
    `hire_date` date default (current_date),
    # if a termination date isn't specified, it defaults null which means
    # that the employee hasn't terminated its contract, and is an active
    # employee
    `termination_date` date default null,
    # a salary, as any other monetary value specified can be defined 
    # up to the cents
    `salary` decimal(10,2) not null 
		# we use the check statement to impose that the salary 
        # must be a positive value
		check (`salary` >= 0.00),
    `gender` enum("male","female","non-binary") default null,
    # manager_id refers back to its own table since there is a 
    # hierarchical relationship between employee and manager positions
    foreign key (`manager_id`) references employee(`employee_id`)
		on update cascade
        # if the manager's instance is deleted, the corresponding manager_id will be 
        # set to null
		on delete set null,
    foreign key (`address_id`) references  address(`address_id`)
		on update cascade 
		on delete restrict,
    primary key (`employee_id`));
--
create table if not exists `publisher`(
	`publisher_id` int unsigned not null auto_increment,
    `publisher_name` varchar(45) not null,
    `email` varchar(128) not null,
    `phone_number` int unsigned default null
		check(length(`phone_number`) = 9 or `phone_number` is null),
    primary key (`publisher_id`));
--
create table if not exists `author`(
	`author_id` int unsigned not null auto_increment,
    `first_name` varchar(45) not null,
    `last_name` varchar(45) not null,
    `date_of_birth` date default null,
    `gender` enum("male","female","non-binary") default null,
    primary key (`author_id`));
--
create table if not exists `book`(
	# a book's primary key is isbn-13 standard
    # it defines uniquely every book in the world
	`isbn` bigint unsigned not null
		# isbn-13 has exactly 13 decimal digits
		check(length(`isbn`) = 13),
    `title` varchar(128) not null,
    `publisher_id` int unsigned not null,
    `price` decimal(10,2)  not null
		# similarly to the case of salaries
        # the price of each book must be a positive value
		check (`price` >= 0.00),
    `number_of_pages` smallint unsigned default null,
    foreign key (`publisher_id`) references publisher(`publisher_id`)
		on update cascade
		on delete restrict,
    primary key (`isbn`));
--
# as mencioned in the introduction this linking table resolves the 
# many-to-many relationship between author and book
create table if not exists `author_book` (
    `isbn` bigint unsigned not null, # doesnt allow if foreign key is not initialized
    `author_id` int unsigned not null,
    # both foreign keys are primary keys of other tables, so these relationships
    # are identifying
    foreign key (`author_id`) references author(`author_id`)
		on update cascade
		# the on delete policy for this linking table is diferent from the
        # previously mencioned cases, once a instance is removed from the parent table
        # we want to automatically delete all of the instances in this child table
        # referenced by the corresponding foreign key
		on delete cascade,
    foreign key (`isbn`) references book(`isbn`)
		on update cascade
		on delete cascade,
    primary key (`author_id`,`isbn`));
--
create table if not exists `sale`(
	`sale_id` int unsigned not null auto_increment,
    `customer_id` int unsigned not null,
    `address_id` int unsigned not null,
    `employee_id` int unsigned not null,
	# we set as default for the the order_date, the instance's insertion date.
    `order_date` date not null default (current_date),
    `shipment_date` date default null, 
    foreign key (`customer_id`) references customer(`customer_id`)
		on update cascade
		on delete restrict,
    foreign key (`address_id`) references address(`address_id`)
		on update cascade
		on delete restrict,
    foreign key (`employee_id`) references employee(`employee_id`)
		on update cascade
		on delete restrict,
	# a couple of queries proposed in the project description involve
    # the search of specific order_dates, 
    # in order to optimize those queries, and since the order_date has a high
    # cardinality in relation to the sale, we choose to create an index
    # on order_date.
    # a more in depth discussion on the optimization of the queries involved 
    # can be found on Part F of this script.
	index (`order_date`),
    primary key (`sale_id`));
--
# this linking table resolves the many-to-many relationship between sale and book
# number of units of each book in a particular sale is a property of the sale
# and book, and will take as default 1
create table if not exists `sale_content` (
	`sale_id` int unsigned not null,
    # we have already imposed check conditions on the primary key of the book table
    # since isbn is foreign key, it makes no sense to add check conditions on this 
    # attribute
    `isbn` bigint unsigned not null,
    `quantity` tinyint unsigned default 1,
	# both foreign keys are primary keys of other tables, so these relationships
    # are identifying
    foreign key (`sale_id`) references sale(`sale_id`)
		on update cascade
		on delete cascade,
    foreign key (`isbn`) references book(`isbn`)
		on update cascade
		on delete restrict,
    primary key (`sale_id`,`isbn`));
--
# rating is joint property of a customer and a book
create table if not exists `rating` (
	`customer_id` int unsigned not null,
    `isbn` bigint unsigned not null,
    # our rating range only from 1 to 5
    # so we impose a condition on the values that can 
    # appear in this field
    `rating` tinyint not null
		check (`rating` = 1 or `rating` = 2 or `rating` = 3 
			or `rating` = 4 or `rating` = 5),
    `rating_date` date default (current_date),
    foreign key (`customer_id`) references customer(`customer_id`)
		on update cascade
		on delete restrict,
    foreign key (`isbn`) references book(`isbn`)
		on update cascade
		on delete cascade,
    primary key (`customer_id`,`isbn`));
--
# the log table registers actions in our database 
create table if not exists `log` (
	`log_id` bigint unsigned not null auto_increment,
    # save the time of the action, defaulting to the current timestamp
    `log_time` datetime not null default now(),
    # registers the user who made the changes
    `user` varchar(45) not null default (user()),
    # the table in which the changes were made
    `table` varchar(45) not null,
    # the kind of action or event that occurred
    `event` enum("insert","update","delete") not null,
    # the key of the entry affected
    `entry_id` varchar(45) not null,
    # and a small message detailing the outcome of the 
    # event, depending on the action executed the message
    # field can have arbitrary length, so we chose blob
    # for its type.
    `message` blob default null,
    primary key (`log_id`));

/*-----------------------------Part C--------------------------------------------------
	Triggers are SQL statements thate execute automatically when a specific event occurs
in the database. We want to fill our log table automatically with information regarding
in which table the event was performed, by whom, at what time, what kind of event, 
which instance was changed, and a small message showing what kind of change was 
performed. We write three triggers for each table which execute after the insertion, 
deletion, and update event. 
	Apart from the triggers that fill the log table, we also need triggers that 
enforce the business logic. For example, if the same rating is given at some later date,
the rating date field stored should be the one from the previous review, and the rating 
date should not change. If someone tries to rate a book without recieving or buying it
the database should throw an error. Similarly, if we attempt to introduce a sale made by 
an employee who has a terminated contract (an ex-employee), an error should be raised as well.
*/
-- 1. Triggers Definition:
--
# In some particular cases the message is too long, so instead of generating a long message 
# we fill the field with a default message stored in the @default_meassage variable
# an optional course of action would be set a default message directly in the table creation, 
# but blob types cannot take a default.
set @default_message := "changes have been applied to this entity";
--
# We set the delimiter "$$" in order to allow multi-line statements
# The trigger "log_city_insert" fires after an insert on the table "city" and inserts a 
# new record into the log table. This new record holds the information about each insert 
# operation on the table `city`.
delimiter $$
create trigger `log_city_insert` after insert on `city`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("city","insert",new.city_id,new.city_name);
end $$
--
# Now, this trigger only fires when there's an update in table `city`. We chose this specific 
# message to visually aid the user to the new changes
create trigger `log_city_update` after update on `city`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("city","update",new.city_id,concat(old.city_name," -> ",new.city_name));
end $$
--
# Almost same as before, but this time it fires on a delete action
create trigger `log_city_delete` after delete on `city`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("city","delete",old.city_id,old.city_name);
end $$ 
--
# The message may look a little more complicated, but to visually aid the user, we 
# chose to use the city_name from the `city` table instead of simply showing the 
# city_id.
create trigger `log_postal_code_insert` after insert on `postal_code`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`)
        select "postal_code","insert",new.postal_code,concat("(",c.city_name,")") 
		from `city` as c where c.city_id = new.city_id;
end $$
--
create trigger `log_postal_code_update` after update on `postal_code`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		# for updates on tables with a small number of attributes, our log message 
        # displays: (old information) -> (new information)
		("postal_code","update",new.postal_code,
		concat("(",old.postal_code,",",old.city_id,") -> (",new.postal_code,",",new.city_id,")"));
end $$ 
--
create trigger `log_postal_code_delete` after delete on `postal_code`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`)
        select "postal_code","delete",old.postal_code,concat("(",c.city_name,")") 
		from `city` as c where c.city_id = old.city_id;
end $$
--
create trigger `log_address_insert` after insert on `address`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`)
        select "adress","insert",new.address_id,
        concat("(",coalesce(new.door_number,"null"),",",new.street_name,",",
			new.postal_code,",",c.city_name,")")
		from `postal_code` as pc, `city` as c 
        where new.postal_code = pc.postal_code and pc.city_id = c.city_id;
end $$
--
create trigger `log_address_update` after update on `address`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("adress","update",new.address_id,
		concat("(",old.address_id,"|",coalesce(old.door_number,"null"),",",
		old.street_name,",",old.postal_code,") -> (",
		coalesce(new.door_number,"null"),",",new.street_name,",",
		new.postal_code,")"));
end $$
--
create trigger `log_address_delete` after delete on `address`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`)
        select "adress","delete",old.address_id,
        concat("(",coalesce(old.door_number,"null"),",",old.street_name,",",
			old.postal_code,",",c.city_name,")")
		from `postal_code` as pc, `city` as c 
        where old.postal_code = pc.postal_code and pc.city_id = c.city_id;
end $$
--
create trigger `log_customer_insert` after insert on `customer`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("customer","insert",new.customer_id,
        concat("(",new.first_name,",",new.last_name,",",new.address_id,")"));
end $$
--
create trigger `log_customer_update` after update on `customer`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("customer","update",new.customer_id,@default_message);
end $$ 
--
create trigger `log_customer_delete` after delete on `customer`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("customer","delete",old.customer_id,
		concat("(",old.first_name,",",old.last_name,",",old.address_id,")"));
end $$
--
create trigger `log_employee_insert` after insert on `employee`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("employee","insert",new.employee_id,
        concat("(",new.first_name,",",new.last_name,",",coalesce(new.manager_id,"null"),",",
        new.hire_date,")"));
end $$
--
create trigger `log_employee_update` after update on `employee`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("employee","update",new.employee_id,@default_message);
end $$
--
create trigger `log_employee_delete` after delete on `employee`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("employee","delete",old.employee_id,
		concat("(",old.first_name,",",old.last_name,",",coalesce(old.manager_id,"null"),",",
        old.hire_date));
end $$
--
create trigger `log_author_insert` after insert on `author`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("author","insert",new.author_id,
        concat("(",new.first_name,",",new.last_name,")"));
end $$
--
create trigger `log_author_update` after update on `author`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("author","update",new.author_id,@default_message);
end $$
--
create trigger `log_author_delete` after delete on `author`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("author","delete",old.author_id,
        concat("(",old.first_name,",",old.last_name,")"));
end $$
--
create trigger `log_publisher_insert` after insert on `publisher`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("publisher","insert",new.publisher_id,
        concat("(",new.publisher_name,",",coalesce(new.email,"null")));
end $$
--
create trigger `log_publisher_update` after update on `publisher`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("publisher","update",new.publisher_id,
		concat(old.publisher_id,"| (",old.publisher_name,",",coalesce(old.email,"null"),
		") -> (",new.publisher_name,",",coalesce(new.email,"null"),")"));
end $$ 
--
create trigger `log_publisher_delete` after delete on `publisher`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("publisher","delete",old.publisher_id,
        concat("(",old.publisher_name,",",coalesce(old.email,"null")));
end $$
--
create trigger `log_book_insert` after insert on `book`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("book","insert",new.isbn,
        concat("(",new.title,",",new.price));
end $$
--
create trigger `log_book_update` after update on `book`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("book","update",new.isbn,
		concat(old.isbn,"| (",old.title,",",old.price,
		") -> (",new.title,",",new.price,")"));
end $$ 
--
create trigger `log_book_delete` after delete on `book`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("book","delete",old.isbn,
        concat("(",old.title,",",old.price));
end $$
--
create trigger `log_sale_insert` after insert on `sale`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("sale","insert",new.sale_id,
        concat("(",new.customer_id,",",new.employee_id,")"));
end $$
--
# For the message on the `log_sale_update` trigger - "@default_message" we have 
# set it before as "changes have been applied to this entity".
create trigger `log_sale_update` after update on `sale`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
		("sale","update",new.sale_id,@default_message);
end $$
--
create trigger `log_sale_delete` after delete on `sale`
for each row
begin
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
        ("book","delete",old.sale_id,
        concat("(",old.customer_id,",",old.employee_id,")"));
end $$
--
create trigger `log_sale_content_insert` after insert on `sale_content`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
	("sale_content","insert",concat("(",new.sale_id,",",new.isbn,")"),
    concat("(",new.quantity,")"));
end $$
--
create trigger `log_sale_content_update` after update on `sale_content`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
	("sale_content","update",concat("(",new.sale_id,",",new.isbn,")"),
    concat("(",old.sale_id,",",old.isbn,")| (",old.quantity,") -> ","(",new.quantity,")"));
end $$
--
create trigger `log_sale_content_delete` after delete on `sale_content`
for each row
begin 
	insert into `log` (`table`,`event`,`entry_id`,`message`) values
	("sale_content","delete",concat("(",old.sale_id,",",old.isbn,")"),
    concat("(",old.quantity,")"));
end $$
--
create trigger `log_author_book_insert` after insert on `author_book`
for each row
begin
	insert into `log` ( `table`, `event`, `entry_id`, `message`) values
	('author_book', 'insert', concat('(',new.author_id,',',new.isbn, ')'), '');
end $$ 
--
create trigger `log_author_book_update` after update on `author_book`
for each row
begin
	insert into `log` (`table`, `event`, `entry_id`, `message`) values
	('author_book', 'update', concat('(',new.author_id,',', new.isbn, ')'), 
	concat('(', old.author_id,'->', new.author_id,")| (",old.isbn,') -> (', new.isbn, ')'));
end $$
--
create trigger `log_author_book_delete` after delete on `author_book`
for each row
begin
	insert into `log` (`table`, `event`, `entry_id`, `message`) values
	('author_book', 'delete', concat('(',old.author_id,', ',old.isbn, ')'), '');
end $$
--
create trigger `log_rating_insert` after insert on `rating`
for each row
begin
	insert into `log` (`table`, `event`, `entry_id`, `message`) values
    ('rating','insert',concat("(",new.customer_id,",",new.isbn,")"),
    concat("(",new.rating,",",new.rating_date,")"));
end $$
--
create trigger `log_rating_update` after update on `rating`
for each row
begin
	insert into `log` (`table`, `event`, `entry_id`, `message`) values
    ('rating','update',concat("(",new.customer_id,",",new.isbn,")"),
    concat("(",old.customer_id,",",old.isbn,")","| (",old.rating,") -> (",new.rating,")"));
end $$
--
create trigger `log_rating_delete` after delete on `rating`
for each row
begin
	insert into `log` (`table`, `event`, `entry_id`, `message`) values
    ('rating','delete',concat("(",old.customer_id,",",old.isbn,")"),
    concat("(",old.rating,",",old.rating_date,")"));
end $$
--
##
# the `rating_update` trigger ensures that if the updated rating 
# value is the same as before, we keep the previous rating date
create trigger `rating_update` before update on `rating`
for each row
begin
	# in this trigger we have to pay attention to deadlock
    # while this trigger is running you cannot insert, update 
    # or delete in the `rating` table
	if new.rating = old.rating then
		set new.rating_date := old.rating_date;
	else
		set new.rating_date := current_date();
	end if;
end $$
--
# This trigger uses the "if not exists" condition in order to 
# confirm if the client that is trying to rate their book, actually has 
# bought the book and if they have received their book 
# (we can know it through the shipment_date). If the client hasn't, 
# the trigger will raise an error with the custom message. Also, it only 
# fires before an insert on the table `sale`.
create trigger `rating_insert` before insert on `rating`
for each row
begin
	# the if not exists clause verifies if the result of the nested 
    # query is empty
	if not exists(
		# this sub query finds all the shipment dates of sales made 
        # to a certain customer which include a specific book.
        # if this query comes out empty, the customer did not buy 
        # the book or he hasn't recieved it
		select shipment_date from sale as s, sale_content as c
		where s.customer_id = new.customer_id 
		and c.isbn = new.isbn 
		and s.shipment_date is not null)
    then
		# this SQl statement raises an error with a specific 
        # error message
		signal sqlstate '45000'
		set message_text = "Book hasn't been purchased or recieved. Rating not available";
end if;
end $$
--
# A sale can only be made by active employees. This trigger checks if the employee 
# making a new sale has a terminated contract. Firstly we retrive the termination date 
# from the employee making the sale and confirm if said date is either null (meaning the 
# employee is not terminated), or if it is, it confirms if the date is before the new 
# sale's order date.
create trigger `no_sale_after_termination` before insert on `sale`
for each row
begin
	# the variable termination_date is the termination_date of the employee in
    # question, it can be null (active employee) or it can have a date value
	set @termination_date := (select e.termination_date from employee as e 
		where e.employee_id = new.employee_id);
	# if the employee is not active and if the order inserted is after the termination
    # date, then an error is raised
	if (@termination_date is not null and @termination_date < new.order_date)
	then
		signal sqlstate '45000'
		set message_text = 'Employee has a terminated contract. Cannot make new sales.';
	end if;
end $$
#This last "delimiter" resets to the default ";" instead of the "$$" we defined earlier.
delimiter ;
--
-- 2. Trigger Testing: 
--
# We insert test values in all the tables, with the exception of the log
# and see, if the correct entries appear in the log table:
insert into `city` (`city_name`) values
	("Lisbon");
insert into `postal_code` (`postal_code`,`city_id`) values 
	("1111-111",1);
insert into `address` (`street_name`,`postal_code`) values
	("Avenida da Liberdade","1111-111");
insert into `customer` (`first_name`,`last_name`,`email`,`address_id`) values
	("Vito","Corleone","the_don@mob.it",1);
insert into `employee` (`first_name`,`last_name`,`date_of_birth`,`email`,`address_id`,`salary`) values
	("Marge","Simpson","1987-12-17","m.simpson@onceuponatime.pt",1,11400.00);
insert into `author` (`first_name`,`last_name`) values
	('Fyodor','Dostoevsky');
insert into `publisher` (`publisher_name`,`email`) values
	('Mom Quixote','info@domquixote.pt');
insert into `book` (`isbn`,`title`,`publisher_id`,`price`) values
	(9789720032082,'Crime e Castigo',1,10.00);
insert into `sale` (`customer_id`,`address_id`,`employee_id`,`order_date`) values
	(1,1,1,"2023-12-8");
insert into `sale_content` (`sale_id`,`isbn`,`quantity`) values
	(1,9789720032082,1);
insert into `author_book` (`author_id`,`isbn`) values
	(1,9789720032082);
--
# run this query to view the data from the log table:
# select * from `log`;
--
# `rating_insert` trigger test:
# Let's try to insert a rating before the book as been recieved: (uncomment)
#insert into `rating` (`customer_id`,`isbn`,`rating`) values
# 	(1,9789720032082,"4");  
# Raises an error
# If we update `shipment_date`, then we can insert the rating properly
update `sale` set `shipment_date` = "2023-12-9" where `sale_id` = 1;
insert into `rating` (`customer_id`,`isbn`,`rating`,`rating_date`) values
  	(1,9789720032082,4,"2023-12-10");
# select * from `log`;
--
# log table does not register cascading updates or deletes
# let's now test the update log triggers which:
update `city` set `city_name` = "Porto" where `city_id` = 1;
update `postal_code` set `postal_code` = "1112-111" where `postal_code` = "1111-111";
update `address` set `street_name` = "Avenida da Boavista" where `address_id` = 1;
update `customer` set `first_name` = "Michael" where `customer_id` = 1;
update `author` set `author_id` = 2 where `author_id` =1;
update `publisher` set `publisher_name` = "Dom Quixote" where `publisher_id` = 1;
update `book` set `price` = 15.00 where `isbn` = 9789720032082;
update `sale_content` set `quantity` = 2 where (`sale_id`,`isbn`) = (1,9789720032082);
# select * from `log`;
--
# `rating_update` test:
# If the updated rating is the same as the previous one, `rating_date` does not change;
update `rating` set `rating` = 4 where (`customer_id`,`isbn`) = (1,9789720032082);
# select * from `rating`;
# But if the rating is different from the previous one, `rating_date` will change to today
update `rating` set `rating` = 5 where (`customer_id`,`isbn`) = (1,9789720032082);
# select * from `rating`;
# select * from `log`;
--
# `no_sale_after_termination` trigger test:
update `employee` set `termination_date` = "2023-12-10" where `employee_id` = 1; 
# insert into `sale` (`customer_id`,`address_id`,`employee_id`) values
# 	(1,1,1);
# Raises an error
--
# finally we test the delete log triggers
delete from `rating` where (`customer_id`,`isbn`) = (1,9789720032082);
delete from `sale_content` where (`sale_id`,`isbn`) = (1,9789720032082);
delete from `sale` where `sale_id` = 1;
delete from `author_book` where (`author_id`,`isbn`) = (1,9789720032082);
delete from `book` where `isbn` = 9789720032082;
delete from `publisher`where `publisher_id` = 1;
delete from `author` where `author_id` = 2;
delete from `employee` where `employee_id` = 1;
delete from `customer` where `customer_id` = 1;
delete from `address` where `address_id` = 1;
delete from `postal_code` where `postal_code` = "1112-111";
delete from `city` where `city_id` = 1;
--
# to view the full log entries run the folowing query:
# select * from `log`;
--
# our mock data was created with the auto increment
# option in mind, so after this test, we must reset the 
# auto increments for the tables that use it
alter table `city` auto_increment = 1;
alter table `postal_code` auto_increment = 1;
alter table `address` auto_increment = 1;
alter table `customer` auto_increment = 1;
alter table `employee` auto_increment = 1;
alter table `author` auto_increment = 1;
alter table `publisher` auto_increment = 1;
alter table `sale` auto_increment = 1;

/*-----------------------------Part E--------------------------------------------------
	We insert some mock data to populate our database. The data was chosen according
to the project's requirement. We have also tried to be as trustworthy as possible by 
using real books with real isbns, real portugues cities, postal codes and addresses,
publishers and authors, and consistent emails.
*/
insert into `city` (`city_name`) values
    ('Lisbon'),
    ('Porto'),
    ('Faro'),
    ('Coimbra'),
    ('Braga'),
    ('Aveiro'),
    ('Évora'),
    ('Viseu'),
    ('Setúbal');
--
insert into `postal_code` (`postal_code`, `city_id`) values
	('1100-001',1),('1100-002',1),('1100-003',1),   -- Lisbon
	('4000-001',2),('4000-002',2),('4000-003',2),   -- Porto
	('8000-001',3),('8000-002',3),('8000-003',3),   -- Faro
	('3000-001',4),('3000-002',4),('3000-003',4),   -- Coimbra
	('4700-001',5),('4700-002',5),('4700-003',5),   -- Braga
	('3800-001',6),('3800-002',6),('3800-003',6),   -- Aveiro
	('7000-001',7),('7000-002',7),('7000-003',7),   -- Évora
	('3500-001',8),('3500-002',8),('3500-003',8),   -- Viseu
	('2900-001',9),('2900-002',9),('2900-003',9);   -- Setúbal
--
insert into `address` (`street_name`,`door_number`,`postal_code`) values
	('Rua Augusta', 10, '1100-001'),
	('Avenida da Liberdade', 20, '1100-002'),
	('Rua Garrett', 30, '1100-003'),
	('Rua Santa Catarina', 40, '4000-001'),
	('Avenida dos Aliados', 50, '4000-002'),
	('Rua de Cedofeita', 60, '4000-003'),
	('Avenida da República', 70, '8000-001'),
	('Rua de Santo António', 80, '8000-002'),
	('Rua Conselheiro Bívar', 90, '8000-003'),
	('Rua da Sofia', 5, '3000-001'),
	('Rua Larga', 15, '3000-002'),
	('Avenida Sá da Bandeira', 25, '3000-003'),
	('Rua do Souto', 8, '4700-001'),
	('Avenida Central', 18, '4700-002'),
	('Rua do Castelo', 28, '4700-003'),
	('Avenida Lourenço Peixinho', 7, '3800-001'),
	('Rua João Mendonça', 17, '3800-002'),
	('Avenida Dr. Lourenço Peixinho', 27, '3800-003'),
	('Rua Serpa Pinto', 9, '7000-001'),
	('Rua de Aviz', 19, '7000-002'),
	('Avenida Túlio Espanca', 29, '7000-003'),
	('Rua Direita', 11, '3500-001'),
	('Avenida da Bélgica', 21, '3500-002'),
	('Largo Mouzinho de Albuquerque', 31, '3500-003'),
	('Avenida Luísa Todi', 13, '2900-001'),
	('Rua dos Aranhas', 23, '2900-002'),
	('Praceta Alves Redol', 33, '2900-003');
--
insert into `customer` (`first_name`,`last_name`,`date_of_birth`,`email`,`address_id`,`phone_number`,`gender`) values
	('Maria', 'Silva', '1980-10-30', 'maria.silva@hotmail.com', 1, 919701516, 'female'),
	('Pedro', 'Lourenço', '1995-12-05', 'pedro.lourenço@outmail.com', 2, 916223344, 'male'),
	('Sofia', 'Soares', '1980-03-15', 'sofia.soares@gmail.com', 4, 917334455, 'non-binary'),
	('João', 'Silva', '1990-06-30', 'joao.silva90@outmail.com',5 , 919545566, 'male'),
	('Inês', 'Dias', '1998-01-25', 'ines.dias@gmail.com', 7, 916556677, 'female'),
	('Carolina', 'Gaspar', '2003-11-14', 'carolina.g@gmail.com', 8, 914778899, 'female'),
	('Miguel', 'Almeida', '1997-07-10', 'miguel.almeida@outmail.com', 10, 913889900, 'non-binary'),
	('Beatriz', 'Correia', '2001-02-07', 'beatriz.slc.@gmail.com', 11, 919001122, 'female'),
	( 'Tiago', 'Teixeira', '1999-05-19', 'tiago.teixeira@outmail.com', 13, 918112233, 'male'),
	( 'Maria', 'Silva', '1987-09-10', 'a.maria.silva@hotmail.com', 14, 917112233, 'female'),
	( 'Ricardo', 'Oliveira', '1995-12-05', 'ricardo.oliveira@outmail.com', 16, 916223344, 'male'),
	( 'Catarina', 'Pereira', '1997-03-05', 'catarina.pereira@gmail.com', 17, 917334455, 'female'),
	( 'Catarina', 'Fernandes', '2002-06-19', 'catarina.fernandes@outmail.com', 19, 919545566, 'non-binary'),
	( 'Mariana', 'Rocha', '1988-01-14', 'mariana.rocha@hotmail.com', 20, 916556677, 'female'),
    # Gustavo and Leonor are siblings, so their address_id is the same
	( 'Gustavo', 'Santos', '200-04-05', 'gustavo.santos@outmail.com', 22, 915667788, 'male'),
	( 'Leonor', 'Santos', '2001-11-17', 'leonor.goncalves@gmail.com', 22, 914778899, 'female'),
	( 'Hugo', 'Pinto', '1999-05-24', 'hugo.ferreira.pinto@outmail.com', 25, 918112233, 'male');
--
insert into `employee` (`first_name`,`last_name`,`date_of_birth`,`email`,`address_id`,
	`phone_number`,`manager_id`,`hire_date`,`termination_date`,`salary`,`gender`) values
    # CEO
    ('André', 'Sousa', '1990-05-15', 'andre.sousa@onceuponatime.pt', 3, 937654320, null, '2021-10-07' , null, 48000.00, 'male'),
    # Manager
    ('Alice', 'Gomes', '1988-08-22', 'alice.gomes@onceuponatime.pt', 6, 937654321, 1, '2021-10-07', null,  24000.00, 'female'),
    # Staff
    ('Bernardo', 'Santos', '1995-04-10', 'bernardo.santos@onceuponatime.pt', 9, 937654325,2, current_date, null, 11400.00, 'male'),
    # Paulo Pires contract terminated on 2023-05-31
    ('Paulo', 'Pires', '1992-11-30', 'paulo.pires@onceuponatime.pt', 12, 937654322, 2, '2021-10-07', '2023-05-31', 11400.00, 'male'), 
    ('José', 'Anastácio', '1998-07-05', 'jose.anastacio@onceuponatime.pt', 15, 937654323, 2, '2022-09-01', null, 11400.00, 'male'),
	('Ana', 'Duarte', '2000-04-05', 'ana.duarte@onceuponatime.pt', 18, 937654324, 2, '2023-06-01', null, 11400.00, 'female');
--
insert into `author` (`first_name`,`last_name`,`date_of_birth`,`gender`) values
	('José','Saramago','1922-11-16','male'),
	('Fernando','Pessoa','1888-06-13','male'),
    # Since the exact birth date of Luís de Camões's is unknown, 
    # we've used January 1st of the estimated year.
	( 'Luís','de Camões','1524-01-01','male'),
	('Eça','de Queirós','1845-11-25','male'),
	('Sophia','Andresen','1919-11-06','female'),
	( 'Miguel','Torga','1907-08-12','male'),
	('António','Lobo Antunes','1942-09-01','male'),
	('William','Shakespeare','1564-04-23','male'),
	('Leo','Tolstoy','1828-09-09','male'),
	('Jane','Austen','1775-12-16','female'),
	('Mark','Twain','1835-11-30','male'),
	('George','Orwell','1903-06-25','male'),
	('J.K.','Rowling','1965-07-31','female'),
	('Fyodor','Dostoevsky','1821-11-11','male'),
	('Gabriel','García Márquez','1927-03-06','male'),
	('Harper','Lee','1926-04-28','female');
--
insert into `publisher` ( `publisher_name`, `email`, `phone_number`) values
	('Porto Editora','info@portoeditora.pt',226088312 ),
	('Assírio & Alvim','geral@assirio-alvim.pt',226088313),
	("Relógio d'Água",'geral@relogiodagua.pt.',226088314),
	('Tinta da China','geral@tintadachina.pt',226088315),
	('Dom Quixote','info@domquixote.pt',226088316);
--
insert into `book` (`isbn`,`title`,`publisher_id`,`price`,`number_of_pages`) values
	# for the sake of simplicity, we considered that if a book has more than 400 pages 
    # it's cost is 10.00  euros, otherwise is 5.00 euros.
	(9789720047895,'Ensaio Sobre a Cegueira',1,5.00,346),
	(9789720048380,'O Envagelho Segundo Jesus Cristo',1,10.00,448),
	(9789720049370,'O Ano da Morte de Ricardo Reis',1,10.00,496),
	(9789720049769,'Livro do Desassossego',4,10.00,576),
	(9789720019298,'Os Lusíadas',1,10.00,648),
	(9789720049264,'Os Maias',1,10.00,736),
	(9789720048427,'O Crime do Padre Amaro',1,10.00,528),
	(9789720048885,'O Cavaleiro da Dinamarca',1,5.00,208),
	(9789720030422,'O Colar',1,5.00,160),
	(9789720049226,'Bichos',5,5.00,128),
	(9789720048984,'Que Farei Quando Tudo Arde?',5,10.00,640),
	(9789720048540,'Hamlet',2,5.00,348),
	(9789720031788,'Anna Karenina',3,10.00,800),
	(9789720031887,'Orgulho e Preconceito',3,10.00,416),
	(9789720048700,'As Aventuras de Tom Sawyer',2,5.00,272),
	(9789720031986,'1984',5,5.00,314),
	(9789720048809,'Harry Potter e a Pedra Filosofal',3,5.00,352),
	(9789720032082,'Crime e Castigo',2,10.00,608),
	(9789720048908,'Cen anos de Solidao',4,10.00,417),
	(9789720032181,'Mataram a Cotovia',4,5.00,384);
--
insert into `author_book` (`isbn`, `author_id`) values
	(9789720047895,1),
    (9789720048380,1),
    (9789720049370,1),
	(9789720049769,2),
	(9789720019298,3),
	(9789720049264,4),
    (9789720048427,4),
	(9789720048885,5),
    (9789720030422,5),
	(9789720049226,6),
	(9789720048984,7),
	(9789720048540,8),
	(9789720031788,9),
	(9789720031887,10),
	(9789720048700,11),
	(9789720031986,12),
	(9789720048809,13),
	(9789720032082,14),
	(9789720048908,15),
	(9789720032181,16);
--
insert into `sale` (`customer_id`,`address_id`,`employee_id`,`order_date`,`shipment_date`) values
	#2021
    (1, 1, 4, '2021-10-08', '2021-10-11'),
    #2022
	(2, 2, 4, '2022-01-10', '2022-01-13'),
	(3, 4, 4, '2022-02-15', '2022-02-18'),
	(4, 5, 4, '2022-03-20', '2022-03-23'),
	(5, 7, 4, '2022-04-25', '2022-04-28'),
	(5, 7, 4, '2022-05-01', '2022-05-04'),
	(3, 4, 4, '2022-05-20', '2022-05-23'),
	(6, 8, 4, '2022-05-25', '2022-05-28'),
	(7, 10, 4, '2022-06-01', '2022-06-04'),
	(8, 11, 4, '2022-06-10', '2022-06-12'),
	(9, 13, 4, '2022-06-15', '2022-06-18'),
	(10, 14, 4, '2022-06-20', '2022-06-23'),
	(11, 16, 4, '2022-06-25', '2022-06-28'),
	(5, 7, 4, '2022-07-01', '2022-07-04'),
	(8, 11, 4, '2022-07-10', '2022-07-12'),
	(12, 17, 4, '2022-07-15', '2022-07-18'),
	(13, 19, 4, '2022-07-20', '2022-07-23'),
	(14, 20, 4, '2022-07-25', '2022-07-28'),
    (15, 22, 5, '2022-09-01', '2022-09-04'), # first order of employee_id 5
    (16, 22, 4, '2022-09-10', '2022-09-12'),
    (6, 8, 5, '2022-09-15', '2022-09-18'), 
    (3, 4, 4, '2022-10-20', '2022-10-23'),
    (17, 25, 5, '2022-11-25', '2022-11-28'),
    (7, 10, 4, '2022-11-25', '2022-11-28'),
    (5, 7, 5, '2022-12-05', '2022-12-08'),
	(13, 19, 4, '2022-12-05', '2022-12-08'),
	(10, 14, 5, '2022-12-20','2022-12-23'),
    #2023
    (1, 1, 4, '2023-01-01', '2023-01-04'),
    (16, 22, 5, '2023-01-10', '2023-01-12'),
    (1, 1, 4, '2023-02-15', '2023-02-18'),
    (6, 8, 5, '2023-02-20', '2023-02-23'),
    (12, 17, 4, '2023-03-25', '2023-03-28'),
    (2, 2, 5, '2023-04-01', '2023-04-03'), 
    (7, 10, 4, '2023-04-10', '2023-04-13'),
    (9, 13, 5, '2023-04-10', '2023-04-13'),
    (6, 8, 4, '2023-04-20', '2023-04-23'),
    (10, 14, 4, '2023-05-28', '2023-05-31'), # last order of employee_id 4
	(7, 10, 5, '2023-06-01', '2022-06-04'),
    (8, 11, 5, '2023-06-10', '2023-06-12'),
	(9, 13, 6, '2023-06-15', '2023-06-18'),
	(10, 14, 5, '2023-06-20', '2023-06-23'),
	(11, 16, 6, '2023-06-25', '2023-06-28'),
	(5, 7, 5, '2023-07-01', '2023-07-04'),
	(8, 11, 6, '2023-07-10', '2023-07-12'),
	(12, 17, 5, '2023-07-15', '2023-07-18'),
	(13, 19, 6, '2023-07-20', '2023-07-23'),
	(14, 20, 5, '2023-07-25', '2023-07-28'),
	(15, 22, 6, '2023-09-01', '2023-09-04'),
	(16, 22, 5, '2023-09-10', '2023-09-12'),
	(4, 5, 6, '2023-09-15', '2023-09-18'),
	(3, 4, 5, '2023-10-20', '2023-10-23'),
	(2, 2, 5, '2023-11-25', '2023-11-28'),
	(1, 1, 6, '2023-12-05', '2023-12-08'),
	(13, 19, 5, '2023-12-05', '2023-12-08'),
	(17, 25, 6, current_date, null); # customer that made a purchase, but has not yet received it.
--
insert into `sale_content` (`sale_id`,`isbn`,`quantity`) values
	# 2021
	(1,9789720047895,1),
    (1,9789720048380,1),
    # 2022
	(2,9789720048380,3),
	(3,9789720049370,1), 	
	(4,9789720019298,4),
	(5,9789720049370,1),
	(6,9789720047895,1),
    (6,9789720048380,1),
	(7,9789720030422,1),
	(8,9789720030422,2),
	(9,9789720030422,1),
	(10,9789720030422,1),
    (10,9789720047895, 1),
	(10,9789720048380,1),
    (10,9789720049370,1),
	(11,9789720049264,1),
	(12,9789720049226,1),
	(13,9789720049226,2),
	(14,9789720049226,1),
    (14,9789720049264,1),
	(15,9789720049264,1),
    (15,9789720048427,1),
	(16,9789720048427,1),
	(17,9789720048885,1),
	(18,9789720048885,2),
	(19,9789720048885,2), # first order of employee_id =5
    (19,9789720030422,3),
	(20,9789720048540,2),
	(21,9789720048540,2),
	(22,9789720048540,1),
	(23,9789720048427,1),
	(24,9789720048427,1),
    (24,9789720031788,1),
	(25,9789720031788,1),
	(26,9789720032181,1),
	(27,9789720048885,1),
    (27,9789720030422,1),
    (27,9789720048809,1), 
    # 2023
	(28,9789720048885,1),
    (28,9789720030422,1),
    (28,9789720048700,1),
	(29,9789720048984,1),
    (29,9789720031788,1),
    (29,9789720031887,1),
	(30,9789720031887,1),
	(31,9789720031788,2),
    (31,9789720031887,2),
	(32,9789720031887,1),
	(33,9789720031887,1),
    (33,9789720048700,1), 
	(34,9789720031986,2),
	(35,9789720031986,1),
	(36,9789720031986,1),
    (36,9789720048809,1),
    (36,9789720048700,1), 
	(37,9789720031887,3),
	(38,9789720048809,1),
	(39,9789720031887,2),
    (39,9789720048908,1),  
	(40,9789720048908,1), 
	(41,9789720031986,1), 
	(42,9789720031986,2), 
	(43,9789720032181,2),
    (43,9789720031986,1), 
	(44,9789720032082,2), 
	(45,9789720032082,1), 
	(46,9789720048540,1),
	(47,9789720032181,2), 
	(48,9789720032181,1),
    (48,9789720048908,1),
    (48,9789720032082,1),
	(49,9789720048809,2),
	(50,9789720048809,2),
	(51,9789720031986,1),
	(52,9789720031986,1),
    (52,9789720048809,1),
	(53,9789720031986,1),
    (53,9789720048809,1),
	(54,9789720048809,1), 
	(55,9789720048809,1),
    (55,9789720048908,1);
--
insert into `rating` (`customer_id`,`isbn`,`rating`,`rating_date`) values
	#2021
	(1,9789720047895,2,'2021-10-14'),
    (1,9789720048380,3,'2021-10-14'),
	#2022
	(2,9789720048380,5,'2022-01-16'),
	(3,9789720049370,5,'2022-02-21'),
	(4,9789720019298,4,'2022-03-26'),
	(5,9789720049370,1,'2022-05-01'),
	(3,9789720030422,5,'2022-05-28'),
	(6,9789720030422,5,'2022-05-31'),
	(7,9789720030422,2,'2022-06-07'),
	(8,9789720030422,1,'2022-06-15'),
    (8,9789720047895,2,'2022-06-15'),
    (8,9789720048380,3,'2022-06-15'),
    (8,9789720049370,4,'2022-06-15'),
	(9,9789720049264,5,'2022-06-21'),
	(10,9789720049226,3,'2022-06-25'),
	(11,9789720049226,3,'2022-07-01'),
	(5,9789720049226,2,'2022-07-07'),
    (5,9789720049264,3,'2022-07-04'),
	(8,9789720049264,3,'2022-07-15'),
    (8,9789720048427,4,'2022-07-12'),
	(12,9789720048427,3,'2022-07-21'),
	(13,9789720048885,2,'2022-07-26'),
	(14,9789720048885,5,'2022-07-31'), 
	(16,9789720048540,2,'2022-09-15'),
	(6,9789720048540,4,'2022-09-21'), 
	(3,9789720048540,4,'2022-10-26'),
	(7,9789720048427,1,'2022-12-01'),
    (7,9789720031788,3,'2022-12-01'),
	(5,9789720031788,2,'2022-12-11'),
	(13,9789720032181,1,'2022-12-08'),
	(10,9789720048885,2,'2022-12-26'),
    (10,9789720030422,2,'2022-12-26'),
    (10,9789720048809,2,'2022-12-26'), 
	#2023
	(1,9789720048885, 2,'2023-01-08'),
    (1,9789720030422,3,'2023-01-08'),
    (1,9789720048700,3,'2023-01-08'),
	(16,9789720048984,2,'2023-01-15'),
    (16,9789720031788,3,'2023-01-15'),
    (16,9789720031887,3,'2023-01-15'),
	(1,9789720031887,4,'2023-02-21'),
	(6,9789720031788,4,'2023-02-26'),
    (6,9789720031887,4,'2023-02-26'), 
	(12,9789720031887,3,'2023-03-31'),
	(7,9789720031986,5,'2023-04-16'),
	(9,9789720031986,5,'2023-04-16'),
	(6,9789720031986,1,'2023-04-25'),
    (6,9789720048809,3,'2023-04-25'),
    (6,9789720048700,4,'2023-04-25'), 
	(10,9789720031887,5,'2023-06-03'),
	(8,9789720031887,5,'2023-06-15'),
    (8,9789720048908, 5,'2023-06-15'),  
	(9,9789720048908,4,'2023-06-21'), 
	(10,9789720031986,1,'2023-06-25'),
	(11,9789720031986,5,'2023-07-01'),
	(5,9789720032181,2,'2023-07-08'),
    (5,9789720031986,1, '2023-07-08'), 
	(8,9789720032082,5,'2023-07-15'), 
	(12,9789720032082,5,'2023-07-21'), 
	(14,9789720032181,5,'2023-07-31'), 
	(15,9789720032181,5,'2023-09-08'),
    (15,9789720048908,2,'2023-09-08'),
    (15,9789720032082,3,'2023-09-08'),
	(4,9789720048809,4,'2023-09-21'),
	(2,9789720031986,5,'2023-12-01'),
    (2,9789720048809,5,'2023-12-01'),
	(1,9789720031986,4,'2023-12-11'),
    (1,9789720048809,5,'2023-12-11'),
    # customer that purchased a book but has not yet received it.
	(13,9789720048809,5,'2023-12-10');
--
# to view the data inserted run the following queries:
# select * from `city`;
# select * from `postal_code`;
# select * from `address`;
# select * from `customer`;
# select * from `employee`;
# select * from `publisher`;
# select * from `author`;
# select * from `book`;
# select * from `author_book`;
# select * from `sale`;
# select * from `sale_content`;
# select * from `rating`;
# select * from `log`;
--
/*---------------------------------------Part F —-------------------------------------------
1.
- EXECUTION: To retrieve customer names, purchase dates and book details within a range of 
two dates, the query selects from the `sale` table and performs joins with three additional 
tables: `customer`, `sale_content` and `book`. It filters by `order_date`to include only 
sales that occurred within the previously specified range of dates.
- OPTIMIZATION: The `order_date` attribute is of date type which implies a high 
cardinality due to the uniqueness of its values. Indexing this attribute, allows that records 
within the given period can be filtered first, minimizing time consumption and the number of 
rows involved in the joins. The corresponding index was created directly on the "create table" 
statement.
*/
select s.order_date, 
		c.customer_id, 
		concat(c.first_name,' ', c.last_name) as customer_name, 
		b.title, 
        b.isbn
from sale as s
join customer as c on c.customer_id = s.customer_id
join sale_content as sc on s.sale_id = sc.sale_id
join book as b on sc.isbn = b.isbn
where s.order_date between '2021-10-08' and '2023-12-05';
--
# the next view is used by queries and other views in order to access the properties of 
# each sale this was not necessary, since we can always perform a nested query to get 
# these properties, but since these values are used more than once, so we decided to 
# define the `sale_properties` view to access them
create view sale_property as 
	select s.sale_id,
		s.customer_id,
		sum(sc.quantity) as number_of_books,
		sum(sc.quantity * b.price) as total_value
	from sale as s
	join sale_content sc on s.sale_id = sc.sale_id
	join book b on sc.isbn = b.isbn
	group by s.sale_id, s.customer_id;
--
/* 2.
- BEST CUSTOMER CRITERIA: we took into consideration three types of what constitutes the 
best customer:
		a. The customer who spent the most money
        b. The customer who bought more books
		c. The customer Who made more purchases
- EXECUTION: Three queries were developed to align with the criteria defined above.
For all of them, specific joins had to be made, but since the purpose was to get the three 
best customers, it was necessary to group by `customer_id`, order the specific attribute in 
descending order (relevant for each criterion), and limit the output to the top three. 
- OPTIMIZATION: Further optimization is not feasible, as they only perform inner joins using 
foreign keys. 
*/
# a. Customers who spent the most money
select cust.customer_id, 
		concat(cust.first_name,' ',cust.last_name) as customer_name, 
        sum(sp.total_value) as total_value_spent
from customer as cust 
join sale as s on cust.customer_id = s.customer_id
join sale_property as sp on s.sale_id = sp.sale_id
group by cust.customer_id
order by total_value_spent desc
limit 3;
--
# b. Customers who bought more books
select cust.customer_id,
		concat(cust.first_name, ' ', cust.last_name) as customer_name, 
        sum(sc.quantity) as number_of_books
from customer as cust
join sale as s on cust.customer_id = s.customer_id
join sale_content as sc on sc.sale_id = s.sale_id
group by cust.customer_id
order by number_of_books desc
limit 3;
--
# c. The customers who made more purchases
select cust.customer_id,
		concat(cust.first_name, ' ', cust.last_name) as customer_name, 
        count(s.sale_id) as number_of_purchases
from customer as cust
join sale as s on cust.customer_id = s.customer_id
group by cust.customer_id
order by number_of_purchases desc
limit 3;
--
/* 3.
- EXECUTION: The necessary mathematical operations were perfomerd in the outer query, 
after extracting the entries from the `sale` table that had an `order_date` between a 
specific given period. The calculation of `yearly_average` took into account the number of 
days, a decision based on the significant impact that even a few month's difference 
can have. 
- OPTIMIZATION: The same optimization problem occurring in the first query reoccurs. 
We have chosen to address it in the same manner: using the index to the `order_date` 
of the `sale` table.
*/
select concat('2021-10-08', ' - ', '2023-12-05') as period_of_sales, 
		ts.total_sales, 
		round(total_sales / (timestampdiff(day, '2021-10-08', '2023-12-05') / 365), 2) as yearly_average,
		round(total_sales / timestampdiff(month, '2021-10-08', '2023-12-05'), 2) as montly_average
from (select sum(sp.total_value) as total_sales
		from sale_property as sp
		join sale as s on s.sale_id = sp.sale_id
        where s.order_date between '2021-10-08' and '2023-12-05') as ts;
/* 4.
- EXECUTION: To determine the cities where our product was sold, it's necessary to identy the 
cities to which purchase was delivered. This requires joining `city`, `postal_code`, 
`address` and `sale`. Grouping by the `city_id` is used in order to group rows with the same 
values into summary rows.
- OPTIMIZATION: The queries can't be further optimized once it only performs inner joins 
through the usage of foreign keys. 
*/
# this view is also useful when specifying the employee's, customer's 
# and shipping address of a sale, and is used multiple times accross
# multiple queries and views
create view full_address as
	select a.address_id, 
		a.door_number, 
		a.street_name, 
        a.postal_code, 
        c.city_name,
        c.city_id
    from address as a
    join postal_code as pc on pc.postal_code = a.postal_code
    join city as c on pc.city_id = c.city_id;
--
select fa.city_id, 
		fa.city_name, 
		count(s.sale_id) as total_sales
from full_address as fa
join sale as s on s.address_id = fa.address_id
group by c.city_id;
--
/* 5.
- EXECUTION: To identify the cities where products were sold but not rated, several inner joins 
were necessary. The `book` table is related to the `rating` table. An entry in the `rating` table 
exists only if a rating has been given, thus the requirement to check for  an entry with the same 
`isbn` as the product and the same `customer_id` as the sale. The query was expanded to calculate 
the total number of sales and the average book rating for each city.
- OPTIMIZATION: The query can't be further optimized once it only performs inner joins through the 
usage of foreign keys. 
*/
select fa.city_id, 
		fa.city_name, 
		count(s.sale_id) as total_sales, 
        round(avg(r.rating),1) as average_rating
from full_address as fa
join sale as s on s.address_id = fa.address_id
join sale_content as sc on sc.sale_id = s.sale_id
join book as b on b.isbn = sc.isbn
join rating as r on r.isbn = b.isbn and r.customer_id = s.customer_id
group by c.city_id;

/*---------------------------------------Part F - Extra—----------------------------------------
	We have also created some views which might be used often. These views show detailed information
of the main entities. For example, the `full_address` view, shows the complete address with the 
corresponding city, by joining the `postal_code` and `city` tables with the `address table`.
Another example, is the `book_details` view which shows, besides information already contained in the 
entity's table, all of its authors, the publisher, the number of sales in which the books was purchased, 
who many value the book generated to the business, and its average rating. 
	All of following views perform joins on foreign keys which are unique by definition, and no further 
optimization can be made with the use of an index. 
*/
--
create view customer_detail as
	select cust.customer_id,
		# customer's full name
		concat(cust.first_name," ",cust.last_name) as customer_name, 
		cust.email,
        # customer's full address
        concat(fa.door_number,", ",fa.street_name,", ",fa.postal_code,", ",fa.city_name) as address,
        # number of purchases the customer made
		count(sp.sale_id) as number_of_purchases,
        # number of books purchased
		sum(sp.number_of_books) as number_of_books_purchased,
        # total amount of value spent in our store
		sum(sp.total_value) as lifetime_value,
        # the value of the most expensive purchase
		max(sp.total_value) as most_expensive_purchase,
        # average rating the customer attributes to books
		round(avg(r.rating),2) as average_rating
    from customer as cust
    join full_address as fa on fa.address_id = cust.address_id
    # in here we use the previously defined view `sale_properties`
    join sale_property as sp on sp.customer_id = cust.customer_id
	join rating as r on r.customer_id = cust.customer_id
    group by cust.customer_id;
--
create view employee_detail as 
	select e.employee_id, 
		# employee's full name
		concat(e.first_name," ",e.last_name) as employee_name, 
		e.hire_date, 
		e.termination_date, 
        e.salary,
        # employee's full adress
		concat(fa.door_number,", ",fa.street_name,", ",fa.postal_code,", ",fa.city_name) as address,
        # manager's full name
		concat(m.first_name," ",m.last_name) as manager_name,
        # the number of sales the emplyee made
		count(temp.sale_id) as number_of_sales, 
		sum(temp.number_of_books) as number_of_books_sold,
        # total amount of value generated by the employee
		sum(temp.total_value) as total_amount_of_value_sold,
        # the value of the most expensive sale
		max(temp.total_value) as most_expensive_sale
    from employee as e
    # we used left join because the CEO has a null value in
    # his manager field
    left join employee as m on m.employee_id = e.manager_id
    join full_address as fa on fa.address_id = e.address_id
	# a nested query is necessary here to perform a sub group by.
    # there are employees (managers and CEO) who have performed no 
    # sales, nevertheless we want them to appear in the employee details
    # view
    left join (select s.employee_id, s.sale_id, 
			sum(sc.quantity) as number_of_books,
			sum(sc.quantity * b.price) as total_value
		from sale as s
		join sale_content sc on s.sale_id = sc.sale_id
		join book b on sc.isbn = b.isbn
        group by s.sale_id, s.employee_id) as temp on temp.employee_id = e.employee_id
	group by e.employee_id;
--
create view publisher_detail as
	select p.publisher_id, 
		p.publisher_name,
		group_concat(distinct b.title separator ", ") as books,
        # "group_concat" is an aggregation operation which concatenates
        # grouped fields resulting from a group by.
        # we show all the authors that have written books printed by the publisher
		group_concat(distinct concat(aut.first_name," ",aut.last_name) separator ", ") as associated_authors,
		round(avg(b.price),2) as average_book_price,
		sum(sc.quantity) as number_of_book_sales,
        # value generated by the all the books sold from the publisher
		sum(sc.quantity * b.price) as value_generated
    from publisher as p
    join book as b on b.publisher_id = p.publisher_id
    join author_book as ab on ab.isbn = b.isbn
    join author as aut on aut.author_id = ab.author_id
    join sale_content as sc on sc.isbn = b.isbn
    join sale as s on s.sale_id = sc.sale_id
    group by p.publisher_id;
--
create view author_detail as
	select aut.author_id, 
		concat(aut.first_name," ",aut.last_name) as author_name,
        # all the title written by the author
		group_concat(distinct b.title separator ", ") as author_books,
        # shows all the publisher in which print a book from the author
		group_concat(distinct p.publisher_name separator ", ") as associated_publishers,
		round(avg(b.price),2) as average_book_price,
		sum(sc.quantity) as number_of_book_sales,
		sum(sc.quantity * b.price) as value_generated
    from author as aut
    join author_book as ab on ab.author_id = aut.author_id
	join book as b on ab.isbn = b.isbn
    join publisher as p on p.publisher_id = b.publisher_id
    join sale_content as sc on sc.isbn = b.isbn
    join sale as s on s.sale_id = sc.sale_id
    group by aut.author_id;
--
create view book_detail as
	select b.isbn, 
		b.title, 
        # shows the full name of all the authors of the book
		group_concat(distinct concat(aut.first_name," ",aut.last_name) separator ", ") as author_name,
		p.publisher_name as publisher_name, 
        b.price, 
        b.number_of_pages,
		sum(sc.quantity) as number_of_book_sales,
		sum(sc.quantity * b.price) as value_generated,
		round(avg(r.rating),2) as average_rating
    from book as b
    join author_book as ab on ab.isbn = b.isbn
    join author as aut on aut.author_id = ab.author_id
    join publisher as p on p.publisher_id = b.publisher_id
    join sale_content as sc on sc.isbn = b.isbn
    join sale as s on s.sale_id = sc.sale_id
    join rating as r on r.isbn = b.isbn
    group by b.isbn;
--
create view sale_detail as
	select s.sale_id, concat(cust.first_name," ",cust.last_name) as customer_name,
		concat(e.first_name," ",e.last_name) as employee_name,
		concat(fa.door_number,", ",fa.street_name,", ",fa.postal_code,", ",fa.city_name) as address,
		s.order_date, 
        s.shipment_date, 
        count(sc.isbn) as number_of_books,
		sum(sc.quantity * b.price) as total_value
    from sale as s
    join sale_content as sc on sc.sale_id = s.sale_id
    join book as b on sc.isbn = b.isbn
    join customer as cust on cust.customer_id = s.customer_id
    join employee as e on e.employee_id = s.employee_id
	join full_address as fa on fa.address_id = s.address_id
    group by s.sale_id;
--
# select * from `full_address`;
# select * from `customer_detail`;
# select * from `employee_detail`;
# select * from `publisher_detail`;
# select * from `author_detail`;
# select * from `book_detail`;
# select * from `sale_detail`;

/*---------------------------------------Part G —-------------------------------------------
	We are asked to generate an invoice. An invoice is a property of a specific sale showing
the customer information, the shipping address, the total value of the sale before and after 
tax, together with a detailed description of the books sold, their quantities, and the values
each book contributes to the sale.
	Although we are asked to generate a view, it is more logical to define a procedure which
generates the invoice for any sale, by passing `sale_id` as argument to the procedure.
A procedure is a block SQL statements which use arguments, and can output values.
In this case the procedures defined to generate the invoice body and head take sale_id as
the argument, and show the result of a query defined in the procedure body.
*/
# the procedure `invoice_head` shows the customer information, the shipping address, 
#the total value of the sale before and after tax
delimiter $$
create procedure `invoice_head` (in `sale_id` int)
	begin
		select s.sale_id, 
			concat(cust.first_name," ",cust.last_name) as customer_name,
			concat(fa.door_number,", ",fa.street_name,", ",fa.postal_code,", ",fa.city_name) as address,
			round(sum(sc.quantity*b.price),2) as total_value,
            # choose a 13% tax rate  
			round(1.13*sum(sc.quantity*b.price),2) as total_value_after_tax
        from customer as cust
        join sale as s on s.customer_id = cust.customer_id
        join full_address as fa on fa.address_id = cust.address_id
		join sale_content as sc on sc.sale_id = s.sale_id
		join book as b on b.isbn = sc.isbn
		group by s.sale_id having s.sale_id = sale_id;
    end $$
--
# the `invoice_body` procedure lists all the books contained in the sale, 
# the number of units of each book sold, the total value of their fraction in the
# sale before and after tax, and the cumulative value of each contribution before and
# after tax
create procedure `invoice_body` (in `sale_id` int)
	begin
		select sc.isbn, 
			b.title,
            # the number of units of each book in the sale
			sc.quantity,
            # value contribution of a book to the total value of the sale
			round(sc.quantity*b.price,2) as contribution_value,
            # value after tax contribution of a book to the total value of the sale
			round(1.13 * sc.quantity * b.price,2) as value_after_tax,
            # in order to perform a cumulative sum, we use the window function "over"
            # which performs the sum within related rows. in order to sum up to a specific instance
            # we pass as argument to the "over function" the isbn ordering, such that the sum is made
            # up to our specific isbn.
            round(sum(sc.quantity * b.price) over(order by b.isbn),2) as cumulative_value,
            # cumulative value after tax contribution of a book to the total value of the sale
			round(sum(1.13 * sc.quantity * b.price) over (order by b.isbn),2) as cumulative_value_after_tax
            # the last row will include the total value of the sale, and the total value of the sale after tax
		from sale_content as sc
		join book as b on b.isbn = sc.isbn
		where sc.sale_id = sale_id;
    end $$
delimiter ;
--
# we can now show the head and body of the invoice of a specific sale
set @sale_to_generate_invoice := 10;
call invoice_head(@sale_to_generate_invoice);
call invoice_body(@sale_to_generate_invoice);

/* 	We reversed engineered our script to create an ERD representation of the database
we have constructed. You can find it in the project's folder by "erd.mwb" or 
"erd.png". */