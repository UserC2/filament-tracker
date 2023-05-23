/* Description:
 * Group filaments by colour, material, or both, and display the total usable
 * mass of each group.
 * ** Why this is useful: **
 * When planning a project, this query can be used to determine which colours
 * and materials can be used for a project.
 * For example: A project requires 500g of PLA filament in any colour for
 * several prints. `SELECT * FROM total_usable_mass_by_colour` would show the
 * total mass of each colour, and the user can select which colour they want to
 * use for their project.
 */

CREATE VIEW total_usable_mass_by_colour AS
	SELECT
		colour.name AS colour,
		sum(usable_filament_grams) AS usable_filament_grams
	FROM
		filament
		JOIN colour ON colour_id = colour.id
	GROUP BY
		colour
	ORDER BY
		colour asc,
		usable_filament_grams desc
;

CREATE VIEW total_usable_mass_by_material AS
	SELECT
		material.name AS material,
		sum(usable_filament_grams) AS usable_filament_grams
	FROM
		filament
		JOIN material ON material_id = material.id
	GROUP BY
		material
	ORDER BY
		material asc,
		usable_filament_grams desc
;

CREATE VIEW total_usable_mass AS
	SELECT
		material.name AS material,
		colour.name AS colour,
		sum(usable_filament_grams) AS usable_filament_grams
	FROM
		filament
		JOIN colour ON colour_id = colour.id
		JOIN material ON material_id = material.id
	GROUP BY
		material,
		colour
	ORDER BY
		material asc,
		colour asc,
		usable_filament_grams desc
;

-- ** EXAMPLE USE **
-- By colour and material:
SELECT * FROM total_usable_mass;
-- By colour:
SELECT * FROM total_usable_mass_by_colour;
-- By material:
SELECT * FROM total_usable_mass_by_material;