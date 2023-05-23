CREATE TABLE colour(
	id serial PRIMARY KEY,
	name varchar UNIQUE
);

INSERT INTO colour(name)
VALUES 
	('white'), ('black'),
	('grey'), ('bluish grey'), ('dark grey'), 
	('red'), ('dark red'),
	('orange'), ('light orange'), ('orange-red'),
	('yellow'),
	('green'), ('dark green'),
	('blue'), ('light blue'), ('dark blue'),
	('purple-blue'),
	('natural'), ('translucent'), ('green glow in the dark')
;

CREATE TABLE material(
	id serial PRIMARY KEY,
	name varchar UNIQUE
);

INSERT INTO material(name)
VALUES ('ABS'), ('PETG'), ('PLA'), ('PLA+');
-- fill in some more from Ultimaker Cura

-- more stuff here if desired

CREATE TABLE filament(
	id serial PRIMARY KEY,
	colour_id integer REFERENCES colour ON DELETE RESTRICT,
	material_id integer REFERENCES material ON DELETE RESTRICT,
	roll_mass numeric NOT NULL, -- grams?
	remaining_filament_grams numeric NOT NULL,
	reserved_filament_grams numeric DEFAULT 0 NOT NULL,
	usable_filament_grams numeric GENERATED ALWAYS AS (remaining_filament_grams - reserved_filament_grams) STORED NOT NULL,
	--roll_picture_filename varchar 
	--colour_picture_filename varchar
	CONSTRAINT mass_is_positive CHECK (roll_mass >= 0 AND remaining_filament_grams >= 0 AND reserved_filament_grams >= 0),
	CONSTRAINT filament_not_overreserved CHECK (usable_filament_grams >= 0)
);

/*
CREATE TABLE picture(
	id serial PRIMARY KEY,
	roll_picture_filename varchar,
	colour_picture_filename varchar
);

--picture data
*/

INSERT INTO filament(colour_id, material_id, roll_mass, remaining_filament_grams)
VALUES (1, 1, 100, 600), (7, 2, 100, 900);

CREATE TABLE project(
	id serial PRIMARY KEY,
	name varchar UNIQUE
);

INSERT INTO project(name)
VALUES ('shifter'), ('keychain');

CREATE TABLE project_filament(
	project_id integer REFERENCES project ON DELETE CASCADE, -- delete print-project relationships when project deleted
	print_name varchar,
	filament_id integer REFERENCES filament ON DELETE RESTRICT, -- disallow deleting filaments still associated with projects
	filament_amount numeric CHECK (filament_amount > 0),
	PRIMARY KEY (project_id, print_name)
);

INSERT INTO project_filament(project_id, print_name, filament_id, filament_amount)
VALUES
	(1, 'base', 1, 250),
	(1, 'body', 1, 200),
	(2, 'small', 1, 25),
	(2, 'normal', 2, 50)
;

CREATE FUNCTION find_reserved_mass(id integer)
	RETURNS numeric
	LANGUAGE PLPGSQL
	AS
	'
	DECLARE
    	total_reserved_mass numeric;
	BEGIN
		SELECT sum(filament_amount)
    	INTO total_reserved_mass
		FROM print
		WHERE filament_id = id;
    	RETURN total_reserved_mass;
	END
	';

-- check value of reserved_filament_grams when row is updated or inserted
-- will increase reserved_filament_grams
CREATE FUNCTION update_reserved_mass()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	'
	BEGIN
		UPDATE filament
		SET reserved_filament_grams = find_reserved_mass(NEW.filament_id)
		WHERE NEW.filament_id = id;
		RETURN NEW;
	END
	';

-- check value of reserved_filament_grams when row is deleted
-- will decrease reserved_filament_grams
CREATE FUNCTION release_reserved_mass()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
	'
	BEGIN
		UPDATE filament
		SET reserved_filament_grams = find_reserved_mass(OLD.filament_id)
		WHERE OLD.filament_id = id;
		RETURN NEW;
	END
	';

CREATE TRIGGER update_reserved_mass
	AFTER INSERT OR UPDATE
	ON project_filament
    FOR EACH ROW
	EXECUTE FUNCTION update_reserved_mass();

CREATE TRIGGER release_reserved_mass
	AFTER DELETE
	ON project_filament
	FOR EACH ROW
	EXECUTE FUNCTION release_reserved_mass();