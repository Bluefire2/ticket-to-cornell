open Components

(* [location] represents a location on the board. It consists of the name
 * of the location, its coordinates for the GUI, and a list of locations that
 * are adjacent. *)
type location = Location of string * float * float * string list

(* [route] represents a route between two locations on the map. It can be
 * any length between 1 and 6 and has any train_color, or none. *)
type route = location * location * int * train_color * player_color option

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

(* [routes] is the total list of the routes on the map. *)
val routes : route list

(* [locations] is a list of all of the locations on the board. *)
val locations: location list

val completed : string -> string -> route list -> route list -> bool
