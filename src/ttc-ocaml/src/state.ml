open Components
open Board
open Player

type state = { player_index : int;
               players : player list;
               routes : Board.route list;
               destination_deck : DestinationDeck.t;
               destination_trash : DestinationDeck.tr;
               choose_destinations : DestinationDeck.card list;
               train_deck : TrainDeck.t;
               facing_up_trains : TrainDeck.t;
               train_trash : TrainDeck.tr;
               taking_routes : bool;
               error : string;
               turn_ended : bool;
               last_round : bool}

let init_state num =
  let players = init_players num in
  { player_index = 0;
    players = players;
    routes = Board.routes;
    destination_deck = DestinationDeck.init_deck ();
    destination_trash = DestinationDeck.init_trash;
    choose_destinations = [];
    train_deck = TrainDeck.init_deck ();
    facing_up_trains = TrainDeck.init_faceup ();
    train_trash = TrainDeck.init_trash;
    taking_routes = false;
    error = "";
    turn_ended = false;
    last_round = false }

let current_player st =
  List.nth st.players st.player_index

let players st = st.players

let routes st = st.routes

let destination_items st = (st.destination_deck, st.destination_trash)

let train_items st = (st.train_deck, st.facing_up_trains, st.train_trash)

let message st = st.error

let turn_ended st = st.turn_ended

let last_round st = st.last_round

let choose_destinations st = st.choose_destinations

let score st player =
  (Player.score (current_player st))

(* If the current player has less than or equal to 2 remaining trains, then
 * it is the last round. *)
let check_last_round st =
  let p = current_player st in
  (trains_remaining p) <= 2

(* If it was the last turn for all the players, then the game is over. *)
let game_ended st =
  let rec loop = function
    | [] -> true
    | p::t -> (last_turn p) && loop t in
  loop (players st)

let turn_ended_error st =
  { st with error = "Turn has already ended for the current player." }

(* [update_players i new_p lst] returns [lst] but with the player at index [i]
 * changed to [new_p]. *)
let update_players i new_p lst =
  let rec update_loop i new_i new_p acc = function
  | [] -> acc
  | h::t -> if i = new_i then acc @ [new_p] @ t
    else update_loop (i+1) new_i new_p (acc @ [h]) t in
  update_loop 0 i new_p [] lst

let next_player st =
  if (turn_ended st) then
    if (game_ended st) then {st with error = "Game has ended."}
    else
      let next_player = ((st.player_index + 1) mod (List.length st.players)) in
      let st' = {st with player_index = next_player} in
      if ((check_last_round st) || (last_round st))
      then
        let p' = set_last_turn (current_player st') in
        {st' with last_round = true;
                  players = update_players (st'.player_index) p' st'.players;
                  turn_ended = false }
      else st'
  else
    { st with error = "Turn has not ended yet for the current player." }

let draw_card_facing_up st i =
  if (turn_ended st) then turn_ended_error st
  else (
  let (c, (cards, deck,trash)) = TrainDeck.draw_faceup (st.train_deck) i (st.facing_up_trains) (st.train_trash) in
  let p' = draw_train_card (current_player st) c in
  let i = st.player_index in
  { st with facing_up_trains = cards;
            train_deck = deck;
            players = update_players i p' st.players;
            train_trash = trash;
            turn_ended = true } )

let draw_card_pile_no_error st =
  let tr = st.train_trash in
  let (c1, deck',tr') = TrainDeck.draw_card (st.train_deck) tr in
  let (c2, deck'',tr'') = TrainDeck.draw_card deck' tr in
  let p' = draw_train_card (current_player st) c1 in
  let p'' = draw_train_card p' c2 in
  let i = st.player_index in
  { st with train_deck = deck'';
            train_trash = tr'';
            players = update_players i p'' st.players }

let draw_card_pile st =
  if (turn_ended st) then turn_ended_error st
  else (
  let st' = draw_card_pile_no_error st in
  { st' with turn_ended = true } )

let take_route st =
  if (turn_ended st) then turn_ended_error st
  else (
  let deck = st.destination_deck in
  let tr = st.destination_trash in
  let (tickets, deck') = DestinationDeck.draw_card deck tr in
  { st with destination_deck = deck';
            choose_destinations = tickets;
            taking_routes = false } )

(* grab 4 train cards, grabs 3 destination tickets and choose 2-3. *)
let setup_state st =
  if (turn_ended st) then turn_ended_error st
  else (
  let st1 = draw_card_pile_no_error st in
  let st2 = draw_card_pile_no_error st1 in
  take_route st2 )

let decided_routes st indexes =
  if (turn_ended st) then turn_ended_error st
  else (
    let p = current_player st in
    let required_tickets = if first_turn p then 2 else 1 in
    let tickets_chosen = List.length indexes in
    if tickets_chosen >= required_tickets then
      ( let choose = choose_destinations st in
        let rec loop acc = function
            | [] -> acc
            | i::t -> loop ((List.nth choose i)::acc) t in
        let tickets = loop [] indexes in
        let p' = update_destination_tickets p tickets in
        let i = st.player_index in
         { st with players = update_players i p' st.players;
                   choose_destinations = [];
                   taking_routes = false;
                   error = "";
                   turn_ended = true } )
    else {st with
          error = "Player only chose " ^ (string_of_int tickets_chosen)
                  ^ " tickets, must take at least "
                  ^ (string_of_int required_tickets) ^ "."} )

let update_routes (routes: Board.route list) old_r new_r : Board.route list =
  let rec loop acc = function
    | [] -> acc
    | h::t -> if h = old_r then acc @ (new_r::t) else loop (h::acc) t in
  loop [] routes

let check_cards cards n clr =
  let rec loop = function
    | [] -> 0
    | (clr', i)::t -> ( if clr' = clr then i else loop t ) in
  (loop cards) >= n

let place_on_board st r clr =
  if (turn_ended st) then turn_ended_error st
  else (
  (* Checking player has train cards for selected route *)
  let cards = train_cards (current_player st) in
  let num = match r with | (_, _, n, _, _) -> n in
  if (check_cards cards num clr) then (
    let num_trains = trains_remaining (current_player st) in
    if (num_trains >= num) then (
      let p' = place_train (current_player st) r in
      let i = st.player_index in
      let p_clr = p'.color in
      let r' = match r with | (s1, s2, n, clr, _) -> (s1, s2, n, clr, Some p_clr) in
      {st with players = update_players i p' st.players;
               routes = update_routes (st.routes) r r';
               error = "";
               turn_ended = true })
    else {st with error = "Not enough trains."} )
  else {st with error = "Not enough train cards."} )

let select_route st r =
  if (turn_ended st) then turn_ended_error st
  else (
  match r with
  | (_, _, _, _, Some _) -> {st with error = "Route already taken."}
  | (_, _, _, Grey, _) -> {st with error = "Choose a train card color."}
  | (_, _, _, clr, _) -> place_on_board st r clr )

let longest_route st =
  let rec players_loop plyrs best =
    ( if List.length plyrs > 0 then
      ( let p = List.hd plyrs in
        let rest = List.tl plyrs in
        if (Player.score p) > (Player.score best) then
          players_loop rest p
        else
          players_loop rest best )
      else best) in
  let first = List.hd st.players in
  players_loop st.players first
