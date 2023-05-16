* A 'id' primary key is omitted from each table
* A table marked as a 'lookup table' is a table with an id and a name. The data listed under the table name is some sample data.

```
filament
	colour
	material
	manufacturer
	condition
	remaining_mass
	roll
	storage
	picture

colour lookup table
	(insert colours)

material lookup table
	ABS
	PETG
	PLA
	PLA+
	- fill in some from Ultimaker Cura

manufacturer lookup table
	(insert manufacturers)

condition
	isDry -- boolean
	isClean -- boolean

remaining_mass
	roll_mass --calculated: original total mass - manufacturer reported filament mass
	current_total_mass --measured
	remaining_filament_mass = current_total_mass - roll_mass

roll
	type
	colour
	size

roll type lookup table
	loose -> how to handle this case
	cardboard
	plastic

roll colour lookup table
	none -> special case
	white
	black
	brown
	transparent

roll size lookup table
	none -> special case
	small
	normal

storage lookup table
	loose
	permanentely sealed bag
	resealable bag
	retail box

picture
	roll_filename
	colour_filename
```