/* 1. Create tables using the attached ERD. Be sure to include the appropriate data 
types. Rental date should default to the sysdate
Include a drop table statement before you create each table.
Run a DESC command for each table.*/

/*2.Add the following integrity constraints:
• Create primary key (PK) and foreign key (FK) constraints as needed per ERD 
• Create not null (NN) constraints where necessary as per ERD
• Create check constraint on rating field in movie table to limit rating values to 'G', 'PG', 'R', 'PG13'
• Create check constraint on category field in movie table to limit categories to
'DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY' • Run queries from the data dictionaries for the above constraints.*/

/* Dropping, creating and adding constraints to the actors table*/

DROP TABLE actors PURGE;

CREATE TABLE  actors
(actor_id NUMBER(10) CONSTRAINT actor_actor_id_pk PRIMARY KEY ,
stage_name VARCHAR2(40) CONSTRAINT actor_stage_name_nn NOT NULL ,
first_name VARCHAR2(25) CONSTRAINT actor_first_name_nn NOT NULL ,
last_name VARCHAR2(25) CONSTRAINT actor_last_name_nn NOT NULL ,
birth_date DATE CONSTRAINT actor_birth_date_nn NOT NULL);
   
DESC actors;

/* Dropping, creating and adding constraints to the movies table*/

DROP TABLE movies PURGE;

CREATE TABLE movies
(title_id NUMBER(10) CONSTRAINT movie_title_id_pk PRIMARY KEY,
title VARCHAR2(60) CONSTRAINT movie_title_nn NOT NULL,
description VARCHAR2(400) CONSTRAINT movie_desc_nn NOT NULL,
rating VARCHAR2(4) CONSTRAINT movie_rate_chk CHECK (rating IN ('G', 'PG', 'R', 'PG13')),
category VARCHAR2(20) CONSTRAINT movie_cat_chk CHECK (category IN ('DRAMA', 'COMEDY', 'ACTION', 'CHILD', 'SCIFI', 'DOCUMENTARY')),            
release_date DATE CONSTRAINT movie_rel_date_nn NOT NULL); 

DESC movies;

/* Dropping, creating and adding constraints to the star_billings table*/

DROP TABLE star_billings PURGE;

CREATE TABLE  star_billings
(actor_id NUMBER(10) CONSTRAINT star_bill_actor_id_fk REFERENCES actors(actor_id),
title_id NUMBER(10) CONSTRAINT star_bill_title_id_fk REFERENCES movies(title_id),
comments VARCHAR2(40),
CONSTRAINT star_bill_actor_title_id_pk PRIMARY KEY (actor_id, title_id));

DESC star_billings;

/* Dropping, creating and adding constraints to the media table*/

DROP TABLE media PURGE;

CREATE TABLE media
(media_id NUMBER(10) CONSTRAINT media_media_id_pk PRIMARY KEY,
format VARCHAR2(3) CONSTRAINT media_format_nn NOT NULL,
title_id NUMBER(10) CONSTRAINT media_title_id_nn NOT NULL,
CONSTRAINT media_title_id_fk FOREIGN KEY(title_id) REFERENCES movies(title_id));
   
DESC media;

/* Dropping, creating and adding constraints to the customers table*/

DROP TABLE customers PURGE;

CREATE TABLE  customers
(customer_id NUMBER(10) CONSTRAINT cust_cust_id_pk PRIMARY KEY,
last_name VARCHAR2(25) CONSTRAINT cust_last_name_nn NOT NULL,
first_name VARCHAR2(25) CONSTRAINT cust_first_name_nn NOT NULL,
home_phone VARCHAR2(12) CONSTRAINT cust_phone_nn NOT NULL,
address VARCHAR2(100) CONSTRAINT cust_adds_nn NOT NULL,
city VARCHAR2(30) CONSTRAINT cust_city_nn NOT NULL,
state VARCHAR2(2) CONSTRAINT cust_state_nn NOT NULL,
email VARCHAR2(25),
cell_phone VARCHAR2(12));

DESC customers;

/* Dropping, creating and adding constraints to the rental_history table*/

DROP TABLE rental_history PURGE;

CREATE TABLE  rental_history
(media_id NUMBER(10) CONSTRAINT rent_hist_media_id_fk REFERENCES media(media_id),
rental_date DATE DEFAULT SYSDATE,
customer_id NUMBER(10) CONSTRAINT rent_hist_cust_id_nn NOT NULL,
return_date DATE,
CONSTRAINT rent_hist_cust_id_fk FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
CONSTRAINT rent_media_id_rent_date_pk PRIMARY KEY (media_id, rental_date)); 

DESC rental_history;

/* 3. Create a view called TITLE_UNAVAIL to show the movie titles and media_id of the media not returned yet. 
The view should not allow any DML operations.
• Run a SELECT * for the view (after data has been added in later step)*/

CREATE VIEW title_unavail ("movie title", "media id")
AS SELECT movies.title, media.media_id
FROM rental_history 
INNER JOIN media ON rental_history.media_id = media.media_id 
INNER JOIN movies ON media.title_id = movies.title_id
WHERE rental_history.return_date IS NULL
WITH READ ONLY; 

/* 4. Create the following sequences to be used for primary key values:
• Use a sequence to generate PKs for CUSTOMER_ID in CUSTOMERS table o Begin at 101 and increment by 1
• Use a sequence to generate PKs for TITLE_ID in MOVIES table o Begin at 1 and increment by 1
• Use a sequence to generate PKs for MEDIA_ID in MEDIA table o Begin at 92 and increment by 1
• Use a sequence to generate PKs for ACTOR_ID in ACTOR table o Begin at 1001 and increment by 1
• Run queries from the data dictionaries for the above sequences.*/

CREATE SEQUENCE customer_id_seq
INCREMENT BY 1
START WITH 101;

CREATE SEQUENCE title_id_seq
INCREMENT BY 1
START WITH 1;

CREATE SEQUENCE media_id_seq
INCREMENT BY 1
START WITH 92;

CREATE SEQUENCE actor_id_seq
INCREMENT BY 1
START WITH 1001;

/*Add the data to the tables. Be sure to use the sequences for the PKs. 
• Run a SELECT * for each table.*/

/*Adding the data to the actors table.*/
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Brad Pitt', 'William', 'Pitt', TO_DATE('18-DEC-1963','DD-MON-YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Charlize Theron', 'Charlize', 'Theron', TO_DATE('07-AUG-1975','DD-MM-YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Sophia Bush', 'Sophia', 'Bush', TO_DATE('08-JUL-1982','DD-Month-YYYY'));
INSERT INTO actors(actor_id, stage_name, first_name, last_name, birth_date)
VALUES(actor_id_seq.NEXTVAL, 'Tom Holland', 'Thomas', 'Holland', TO_DATE('01-JUN-1996','DD/MM/YYYY'));

UPDATE actors
SET stage_name = 'Jim Carrey'
WHERE actor_id = 1001;

UPDATE actors
SET first_name = 'James'
WHERE actor_id = 1001;

UPDATE actors
SET last_name = 'Carrey'
WHERE actor_id = 1001;

UPDATE actors
SET birth_date = '17-JAN-1962'
WHERE actor_id = 1001;

UPDATE actors
SET stage_name = 'Drew Barrymore'
WHERE actor_id = 1003;

UPDATE actors
SET first_name = 'Drew'
WHERE actor_id = 1003;

UPDATE actors
SET last_name = 'Barrymore'
WHERE actor_id = 1003;

UPDATE actors
SET birth_date = '22-Feb-1975'
WHERE actor_id = 1003;

UPDATE actors
SET stage_name = 'Kate Winslet'
WHERE actor_id = 1002;

UPDATE actors
SET first_name = 'Kate'
WHERE actor_id = 1002;

UPDATE actors
SET last_name = 'Winslet'
WHERE actor_id = 1002;

UPDATE actors
SET birth_date = '05-Oct-1975'
WHERE actor_id = 1002;

Select * from actors;

/*Adding the data to the movies table.*/

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'Titanic', 'A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.', 'PG13', 'DRAMA',  TO_DATE('19 December 1997','DD Month YYYY'));

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'The Avengers', 'Earth''s mightiest heroes must come together and learn to fight as a team if they are going to stop the mischievous Loki and his alien army from enslaving humanity.', 'PG13', 'ACTION',
  TO_DATE('04 May 2012','DD Month YYYY'));

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'Charlie''s Angels', 'Three women, detectives with a mysterious boss, retrieve stolen voice-ID software, using martial arts, tech skills, and sex appeal.', 'PG13', 'ACTION',
  TO_DATE('22 October 2000','DD Month YYYY'));

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'Spider-Man: No Way Home', 'With Spider-Man''s identity now revealed, Peter asks Doctor Strange for help. When a spell goes wrong, dangerous foes from other worlds start to appear, forcing Peter to discover what it truly means to be Spider-Man.', 'PG13', 'ACTION',
  TO_DATE('10 May 2021','DD Month YYYY'));

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'The Lion King', 'Lion prince Simba and his father are targeted by his bitter uncle, who wants to ascend the throne himself.', 'G', 'CHILD',
  TO_DATE('24 June 1994','DD Month YYYY')); 

INSERT INTO movies(title_id, title , description ,  rating , category , release_date)
VALUES(title_id_seq.NEXTVAL, 'The Mask', 'Bank clerk Stanley Ipkiss is transformed into a manic superhero when he wears a mysterious mask.', 'PG13', 'COMEDY',
  TO_DATE('28-JUL-1994','DD Month YYYY'));
  
UPDATE movies
SET title = 'Bruce Almighty'
WHERE title_id = 2;

UPDATE movies
SET description = 'A guy who complains about God too often is given almighty powers to teach him how difficult it is to run the world.'
WHERE title_id = 2;

UPDATE movies
SET rating = 'PG13'
WHERE title_id = 2;

UPDATE movies
SET category = 'COMEDY'
WHERE title_id = 2;

UPDATE movies
SET release_date = '23-MAY-2003'
WHERE title_id = 2;

UPDATE movies
SET title = 'The Impossible'
WHERE title_id = 5;

UPDATE movies
SET description = 'The story of a tourist family in Thailand caught in the destruction and chaotic aftermath of the 2004 Indian Ocean tsunami.'
WHERE title_id = 5;

UPDATE movies
SET rating = 'PG13'
WHERE title_id = 5;

UPDATE movies
SET category = 'DRAMA'
WHERE title_id = 5;

UPDATE movies
SET release_date = '04-JAN-2013'
WHERE title_id = 5; 

DELETE movies
WHERE title_id = 7; 

Select * from movies;

/*Adding the data to the star_billings table.*/

INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1003,3, 'Drew played a tomboy named Dylan'); 
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1004,4, 'Tom played the newest Spider-man.'); 
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1002,1, 'Kate played the leading lady.');
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1001,2, 'Jim plays the lead in the movie.'); 
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1001,8, 'Jim plays the lead in the movie.'); 
INSERT INTO star_billings(actor_id, title_id , comments)
VALUES(1004,5, 'Tom plays a young boy in this true story');

Select * from star_billings;

/*Adding the data to the media table.*/

INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',1);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',1);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',2);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',2); 
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',3);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',3);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',4);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',4);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',5);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',5);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'DVD',8);
INSERT INTO media(media_id, format , title_id)
VALUES(media_id_seq.NEXTVAL,'VHS',8);

Select * FROM media;

/*Adding the data to the customers table.*/

INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Roussy', 'Amy', '713-250-5569', '123 Main St', 'Cherry', 'MN', 'aRoussy@mcc.edu', '713-555-1212');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Dannis', 'Stephanie', '713-250-5569', '123 Main St', 'Cherry', 'MN', 'sDannis@mcc.edu', '480-876-8888');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Johnson', 'Debbie', '540-987-5432', '54632 Maple Drive', 'San Diego', 'CA', 'dJohnson23@hotmail.com', '444-999-5432');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Tharon', 'Charlize', '222-333-4444', '67 Mountain Peak', 'Scottsdale', 'AZ', 'cTheron@outlook.com', '111-000-5433');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Efron', 'Zac', '222-333-5555', '89 Sunny Drive', 'Atlanta', 'GA', 'zEfron@mcc.edu', '999-587-4567');
INSERT INTO customers(customer_id, last_name, first_name,  home_phone, address, city, state, email,  cell_phone)
VALUES(customer_id_seq.NEXTVAL,'Hanks', 'Tom', '480-543-0000', '0984 Potato Tree Parkway.', 'Columbus', 'OH', 'tHanks@hotmail.com', '456-777-8833');

select * from customers;

/*Adding the data to the rental_history table.*/

INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(92, TO_DATE('01/09/2003','DD-MM-YY'), 101, TO_DATE('03/09/2003','DD-MON-YY'));
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(102, TO_DATE('01/09/2003','DD-MM-YY'), 103, TO_DATE('03/09/2003','DD-MON-YY'));
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(100, TO_DATE('22-OCT-2014','DD-MON-YY'), 102, TO_DATE('26-OCT-2014','DD-MON-YY'));
INSERT INTO rental_history(media_id, rental_date, customer_id,  return_date)
VALUES(98, TO_DATE('01-JAN-2021','DD-MON-YY'), 102, TO_DATE('03-JAN-2022','DD-MM-YY'));

Select * FROM rental_history;

/*Run a SELECT * for the view (after data has been added*/
Select * from title_unavail;

/*Create an index on the last_name column of the Customers table.
• Run a query from the data dictionary for indexes showing this index.*/

CREATE INDEX cust_last_name_idx
ON customers(last_name);

/*Create a synonym called TU for the TITLE_UNAVAIL view.
• Run query from the data dictionary for synonyms showing this synonym. 
• Print a SELECT * from the synonym.*/

CREATE  SYNONYM tu
FOR title_unavail;

Select * FROM tu;