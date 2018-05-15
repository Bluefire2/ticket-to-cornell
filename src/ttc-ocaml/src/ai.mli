open Components

(* [action] represents the next possible action the AI can do. *)
type action = Take_DTicket | Place_Train | Take_Faceup | Take_Deck

(* [next_move lst td p] is the next action the AI wants to do depending on the
 * current player [p], the facing up cards [td], and the routes [lst]. *)
val next_move : Board.route list -> TrainDeck.t -> Player.player -> action

(* [ai_facing_up p td] is the facing up card index the AI wants to choose from
 * the facing up cards [td]. *)
val ai_facing_up : Player.player -> TrainDeck.t -> int

(* [ai_take_dticket p lst td] is the list of indeces the AI wants to choose from
 * the list of destination tickets [lst]. *)
val ai_take_dticket : Player.player -> Board.route list -> DestinationDeck.card list -> int list

(* [ai_place_train p lst] is a tuple with which route the AI wants to choose,
 * with which tarin card color they want to fill in the route, and how many
 * wildcards they want to use to place the train. *)
val ai_place_train : Player.player -> Board.route list -> Board.route * Components.train_color * int

(* [ai_setup p lst] is the list of indeces of the cards the AI wants to keep from
 * [lst]. *)
val ai_setup : Player.player -> DestinationDeck.card list -> int list
