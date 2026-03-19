-- CREATE SCHEMA STORE;
-- USE STORE;
drop database if EXISTS temp1;
DROP database IF  EXISTS temp1;
create database temp1;
Use temp1;

DROP TABLE IF EXISTS Customer;
CREATE TABLE Customer (
  cust_id int NOT NULL AUTO_INCREMENT,
  email_id varchar(60) NOT NULL,
  Name varchar(20) NOT NULL,
  Ph_no varchar(10) NOT NULL,
  Cust_pass varchar(60) NOT NULL,
  Address varchar(200) NOT NULL,
  PRIMARY KEY (cust_id),
  UNIQUE KEY cust_id_Unique (cust_id)
) ;



DROP TABLE IF EXISTS Category_Description;
CREATE TABLE Category_Description (
  Category_ID int NOT NULL AUTO_INCREMENT,
  Main_Category varchar(60) NOT NULL,
  Sub_Category varchar(60) NOT NULL,
  Description varchar(60) NOT NULL,
  PRIMARY KEY (Category_ID)
);



DROP TABLE IF EXISTS Vendor;
CREATE TABLE Vendor (
    Vendor_ID int NOT NULL AUTO_INCREMENT,
    Name varchar(60) NOT NULL,
    E_Mail varchar(60) NOT NULL,
    Verified bool NOT NULL,
    Phone varchar(15) NOT NULL,
    Passwd varchar(20) NoT NULL,
    PRIMARY KEY (Vendor_ID)
);

drop table if exists Item;
CREATE TABLE Item (
  Item_id int NOT NULL AUTO_INCREMENT,
  Item_name varchar(60) NOT NULL,
  stock INT NOT NULL default 0,
  Item_price int NOT NULL,
  vendor_id int not null,
  category_id int NOT NULL,
  PRIMARY KEY (Item_id),
  Foreign KEY (category_id) references Category_Description(Category_ID),
  Foreign KEY (vendor_id) references Vendor(Vendor_ID),
  UNIQUE KEY Item_id_Unique (Item_id)
) ;




DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  Order_ID int NOT NULL AUTO_INCREMENT,
  Vendor_ID varchar(60) NOT NULL,
  description varchar(60),
  customer_id INT not null,
  item_id INT not null,
  Foreign KEY (customer_id) references Customer(cust_id),
  Foreign KEY (item_id) references Item(Item_id),
  PRIMARY KEY (Order_ID)
) ;


CREATE TABLE cart (
  item_id int ,
  customer_id int NOT NULL ,
  Foreign KEY (customer_id) references Customer(cust_id),
  Foreign KEY (item_id) references Item(Item_id)
) ;




DROP TABLE IF EXISTS Delivery_Description;
CREATE TABLE Delivery_Description (
  Delivery_ID int NOT NULL AUTO_INCREMENT,
  Name_Of_Receiver varchar(60) NOT NULL,
  Mobile_No_of_Receiver varchar(10) NOT NULL,
  Total_Price int unsigned NOT NULL DEFAULT 0,
  Vehicle_No varchar(60) NOT NULL,
  Description varchar(60) NOT NULL,
  Ratings tinyint unsigned NOT NULL,
  order_id INT,
  Foreign KEY (order_id) references orders(order_id),
  PRIMARY KEY (Delivery_ID)
);


DROP TABLE IF EXISTS Admin;
CREATE TABLE Admin (
  Admin_id int NOT NULL AUTO_INCREMENT,
  Mail varchar(60) NOT NULL,
  Ph_no varchar(10) NOT NULL,
  Pass varchar(60) NOT NULL,
  customer_id INT not null,
  vendor_id INT not null,
  item_id INT not null,
  PRIMARY KEY (Admin_id),
  UNIQUE KEY Admin_id_Unique (Mail),
  Foreign KEY (customer_id) references Customer(cust_id),
  Foreign KEY (vendor_id) references Vendor(Vendor_ID),
  Foreign KEY (item_id) references Item(Item_id)
) ;






INSERT INTO Customer (email_id, Name, Ph_no, Cust_pass, Address) VALUES
('john@example.com', 'John Doe', '1234567890', 'password123', '123 Main St, City, Country'),
('jane@example.com', 'Jane Smith', '9876543210', 'password456', '456 Elm St, City, Country'),
('alice@example.com', 'Alice Johnson', '1112223333', 'password789', '789 Oak St, City, Country'),
('bob@example.com', 'Bob Williams', '4445556666', 'passwordabc', '456 Pine St, City, Country'),
('emily@example.com', 'Emily Brown', '7778889999', 'passworddef', '890 Maple St, City, Country'),
('michael@example.com', 'Michael Wilson', '1231231234', 'passwordghi', '111 Birch St, City, Country'),
('samantha@example.com', 'Samantha Lee', '4564564567', 'passwordjkl', '222 Cedar St, City, Country'),
('david@example.com', 'David Martinez', '7897897890', 'passwordmno', '333 Willow St, City, Country'),
('jessica@example.com', 'Jessica Taylor', '9998887776', 'passwordpqr', '444 Walnut St, City, Country'),
('matthew@example.com', 'Matthew Garcia', '1112223333', 'passwordstu', '555 Spruce St, City, Country');

INSERT INTO Customer (email_id, Name, Ph_no, Cust_pass, Address) VALUES

('c', 'John Doe', '1234567890', 'c1', '123 Main St, City, Country');


INSERT INTO Category_Description (Main_Category, Sub_Category, Description) VALUES
('Electronics', 'Smartphones', 'Latest models available'),
('Electronics', 'Laptops', 'Variety of brands and specifications'),
('Clothing', 'Men', 'Trendy and fashionable styles'),
('Clothing', 'Women', 'Wide range of sizes available'),
('Books', 'Fiction', 'Bestselling novels and classics'),
('Books', 'Non-Fiction', 'Informative and educational reads'),
('Home Decor', 'Furniture', 'Stylish and durable pieces'),
('Home Decor', 'Lighting', 'Elegant lighting solutions'),
('Toys', 'Educational', 'Interactive and fun learning toys'),
('Toys', 'Outdoor', 'Outdoor games and playsets');


INSERT INTO Vendor (Name, E_Mail, Verified, Phone,Passwd) VALUES
('v', 'best@example.com', 1, '1234567890',"v1"),
('Laptop World', 'laptopworld@example.com', 1, '9876543210',"v2"),
('Fashion Boutique', 'fashionboutique@example.com', 0, '1112223333',"v3"),
('Jeans & More', 'jeansmore@example.com', 1, '4445556666',"v4"),
('Book Emporium', 'bookemporium@example.com', 0, '7778889999',"v5"),
('Book Nook', 'booknook@example.com', 1, '1231231234',"v6"),
('Furniture Palace', 'furniturepalace@example.com', 1, '4564564567', "v7"),
('Luminaire Haven', 'luminairehaven@example.com', 0, '7897897890',"v8"),
('Toys Galore', 'toysgalore@example.com', 1, '9998887776',"v9"),
('Sports World', 'sportsworld@example.com', 1, '1112223333',"v10");


INSERT INTO Item (Item_name, stock, Item_price, category_id,vendor_id) VALUES
('iPhone 13', '100', 1000, 1,1),
('MacBook Pro', '50', 2000, 2,2),
('T-Shirt', '200', 20, 3,3),
('Jeans', '150', 50, 4,4),
('To Kill a Mockingbird', '300', 15, 5,5),
('The Subtle Art of Not Giving a F*ck', '200', 20, 6,6),
('Sofa', '20', 500, 7,7),
('Chandelier', '30', 300, 8,8),
('LEGO Mindstorms EV3', '50', 300, 9,9),
('Basketball', '30', 25, 10,9);



INSERT INTO Admin (Mail, Ph_no, Pass, customer_id, vendor_id, item_id) VALUES
('admin1@example.com', '1234567890', 'adminpass1', 1, 1, 1),
('admin2@example.com', '9876543210', 'adminpass2', 2, 2, 2),
('admin3@example.com', '1112223333', 'adminpass3', 3, 3, 3),
('admin4@example.com', '4445556666', 'adminpass4', 4, 4, 4),
('admin5@example.com', '7778889999', 'adminpass5', 5, 5, 5),
('admin6@example.com', '1231231234', 'adminpass6', 6, 6, 6),
('admin7@example.com', '4564564567', 'adminpass7', 7, 7, 7),
('admin8@example.com', '7897897890', 'adminpass8', 8, 8, 8),
('admin9@example.com', '9998887776', 'adminpass9', 9, 9, 9),
('admin10@example.com', '1112223333', 'adminpass10', 10, 10, 10);



INSERT INTO Admin (Mail, Ph_no, Pass, customer_id, vendor_id, item_id) VALUES
('a', '1234567890', 'a1', 1, 1, 1);

select * from customer;
select * from Category_Description;
select * from Item;
select * from Vendor;
select * from orders;
select * from Delivery_Description;
select * from cart;
select * from Admin;

-- Triggers
 -- 1
DELIMITER $$
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE item_stock INT;
    SELECT stock INTO item_stock FROM Item WHERE Item_id = NEW.item_id;
    IF item_stock > 0 THEN
        UPDATE Item SET stock = stock - 1 WHERE Item_id = NEW.item_id;
    END IF;
END$$
DELIMITER ;

-- 2
DELIMITER $$
CREATE TRIGGER verify_vendor_on_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE vendor_exists INT;
    SELECT COUNT(*) INTO vendor_exists FROM Vendor WHERE Vendor_ID = NEW.Vendor_ID;
    IF vendor_exists > 0 THEN
        UPDATE Vendor SET Verified = 1 WHERE Vendor_ID = NEW.Vendor_ID;
    END IF;
END$$
DELIMITER ;



-- NON-conflicting Transactions

-- user registration
START TRANSACTION;
INSERT INTO Customer (email_id, Name, Ph_no, Cust_pass, Address)
VALUES ('test@example.com', 'Test User', '9999999999', 'testpassword', '123 Test St, City, Country');
COMMIT;


-- item purchase
START TRANSACTION;
INSERT INTO orders (Vendor_ID, description, customer_id, item_id)
VALUES ('VND011', 'One iPhone 13', 1, 1);
COMMIT;


-- add item to cart
START TRANSACTION;
INSERT INTO cart (item_id, customer_id)
VALUES (1, 1);
COMMIT;

-- add vendor

START TRANSACTION;
INSERT INTO Vendor (Name, E_Mail, Verified, Phone, Passwd)
VALUES ('New Vendor', 'newvendor@example.com', 1, '1234567890', 'newvendorpass');
COMMIT;



-- Conflicting trasactions

-- simultaneous item purchase
-- cust1


START TRANSACTION;
INSERT INTO orders (Vendor_ID, description, customer_id, item_id)
VALUES ('VND012', 'One MacBook Pro', 2, 2);
COMMIT;


START TRANSACTION;
INSERT INTO orders (Vendor_ID, description, customer_id, item_id)
VALUES ('VND013', 'One MacBook Pro', 3, 2);
COMMIT;


-- stock update at the same time

-- vend1
SET autocommit = 0;


BEGIN;
savepoint before1;
savepoint before2;
UPDATE Item SET stock = stock - 1 WHERE Item_id = 1;
savepoint after1;
savepoint after2;
rollback to before1;
COMMIT;

UPDATE Item SET stock = stock + 2 WHERE Item_id = 1;

select *from item where item_id =1;

START TRANSACTION;
UPDATE Item SET stock = stock - 1 WHERE Item_id = 1;
COMMIT;



START TRANSACTION;
INSERT INTO orders (Vendor_ID, description, customer_id, item_id)
VALUES ('VND012', 'One MacBook Pro', 2, 2);
COMMIT;




