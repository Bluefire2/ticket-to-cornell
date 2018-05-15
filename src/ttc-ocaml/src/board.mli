open Components

(* [location] represents a location on the board. It consists of the name
 * of the location, its coordinates for the GUI, and a list of locations that
 * are adjacent. *)
type location = Location of string * float * float * string list

(* [leftRightRoute] represents a left route or a right route. *)
type leftRightRoute = LeftRoute | RightRoute

(* [route] represents a route between two locations on the map. It can be
 * any length between 1 and 6 and has any train_color, or none. It also might
 * be a double route or not, and it can be a LeftRoute or a RightRoute, or none. *)
type route = location * location * int * train_color * player_color option * bool * leftRightRoute option

(* [route_score] represents the score of a route length as specified
 * by the official Ticket to Ride rules. *)
val route_score : route -> int

(* [is_taken] returns whether or not the road has already been claimed
 * by a player. *)
val is_taken : route -> bool

(* [get_length] returns the route length. *)
val get_length : route -> int

(* [get_color] returns the color of the route on the board. *)
val get_color : route -> train_color

(* [get_player] returns the player if the route has been taken, None otherwise. *)
val get_player : route -> player_color option

(* [routes] is the total list of the routes on the map. *)
val routes : route list

(* [name l] is a string representing the location [l]. *)
val name : location -> string

(* [locations] is a list of all of the locations on the board. *)
val locations: location list

(* [completed] returns whether or not there is a path between [loc1] and [loc2].
 * Requires: a list of routes that accounts for all routes a player has completed. *)
val completed : string -> string -> route list -> route list -> bool

(* [get_location s lst] is a location in [lst] with name [s]. *)
val get_location : string -> location list -> location

(* [get_next_loc] returns the next location name that should be traveled to from a starting location
 * to an ending location based on the shortest distance. *)
val get_next_loc : location -> string -> string option -> float -> string list -> string list -> string option

(* [get_paths] returns a list of locations names that lead from the shortest distance from
 * [s1] to [s2]. *)
val get_paths : string -> string -> string list -> string list

(* [path_routes] returns a list of routes leading from a path list.
 * Requires: a valid string list as determined from [get_paths]. *)
val path_routes : route list -> string list -> route list

(* [get_string] returns the location as a string.*)
val get_string : location -> string

(* [get_neighbors] returns all of the adjacent location names to a given location. *)
val get_neighbors : location -> string list
