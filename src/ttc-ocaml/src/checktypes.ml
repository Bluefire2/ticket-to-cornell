module type STATE = sig
type state = { player_index : int;
               players : Player.player list;
               routes : Board.route list;
               destination_deck : Components.DestinationDeck.t;
               destination_trash : Components.DestinationDeck.tr;
               choose_destinations : Components.DestinationDeck.card list;
               train_deck : Components.TrainDeck.t;
               facing_up_trains : Components.TrainDeck.t;
               train_trash : Components.TrainDeck.tr;
               taking_routes : bool;
               error : string;
               turn_ended : bool;
               last_round : bool;
               winner : Player.player option;
               cards_grabbed : int;
               success : string }
val init_state : int -> int -> State.state
val current_player : State.state -> Player.player
val players : State.state -> Player.player list
val routes : State.state -> Board.route list
val destination_items : State.state -> (Components.DestinationDeck.t * Components.DestinationDeck.tr)
val train_items : State.state -> (Components.TrainDeck.t * Components.TrainDeck.t * Components.TrainDeck.tr)
val error : State.state -> string
val success : State.state -> string
val turn_ended : State.state -> bool
val last_round : State.state -> bool
val choose_destinations : State.state -> Components.DestinationDeck.card list
val score : State.state -> Player.player -> int
val winner : state -> Player.player option
val setup_state : State.state -> State.state
val next_player : State.state -> State.state
val draw_card_pile : State.state -> State.state
val draw_card_facing_up : State.state -> int -> State.state
val take_route : State.state -> State.state
val decided_routes : State.state -> int list -> State.state
val select_route : state -> Board.route -> Components.train_color option -> int -> state
val longest_route_player : State.state -> int
end

module type COMPONENTS = sig
  type train_color =
    | Red
    | Green
    | Blue
    | Yellow
    | Pink
    | Orange
    | White
    | Black
    | Wild
    | Grey
  type player_color =
    | PBlue
    | PRed
    | PYellow
    | PGreen
    | PBlack
  type destination_ticket = {
    loc1 : string;
    loc2 : string;
    points : int
  }
  module type TrainDeck = sig
    type card = train_color
    type t = card list
    type tr = card list
    val shuffle : t -> tr -> t * tr
    val init_deck : unit -> t
    val init_trash : tr
    val draw_card : t -> tr -> (card * t * tr)
    val five_faceup : t -> tr -> (card list * card list * card list)
    val add_faceup : card list -> card list -> card list -> (card list * card list * card list)
    val init_faceup : unit -> card list
    val draw_faceup : card list -> int -> card list -> card list -> card *(card list * card list  * card list)
  end

  module TrainDeck : TrainDeck

  module type DestinationDeck = sig
    type card = destination_ticket
    type t = card list
    type tr = card list
    val shuffle : t -> tr -> t * tr
    val discard : card list -> tr -> tr
    val init_deck : unit -> t
    val init_trash : tr
    val draw_card : t -> tr -> (card list * t)
  end

  module DestinationDeck : DestinationDeck
end


module type PLAYER = sig
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
  val update_destination_tickets : player -> Components.DestinationDeck.card list -> player
  val destination_tickets : player -> Components.DestinationDeck.card list
  val train_cards : player -> (Components.TrainDeck.card * int) list
  val increase_score : player -> int -> player
  val completed_destination_tickets : player -> player
  val score : player -> int
  val first_turn : player -> bool
  val last_turn : player -> bool
  val color : player -> Components.player_color
  val routes : player -> Board.route list
  val trains_remaining : player -> int
  val init_players : int -> bool -> player list
  val draw_train_card : player -> Components.TrainDeck.card  -> player
  val place_train : player -> Components.train_color -> Board.route -> int -> player
  val set_last_turn : player -> player
  val longest_route : player -> int
end

module type BOARD = sig
  type location = Location of string * float * float * string list
  type leftRightRoute = LeftRoute | RightRoute
  type route = location * location * int * Components.train_color * Components.player_color option * bool * leftRightRoute option
  val route_score : route -> int
  val is_taken : route -> bool
  val get_length : route -> int
  val get_color : route -> Components.train_color
  val name : location -> string
  val completed : string -> string -> route list -> route list -> bool
  val get_location : string -> location list -> location
  val get_next_loc : location -> string -> string option -> float -> string list -> string list -> string option
  val get_paths : string -> string -> string list -> string list
  val path_routes : route list -> string list -> route list
  val get_string : location -> string
  val get_neighbors : location -> string list
end

module type AI = sig
  val ai_move : State.state -> State.state
end

module type TEST = sig
  val components_tests : OUnit2.test list
  val board_tests : OUnit2.test list
  val player_tests : OUnit2.test list
  val state_tests : OUnit2.test list
end

module CheckState : STATE = State
module CheckComponent : COMPONENTS = Components
module CheckPlayer : PLAYER = Player
module CheckBoard : BOARD = Board
module CheckAI : AI = Ai
module CheckTest : TEST = Test
