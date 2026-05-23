/// Full list of counties per state for filter drill-down.
/// Source: Census / standard US county lists. Used by CountySelectorScreen.
/// sdd-miw-gift: each supported state has complete county list.
class StateCounties {
  StateCounties._();

  /// State code (e.g. AZ) -> sorted list of county names (no "County" suffix for display/API).
  static const Map<String, List<String>> _stateCounties = {
    'AZ': [
      'Apache', 'Cochise', 'Coconino', 'Gila', 'Graham', 'Greenlee', 'La Paz',
      'Maricopa', 'Mohave', 'Navajo', 'Pima', 'Pinal', 'Santa Cruz', 'Yavapai', 'Yuma',
    ],
    'FL': [
      'Alachua', 'Baker', 'Bay', 'Bradford', 'Brevard', 'Broward', 'Calhoun', 'Charlotte',
      'Citrus', 'Clay', 'Collier', 'Columbia', 'DeSoto', 'Dixie', 'Duval', 'Escambia',
      'Flagler', 'Franklin', 'Gadsden', 'Gilchrist', 'Glades', 'Gulf', 'Hamilton', 'Hardee',
      'Hendry', 'Hernando', 'Highlands', 'Hillsborough', 'Holmes', 'Indian River', 'Jackson',
      'Jefferson', 'Lafayette', 'Lake', 'Lee', 'Leon', 'Levy', 'Liberty', 'Madison', 'Manatee',
      'Marion', 'Martin', 'Miami-Dade', 'Monroe', 'Nassau', 'Okaloosa', 'Okeechobee', 'Orange',
      'Osceola', 'Palm Beach', 'Pasco', 'Pinellas', 'Polk', 'Putnam', 'St. Johns', 'St. Lucie',
      'Santa Rosa', 'Sarasota', 'Seminole', 'Sumter', 'Suwannee', 'Taylor', 'Union', 'Volusia',
      'Wakulla', 'Walton', 'Washington',
    ],
    'TX': [
      'Anderson', 'Andrews', 'Angelina', 'Aransas', 'Archer', 'Armstrong', 'Atascosa',
      'Austin', 'Bailey', 'Bandera', 'Bastrop', 'Baylor', 'Bee', 'Bell', 'Bexar', 'Blanco',
      'Borden', 'Bosque', 'Bowie', 'Brazoria', 'Brazos', 'Brewster', 'Briscoe', 'Brooks',
      'Brown', 'Burleson', 'Burnet', 'Caldwell', 'Calhoun', 'Callahan', 'Cameron', 'Camp',
      'Carson', 'Cass', 'Castro', 'Chambers', 'Cherokee', 'Childress', 'Clay', 'Cochran',
      'Coke', 'Coleman', 'Collin', 'Collingsworth', 'Colorado', 'Comal', 'Comanche',
      'Concho', 'Cooke', 'Coryell', 'Cottle', 'Crane', 'Crockett', 'Crosby', 'Culberson',
      'Dallam', 'Dallas', 'Dawson', 'Deaf Smith', 'Delta', 'Denton', 'DeWitt', 'Dickens',
      'Dimmit', 'Donley', 'Duval', 'Eastland', 'Ector', 'Edwards', 'Ellis', 'El Paso',
      'Erath', 'Falls', 'Fannin', 'Fayette', 'Fisher', 'Floyd', 'Foard', 'Fort Bend',
      'Franklin', 'Freestone', 'Frio', 'Gaines', 'Galveston', 'Garza', 'Gillespie',
      'Glasscock', 'Goliad', 'Gonzales', 'Gray', 'Grayson', 'Gregg', 'Grimes', 'Guadalupe',
      'Hale', 'Hall', 'Hamilton', 'Hansford', 'Hardeman', 'Hardin', 'Harris', 'Harrison',
      'Hartley', 'Haskell', 'Hays', 'Hemphill', 'Henderson', 'Hidalgo', 'Hill', 'Hockley',
      'Hood', 'Hopkins', 'Houston', 'Howard', 'Hudspeth', 'Hunt', 'Hutchinson', 'Irion',
      'Jack', 'Jackson', 'Jasper', 'Jeff Davis', 'Jefferson', 'Jim Hogg', 'Jim Wells',
      'Johnson', 'Jones', 'Karnes', 'Kaufman', 'Kendall', 'Kenedy', 'Kent', 'Kerr',
      'Kimble', 'King', 'Kinney', 'Kleberg', 'Knox', 'Lamar', 'Lamb', 'Lampasas',
      'La Salle', 'Lavaca', 'Lee', 'Leon', 'Liberty', 'Limestone', 'Lipscomb', 'Live Oak',
      'Llano', 'Loving', 'Lubbock', 'Lynn', 'McCulloch', 'McLennan', 'McMullen', 'Madison',
      'Marion', 'Martin', 'Mason', 'Matagorda', 'Maverick', 'Medina', 'Menard', 'Midland',
      'Milam', 'Mills', 'Mitchell', 'Montague', 'Montgomery', 'Moore', 'Morris', 'Motley',
      'Nacogdoches', 'Navarro', 'Newton', 'Nolan', 'Nueces', 'Ochiltree', 'Oldham',
      'Orange', 'Palo Pinto', 'Panola', 'Parker', 'Parmer', 'Pecos', 'Polk', 'Potter',
      'Presidio', 'Rains', 'Randall', 'Reagan', 'Real', 'Red River', 'Reeves', 'Refugio',
      'Roberts', 'Robertson', 'Rockwall', 'Runnels', 'Rusk', 'Sabine', 'San Augustine',
      'San Jacinto', 'San Patricio', 'San Saba', 'Schleicher', 'Scurry', 'Shackelford',
      'Shelby', 'Sherman', 'Smith', 'Somervell', 'Starr', 'Stephens', 'Sterling', 'Stonewall',
      'Sutton', 'Swisher', 'Tarrant', 'Taylor', 'Terrell', 'Terry', 'Throckmorton', 'Titus',
      'Tom Green', 'Travis', 'Trinity', 'Tyler', 'Upshur', 'Upton', 'Uvalde', 'Val Verde',
      'Van Zandt', 'Victoria', 'Walker', 'Waller', 'Ward', 'Washington', 'Webb', 'Wharton',
      'Wheeler', 'Wichita', 'Wilbarger', 'Willacy', 'Williamson', 'Wilson', 'Winkler',
      'Wise', 'Wood', 'Yoakum', 'Young', 'Zapata', 'Zavala',
    ],
    'NV': [
      'Carson City', 'Churchill', 'Clark', 'Douglas', 'Elko', 'Esmeralda', 'Eureka',
      'Humboldt', 'Lander', 'Lincoln', 'Lyon', 'Mineral', 'Nye', 'Pershing', 'Storey',
      'Washoe', 'White Pine',
    ],
    'CO': [
      'Adams', 'Alamosa', 'Arapahoe', 'Archuleta', 'Baca', 'Bent', 'Boulder', 'Broomfield',
      'Chaffee', 'Cheyenne', 'Clear Creek', 'Conejos', 'Costilla', 'Crowley', 'Custer',
      'Delta', 'Denver', 'Dolores', 'Douglas', 'Eagle', 'Elbert', 'El Paso', 'Fremont',
      'Garfield', 'Gilpin', 'Grand', 'Gunnison', 'Hinsdale', 'Huerfano', 'Jackson',
      'Jefferson', 'Kiowa', 'Kit Carson', 'Lake', 'La Plata', 'Larimer', 'Las Animas',
      'Lincoln', 'Logan', 'Mesa', 'Mineral', 'Moffat', 'Montezuma', 'Montrose', 'Morgan',
      'Otero', 'Ouray', 'Park', 'Phillips', 'Pitkin', 'Prowers', 'Pueblo', 'Rio Blanco',
      'Rio Grande', 'Routt', 'Saguache', 'San Juan', 'San Miguel', 'Sedgwick', 'Summit',
      'Teller', 'Washington', 'Weld', 'Yuma',
    ],
    'SD': [
      'Aurora', 'Beadle', 'Bennett', 'Bon Homme', 'Brookings', 'Brown', 'Brule',
      'Buffalo', 'Butte', 'Campbell', 'Charles Mix', 'Clark', 'Clay', 'Codington',
      'Corson', 'Custer', 'Davison', 'Day', 'Deuel', 'Dewey', 'Douglas', 'Edmunds',
      'Fall River', 'Faulk', 'Grant', 'Gregory', 'Haakon', 'Hamlin', 'Hand', 'Hanson',
      'Harding', 'Hughes', 'Hutchinson', 'Hyde', 'Jackson', 'Jerauld', 'Jones',
      'Kingsbury', 'Lake', 'Lawrence', 'Lincoln', 'Lyman', 'McCook', 'McPherson',
      'Marshall', 'Meade', 'Mellette', 'Miner', 'Minnehaha', 'Moody', 'Oglala Lakota',
      'Pennington', 'Perkins', 'Potter', 'Roberts', 'Sanborn', 'Spink', 'Stanley',
      'Sully', 'Todd', 'Tripp', 'Turner', 'Union', 'Walworth', 'Yankton', 'Ziebach',
    ],
  };

  /// Returns the full list of county names for a state, or empty if state not supported.
  static List<String> getCountiesForState(String stateCode) {
    return List.unmodifiable(_stateCounties[stateCode] ?? []);
  }

  /// Returns all state codes that have county data.
  static List<String> get supportedStates =>
      List.unmodifiable(_stateCounties.keys.toList()..sort());
}
