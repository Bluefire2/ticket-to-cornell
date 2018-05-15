open Components

type action = Take_DTicket | Place_Train | Take_Faceup | Take_Deck

val next_move : Board.route list -> TrainDeck.t -> Player.player -> action

(* Given the facing up cards list, choose which one the AI wants. *)
val ai_facing_up : Player.player -> TrainDeck.t -> int

(* Given the player, the route list, and the choose destinations, choose which one/s the AI wants. *)
val ai_take_dticket : Player.player -> Board.route list -> DestinationDeck.card list -> int list

(* Gives me the route you want to place, the train color that you want to use to
 * place these trains and the number of wild cards that you want to use for this. *)
val ai_place_train : Player.player -> Board.route list -> Board.route * Components.train_color * int

(* [ai_setup p lst] is the list of indeces of the cards the AI wants to keep from
 * [lst]. *)
val ai_setup : Player.player -> DestinationDeck.card list -> int list
