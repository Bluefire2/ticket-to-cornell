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

let get_val = function
    | None -> raise (Failure "Not_available")
    | Some x -> x

let rec priorize_build (count : int)  (acc : route option) = function
  | [] -> acc
  | h::t -> ( match h with
    | (_,_,l,_,_) -> if (l > count) then priorize_build l (Some h) t else priorize_build count acc t)

let rec extract_hand_colors c = function
  | [] -> 0
  | (c',num)::t -> if c = c' then num else extract_hand_colors c t

let rec desired_colors goal_routes p acc =
  match goal_routes with
  | [] -> acc
  | (_,_,l,c,o)::t -> if (o = None && (l - (extract_hand_colors c p.train_cards) > 0)) then desired_colors t p (c::acc)
  else desired_colors t p acc

 let rec check_like_cards hand n =
    match hand with
    | [] -> None
    | (c,num)::t -> if num >= n then Some c else check_like_cards hand n

 let rec enough_cards hand n =
    match hand with
    | [] -> false
    | (c,num)::t -> if num >= n then true else enough_cards hand n



let dest_ticket_action clist st =
  (* draw destination tickets -> contained in clist *)
  (* check current routes completed, see if any d tickets are included/easy to do*)
  (* check how many trains are remaining if feasible *)
  (* take ones that aren't difficult. *)
  failwith "Unimplemented"


let place_action p st build_options =
  (* place at a long route, 5-6 prioritized.*)
  let build = get_val (priorize_build 0 None build_options) in
  let color = get_color build in
  (* if color = Grey then *)
  select_route st build (Some color)

let draw_action st p goals =
  let colors = desired_colors goals p [] in
  let Some (_,_,_,c,_) = priorize_build 0 None goals in
  (* if Board.contains c st.facing_up trains then (*draw_card_facing_up*) st else *)
  let d1 = draw_card_pile st in
  draw_card_pile st


  (* check what colors are needed, if showing, take showing, otherwise take random.
   * take wild if 1 away from 5 or 6 route needed. *)


let rec completed_dtickets st dtickets =
  match dtickets with
  | [] -> true
  | {loc1 = x; loc2 = y; points = z}::t -> completed x y st.routes [] && completed_dtickets st t

let rec incomplete_dticket st dtickets acc =
  match dtickets with
  | [] -> acc
  | {loc1 = x; loc2 = y; points = z}::t -> if not (completed x y st.routes [])
                                           then incomplete_dticket st t (({loc1 = x; loc2 = y; points = z})::acc)
                                           else incomplete_dticket st t acc


let rec best_paths =  function
  | [] -> []
  | {loc1 = x; loc2 = y; points = z}::t -> (get_paths x y [])::(best_paths t)

let rec best_routes st = function
  | [] -> []
  | h::t -> (path_routes st.routes h)::(best_routes st t)

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

let rec can_build goal_routes st p =
  match goal_routes with
  | [] -> []
  | h::t -> ( match h with
      | (_,_,l,c,o) -> if o = None && (extract_hand_colors c p.train_cards = l || (c = Grey && enough_cards p.train_cards l)) then (h::(can_build t st p))
                       else can_build t st p )

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

let rec check_routes_list p st rtss acc =
  match rtss with
  | [] -> acc
  | rts::t -> (check_routes_list p st t (check_routes p st rts []::acc))


let ai_move st =
  let cpu = current_player st in
  if completed_dtickets st cpu.destination_tickets && cpu.trains_remaining > 5 then
  let ddraw = DestinationDeck.draw_card st.destination_deck st.destination_trash in
  dest_ticket_action (fst ddraw) {st with
                                  destination_deck = (snd ddraw);
                                  choose_destinations = (fst ddraw)}
  else
  let goal_routes = best_routes st (best_paths cpu.destination_tickets) in
  let routes = check_routes_list cpu st (goal_routes) [] in
  let goal_routes = List.flatten routes in
  let build_options = can_build goal_routes st cpu in
  if List.length (build_options) > 0 then place_action cpu st build_options
  else
  draw_action st cpu goal_routes


  (* check routes needed for completion *)

