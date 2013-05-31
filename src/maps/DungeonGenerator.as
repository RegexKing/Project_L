package maps
{
	/**
	 * Creates a randomly generated level, ready to be used with FlxTilemap
	 * Also allows getting random room & corridor points to know where to spawn the player / monsters / items / traps / ...
	 * @author Raf Vermeulen
	 */
	
	 
	 import org.flixel.plugin.photonstorm.FlxMath;
	 
	public class DungeonGenerator 
	{
		public var map:Array; // One-dimensional array containing the actual map data
		
		protected var rooms:Array; // Array containing arrays of the format (x, y). These coordinates are all floor spaces of rooms
		protected var corridors:Array; // Array containing arrays of the format (x, y). These coordinates are all floor spaces of corridors
		
		protected var prevDoor:Array; // Array of the format (x, y). Contains the coordinates of the previous room's door
		
		// Constants, used to configure the floors
		public static const TOTAL_ROWS:int = 40;
		public static const TOTAL_COLS:int = 40;
		protected const WALL:int = 2;
		protected const FLOOR:int = 1;
		protected const MIN_ROOM_WIDTH:int = 4;
		protected const MAX_ROOM_WIDTH:int = 12;
		protected const MIN_ROOM_HEIGHT:int = 4;
		protected const MAX_ROOM_HEIGHT:int = 12;
		protected const MIN_ROOMS:int = 5;
		protected const MAX_ROOMS:int = 10;

		/**
		 * Constructor
		 */
		public function DungeonGenerator() 
		{
			// Initialize class-wide arrays
			map = new Array();
			rooms = new Array();
			corridors = new Array();			
			prevDoor = new Array();
			
			// Generate the map
			generateMap();

			sealMap();
		}
				
		/**
		 * Generates the level
		 */
		protected function generateMap():void {
			var firstRoom:Boolean; // Used to know if it's the level's first room or not
			
			// Fill the level with "wall" tiles, so we can dig out floor space
			clearMap();
			
			// Get a random amount of rooms (up to the top limit)
			// Ceil is used for rounding here, to avoid getting 0 rooms
			var totalRooms:int = FlxMath.rand(MIN_ROOMS, MAX_ROOMS);
			
			// Create each room
			for (var i:int = 0; i < totalRooms; i++) {
				firstRoom = (i == 0); // Check if it's the first room of the level
				createRoom(firstRoom);
			}
		}
		
		protected function sealMap():void
		{
			for (var i:int = 0; i < TOTAL_ROWS * TOTAL_COLS; i++)
			{
				if (Math.floor(i / TOTAL_COLS) == 0 || Math.ceil(i / TOTAL_COLS) == TOTAL_COLS ||  i % TOTAL_ROWS == 0 || i % TOTAL_ROWS == TOTAL_ROWS-1) map[i] = WALL;
			}
		}
		
		/**
		 * Fills the entire level with "wall" tiles
		 */
		protected function clearMap():void {
			for (var i:int = 0; i < (TOTAL_ROWS * TOTAL_COLS); i++) {
				map.push(WALL);
			}			
		}
		
		/**
		 * Creates a single room.
		 * Also connects that new room to the previous room if possible
		 * @param	firstRoom Boolean, defaults to false. To create a level's first room, set this to TRUE
		 */
		protected function createRoom(firstRoom:Boolean = false):void {
			// Generate the room's width, keeping minimum and maximum in mind
			var roomWidth:int = Math.round(Math.random() * (MAX_ROOM_WIDTH - MIN_ROOM_WIDTH)) + MIN_ROOM_WIDTH;
			
			// Generate the room's height, keeping minimum and maximum in mind
			var roomHeight:int = Math.round(Math.random() * (MAX_ROOM_HEIGHT - MIN_ROOM_HEIGHT)) + MIN_ROOM_HEIGHT;
			
			// Generate the room's coordinates, making sure it fits on the map
			// Floor is used here to avoid index out of bound errors
			var startX:int = Math.floor(Math.random() * (TOTAL_ROWS - roomWidth));
			var startY:int = Math.floor(Math.random() * (TOTAL_COLS - roomHeight));
			
			// Fills the room with floor tiles
			fillRect(startX, startY, roomWidth, roomHeight);
			
			// Get a random coordinate for the door (door in this case meaning random point anywhere in the room)
			var door:Array = getRandomPoint(startX, startY, roomWidth, roomHeight);
			
			// Create a corridor to the previous room if necessary
			if (firstRoom == false) {
				createCorridor(door);
			}
			
			// Set the previous room's door to be this one's, so it's ready for the next room
			prevDoor = new Array(door[0], door[1]);
		}
		
		/**
		 * Fills a rectacle with FLOOR tiles
		 * @param	startX integer. The room's top left X coordinate
		 * @param	startY integer. The room's top left Y coordinate
		 * @param	width integer. The room's width
		 * @param	height integer. The room's height
		 */
		protected function fillRect(startX:int, startY:int, width:int, height:int):void {
			for (var x:int = 0; x < width; x++) {
				for (var y:int = 0; y < height; y++) {
					
					var index:int = (startY + y) + (startX + x) * TOTAL_COLS; // Thanks to wg/funstorm for this formula
					
					map[index] = FLOOR;
					
					// Store the coordinates in the rooms array, to keep track of all rooms' floors	
					storeRoom(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS));
				}
			}			
		}
		
		/**
		 * Gets a random point within the given rectangle
		 * @param	startX integer. The room's top left X coordinate
		 * @param	startY integer. The room's top left Y coordinate
		 * @param	width integer. The room's width
		 * @param	height integer. The room's height
		 * @return Array. The random point's coordinates, as (x, y)
		 */
		protected function getRandomPoint(startX:int, startY:int, width:int, height:int):Array {
			var x:int = Math.round(Math.random() * width) + startX;
			var y:int = Math.round(Math.random() * height) + startY;
			
			var result:Array = new Array(x, y);
			
			// Avoid corners as random points, as that can result in unconnected corridors.
			if (x == startX && y == startY || // Top left corner
				x == (startX + width) && y == startY || // Top right corner
				x == startX && y == (startY + height) || // Bottom left corner
				x == (startX + width) && y == (startY + height) // Bottom right corner
			) { result = getRandomPoint(startX, startY, width, height); } // Call this function again to generate new coordinates
			
			return result;
		}
		
		/**
		 * Creates a corridor between two rooms.
		 * Basically draws an L-shaped corridor, first going from one room's X-coordinate to the other 
		 * (at starting room's Y-coordinate level),
		 * then going from that end-point X-coordinate to the destination room's Y-coordinate.
		 * @param	door Array. The new room's door coordinates, as (x, y)
		 */
		protected function createCorridor(door:Array):void {
			var x:int = door[0]; // For readability reasons
			var y:int = door[1]; // For readability reasons
			var prevX:int = prevDoor[0]; // For readability reasons
			var prevY:int = prevDoor[1]; // For readability reasons
			
			fillLine(x, prevX, x, y, true); // Draw the horizontal part of the corridor
			fillLine(y, prevY, prevX, y, false); // Draw the vertical part of the corridor
		}
		
		/**
		 * Fills a line with FLOOR tiles
		 * @param	start Integer. Starting room's coordinate. Can be either X or Y, dependant on the 'horizontal' parameter
		 * @param	end Integer. Destination room's coordinate. Can be either X or Y, dependant on the 'horizontal' parameter
		 * @param	x Integer. The starting point's X-coordinate
		 * @param	y Integer. The starting point's Y-coordinate
		 * @param	horizontal Boolean. Whether this line goes horizontally or not
		 */
		protected function fillLine(start:int, end:int, x:int, y:int, horizontal:Boolean):void {
			var i:int; // Initialize counter
			var index:int;
			
			// Check which direction to draw (rightwards / leftwards / upwards / downwards)
			if (start < end) {
				for (i = start; i <= end; i++) {
					if (horizontal == true) { 
						map[y + i * TOTAL_COLS] = FLOOR;
						
						index = y + i * TOTAL_COLS;
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
					else { 
						map[i + x * TOTAL_COLS] = FLOOR; 
						
						index = i + x * TOTAL_COLS;
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
				}
			}
			else if (start > end) {
				for (i = end; i <= start; i++) {
					if (horizontal == true) { 
						map[y + i * TOTAL_COLS] = FLOOR; 
						
						index = y + i * TOTAL_COLS;
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
					else { 
						map[i + x * TOTAL_COLS] = FLOOR; 
						
						index = i + x * TOTAL_COLS;
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
				}				
			}			
		}
		
		/**
		 * Store the coordinates in the rooms array, to keep track of all rooms' floors
		 * @param	x Integer. X-coordinate
		 * @param	y Integer. Y-coordinate
		 */
		protected function storeRoom(x:int, y:int):void {
			var coords:Array = new Array(x, y);
			rooms.push(coords);			
		}
		
		/** 
		 * Store the coordinates in the corridors array, to keep track of all corridors' floors
		 * @param	x Integer. X-coordinate
		 * @param	y Integer. Y-coordinate
		 */		
		protected function storeCorridor(x:int, y:int):void {
			var coords:Array = new Array(x, y);
			corridors.push(coords);			
		}		
		
		/**
		 * Get a random room floor tile
		 * Useful for spawning monsters / players / items / stairs / traps / ...
		 * @return Array. The random point's coordinates, as (x, y)
		 */
		public function getRandomRoomTile():Array {
			var index:int = Math.floor(Math.random() * rooms.length);
			return rooms[index];
		}
		
		/**
		 * Get a random corridor floor tile
		 * Useful for spawning monsters / players / items / stairs / traps / ...
		 * @return Array. The random point's coordinates, as (x, y)
		 */		
		public function getRandomCorridorTile():Array {
			var index:int = Math.floor(Math.random() * corridors.length);
			return corridors[index];
		}		
	}

}