open Components
open Player
open Board
open State

let max a b c =
  max c (max a b)

let min a b c =
  min c (min a b)

(* will call [state_setup], and be able to choose 2-3 destination tickets, and then call
 * decided routes *)
 (* CURRENTLY WILL ONLY EVER TAKE TWO ROUTES, FOR BASICNESS. WILL BE IMPROVED IF TIME RIP*)
let ai_setup st =
  let st' = setup_state st in
  let keep_tickets = match choose_destinations st' with
    | {loc1 = a; loc2 = b; points = x}::{loc1 = c; loc2 = d; points = y}::{loc1 = e; loc2 = f; points = z}::[] ->
      if a = c || a = d || b = c || b = d then [0; 1] else
      if a = e || a = f || b = e || b = f then [0; 2] else
      if c = e || c = f || d = e || d = f then [1; 2] else
      if max x y z = x && min x y z = y then [0; 1] else
      if max x y z = x && min x y z = z then [0; 2] else
      [1; 2]
    | _ -> failwith "not possible"
  in decided_routes_setup st' keep_tickets


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
