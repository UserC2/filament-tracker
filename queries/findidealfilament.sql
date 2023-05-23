/* Description:
 * Find the smallest roll that is >= min capacity.
 * ** Why this is useful: **
 * This filters filaments by colour and material, then chooses the smallest
 * roll of filament that has at least 'min_capacity' filament remaining. This
 * means that the smallest suitable roll is always used, preserving larger
 * rolls for prints that actually need them.
 * Saving larger rolls until they are needed allows larger prints to be printed
 * without switching filament rolls part way through, saving time and reducing
 * errors made while switching filaments that can cause prints to fail.
 */

-- Use '%' as colour_name or material_name to allow all colours or materials.
CREATE FUNCTION find_ideal_filament(min_capacity integer, material_name text, colour_name text)
	RETURNS integer
	LANGUAGE SQL
	AS
	'
	SELECT id
	FROM
		filament
		JOIN colour ON colour_id = colour.id
		JOIN material ON material_id = material.id
	WHERE
		colour.name LIKE colour_name
		AND material.name LIKE material_name
		AND usable_filament_grams >= min_capacity
	ORDER BY usable_filament_grams asc
	LIMIT 1;
	';

-- ** EXAMPLE USE **
SELECT find_ideal_filament(500, 'ABS', 'white');