open Components
open Player
open Board
open State

(*let ai_setup st
 * will call [state_setup], and be able to choose 2-3 destination tickets, and then call
 * decided routes*)

let dest_ticket_action clist st =
  (* draw destination tickets -> contained in clist *)
  (* check current routes completed, see if any d tickets are included/easy to do*)
  (* check how many trains are remaining if feasible *)
  (* take ones that aren't difficult. *)
  failwith "Unimplemented"


let place_action hand st =
  (* place at a long route, 5-6 prioritized.*)
  failwith "Unimplemented"

let draw_action st =
  (* check what colors are needed, if showing, take showing, otherwise take random.
   * take wild if 1 away from 5 or 6 route needed. *)
   failwith "Unimplemented"

let ai_move st =
  (*let cpu = current_player st in
  if completed cpu.destination_tickets && cpu.trains_remaining > 5 then
  let ddraw = DestinationDeck.draw_card st.destination_deck st.destination_trash in
  dest_ticket_action (fst ddraw) {st with (*updates*)}
  else
  (* check routes needed for completion *)*)
  failwith "Unimplemented"
