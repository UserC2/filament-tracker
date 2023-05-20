# Queries

## Query Ideas

### Modifying Data
* Add a new filament
* Update the remaining mass of a filament

### Projects
* Add a project
* Mark a project as complete (subtract filament amount)
* Cancel a project (release filament amount)

### Aggregation & Grouping
* Find the total amount of filament of each...
	* Material
	* Material & Colour
	* Note: Not colour only, as you should not mix different types of filament in one print.

### Filtering
* Find all materials of the same...
	* Material
	* Material & Colour
	* Colour
* Restrict another query to filaments of the same...
	* Material
	* Material & Colour
	* Colour
	* (This could be implemented by feeding the desired query the results of this query.)

### Sorting
* Show all filaments, ordered by...
	* Amount remaining (ascending)
	* Amount remaining (descending)
	* Colour (ascending alphabetical)
* Find the smallest roll with a certain capacity
	* Example: Input is 400g, there is one 300g roll, one 450g roll, and one 700g roll
	* 300g < 400g, so roll is rejected
	* 450g > 400g, so roll is kept
	* 700g roll also kept
	* Smallest roll is returned (450g)
	* This can help use up smaller rolls of filament, which allows more complete rolls to be used for larger prints without switching filament part way through.