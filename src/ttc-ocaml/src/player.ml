open Components

let color_of_int n =
  match n with
  | 0 -> PBlue
  | 1 -> PRed
  | 2 -> PYellow
  | 3 -> PGreen
  | 4 -> PBlack
  | _ -> failwith "impossible"

type player = { color : player_color;
                destination_tickets : Components.DestinationDeck.card list;
                train_cards : (Components.TrainDeck.card * int) list;
                score : int;
                routes : Board.route list;
                trains_remaining : int ;
                first_turn : bool ;
                last_turn : bool ;
                bot : bool }

let destination_tickets p = p.destination_tickets

let routes p = p.routes

let update_destination_tickets p tickets =
  { p with destination_tickets = tickets @ p.destination_tickets;
           first_turn = false }

let increase_score p n =
  { p with score = p.score + n }

let completed_destination_tickets p =
  let rec loop p = function
    | [] -> p
    | {loc1 = n1; loc2 = n2; points = pts}::t ->
      if (Board.completed n1 n2 (routes p) [])
      then loop (increase_score p pts) t
      else loop p t in
  loop p (destination_tickets p)

let train_cards p = p.train_cards

let score p = p.score

let first_turn p = p.first_turn

let last_turn p = p.last_turn

let color p = p.color

let trains_remaining p = p.trains_remaining

(* TODO: let players choose their colors. For now:
  P1 -> blue
  P2 -> red
  P3 -> yellow
  P4 -> green
  P5 -> black
*)
(* [add_train_cards lst c acc] adds one card to [lst] that matches the color [c]. *)
let rec add_train_cards lst c acc =
  match lst with
  | [] -> acc
  | (a,b)::t ->
    if c = a then acc @ ((a,b+1)::t)
    else add_train_cards t c (acc @ [(a,b)])

let rec init_players n =
  match n with
  | 0 -> []
  | _ -> let p = { color = color_of_int (n-1);
                  destination_tickets = [];
                  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
                  score = 0;
                  routes = [];
                  trains_remaining = 45;
                  first_turn = true;
                  last_turn = false;
                  bot = false } in
            p::(init_players (n-1))

let draw_train_card p c =
  { p with train_cards = add_train_cards p.train_cards c []}

(* [remove_color n c lst] removes [n] number of cards of color [c] from [lst]. *)
let rec remove_color n c lst =
  if n = 0 then lst else
  let rec loop acc = function
    | [] -> acc
    | (a1, a2)::t ->
      if a1 = c then acc @ [(a1, a2-n)] @ t
      else loop (acc @ [(a1, a2)]) t in
  loop [] lst

let place_train p r =
  { p with train_cards = remove_color (Board.get_length r) (Board.get_color r) p.train_cards;
           score = p.score + (Board.route_score r);
           routes = r::p.routes;
           trains_remaining = p.trains_remaining - Board.get_length r }

let rec path = function
  | [] -> []
  | (x,y,_,_,_)::t -> ( match (x,y) with
      | ( (x',_,_), (y',_,_) ) -> (x',y')::path t )

let set_last_turn p =
  { p with last_turn = true }

let rec between_before l acc = function
  | [] -> acc
  | h::t -> if h=l then acc @ [l] else between_before l (acc @ [l]) t

let calculate_paths l1 l2 locations paths =
  if (List.mem l1 locations) then
    let rec loop acc = function
      | [] -> acc
      | (hd, between, last)::t ->
        if (l1 = last) then loop (acc @ [(hd, (between @ [l1]), l2)]) t
        else if (List.mem l1 between)
        then loop (acc @ [(hd, between, last)] @ [(hd, (between_before l1 [] between), l2)]) t
        else loop (acc @ [(hd, between, last)] @ [(l1, [], l2)]) t in
    (locations, loop [] paths)
  else (l1::locations, (l1, [], l2)::paths)

let rec length acc = function
  | [] -> acc
  | r::t -> length (acc + (Board.get_length r)) t

let longest_route p =
  let rec loop longest locations paths = function
    | [] -> longest
    | (l1, l2, _, _, _, _, _)::t ->
      let n1 = Board.name l1 in
      let n2 = Board.name l2 in
      let (locations, paths) = calculate_paths n1 n2 locations paths in
      let (locations', paths') = calculate_paths n2 n1 locations paths in
      let paths'' =
        let rec loop2 acc = function
          | [] -> acc
          | (hd, between, last)::t ->
            let p = Board.path_routes (routes p) ([hd] @ between @ [last]) in
            loop2 (acc @ [p]) t in
        loop2 [] paths' in
      let rec loop3 best = function
        | [] -> best
        | lst::t -> let l = length 0 lst in
          if l >= best then loop3 l t else loop3 best t in
      let l2 = loop3 0 paths'' in
      if l2 >= longest then loop l2 locations' paths' t
      else loop longest locations' paths' t in
  loop 0 [] [] (routes p)
