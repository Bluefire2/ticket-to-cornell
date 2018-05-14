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
  in decided_routes st' keep_tickets


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

let rec best_paths taken  =  function
  | [] -> []
  | {loc1 = x; loc2 = y; points = z}::t -> (get_paths x y [])@(best_paths taken t)

let check_routes lst p st = match lst with
  | [] -> []

let rec best_routes st = function
  | [] -> []
  | h::t -> (path_routes st.routes h)@(best_routes st t)

let other_player p = function
  | (_,_,_,_,None) -> false
  | (_,_,_,_,x) -> Some p.color <> x

let extract_goal rts =
  let last_el = List.nth rts ((List.length rts) -1) in
  match last_el with
  | (_,goal,_,_,_) -> get_string goal

let rec extract_strings rts =
  match rts with
  | [] -> []
  | (Location (n1, _,_,_),Location (n2,_,_,_),_,_,_)::t -> n2::n1::(extract_strings t)

let get_val = function
    | None -> raise (Failure "Not_available")
    | Some x -> x


let rec check_routes p st (rts : route list) acc =
  match rts with
  | [] -> acc
  | rt::t -> if other_player p rt then
             let goal = extract_goal rts in
             ( match rt with
              | (l1,l2,_,_,_) -> try (let new_l = get_val (get_next_loc l1 goal None (-1.) ((get_string l2)::(extract_strings acc)) (get_neighbors l1)) in
              let new_path = (get_paths (new_l) (goal) (extract_strings acc)) in
              let reroute = path_routes st.routes new_path in
               check_routes p st reroute []) with
              | Failure _ -> rts )
              else check_routes p st t (rt::acc)


let ai_move st =
  (* let cpu = current_player st in
  if completed cpu.destination_tickets && cpu.trains_remaining > 5 then
  let ddraw = DestinationDeck.draw_card st.destination_deck st.destination_trash in
  dest_ticket_action (fst ddraw) {st with (*updates*)}
  else
  let goal_routes = best_routes st.routes (best_paths cpu.destination_tickets) in
  f
  (* check routes needed for completion *) *)
  failwith "nada"
