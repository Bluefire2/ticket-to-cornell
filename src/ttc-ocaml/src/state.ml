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
               last_round : bool;
               winner: player option }

let init_state n bots =
  let init = { player_index = 0;
               players = [];
               routes = [];
               destination_deck = DestinationDeck.init_deck ();
               destination_trash = DestinationDeck.init_trash;
               choose_destinations = [];
               train_deck = TrainDeck.init_deck ();
               facing_up_trains = TrainDeck.init_faceup ();
               train_trash = TrainDeck.init_trash;
               taking_routes = false;
               error = "Number players must be 2-5.";
               turn_ended = false;
               last_round = false;
               winner = None } in
  if ((n+bots) < 2 || (n+bots) > 5) then init
  else
    let players = init_players n false in
    let bots = init_players bots true in
    {init with players = (players @ bots);
               routes = Board.routes;
               error = "" }

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

let winner st = st.winner

let longest_route_player st =
  let rec players_loop best i = (function
    | [] -> best
    | p::t ->
      let p_best = List.nth (players st) best in
      if (Player.longest_route p) > (Player.longest_route p_best)
      then players_loop i (i+1) t
      else players_loop best (i+1) t ) in
  players_loop 0 0 (players st)

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

(* [update_players i new_p lst] returns [lst] but with the player at index [i]
 * changed to [new_p]. *)
let update_players i new_p lst =
  let rec update_loop i new_i new_p acc = function
  | [] -> acc
  | h::t -> if i = new_i then acc @ [new_p] @ t
    else update_loop (i+1) new_i new_p (acc @ [h]) t in
  update_loop 0 i new_p [] lst

(* [update_players_tickets st] returns a list of players in which they have all
 * been updated by adding to their score points they have earned for completing
 * destination tickets. *)
let update_players_tickets st =
  let rec loop acc = function
    | [] -> acc
    | p::t ->
      let p' = (Player.completed_destination_tickets p) in
      loop (acc @ [p']) t in
  loop [] (players st)

(* [calculate_winner st] returns the winner for [st], or None if ther are no
 * players. *)
let calculate_winner st =
  let longest_i = longest_route_player st in
  let plyrs = players st in
  let longest_p = List.nth plyrs longest_i in
  let p' = Player.increase_score longest_p 10 in
  let st' = {st with players = update_players longest_i p' plyrs } in
  let st'' = {st with players = update_players_tickets st'} in
  let rec loop best = function
    | [] -> best
    | p::t ->
      match best with
      | None -> loop (Some p) t
      | Some p_best ->
        if (Player.score p > Player.score p_best)
        then loop (Some p) t
        else loop best t in
  (st'', loop None (players st''))

(* [end_game st] represents when [st] has ended. *)
let end_game st =
  let (st', winner) = calculate_winner st in
  {st' with error = "Game has ended.";
           winner =  winner }

(* [turn_ended_error st] is [st] but with a turn ended error message. *)
let turn_ended_error st =
  { st with error = "Turn has already ended for the current player." }

(* [first_turn_error st] is [st] but with an error message for when a player
 * tries to do something other than collect destination tickets in their first
 * turn. *)
let first_turn_error st =
  { st with error = "Can't call this function in the first turn, must choose destination tickets first. "}

let next_player st =
  if (turn_ended st) then
    if (game_ended st) then end_game st
    else
      let next_player = ((st.player_index + 1) mod (List.length st.players)) in
      let st' = {st with player_index = next_player;
                         turn_ended = false;
                         error = "" } in
      if ((check_last_round st) || (last_round st))
      then
        let p' = set_last_turn (current_player st') in
        {st' with last_round = true;
                  players = update_players (st'.player_index) p' st'.players }
      else st'
  else
    { st with error = "Turn has not ended yet for the current player." }

let draw_card_facing_up st i =
  if (turn_ended st) then turn_ended_error st
  else (
  if (first_turn (current_player st)) then first_turn_error st
  else (
  let (c, (cards, deck,trash)) = TrainDeck.draw_faceup (st.train_deck) i (st.facing_up_trains) (st.train_trash) in
  let p' = draw_train_card (current_player st) c in
  let i = st.player_index in
  { st with facing_up_trains = cards;
            train_deck = deck;
            players = update_players i p' st.players;
            train_trash = trash;
            turn_ended = true;
            error = "" } ) )

(* [draw_card_pile_no_error st] is `draw_card_pile st` but it does not end
 * the turn for the player, used for setup_state. *)
let draw_card_pile_no_error st =
  let tr = st.train_trash in
  let (c1, deck',tr') = TrainDeck.draw_card (st.train_deck) tr in
  let (c2, deck'',tr'') = TrainDeck.draw_card deck' tr in
  let p' = draw_train_card (current_player st) c1 in
  let p'' = draw_train_card p' c2 in
  let i = st.player_index in
  { st with train_deck = deck'';
            train_trash = tr'';
            players = update_players i p'' st.players;
            error = "" }

let draw_card_pile st =
  if (turn_ended st) then turn_ended_error st
  else (
  let st' = draw_card_pile_no_error st in
  { st' with turn_ended = true;
             error = "" } )

let take_route st =
  if (turn_ended st) then turn_ended_error st
  else (
  let deck = st.destination_deck in
  let tr = st.destination_trash in
  let (tickets, deck') = DestinationDeck.draw_card deck tr in
  { st with destination_deck = deck';
            choose_destinations = tickets;
            taking_routes = true;
            error = "" } )

let setup_state st =
  if (turn_ended st) then turn_ended_error st
  else (
  if (first_turn (current_player st))
  then (
  let st1 = draw_card_pile_no_error st in
  let st2 = draw_card_pile_no_error st1 in
  take_route st2 )
  else {st with error = "Can't setup when it is not the first turn."} )

let decided_routes st indexes =
  if (turn_ended st) then turn_ended_error st
  else (
    if (st.taking_routes) then (
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
    else {st with error = "Must take destination tickets first."} )

(* [update_routes rts old new] is [rts] but with the [old] route replaced by
 * the [new] route. *)
let update_routes routes old_r new_r =
  let rec loop acc = function
    | [] -> acc
    | h::t -> if h = old_r then (acc @ [new_r] @ t) else loop (acc @ [h]) t in
  loop [] routes

(* [check_cards cards n clr] is true if there are at least [n] cards of the [clr]
 * color in [cards]. *)
let check_cards cards n clr =
  let rec loop = function
    | [] -> 0
    | (clr', i)::t -> ( if clr' = clr then i else loop t ) in
  (loop cards) >= n

(* [place_on_board st r clr] returns a new [st] with the route [r] added to the
 * current player and with the routes updated to reflect this change. It checks
 * that the current player has enough cards of color [clr] to take this route
 * and enough trains remaining. *)
let place_on_board st r clr =
  (* Checking player has train cards for selected route *)
  let cards = train_cards (current_player st) in
  let num = match r with | (_, _, n, _, _, _, _) -> n in
  if (check_cards cards num clr) then (
    let num_trains = trains_remaining (current_player st) in
    if (num_trains >= num) then (
      let p_clr = (current_player st).color in
      let r' = match r with | (s1, s2, n, clr', _, b, lr) -> (s1, s2, n, clr', Some p_clr, b, lr) in
      let p' = place_train (current_player st) r' in
      let i = st.player_index in
      {st with players = update_players i p' st.players;
               routes = update_routes (routes st) r r';
               error = "";
               turn_ended = true })
    else {st with error = "Not enough trains."} )
  else {st with error = "Not enough train cards."}

let select_route st r clr =
  if (turn_ended st) then turn_ended_error st
  else (
  if (first_turn (current_player st)) then first_turn_error st
  else (
    match r with
    | (_, _, _, _, Some _, _, _) -> {st with error = "Route already taken."}
    | (_, _, _, Grey, _, _, _) ->
      ( match clr with
      | None -> {st with error = "Choose a train card color."}
      | Some clr' -> place_on_board st r clr' )
    | (_, _, _, clr, _, _, _) -> place_on_board st r clr ))
