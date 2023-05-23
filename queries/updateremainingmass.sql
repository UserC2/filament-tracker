/* Description:
 * Update the remaining mass of a filament.
 * ** Why this is useful: **
 * The user can update the remaining mass of a filament if it is used outside
 * of this database's project system.
 */

CREATE PROCEDURE update_remaining_mass(filament_id integer, total_mass numeric)
	LANGUAGE SQL
	AS
	'
	UPDATE filament
	SET remaining_filament_grams = (total_mass - roll_mass)
	WHERE id = filament_id;
	';

-- ** EXAMPLE USE **
CALL update_remaining_mass(1, 500);