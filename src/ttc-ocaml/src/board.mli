open Components

(* [route] represents a route between two locations on the map. It can be
 * any length between 1 and 6 and has any train_color, or none. *)
type route = location * location * int * train_color * player_color option

(* [route_score] represents the score of a route length as specified
 * by the official Ticket to Ride rules. *)
val route_score : route -> int

(* [is_taken] returns whether or not the road has already been claimed
 * by a player. *)
val is_taken : route -> bool

val get_length : route -> int

val get_color : route -> train_color
