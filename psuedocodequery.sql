-- find project id given name
SELECT project_id
INTO FOUND_PROJECT_ID
FROM project
WHERE name = UI_PROJECT_NAME;

-- update remaining filament mass
UPDATE filament
SET remaining_filament_grams = UI_TOTAL_GRAMS - roll_mass
WHERE id = UI_ID;

-- add a new filament
/*
	-- print sorted colours (alphabet asc)
	-- wait until input
	-- gonna be user's responsibility to do that

SELECT id
INTO UI_COLOUR_ID
FROM colour
WHERE name = UI_COLOUR_NAME;

	-- print sorted materials (alphabet asc)
	-- wait until input

SELECT id
INTO UI_MATERIAL_ID
FROM material
WHERE name = UI_MATERIAL_NAME;
*/

	-- calc roll mass
IF (UI_IS_NEW_FILAMENT) THEN
	CALC_ROLL_MASS := UI_ORIGINAL_TOTAL_MASS - UI_MANUFACTURER_SPECIFIED_FILAMENT_MASS
ELSE -- wrong word
	CALC_ROLL_MASS := UI_ROLL_MASS
END IF;

	-- calc remaining mass
CALC_REMAINING_FILAMENT_GRAMS := UI_TOTAL_MASS - CALC_ROLL_MASS;

INSERT INTO filament
VALUES (UI_COLOUR_ID, UI_MATERIAL_ID, CALC_ROLL_MASS, CALC_REMAINING_FILAMENT_GRAMS);



-- ** PROJECTS **

-- add project
INSERT INTO project
VALUES (UI_PROJECT);

-- mark project complete
	-- MUST BE PLPGSQL -> LOOP NOT SUPPORTED IN PURE SQL
	-- print is type RECORD
FOR print IN
	SELECT *
	FROM project_filament
	WHERE project_id = UI_PROJECT_ID;
LOOP
	COMPLETE_PRINT_PLACEHOLDER(print.project_id, print.print_name);
END LOOP;
	-- run cancel project query

-- cancel project
DELETE project
WHERE name = UI_NAME;



-- ** PRINTS **

-- add print
	-- find project id
SELECT project_id
INTO FOUND_PROJECT_ID
FROM project
WHERE name = UI_PROJECT_NAME;
	-- manual (use default values in a function)
FOUND_FILAMENT_ID = UI_FILAMENT_ID
	-- automatic
FOUND_FILAMENT_ID = FIND_IDEAL_FILAMENT_PLACEHOLDER(UI_FILAMENT_TABLE)
	-- add the print
INSERT INTO project_filament
VALUES (FOUND_PROJECT_ID, UI_PRINT_NAME, FOUND_FILAMENT_ID, UI_FILAMENT_AMOUNT);

-- mark print as complete
	-- find filament_amount
SELECT filament_amount, filament_id
INTO FOUND_FILAMENT_INFO
FROM project_filament
WHERE
	project_id = UI_PROJECT_ID
	AND print_name = UI_PRINT_NAME
;

	-- subtract the print mass from the filament's mass
UPDATE filament
SET remaining_filament_grams = remaining_filament_grams - FOUND_FILAMENT_INFO.filament_amount
WHERE id = FOUND_FILAMENT_INFO.filament_id;

	-- run cancel print query

-- cancel print
DELETE project_filament
WHERE
	project_id = UI_PROJECT_ID
	AND print_name = UI_PRINT_NAME
;



-- ** OTHER **

-- find total amount of filament of same material
SELECT
	sum(usable_filament_grams)
FROM
	filament
	JOIN material ON material_id = material.id
WHERE
	material.name = UI_MATERIAL_NAME
;

-- find total amount of filament of same material & colour
SELECT
	sum(usable_filament_grams)
FROM
	filament
	JOIN colour ON colour_id = colour.id
	JOIN material ON material_id = material.id
WHERE
	colour.name = UI_COLOUR_NAME
	AND material.name = UI_MATERIAL_NAME
;

-- group by colour and material and find total (usable) mass of filament
SELECT
	material.name AS material,
	colour.name AS colour,
	sum(usable_filament_grams) AS usable_filament_grams
FROM
	-- could these three lines be implemented as a view?
	filament
	JOIN colour ON colour_id = colour.id
	JOIN material ON material_id = material.id
GROUP BY
	material,
	colour
;

-- find all filaments of the same material
	-- can use return query in a function
SELECT * 
FROM
	UI_FILAMENT_TABLE
	JOIN material ON material_id = material.id
WHERE
	material.name = UI_MATERIAL_NAME
;

-- find all filaments of the same colour
SELECT * 
FROM
	UI_FILAMENT_TABLE
	JOIN colour ON colour_id = colour.id
WHERE
	colour.name = UI_COLOUR_NAME
;

-- find all filaments of the same material & colour
	-- query achievable via above two
/*
SELECT * 
FROM
	filament
	JOIN colour ON colour_id = colour.id
	JOIN material ON material_id = material.id
WHERE
	colour.name = UI_COLOUR_NAME
	material.name = UI_MATERIAL_NAME
;
*/

-- order filaments by amount remaining asc
SELECT *
FROM UI_FILAMENT_TABLE
ORDER BY filament.usable_filament_grams asc;

-- order filaments by amount remaining desc
SELECT *
FROM UI_FILAMENT_TABLE
ORDER BY filament.usable_filament_grams desc;

-- order filaments by colour asc
SELECT *
FROM
	UI_FILAMENT_TABLE
	JOIN colour ON colour_id = colour.id
ORDER BY
	colour.name asc;

-- order filaments by material asc
SELECT *
FROM
	UI_FILAMENT_TABLE
	JOIN material ON material_id = material.id
ORDER BY
	material.name asc;

-- order filaments by colour then material asc
-- order filaments by material then colour asc
	-- (combine order by colour/material to achieve above two queries)

-- find smallest roll with certain capacity
	-- filter input first to use with certain colour/material
SELECT id
FROM UI_FILAMENT_TABLE
WHERE usable_filament_grams >= UI_FILAMENT_AMOUNT
ORDER BY usable_filament_grams asc
LIMIT 1;