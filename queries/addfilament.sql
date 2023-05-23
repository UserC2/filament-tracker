/* Description:
 * Add a filament to the database.
 * Additional functions provided to find colour, material, and mass of filament roll.
 * ** Why this is useful: **
 * This saves time for the user when adding a new filament.
 */

CREATE FUNCTION find_colour(colour_name text)
	RETURNS integer
	LANGUAGE SQL
	AS
	'
	SELECT id
	FROM colour
	WHERE name = colour_name;
	';

CREATE FUNCTION find_material(material_name text)
	RETURNS integer
	LANGUAGE SQL
	AS
	'
	SELECT id
	FROM material
	WHERE name = material_name;
	';

-- don't need to call this function if roll_mass is already known
-- for example, if the filament is not on a roll, roll_mass is 0
CREATE FUNCTION calculate_roll_mass(original_total_mass numeric, original_filament_mass numeric)
	RETURNS numeric
	LANGUAGE SQL
	AS 'SELECT original_total_mass - original_filament_mass;'
	;

CREATE PROCEDURE add_filament(colour_id integer, material_id integer, roll_mass numeric, remaining_filament_mass numeric)
	LANGUAGE PLPGSQL
	AS
	'
	BEGIN
		INSERT INTO filament(colour_id, material_id, roll_mass, remaining_filament_grams)
		VALUES (colour_id, material_id, roll_mass, remaining_filament_mass);
	END
	';

-- ** EXAMPLE USE **
CALL add_filament(
	find_colour('translucent'),
	find_material('PLA+'),
	calculate_roll_mass(1250, 1000),
	650
);