open Components

let name = function
  | Board.Location (x, _, _, _) -> x

let stringify_clr = function
  | PBlue -> "blue"
  | PRed -> "red"
  | PYellow -> "yellow"
  | PGreen -> "green"
  | PBlack -> "black"

let stringify_train = function
  | Red -> "red"
  | Green -> "green"
  | Blue -> "blue"
  | Yellow -> "yellow"
  | Pink -> "pink"
  | Orange -> "orange"
  | White -> "white"
  | Black -> "black"
  | Wild -> "wild"
  | Grey -> "grey"

let rec stringify_cards = function
  | [] -> ""
  | (h, i)::t -> if (i==0) then (stringify_cards t)
    else (string_of_int i) ^  ": " ^ (stringify_train h) ^ ". " ^ (stringify_cards t)

let print_player st =
  let p = State.current_player st in
  ANSITerminal.(print_string [blue] ("\nCurrent player: " ^ (stringify_clr (p.color) ^ "\n")))

let print_cards st =
  let p = State.current_player st in
  ANSITerminal.(print_string [blue] ("\nYou have the following cards in your hand:\n"
                                     ^ (stringify_cards (p.train_cards) ^ "\n")))

let rec stringify_tickets acc = function
  | [] -> ""
  | {loc1 = a; loc2 = b; points = p}::t ->
    ((string_of_int acc) ^ ". From: " ^ a ^ ". To: " ^ b ^ ". Points: " ^ (string_of_int p) ^ ".\n" ^ (stringify_tickets (acc+1) t))

let print_tickets tickets =
  ANSITerminal.(print_string [blue] ("\nYou can choose from the following destination tickets:\n"
                                     ^ (stringify_tickets 1 tickets) ^ "Which ones do you want? (type as '1-2' or '1-2-3' or '2-3')\n"))

let print_routes st =
  let r = State.routes st in
  let rec loop acc = function
    | [] -> acc
    | (l1, l2, _, _, x, _, _)::t -> match x with
      | None -> loop acc t
      | Some p -> loop (("Route from " ^ (name l1) ^ " to " ^ (name l2) ^ " belongs to " ^ (stringify_clr p) ^ "\n") ^ acc) t in
  loop "" r

let play num =
  let rec game_loop st i =
    (if i < num then
    (print_player st;
    ANSITerminal.(print_string [blue] ("Grab 4 train cards from deck\n"));
    let st = State.setup_state st in
    print_cards st;
    let tickets = (State.choose_destinations st) in
    print_tickets tickets;
    let choose = match Command.parse (read_line ()) with
      | "1-2", "" -> [0; 1]
      | "2-3", "" -> [1; 2]
      | "1-3", "" -> [0; 2]
      | _ -> [0; 1; 2] in
    let st = (State.decided_routes st choose) in
    let st = State.next_player st in
    game_loop st (i+1))
     else st ) in
  let st = State.init_state num in
  let st = game_loop st 0 in
  ANSITerminal.(print_string [blue]
                  ("What do you want to do next?\nDRAW PILE or DRAW FACING UP to get train cards, TAKE destination ticket, or SELECT <color> route? \n"));
  match Command.parse (read_line ()) with
  | _ ->   ANSITerminal.(print_string [red] "You should try this out on our GUI!\n")

let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to Ticket to Cornell!\n");
  ANSITerminal.(print_string [blue]
                  "\n\nHow many players? (2-5) \n");
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | s ->
    try (let num = int_of_string s in
         let () = assert ((2 <= num) && (num<=5)) in
         play num)
    with
    | _ -> ANSITerminal.(print_string [blue] "\nMust be number between 2 and 5.\n")

let () = main ()
