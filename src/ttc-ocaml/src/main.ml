open Components

let name (x,_,_) = x

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

let print_routes st =
  let r = State.routes st in
  let rec loop = function
    | [] -> ""
    | (l1, l2, _, _, x)::t -> match x with
      | None -> loop t
      | Some p -> ("Route from " ^ (name l1) ^ " to " ^ (name l2) ^ " belongs to " ^ (stringify_clr p) ^ "\n") ^ (loop t) in
  loop r

let play num =
  let rec game_loop st i =
    (if i < num then
    (print_player st;
    ANSITerminal.(print_string [blue] ("Grab 4 train cards from deck\n"));
    let st = State.draw_card_pile st in
    let st = State.draw_card_pile st in
    print_cards st;
    let st = State.next_player st in
    game_loop st (i+1))
     else st ) in
  let st = State.init_state num in
  let st = game_loop st 0 in
  ANSITerminal.(print_string [blue] ("What do you want to do next?\nDRAW PILE or DRAW FACING UP to get train cards, TAKE destination ticket, or SELECT <color> route? \n"));
  match Command.parse (read_line ()) with
  | "draw", "pile" -> ANSITerminal.(print_string [red] ("pile\n"));
  | "draw", "facing up" -> ANSITerminal.(print_string [red] ("facing up\n"));
  | "take", "" -> ANSITerminal.(print_string [red] ("take\n"));
  | "select", x ->
    (let clr = ( match x with
         | "red" -> Red
        | "green" -> Green
        | "blue" -> Blue
        | "yellow" -> Yellow
        | "pink" -> Pink
        | "orange" -> Orange
        | "white" -> White
        | "black" -> Black
        | _ -> Grey ) in
     ANSITerminal.(print_string [red] ("select\n")))
     (*let r = ("Bailey Hall", "Dairy Bar", 1, clr, None) in
     let st' = State.select_route st r in
     ANSITerminal.(print_string [red] ((State.message st') ^ "\n"));
     ANSITerminal.(print_string [blue] (print_routes st')))*)
  | _ -> ()

let main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to Ticket to Cornell!\n");
  ANSITerminal.(print_string [blue]
                  "\n\nHow many players? (2-5) \n");
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | num -> play (int_of_string num)

let () = main ()
