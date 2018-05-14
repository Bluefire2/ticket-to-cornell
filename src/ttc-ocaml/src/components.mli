(* [train_color] represents the color of a train card used to build a road. *)
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

(* [player_color] represents the color corresponding to a player. *)
type player_color =
| PBlue
| PRed
| PYellow
| PGreen
| PBlack

(* [destination_ticket] represents two location that the player should try to
 * get a route through. If they take a route through the two locations, they
 * earn the points at the end of the game. If not, they lose the points. *)
type destination_ticket = {
  loc1 : string;
  loc2 : string;
  points : int
}

(* A [TrainDeck] represents the collection of train cards that are either on display
 * for the players, hidden in the stack with the option to choose from them, or
 * in the discard pile. If they want to discard a card, it goes to a discard
 * pile. *)
module type TrainDeck = sig

  (* [card] represents one TrainDeck card *)
  type card = train_color

  (* [t] represents a TrainDeck, so a collection of cards *)
  type t = card list

  (* [tr] represents the trash *)
  type tr = card list

  (* [shuffle t tr] takes the items in [tr] and rearranges the order, putting
   * them into [t] and returning an empty list as [tr]. *)
  val shuffle : t -> tr -> t * tr

  (* [init_deck] returns an initialized deck. *)
  val init_deck : unit -> t

  (* [init_trash] returns an initialized trash. *)
  val init_trash : tr

  (* [draw_card t tr] takes a card from the deck, and returns a tuple
   * with the new card drawn and the deck without that card. If the deck is empty,
   * the trash is shuffled into the deck. *)
  val draw_card : t -> tr -> (card * t * tr)

  val five_faceup : t -> tr -> (card list * card list * card list)
  val add_faceup : card list -> card list -> card list -> (card list * card list * card list)
  val init_faceup : unit -> card list

  (* [draw_faceup t i f tr] returns the card that the index [i] represents in
   * [f], with the updated [t], [f], and [tr]. *)
  val draw_faceup : card list -> int -> card list -> card list -> card * (card list * card list * card list)
end

module TrainDeck : TrainDeck

(* A [DestinationDeck] represents the collection of destination cards that are
 * available for the players to collect. If they want to discard a card, it goes
 * to the bottom of the deck. *)
module type DestinationDeck = sig

  (* [card] represents one DestinationDeck card *)
  type card = destination_ticket

  (* [t] represents a DestinationDeck, so a collection of cards *)
  type t = card list

  (* [tr] represents the trash *)
  type tr = card list

  (* [shuffle t tr] takes the items in [tr] and rearranges the order, putting
   * them into [t] and returning an empty list as [tr]. *)
  val shuffle : t -> tr -> t * tr

  (* [discard t] is a new t with the card discarded, in a discard pile. *)
  val discard : card list -> tr -> tr

  (* [init_deck] returns an initialized deck. *)
  val init_deck : unit -> t

  (* [init_trash] returns an initialized trash. *)
  val init_trash : tr

  (* [draw_card t tr] takes a card from the deck, and returns a tuple
   * with the new card drawn and the deck without that card. *)
  val draw_card : t -> tr -> (card list * t)
end

module DestinationDeck : DestinationDeck
