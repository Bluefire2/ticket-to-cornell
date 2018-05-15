open Components
open Board
open Player

(* [state] represents the state of a game. *)
type state = { player_index : int;
               players : player list;
               routes : Board.route list;
               destination_deck : DestinationDeck.t;
               destination_trash : DestinationDeck.tr;
               choose_destinations : DestinationDeck.card list;
               train_deck : TrainDeck.t;
               facing_up_trains : TrainDeck.t;
               train_trash : TrainDeck.tr;
               taking_routes : bool;
               error : string;
               turn_ended : bool;
               last_round : bool;
               winner : player option;
               cards_grabbed : int;
               success : string }

(* [init_state n m] initializes the game with [n] players and [m] bots.
 * After this state, call setup_state for each player. *)
val init_state : int -> int -> state

(* [current_player st] returns the current player whose turn it is in [st]. *)
val current_player : state -> player

(* [players st] returns the list of players in [st]. *)
val players : state -> player list

(* [routes st] returns the list of routes in [st]. *)
val routes : state -> Board.route list

(* [destination_items st] returns a tuple with the destination deck and the
 * destination tickets trash in [st]. *)
val destination_items : state -> (DestinationDeck.t * DestinationDeck.tr)

(* [train_items st] returns a tuple with the train deck, the train cards facing
 * up, and the train cards trash in [st]. *)
val train_items : state -> (TrainDeck.t * TrainDeck.t * TrainDeck.tr)

(* [error st] returns an error message for the GUI to display for the current [st]. *)
val error : state -> string

(* [success st] returns a success message for the GUI to display for the current [st]. *)
val success : state -> string

(* [turn_ended st] returns true if the turn has ended for the current [st],
 * false otherwise. *)
val turn_ended : state -> bool

(* [last_round st] returns true if it is the last round the current [st], false
 * otherwise. *)
val last_round : state -> bool

(* [choose_destinations st] returns a list of destination tickets from which the
 * player can choose to keep some. *)
val choose_destinations : state -> DestinationDeck.card list

(* [score st p] returns the total score of a particular [p] in [st]. *)
val score : state -> player -> int

(* [winner st] returns the winner in [st]. *)
val winner : state -> player option

(* [longest_route_player st] returns the index representing the player who has
 * the longest consecutive route. *)
val longest_route_player : state -> int

(* [setup_state st] returns a new state with the initial setup for the current
 * player in [st]: 4 new train cards and 3 destination tickets to choose from.
 * After this state: call `decided_routes` with the chosen tickets. *)
val setup_state : state -> state

(* [next_player st] returns a new state when we transition to the next player.
 * Call this function every time turn_ended is true for the current player. *)
val next_player : state -> state

(* [draw_card_pile st] returns a new state for which the player decides to take
 * 2 new train cards from the card pile. *)
val draw_card_pile : state -> state

(* [draw_card_facing_up st i] returns a new state for which the player decides
 * to take a new train card from the cards facing up, [i] being the index which
 * from the list of cards facing ups the player wants to grab. *)
val draw_card_facing_up : state -> int -> state

(* [take_route st] returns a new state for which the player decides to take
 * additional destination cards.
* After this state: call `decided_routes` with the chosen tickets. *)
val take_route : state -> state

(* [decided_routes st lst] returns a new state depending on the indexes from
 * choose_destinations that the player decided to keep.  *)
val decided_routes : state -> int list -> state

(* [select_route st r clr i] returns a new state for which the player decides to
 * build a train route [r], with [clr] if the route is a grey route. It also
 * takes in [i] which represents the number of wild cards that are to be used
 * for this action. *)
val select_route : state -> Board.route -> Components.train_color option -> int -> state

(* [completed_ticket s1 s2 st] is true if the locations with names [s1] and [s2]
 * have been taken in [st] by [st]'s current player. False otherwise. '*)
val completed_ticket : string -> string -> state -> bool
