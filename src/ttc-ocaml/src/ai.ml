open Components
open Player
open Board

type action = Take_DTicket | Place_Train | Take_Faceup | Take_Deck

(* [max a b c] returns the maximum of three values. *)
let max a b c =
  max c (max a b)

(* [min a b c] returns the minimum of three values. *)
let min a b c =
  min c (min a b)

let ai_setup p dlist =
  match dlist with
  | {loc1 = a; loc2 = b; points = x}::{loc1 = c; loc2 = d; points = y}::{loc1 = e; loc2 = f; points = z}::[] ->
    if a = c || a = d || b = c || b = d then [0; 1] else
    if a = e || a = f || b = e || b = f then [0; 2] else
    if c = e || c = f || d = e || d = f then [1; 2] else
    if max x y z = x && min x y z = y then [0; 1] else
    if max x y z = x && min x y z = z then [0; 2] else
    [1; 2]
  | _ -> failwith "not possible"

(* [get_val] returns the value that an option holds. Raises Not_available if None. *)
let get_val = function
    | None -> raise (Failure "Not_available")
    | Some x -> x

(* [contains x] checks to see if an element [x] is contained in a list. *)
let rec contains x = function
  | [] -> false
  | h::t -> if h=x then true else contains x t

(* [check_faceup clist faceup] determines if a color is contained in the face-up card pile.
 * If the color is grey, any train card can be built, and thus, true is returned. *)
let rec check_faceup clist faceup = match clist with
  | [] -> false
  | h::t -> if (contains h faceup || h=Grey) then true else check_faceup t faceup

(* [prioritize_build count acc] returns what the most optimal route to build is,
 * prioriziing the length of the route as the best route to build. *)
let rec prioritize_build (count : int)  (acc : route option) = function
  | [] -> acc
  | h::t -> ( match h with
    | (_,_,l,_,_,_,_) -> if (l > count) then prioritize_build l (Some h) t else prioritize_build count acc t)

(* [only_color c] returns the number train cards of a specific color there are in hand,
 * excluding wild cards in the count. *)
let rec only_color c = function
  | [] -> 0
  | (c',num)::t -> if c = c' then num  else only_color c t

(* [extract_hand_colors c acc] returns the total number of train cards of a specific color in hand, including
 * wild cards. *)
let rec extract_hand_colors c acc = function
  | [] -> acc
  | (c',num)::t -> if (c = c' || c' = Wild) then extract_hand_colors c (acc+num) t else extract_hand_colors c acc t

(* [desired_colors goal_routes p acc] returns a list of colors of the routes that the AI
 * wants to build on. Values can be repeated. *)
let rec desired_colors goal_routes p acc =
  match goal_routes with
  | [] -> acc
  | (_,_,l,c,o,_,_)::t -> if o = None && (l - (extract_hand_colors c 0 p.train_cards) > 0) then desired_colors t p (c::acc)
  else desired_colors t p acc

(* [extract_goal rts] returns the last location in a given path, a list of routes
 * leading to a destination. *)
let extract_goal rts =
  let last_el = List.nth rts ((List.length rts) -1) in
  match last_el with
  | (_,goal,_,_,_,_,_) -> get_string goal

(* [extract_strings rts] returns a list of locations as strings. *)
let rec extract_strings rts =
  match rts with
  | [] -> []
  | (Location (n1, _,_,_),Location (n2,_,_,_),_,_,_,_,_)::t -> n2::n1::(extract_strings t)

(* [enough_cards hand n] checks that the AI can build on a given route. It is used
 * to check that an AI can place its trains on a grey route. *)
let rec enough_cards hand n =
    match hand with
    | [] -> false
    | (c,num)::t -> if ((extract_hand_colors c 0 hand) >= n) then true else enough_cards t n

(* [best_paths] returns a list of route lists that represent the paths that the AI
 * can take based on its destination tickets. *)
let rec best_paths =  function
  | [] -> []
  | {loc1 = x; loc2 = y; points = z}::t -> (get_paths x y [])::(best_paths t)

(* [best_routes st_routes] returns the routes that an AI can take to complete a destination
 * ticket. *)
let rec best_routes st_routes = function
  | [] -> []
  | h::t -> (path_routes st_routes h)::(best_routes st_routes t)

(* [other_player p] returns whether or not another player has taken a route. *)
let other_player p = function
  | (_,_,_,_,None,_,_) -> false
  | (_,_,_,_,x,_,_) -> Some p.color <> x

(* [check_routes p st_routes rts acc] is used to recalibrate the routes an AI takes.
 * It checks the current route path the AI has laid out, and sees if another player
 * has taken any of those routes. If any of those routes were claimed,
 * a new route is mapped out. If no route can be formed (e.g. there are not available routes into a needed
 * city), an empty list is returned, and the AI will not complete that ticket. *)
let rec check_routes p st_routes (rts : route list) acc =
  match rts with
  | [] -> acc
  | rt::t -> if other_player p rt then
             let goal = extract_goal rts in
             ( match rt with
              | (l1,l2,_,_,_,_,_) -> try (let new_l = get_val (get_next_loc l1 goal None (-1.) ((get_string l2)::(extract_strings acc)) (get_neighbors l1)) in
              let new_path = (get_paths (new_l) (goal) (extract_strings acc)) in
              let reroute = path_routes st_routes new_path in
               check_routes p st_routes reroute []) with
              | Failure _ -> [] )
              else check_routes p st_routes t (rt::acc)

(* [check_routes_list p st_routes rtss] calls [check_routes] on a list of path routes
 * corresponding to the multiple destination tickets a player has. *)
let rec check_routes_list p st_routes rtss =
  match rtss with
  | [] -> [[]]
  | rts::t -> (check_routes p st_routes rts [])::(check_routes_list p st_routes t)

(* [count_route p rts] counts the number of routes of the route list have been
 * taken by the AI. *)
let rec count_route p (rts : route list) = match rts with
  | [] -> 0
  | (_,_,l,_,o,_,_)::t -> if o = Some p.color then count_route p t else l + count_route p t

(* [dest_ticket_helper clist st_routes acc p n] verifies what new destination tickets
 * the AI should keep. It first sees if there are any that already happen to be completed, and then
 * it sees if there are any that are simple to complete. *)
let rec dest_ticket_helper clist st_routes acc p n = match clist with
    | [] -> acc
    | h::t -> ( match h with
            | {loc1 = x; loc2 = y; points = z} -> if completed x y (st_routes) [] then dest_ticket_helper t st_routes (acc@[n]) p (n+1)
                                                  else let path = get_paths x y [] in
                                                  let pathroute = path_routes (st_routes) (path) in
                                                  let confirmed = check_routes p st_routes pathroute [] in
                                                  if (count_route p confirmed > p.trains_remaining)  then dest_ticket_helper t st_routes acc p (n+1)
                                                  else if count_route p confirmed >= 9 then dest_ticket_helper t st_routes (acc@[n]) p (n+1)
                                                  else dest_ticket_helper t st_routes acc p (n+1) )

(* [get_smallest_path clist st_routes p count acc n] returns the index of the shortest path of the
 * picked up destination tickets. *)
let rec get_smallest_path clist st_routes p count acc n = match clist with
  | [] -> acc
  | h::t -> ( match h with
            | {loc1 = x; loc2 = y; points = z} -> let path = get_paths x y [] in
                                                  let pathroute = path_routes (st_routes) (path) in
                                                  let confirmed = check_routes p st_routes pathroute [] in
                                                  let num = count_route p confirmed in
                                                  if num < count then get_smallest_path t st_routes p num n (n+1) else
                                                  get_smallest_path t st_routes p count acc (n+1) )

(* [smallest_points] returns the destination ticket with the lowest point value. Raises impossible if
 * the list is empty or shorter than three elements. *)
let smallest_points = function
  | {loc1 = a; loc2 = b; points = x}::{loc1 = c; loc2 = d; points = y}::{loc1 = e; loc2 = f; points = z}::[] ->
        if min x y z = x then [0] else
        if min x y z = y then [1] else [2]
  | _ -> failwith "impossible"


let ai_take_dticket p rts dest_choice  =
  let keep = dest_ticket_helper dest_choice rts [] p 0 in
  if (List.length keep) = 0 then
    let min_path = get_smallest_path dest_choice rts p 0 (-1) 0 in
    if min_path > p.trains_remaining then
      (smallest_points dest_choice)
    else [min_path]
  else keep

(* [get_index n c] returns the index at which [c] is located within the list.
 * raises out of bounds if it cannot be found.*)
let rec get_index n c = function
  | [] -> failwith "out of bounds"
  | h::t -> if h=c then n else get_index (n+1) c t

(* [place_on_grey len hand] returns whether or not the AI can build on a grey route.
 * Since grey routes can be filled with any color, it checks if a player's hand contains
 * [len] amount of a certain card. *)
let rec place_on_grey (len : int) hand = match hand with
  | [] -> failwith "not possible"
  | (c,num)::t -> if (extract_hand_colors c 0 hand) >= len then c else place_on_grey len t

(* [can_build goal_routes p] returns a bool representing whether or not the AI can build given the cards in
 * its hand. *)
let rec can_build goal_routes p =
  match goal_routes with
  | [] -> []
  | h::t -> ( match h with
      | (_,_,l,c,o,_,_) -> if o = None && (extract_hand_colors c 0 p.train_cards >= l) || (c = Grey && enough_cards p.train_cards l) then (h::(can_build t p))
                       else can_build t p )

let ai_place_train cpu (rts : route list)  =
  (* place at a long route, 5-6 prioritized.*)
  let goal_routes = best_routes rts (best_paths cpu.destination_tickets) in
  let routes = check_routes_list cpu rts (goal_routes) in
  let goal_routes = List.flatten routes in
  let build_options = can_build goal_routes cpu in
  let build = get_val (prioritize_build 0 None build_options) in
  let color = get_color build in
  if color = Grey then
    let choose_color = place_on_grey (Board.get_length build) (cpu.train_cards) in
    if (only_color choose_color cpu.train_cards) < (Board.get_length build) then
      (build, choose_color, (Board.get_length build - only_color (choose_color) (cpu.train_cards)))
    else (build,choose_color,0)
  else
    if only_color color cpu.train_cards < (Board.get_length build) then
    (build,color, (Board.get_length build - only_color (color) (cpu.train_cards)))
  else (build,color, 0)

(* [get_faceup colors faceup n] returns the index representing the face_up color the AI
 * wants to take. If the color is Grey, the AI takes any of the 5 showing cards. *)
let rec get_faceup colors faceup n =
  if contains Grey colors then Random.int 5 else
  match faceup with
  | [] -> n
  | h::t -> if (contains h colors) then n else get_faceup t faceup (n+1)

let ai_facing_up p rts faceup =
  let goal_routes = best_routes rts (best_paths p.destination_tickets) in
  let routes = check_routes_list p rts (goal_routes) in
  let goal_routes = List.flatten routes in
  let colors = desired_colors goal_routes p [] in
  let Some (_,_,_,c,_,_,_) = prioritize_build 0 None goal_routes in
  if contains c faceup then (get_index 0 c faceup)
  else get_faceup colors faceup 0


(* [completed_dtickets p dtickets] returns whether or not a destination ticket is finished.*)
let rec completed_dtickets (p : player) dtickets =
  match dtickets with
  | [] -> true
  | {loc1 = x; loc2 = y; points = z}::t -> completed x y p.routes [] && completed_dtickets p t

let next_move rts sec_draw faceup cpu =
  if sec_draw then
    let goal_routes = best_routes rts (best_paths cpu.destination_tickets) in
    let routes = check_routes_list cpu rts (goal_routes) in
    let goal_routes = List.flatten routes in
    let colors = desired_colors goal_routes cpu [] in
    if check_faceup colors faceup then Take_Faceup else Take_Deck
  else
  if completed_dtickets cpu cpu.destination_tickets && cpu.trains_remaining > 5 then Take_DTicket else
  let goal_routes = best_routes rts (best_paths cpu.destination_tickets) in
  let routes = check_routes_list cpu rts (goal_routes) in
  let goal_routes = List.flatten routes in
  let build_options = can_build goal_routes cpu in
  if List.length (build_options) > 0 then Place_Train else
  let colors = desired_colors goal_routes cpu [] in
  if check_faceup colors faceup then Take_Faceup else Take_Deck
