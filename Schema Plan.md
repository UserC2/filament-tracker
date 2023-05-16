filament table
id
colour
material
manufacturer
condition
remaining_mass
roll
storage
picture

colour table
id
name

colour data
- hi

material table
id
name

material data
ABS
PETG
PLA
PLA+
- fill in some from Ultimaker Cura

manufacturer table
id
name

manufacturer data
- hi

condition table
id
isDry
isClean

remaining_mass table
id
original_total_mass --measured
original_filament_mass --reported by manufacturer
current_total_mass --measured
-- current total - mass of roll = remaining filament
remaining_filament_mass = current_total_mass - (original_total_mass - original_filament_mass)

roll table
id
type
colour
size

roll type table
id
name

roll type data
loose -> how to handle this case
cardboard
plastic

roll colour table
id
name

roll colour data
none -> special case
white
black
brown
transparent

roll size table
id
name

roll size data
none -> special case
small
normal

storage table
id
name

storage data
loose
permanentely sealed bag
resealable bag
retail box

picture table
id
roll_filename
colour_filename

picture data
hi