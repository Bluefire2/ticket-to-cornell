(* [player] is a record representing a player in the game. *)
type player = { color : Components.player_color;
                destination_tickets : Components.DestinationDeck.card list;
                train_cards : (Components.TrainDeck.card * int) list;
                score : int;
                routes : Board.route list;
                trains_remaining : int ;
                first_turn : bool;
                last_turn : bool;
                bot : bool;
              }

(* [destination_tickets p] is a list of the destination tickets [p] has *)
val destination_tickets : player -> Components.DestinationDeck.card list

(* [update_destination_tickets p lst] returns a new player which is [p] but with
 * [lst] included in their destination tickets. *)
val update_destination_tickets : player -> Components.DestinationDeck.card list -> player

(* [increase_score p n] increases [p]'s score by [n]. *)
val increase_score : player -> int -> player

(* [completed_destination_tickets p] increases [p]'s score for each
 * destination ticket that they have completed. *)
val completed_destination_tickets : player -> player

(* [train_card p] is a list of the train cards [p] has.  *)
val train_cards : player -> (Components.TrainDeck.card * int) list

(* [score p] is [p]'s current score.  *)
val score : player -> int

(* [color p] is [p]'s color.  *)
val color : player -> Components.player_color

(* [is_bot p] is true if [p] is a bot, false otherwise.  *)
val is_bot : player -> bool

(* [routes p] is [p]'s completed routes.  *)
val routes : player -> Board.route list

(* [first_turn p] is true if it is [p]'s first turn, false otherwise.  *)
val first_turn : player -> bool

(* [last_turn p] is true if it is [p]'s last turn, false otherwise.  *)
val last_turn : player -> bool

(* [trains_remaining t] is the number of trains the player has left  *)
val trains_remaining : player -> int

(* [init_players i] returns a list of length [i] of the initialized players, all
 * with no destination tickets and no cards. Each one has a different color.  *)
val init_players : int -> bool -> player list

(* [draw_train_card p c] returns a new player which is [p] but with
 * [c] included in their train cards.  *)
val draw_train_card : player -> Components.TrainDeck.card  -> player

(* [place_train p r] adds the route [r] to the player's routes, decreases the
 * necessary amount of train cards and trains to complete this route, and
 * increases the score of the player by the points of the route.
 * Requires: [p] has the minimum number of train cards and trains to complete
 * this route and that the route has been taken by [p]'s color (and not another
 * player). *)
val place_train : player -> Components.train_color -> Board.route -> int -> player

(* [set_last_turn p] is [p] but with the field last_turn as true. *)
val set_last_turn : player -> player

(* [longest_route p] is the length of the longest consecutive route [p] has done. *)
val longest_route : player -> int
