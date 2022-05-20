CREATE TABLE dogs (
	dog_id serial PRIMARY KEY,
	name VARCHAR ( 50 ) NOT NULL,
	race VARCHAR ( 50 ) NOT NULL,
	file_path VARCHAR ( 255 ) NOT NULL
);