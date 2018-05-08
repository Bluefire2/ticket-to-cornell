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
                trains_remaining : int ;
              }

let rec remove_color n c h =
  if n = 0 then h else
  match h with
  | [] -> []
  | (a1,a2)::b -> if a1=c then (a1,a2-n)::b else remove_color n c b

let destination_tickets p = p.destination_tickets

let update_destination_tickets p tickets =
  { p with destination_tickets = tickets @ p.destination_tickets }

let train_cards p = p.train_cards

let score p = p.score

let trains_remaining p = p.trains_remaining
(* TODO: let players choose their colors. For now:
  P1 -> blue
  P2 -> red
  P3 -> yellow
  P4 -> green
  P5 -> black
  well actually vice versa lmao oops
*)
let rec add_train_cards tlist c acc=
  match tlist with
  | [] -> acc
  | (a,b)::t -> if c=a then acc @ ((a,b+1)::t) else add_train_cards t c (acc@[(a,b)])

let color p = p.color
let rec init_players n =
  match n with
  | 0 -> []
  | _ -> let p = { color = color_of_int (n-1);
                  destination_tickets = [];
                  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
                  score = 0;
                  trains_remaining = 45 } in
            p::(init_players (n-1))

let draw_train_card p c =
  { p with train_cards = add_train_cards p.train_cards c []}

(*precondition: hplayer hand has correct number of trains, assume player selected color for route aka not none,
assume state checked player color option if is already taken by person.  *)
let place_train p r =
  { color = p.color;
    destination_tickets = p.destination_tickets;
    train_cards =
      remove_color (Board.get_length r) (Board.get_color r) p.train_cards;
    score = Board.route_score r;
    trains_remaining = p.trains_remaining - Board.get_length r
  }
