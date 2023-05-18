-- adding a filament would SUCK
-- a nicer way to do this would be nice
	-- select from colour where (match user input)
-- add some constraints, see which are applicable

CREATE TABLE filament(
	id serial PRIMARY KEY,
	colour_id integer REFERENCES colour,
	material_id integer REFERENCES material,
	manufacturer_id integer REFERENCES manufacturer,
	condition_id integer REFERENCES condition,
	remaining_mass_id integer REFERENCES remaining_mass,
	roll_id integer REFERENCES roll,
	storage_id integer REFERENCES storage,
	picture_id integer REFERENCES picture,
);

-- filament data

CREATE TABLE colour(
	id serial PRIMARY KEY,
	name varchar
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
	('natural'), ('translucent'), ('green glow in the dark'),
;

CREATE TABLE material(
	id serial PRIMARY KEY,
	name varchar
);

INSERT INTO material(name)
VALUES ('ABS'), ('PETG'), ('PLA'), ('PLA+');
-- fill in some more from Ultimaker Cura

CREATE TABLE manufacturer(
	id serial PRIMARY KEY,
	name varchar
);

INSERT INTO manufacturer(name)
VALUES ('CCTREE'), ('eSUN'), ('Filaments.ca'), ('Generic'), ('Imperial Data'), ('MG Chemicals');

CREATE TABLE condition(
	id serial PRIMARY KEY,
	is_dry boolean,
	is_clean boolean,
)

--INSERT INTO condition(isDry, isClean)
--VALUES ...

CREATE TABLE remaining_mass(
	id serial PRIMARY KEY,
	--original_total_mass numeric,
	--original_filament_mass numeric,
	roll_mass numeric, -- when adding new entry, calculate (original_total_mass - original_filament) automatically
	total_mass numeric,
	remaining_filament_mass numeric -- expression, how to implement
-- remaining = total_mass - roll_mass
)

-- remaining_mass data

CREATE TABLE roll(
	id serial PRIMARY KEY,
	type integer REFERENCES roll_type,
	colour integer REFERENCES roll_colour,
	size integer REFERENCES roll_size
);

INSERT INTO roll(type, colour, size)
VALUES
	(1, 1, 1), -- loose
	(2, 2, 3), -- white cardboard
	(3, 3, 2), -- small black plastic
	(3, 3, 3), -- black plastic
	(3, 5, 3)  -- transparent plastic
	--() -- glow in the dark
	--() -- not original
;

CREATE TABLE roll_type(
	id serial PRIMARY KEY,
	name varchar
);

INSERT INTO roll_type(name)
VALUES ('loose'), ('cardboard'), ('plastic');
-- how to handle loose case

CREATE TABLE roll_colour(
	id serial PRIMARY KEY,
	name varchar
);

INSERT INTO roll_colour(name)
VALUES ('none'), ('white'), ('black'), ('brown'), ('transparent');
-- none special case

CREATE TABLE roll_size(
	id serial PRIMARY KEY,
	name varchar
);

INSERT INTO roll_size(name)
VALUES ('none'), ('small'), ('normal');
-- none special case

CREATE TABLE storage(
	id serial PRIMARY KEY,
	name varchar
);

-- could this be more detailed?
INSERT INTO storage(name)
VALUES ('loose'), ('permanently sealed bag'), ('resealable bag'), ('retail box');

-- should be a function
-- filenames all follow the same format
-- (document this format)
CREATE TABLE picture(
	id serial PRIMARY KEY,
	roll_picture_filename varchar,
	colour_picture_filename varchar
);

-- picture data