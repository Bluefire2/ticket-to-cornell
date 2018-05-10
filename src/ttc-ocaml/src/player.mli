(* A [Player] represents a player with their destination tickets, train cards,
 * score, and the trains that they have remaining. *)

(* [player] is an abstract type representing a player *)
type player = { color : Components.player_color;
                destination_tickets : Components.DestinationDeck.card list;
                train_cards : (Components.TrainDeck.card * int) list;
                score : int;
                routes : Board.route list;
                trains_remaining : int ;
              }

(* [destination_tickets p] is a list of the destination tickets [p] has *)
val destination_tickets : player -> Components.DestinationDeck.card list

(* [update_destination_tickets p lst] returns a new player which is [p] but with
 * [lst] included in their destination tickets. *)
val update_destination_tickets : player -> Components.DestinationDeck.card list -> player

(* [train_card t] is a list of the train cards the player has  *)
val train_cards : player -> (Components.TrainDeck.card * int) list

(* [score t] is the player's current score  *)
val score : player -> int

val color : player -> Components.player_color

val routes : player -> Board.route list

(* [trains_remaining t] is the number of trains the player has left  *)
val trains_remaining : player -> int

(* [init_players i] returns a list of length [i] of the initialized players, all
 * with no destination tickets and no cards. Each one has a different color.  *)
val init_players : int -> player list

(* [draw_train_card p c] returns a new player which is [p] but with
 * [c] included in their train cards.  *)
val draw_train_card : player -> Components.TrainDeck.card  -> player

val place_train : player -> Board.route -> player
