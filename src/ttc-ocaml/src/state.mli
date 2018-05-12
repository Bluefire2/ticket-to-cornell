open Components
open Board
open Player

(* [state] represents the state of a game. *)
type state

(* [init_state i] initializes the game with [i] players.
 * After this state, call setup_state for each player. *)
val init_state : int -> state

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

(* [message st] returns a message for the GUI to display for the current [st]. *)
val message : state -> string

(* [turn_ended st] returns true if the turn has ended for the current [st],
 * false otherwise. *)
val turn_ended : state -> bool

(* [last_round st] returns true if it is the last round the current [st], false
 * otherwise. *)
val last_round : state -> bool

(* [choose_destinations st] returns a list of destination tickets from which the
 * player can choose to keep some. *)
val choose_destinations : state -> DestinationDeck.card list

(* [score] returns the total score of a particular player. *)
val score : state -> player -> int

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

(* [select_route st r] returns a new state for which the player decides to
 * build a train route [r]. *)
val select_route : state -> Board.route -> state

(* [longest_route st] returns the player who has the longest consecutive route. *)
val longest_route : state -> player
