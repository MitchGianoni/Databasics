#Databasics

#Schema

CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar, "last_name" varchar, "email" varchar);
CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "street" varchar, "city" varchar, "state" varchar, "zip" integer);
CREATE TABLE "items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "category" varchar, "description" text, "price" integer);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "item_id" integer, "quantity" integer, "created_at" datetime);

#Homework

# Normal Mode - No Joins Required!

# How many users are there?

sqlite> SELECT COUNT (*) FROM users;
50

# What are the 5 most expensive items?

sqlite> SELECT title, price FROM items ORDER BY price DESC LIMIT 5;
Small Cotton Gloves|9984
Small Wooden Computer|9859
Awesome Granite Pants|9790
Sleek Wooden Hat|9390
Ergonomic Steel Car|9341

# What's the cheapest book? (Does that change for "category is exactly 'book'" versus "category contains 'book'"?)
# NOTE: There is a Books category.

sqlite> SELECT * FROM items WHERE category="Books" ORDER BY price ASC LIMIT 1;
76|Ergonomic Granite Chair|Books|De-engineered bi-directional portal|1496

sqlite> SELECT * FROM items WHERE category LIKE "%Books%" ORDER BY price ASC LIMIT 1;
76|Ergonomic Granite Chair|Books|De-engineered bi-directional portal|1496

# Who lives at "6439 Zetta Hills, Willmouth, WY"? Do they have another address?

sqlite> SELECT users.id, first_name, last_name FROM users INNER JOIN addresses on users.id=addresses.user_id WHERE street="6439 Zetta Hills";
40|Corrine|Little

sqlite> SELECT user_id, street, city, state, zip FROM addresses INNER JOIN users on addresses.user_id=users.id WHERE users.id="40";
40|6439 Zetta Hills|Willmouth|WY|15029
40|54369 Wolff Forges|Lake Bryon|CA|31587

# Correct Virginie Mitchell's address to " New York, NY 12345".

sqlite> SELECT user_id, street, city, state, zip FROM addresses INNER JOIN users on addresses.user_id=users.id WHERE users.first_name="Virginie" AND users.last_name="Mitchell";
39|12263 Jake Crossing|New York|NY|10108
39|83221 Mafalda Canyon|Bahringerland|WY|24028
sqlite> UPDATE addresses SET zip="12345" WHERE addresses.user_id="39" AND addresses.city="New York" AND addresses.state="NY";
sqlite> SELECT user_id, street, city, state, zip FROM addresses INNER JOIN users on addresses.user_id=users.id WHERE users.first_name="Virginie" AND users.last_name="Mitchell";
39|12263 Jake Crossing|New York|NY|12345
39|83221 Mafalda Canyon|Bahringerland|WY|24028

# How many total items did we sell?

sqlite> SELECT SUM (quantity) FROM orders;
2125

# Simulate buying an item by inserting a User for yourself and an Order for that User.

sqlite> INSERT INTO users (first_name, last_name, email) VALUES ("Mitch", "Gianoni", "Mitch@Gianoni.com");
sqlite> SELECT users.id, first_name, last_name FROM users WHERE first_name="Mitch" AND last_name="Gianoni";
51|Mitch|Gianoni
sqlite> INSERT INTO orders (user_id, item_id, quantity, created_at) VALUES ("51", "69", "2", "3/21/2016");
sqlite> SELECT users.id, first_name, last_name FROM users LEFT OUTER JOIN orders ON users.id=orders.user_id WHERE users.id="51";
51|Mitch|Gianoni
sqlite> SELECT user_id, item_id, quantity FROM orders LEFT OUTER JOIN users ON orders.user_id=users.id WHERE orders.user_id="51";
51|69|2

#Schema

CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar, "last_name" varchar, "email" varchar);
CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "street" varchar, "city" varchar, "state" varchar, "zip" integer);
CREATE TABLE "items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "category" varchar, "description" text, "price" integer);
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "item_id" integer, "quantity" integer, "created_at" datetime);

# Hard Mode - Joins, Summation, More Advanced Queries

# How much would it cost to buy one of each tool?

sqlite> SELECT items.id, title, category, price FROM items WHERE category LIKE "%Tool%";
13|Small Plastic Pants|Beauty, Shoes & Tools|7476
20|Gorgeous Plastic Shoes|Industrial & Tools|2851
32|Practical Rubber Shirt|Tools|1107
49|Incredible Granite Gloves|Garden, Toys & Tools|798
50|Gorgeous Rubber Chair|Tools, Garden & Movies|3335
51|Rustic Steel Shirt|Tools, Clothing & Toys|615
59|Fantastic Granite Computer|Tools, Jewelery & Industrial|7606
64|Gorgeous Plastic Computer|Tools, Garden & Games|1913
66|Gorgeous Granite Car|Tools & Computers|2768
67|Practical Concrete Table|Sports & Tools|3160
80|Incredible Plastic Gloves|Tools|5437
84|Rustic Cotton Chair|Games, Sports & Tools|5210
87|Awesome Plastic Shirt|Tools|839
97|Incredible Granite Computer|Books, Toys & Tools|2377
99|Rustic Rubber Hat|Tools & Kids|985

sqlite> SELECT sum(price) FROM items WHERE category LIKE "%Tool%";
46477

# What item was ordered most often? What grossed the most money?
sqlite> SELECT title FROM items INNER JOIN orders ON items.id=item_id ORDER BY quantity DESC LIMIT 1;
Gorgeous Granite Car

sqlite> SELECT title, (orders.quantity*items.price) FROM ITEMS INNER JOIN orders ON items.id=item_id ORDER BY (orders.quantity*items.price) DESC LIMIT 1;
Awesome Granite Pants|97900

# What user spent the most?
sqlite> select first_name, last_name, items.price*orders.quantity FROM users INNER JOIN orders ON (users.id=user_id) INNER JOIN items ON (items.id=item_id) ORDER BY items.price*orders.quantity DESC LIMIT 1;
Missouri|Carroll|97900

# What were the top 3 highest grossing categories?

sqlite> SELECT category, (price*orders.quantity) FROM items INNER JOIN orders ON (item_id=items.id) ORDER BY (price*orders.quantity) DESC LIMIT 3;
Toys & Books|97900
Health & Grocery|91290
Games|90000













