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

let rec contains x = function
  | [] -> false
  | h::t -> if h=x then true else contains x t

let rec priorize_build (count : int)  (acc : route option) = function
  | [] -> acc
  | h::t -> ( match h with
    | (_,_,l,_,_,_,_) -> if (l > count) then priorize_build l (Some h) t else priorize_build count acc t)

let rec extract_hand_colors c acc = function
  | [] -> acc
  | (c',num)::t -> if (c = c' || c' = Wild) then extract_hand_colors c (acc+num) t else extract_hand_colors c acc t

let rec desired_colors goal_routes p acc =
  match goal_routes with
  | [] -> acc
  | (_,_,l,c,o,_,_)::t -> if o = None && (l - (extract_hand_colors c 0 p.train_cards) > 0) then desired_colors t p (c::acc)
  else desired_colors t p acc

let extract_goal rts =
  let last_el = List.nth rts ((List.length rts) -1) in
  match last_el with
  | (_,goal,_,_,_,_,_) -> get_string goal

let rec extract_strings rts =
  match rts with
  | [] -> []
  | (Location (n1, _,_,_),Location (n2,_,_,_),_,_,_,_,_)::t -> n2::n1::(extract_strings t)

let rec enough_cards hand n =
    match hand with
    | [] -> false
    | (c,num)::t -> if num >= n then true else enough_cards t n

let rec best_paths =  function
  | [] -> []
  | {loc1 = x; loc2 = y; points = z}::t -> (get_paths x y [])::(best_paths t)

let rec best_routes st = function
  | [] -> []
  | h::t -> (path_routes st.routes h)::(best_routes st t)

let other_player p = function
  | (_,_,_,_,None,_,_) -> false
  | (_,_,_,_,x,_,_) -> Some p.color <> x

let rec check_routes p st (rts : route list) acc =
  match rts with
  | [] -> acc
  | rt::t -> if other_player p rt then
             let goal = extract_goal rts in
             ( match rt with
              | (l1,l2,_,_,_,_,_) -> try (let new_l = get_val (get_next_loc l1 goal None (-1.) ((get_string l2)::(extract_strings acc)) (get_neighbors l1)) in
              let new_path = (get_paths (new_l) (goal) (extract_strings acc)) in
              let reroute = path_routes st.routes new_path in
               check_routes p st reroute []) with
              | Failure _ -> [] )
              else check_routes p st t (rt::acc)

let rec check_routes_list p st rtss acc =
  match rtss with
  | [] -> acc
  | rts::t -> (check_routes_list p st t ((check_routes p st rts [])::acc))

let rec count_route p (rts : route list) = match rts with
  | [] -> 0
  | (_,_,l,_,o,_,_)::t -> if o = Some p.color then count_route p t else l + count_route p t

let rec dest_ticket_helper clist st acc p n = match clist with
    | [] -> acc
    | h::t -> ( match h with
            | {loc1 = x; loc2 = y; points = z} -> if completed x y (st.routes) [] then dest_ticket_helper t st (acc@[n]) p (n+1)
                                                  else let path = get_paths x y [] in
                                                  let pathroute = path_routes (st.routes) (path) in
                                                  let confirmed = check_routes p st pathroute [] in
                                                  if (count_route p confirmed > p.trains_remaining)  then dest_ticket_helper clist st acc p (n+1)
                                                  else if count_route p confirmed >= 9 then dest_ticket_helper clist st (acc@[n]) p (n+1) else dest_ticket_helper clist st acc p (n+1) )

let rec get_smallest_path clist st p count acc n = match clist with
  | [] -> acc
  | h::t -> ( match h with
            | {loc1 = x; loc2 = y; points = z} -> let path = get_paths x y [] in
                                                  let pathroute = path_routes (st.routes) (path) in
                                                  let confirmed = check_routes p st pathroute [] in
                                                  let num = count_route p confirmed in
                                                  if num < count then get_smallest_path t st p num n (n+1) else
                                                  get_smallest_path t st p count acc (n+1) )

let smallest_points = function
  | {loc1 = a; loc2 = b; points = x}::{loc1 = c; loc2 = d; points = y}::{loc1 = e; loc2 = f; points = z}::[] ->
        if min x y z = x then [0] else
        if min x y z = y then [1] else [2]


let dest_ticket_action clist st p =
  (* draw destination tickets -> contained in clist *)
  (* check current routes completed, see if any d tickets are included/easy to do*)
  (* check how many trains are remaining if feasible *)
  (* take ones that aren't difficult. *)
  let keep = dest_ticket_helper clist st [] p 0 in
  if (List.length keep) = 0 then
    let min_path = get_smallest_path clist st p 0 (-1) 0 in
    if min_path > p.trains_remaining then
      decided_routes st (smallest_points clist)
    else decided_routes st ([min_path])
  else decided_routes st keep
  (* take w/ smallest point value*)

let rec get_index n c = function
  | [] -> failwith "out of bounds"
  | h::t -> if h=c then n else get_index (n+1) c t


let place_action p st build_options =
  (* place at a long route, 5-6 prioritized.*)
  let build = get_val (priorize_build 0 None build_options) in
  let color = get_color build in
  (* if color = Grey then *)
  select_route st build (Some color) 0

let rec draw_action st p goals =
  (* let colors = desired_colors goals p [] in *)
  let Some (_,_,_,c,_,_,_) = priorize_build 0 None goals in
  if contains c st.facing_up_trains then
    let d1 = draw_card_facing_up st (get_index 0 c st.facing_up_trains) in
    (* let colors' = desired_colors goals p [] in *)
    let Some (_,_,_,c,_,_,_) = priorize_build 0 None goals in
    if contains c st.facing_up_trains then draw_card_facing_up d1 (get_index 0 c d1.facing_up_trains)
    else draw_card_pile d1
  else
  let d1 = draw_card_pile st in
  (* let colors' = desired_colors goals p [] in *)
    let Some (_,_,_,c,_,_,_) = priorize_build 0 None goals in
    if contains c st.facing_up_trains then draw_card_facing_up d1 (get_index 0 c d1.facing_up_trains)
    else draw_card_pile d1



  (* check what colors are needed, if showing, take showing, otherwise take random.
   * take wild if 1 away from 5 or 6 route needed. *)


let rec completed_dtickets (p : player) dtickets =
  match dtickets with
  | [] -> true
  | {loc1 = x; loc2 = y; points = z}::t -> completed x y p.routes [] && completed_dtickets p t

let rec incomplete_dticket st dtickets acc =
  match dtickets with
  | [] -> acc
  | {loc1 = x; loc2 = y; points = z}::t -> if not (completed x y st.routes [])
                                           then incomplete_dticket st t (({loc1 = x; loc2 = y; points = z})::acc)
                                           else incomplete_dticket st t acc

let rec can_build goal_routes st p =
  match goal_routes with
  | [] -> []
  | h::t -> ( match h with
      | (_,_,l,c,o,_,_) -> if o = None && (extract_hand_colors c 0 p.train_cards = l || (c = Grey && enough_cards p.train_cards l)) then (h::(can_build t st p))
                       else can_build t st p )

let ai_move st =
  let cpu = current_player st in
  if completed_dtickets cpu cpu.destination_tickets && cpu.trains_remaining > 5 then
  let ddraw = DestinationDeck.draw_card st.destination_deck st.destination_trash in
  dest_ticket_action (fst ddraw) {st with
                                  destination_deck = (snd ddraw);
                                  choose_destinations = (fst ddraw)} cpu
  else
  let goal_routes = best_routes st (best_paths cpu.destination_tickets) in
  let routes = check_routes_list cpu st (goal_routes) [] in
  let goal_routes = List.flatten routes in
  let build_options = can_build goal_routes st cpu in
  if List.length (build_options) > 0 then place_action cpu st build_options
  else
  draw_action st cpu goal_routes


  (* check routes needed for completion *)
