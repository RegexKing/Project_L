package maps
{
	/**
	 * Creates a randomly generated level, ready to be used with FlxTilemap
	 * Also allows getting random room & corridor points to know where to spawn the player / monsters / items / traps / ...
	 * @author Raf Vermeulen
	 */
	
	 
	 import org.flixel.FlxPoint;
	 import org.flixel.FlxRect;
	 import org.flixel.plugin.photonstorm.FlxMath;
	 import org.flixel.plugin.photonstorm.FlxVelocity;
	 
	public class DungeonGenerator 
	{
		public var map:Array; // One-dimensional array containing the actual map data
		
		public var rooms:Array; // Array containing arrays of the format (x, y). These coordinates are all floor spaces of rooms between first room and farthest room
		protected var corridors:Array; // Array containing arrays of the format (x, y). These coordinates are all floor spaces of corridors
		protected var prevDoor:Array; // Array of the format (x, y). Contains the coordinates of the previous room's door
		protected var firstRoomCoords:Array; // array containing coordinates of first room
		protected var allRooms:Array; //array containing all room coords
		public var lastRoomCoords:Array; //array of last room points
		protected var diamondRooms:Array; // array of all rooms between player and treasure
		
		private var roomObjs:Array; // helps figure out farthest room
		private var firstRoomRect:FlxRect; // rectangle containing points of first room
		private var firstRoomSpawnBuffer:FlxRect; //so enemies dont spawn to close to player
		
		// Constants, used to configure the floors
		public static var TOTAL_ROWS:int = 40;
		public static var TOTAL_COLS:int = 40;
		protected const WALL:int = 1;
		protected const FLOOR:int = 0;
		protected const MIN_ROOM_WIDTH:int = 5;
		protected const MAX_ROOM_WIDTH:int = 10;
		protected const MIN_ROOM_HEIGHT:int = 5;
		protected const MAX_ROOM_HEIGHT:int = 12;
		protected static var  MIN_ROOMS:int = 6;
		protected static var  MAX_ROOMS:int = 12;

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
			firstRoomCoords = new Array();
			diamondRooms = new Array();
			roomObjs = new Array();
			
			// scale complexity
			TOTAL_ROWS = 30 + GameData.level*2;
			TOTAL_COLS = 30 + GameData.level*2;
			MIN_ROOMS = 4 + GameData.level;
			MAX_ROOMS = 8 + GameData.level;
			
			// Generate the map
			generateMap();
			sealMap();
			
			lastRoomCoords = findLastRoomCoords();
			allRooms = firstRoomCoords.concat(rooms);
			
			//take out cooridor points in rooms
			//spliceCorridors();
			
			// clear unneeded vars
			prevDoor = null;
			firstRoomRect = null;
			firstRoomSpawnBuffer = null;
			roomObjs = null;
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
			var totalRooms:int = FlxMath.rand(MIN_ROOMS, MAX_ROOMS+1);
			
			// Create each room
			for (var i:int = 0; i < totalRooms; i++) {
				firstRoom = (i == 0); // Check if it's the first room of the level
				createRoom(firstRoom);
			}
		}
		
		
		/**
		 * creates walled border around dungeon
		 */
		protected function sealMap():void
		{
			for (var i:int = 0; i < TOTAL_ROWS * TOTAL_COLS; i++)
			{
				if (!isCoordinateValid(i)) map[i] = WALL;		
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
			
			var roomWidth:int
			var roomHeight:int
			var startX:int
			var startY:int
			
			
			// Makes sure created room doesn't overlap with first room----
			do
			{
				// Generate the room's width, keeping minimum and maximum in mind
				roomWidth = Math.round(Math.random() * (MAX_ROOM_WIDTH - MIN_ROOM_WIDTH)) + MIN_ROOM_WIDTH;
			
				// Generate the room's height, keeping minimum and maximum in mind
				roomHeight = Math.round(Math.random() * (MAX_ROOM_HEIGHT - MIN_ROOM_HEIGHT)) + MIN_ROOM_HEIGHT;
			
				// Generate the room's coordinates, making sure it fits on the map
				// Floor is used here to avoid index out of bound errors
				startX = Math.floor(Math.random() * (TOTAL_ROWS - roomWidth));
				startY = Math.floor(Math.random() * (TOTAL_COLS - roomHeight));
			} while (!firstRoom && (FlxMath.pointInFlxRect(startX, startY, firstRoomRect) 
				|| FlxMath.pointInFlxRect(startX + roomWidth, startY + roomHeight, firstRoomRect)));
			
			if (firstRoom)
			{
				firstRoomRect = new FlxRect(startX, startY, roomWidth, roomHeight);
				firstRoomSpawnBuffer = new FlxRect(firstRoomRect.x - Map.TILE_SIZE * 2, firstRoomRect.y- Map.TILE_SIZE * 2, 
					firstRoomRect.width + Map.TILE_SIZE * 2, firstRoomRect.height + Map.TILE_SIZE * 2);
			}
			// -------------------------------------------------------------
			
			// Fills the room with floor tiles
			fillRect(startX, startY, roomWidth, roomHeight, firstRoom);
			
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
		protected function fillRect(startX:int, startY:int, width:int, height:int, firstRoom:Boolean):void {
			
			if (!firstRoom)
			{
				var roomObj:Room = new Room();
				roomObj.rect = new FlxRect(startX, startY, width, height);
			}
			
			for (var x:int = 0; x < width; x++) {
				for (var y:int = 0; y < height; y++) {
					
					var index:int = (startY + y) + (startX + x) * TOTAL_COLS; // Thanks to wg/funstorm for this formula
					
					map[index] = FLOOR;
					
					// Store the coordinates in the rooms array, to keep track of all rooms' floors	
					if (isCoordinateValid(index))
					{	
						if (firstRoom) storeFirstRoom(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS));// stores first room cooords
						else
						{
							storeRoom(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS));
							
							roomObj.coordsList.push([index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)]);
						}
					}
				}
			}	
			
			if (!firstRoom) roomObjs.push(roomObj);
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
						
						index = y + i * TOTAL_COLS;
						
						map[index] = FLOOR;
						
						if (isCoordinateValid(index - 1))
						{
							map[index - 1] = FLOOR;
							storeCorridor((index+1) % TOTAL_ROWS, Math.floor((index+1) / TOTAL_COLS));
						}
						if (isCoordinateValid(index + 1))
						{
							map[index + 1] = FLOOR;
							storeCorridor((index-1) % TOTAL_ROWS, Math.floor((index-1) / TOTAL_COLS));
						}
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
					else { 
						
						index = i + x * TOTAL_COLS
						
						map[index] = FLOOR; 
						
						if (isCoordinateValid(index - TOTAL_ROWS))
						{
							map[index - TOTAL_ROWS] = FLOOR;
							storeCorridor((index - TOTAL_ROWS) % TOTAL_ROWS, Math.floor((index - TOTAL_ROWS) / TOTAL_COLS));
						}
						if (isCoordinateValid(index + TOTAL_ROWS))
						{
							map[index + TOTAL_ROWS] = FLOOR;
						}
						
						storeCorridor((index + TOTAL_ROWS) % TOTAL_ROWS, Math.floor((index + TOTAL_ROWS) / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
				}
			}
			else if (start > end) {
				for (i = end; i <= start; i++) {
					if (horizontal == true) { 
						
						index = y + i * TOTAL_COLS;
						
						map[index] = FLOOR; 
						
						if (isCoordinateValid(index - 1))
						{
							map[index - 1] = FLOOR;
							storeCorridor((index+1) % TOTAL_ROWS, Math.floor((index+1) / TOTAL_COLS));
						}
						if (isCoordinateValid(index + 1))
						{
							map[index + 1] = FLOOR;
							storeCorridor((index-1) % TOTAL_ROWS, Math.floor((index-1) / TOTAL_COLS));
						}
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
					else { 
						
						index = i + x * TOTAL_COLS;
						
						map[index] = FLOOR;
						
						if(isCoordinateValid(index-TOTAL_ROWS)) map[index - TOTAL_ROWS] = FLOOR;
						if(isCoordinateValid(index+TOTAL_ROWS)) map[index + TOTAL_ROWS] = FLOOR;
						
						storeCorridor(index % TOTAL_ROWS, Math.floor(index / TOTAL_COLS)); // Store the coordinates in the corridors array, to keep track of all corridors' floors
					}
				}				
			}			
		}
		
		/**
		 * Store the coordinates in the first rooms array
		 * @param	x Integer. X-coordinate
		 * @param	y Integer. Y-coordinate
		 */
		protected function storeFirstRoom(x:int, y:int):void {
			var coords:Array = new Array(x, y);
			firstRoomCoords.push(coords);			
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
		public function getRandomFirstRoomTile():Array {
			var index:int = Math.floor(Math.random() * firstRoomCoords.length);
			return firstRoomCoords[index];
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
		
		public function getRandomAllRoomTile():Array
		{
			var index:int = Math.floor(Math.random() * allRooms.length);
			return allRooms[index];
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
		
		public function getRandomLastRoomTile():Array
		{
			var index:int = Math.floor(Math.random() * lastRoomCoords.length);
			return lastRoomCoords[index];
		}
		
		public function get chestCoords():Array
		{
			var diamondCoords:Array = new Array();
			var excludeCoords:Array = new Array();
			
			for (var i:int = 0; i < GameData.CHESTS_PER_LEVEL-1; i++)
			{
				var index:int = FlxMath.rand(0, diamondRooms[i].length, excludeCoords);
				excludeCoords.push(index);
				
				diamondCoords.push(diamondRooms[i][index]);
			}
			
			return diamondCoords;
		}
		/*
		public function get chestCoords():Array
		{
			var chestCoords:Array = new Array();
			var chestNumber:int = Math.ceil(GameData.level / 5);
			
			//reverse diamond rooms so different spawn that diamonds
			diamondRooms.reverse();
			
			for (var i:int = 0; i < chestNumber; i++)
			{
				var index:int = Math.floor(Math.random() * diamondRooms[i].length);
				
				chestCoords.push(diamondRooms[i][index]);
			}
			
			return chestCoords;
		}
		*/
		
		
		/**
		 * Checks to see if coordinate is on the border of dungeon
		 */
		private function isCoordinateValid(i:int):Boolean
		{
			if (Math.floor(i / TOTAL_COLS) == 0 || Math.ceil(i / TOTAL_COLS) == TOTAL_COLS ||  i % TOTAL_ROWS == 0 || i % TOTAL_ROWS == TOTAL_ROWS - 1) return false;
			else return true;
		}
		
		private function findLastRoomCoords():Array
		{
			var tempRoomObj:Room;
			var farthestDistance:int = 0;
			var tempDistance:int = 0;
			
			for (var i:int = 0; i < roomObjs.length; i++)
			{
				
				tempDistance = FlxVelocity.distanceBetweenRects(firstRoomRect, roomObjs[i].rect);
				trace(tempDistance);
					
				if (tempDistance > farthestDistance)
				{
					if (i != 0) diamondRooms.push(tempRoomObj.coordsList);
					
					tempRoomObj = null;
					tempRoomObj = roomObjs[i];
					farthestDistance = tempDistance;
				}
				
				else
				{
					diamondRooms.push(roomObjs[i].coordsList);
				}
			}
			
			trace("Farthest: " + farthestDistance);
			
			return tempRoomObj.coordsList;
		}
		
		private function spliceCorridors():void
		{
			for (var i:int = 0; i < allRooms.length; i++)
			{
				for (var j:int = 0; j < corridors.length; j++)
				{
					if (allRooms[i][0] == corridors[j][0] && allRooms[i][1] == corridors[j][1])
					{
						corridors.splice(j, 1);
						j--;
					}
				}
			}
		}
	}
}