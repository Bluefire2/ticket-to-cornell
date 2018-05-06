module type STATE = sig
  type state
  val init_state : int -> State.state
  val current_player : State.state -> Player.player
  val players : State. state -> Player.player list
  val routes : State.state -> Board.route list
  val destination_items : State.state -> (Components.DestinationDeck.t *
                                          Components.DestinationDeck.tr)
  val train_items : State.state -> (Components.TrainDeck.t * Components.TrainDeck.t
                                    * Components.TrainDeck.tr)

  val message : State.state -> string
  val score : State.state -> Player.player -> int
  val next_player : State.state -> State.state
  val draw_card_pile : State.state -> State.state
  val draw_card_facing_up : State.state -> Components.TrainDeck.card -> State.state
  val take_route : State.state -> State.state
  val decided_routes : State.state -> Components.DestinationDeck.card list -> State.state
  val select_route : State.state -> Board.route -> State.state
  val longest_route : State.state -> Player.player
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
  type location =
    | Empty
    | Node of string * float * float * location list
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
    (*val discard : card -> tr -> tr*)
    val init_deck : unit -> t
    val init_trash : tr
    val draw_card : t -> tr -> (card * t * tr)
    val five_faceup : t -> tr -> (card list * card list * card list)
    val add_faceup : card list -> card list -> card list -> (card list * card list * card list)
    val init_faceup : unit -> card list
    val draw_faceup : card list -> card -> card list -> card list -> (card list * card list  * card list)
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
  type player
  val update_destination_tickets : player -> Components.DestinationDeck.card list -> player
  val destination_tickets : player -> Components.DestinationDeck.card list
  val train_cards : player -> (Components.TrainDeck.card * int) list
  val score : player -> int
  val trains_remaining : player -> int
  val init_players : int -> player list
  val draw_train_card : player -> Components.TrainDeck.card  -> player
  val place_train : player -> Board.route -> player

end

module type BOARD = sig
  type route = string * string * int * Components.train_color * Components.player_color option
  val route_score : route -> int
  val is_taken : route -> bool
  val get_length : route -> int
  val get_color : route -> Components.train_color
end

module type AI = sig
  val ai_move : State.state -> State.state
end

module type TEST = sig
  val train_deck : Components.train_color list
  val dest_ticket_deck : Components.destination_ticket list
  val tests : OUnit2.test list
end

module CheckState : STATE = State
module CheckComponent : COMPONENTS = Components
module CheckPlayer : PLAYER = Player
module CheckBoard : BOARD = Board
module CheckAI : AI = Ai
module CheckTest : TEST = Test
