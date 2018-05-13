type train_color =
| Red
| Green
| Blue
| Yellow
| Pink
| Orange
| White
| Black
| Wild
| Grey

type player_color =
| PBlue
| PRed
| PYellow
| PGreen
| PBlack

type destination_ticket = {
  loc1 : string;
  loc2 : string;
  points : int
}

let train_deck : train_color list =
  [Red; Red;Red;Red;Red;Red;Red;Red;Red;Red;Red;Red;
  Green; Green; Green; Green; Green; Green; Green; Green; Green; Green; Green; Green;
  Blue; Blue; Blue; Blue; Blue; Blue; Blue; Blue; Blue; Blue; Blue; Blue;
  Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow; Yellow;
  Pink; Pink; Pink; Pink; Pink; Pink; Pink; Pink; Pink; Pink; Pink; Pink;
  Orange; Orange; Orange; Orange; Orange; Orange; Orange; Orange; Orange; Orange; Orange; Orange;
  White; White; White; White; White; White; White; White; White; White; White; White;
  Black; Black; Black; Black; Black; Black; Black; Black; Black; Black; Black; Black;
  Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild; Wild
  ]

let dest_ticket_deck : destination_ticket list = [
  {loc1 = "Eddy Gate"; loc2 = "Golf Center"; points = 22};
  {loc1 = "Sigma Chi"; loc2 = "Veterinary School"; points = 21};
  {loc1 = "A LOT"; loc2 = "Blair Farm Barn"; points = 20};
  {loc1 = "Ecology House"; loc2 = "Newman Arboretum"; points = 20};
  {loc1 = "House Becker"; loc2 = "Filtration Plant"; points = 17};
  {loc1 = "Noyes Community Center"; loc2 = "Forest Home"; points = 17};
  {loc1 = "Engineering Quad"; loc2 = "Hasbrouck Community Center"; points = 16};
  {loc1 = "Appel Commons"; loc2 = "Schoellkopf Field"; points = 13};
  {loc1 = "The Commons"; loc2 = "Risley"; points = 13};
  {loc1 = "Dairy Bar"; loc2 = "Johnson Museum"; points = 13};
  {loc1 = "Stewart Ave Bridge"; loc2 = "Riley-Robb Hall"; points = 12};
  {loc1 = "RPCC"; loc2 = "Barton Hall"; points = 12};
  {loc1 = "Physical Sciences Building"; loc2 = "Newman Arboretum"; points = 12};
  {loc1 = "Bartels Hall"; loc2 = "Undergraduate Admissions"; points = 12};
  {loc1 = "Beebe Lake"; loc2 = "Cascadilla Creek"; points = 11};
  {loc1 = "Werly Island"; loc2 = "Engineering Quad"; points = 11};
  {loc1 = "Maplewood Park"; loc2 = "Mann Library"; points = 11};
  {loc1 = "McGraw Tower"; loc2 = "Plantations"; points = 11};
  {loc1 = "CKB Quad"; loc2 = "Bartels Hall"; points = 10};
  {loc1 = "Eddy Gate"; loc2 = "Blair Farm Barn"; points = 10};
  {loc1 = "House Becker"; loc2 = "Werly Island"; points = 9};
  {loc1 = "Maplewood Park"; loc2 = "Dairy Bar"; points = 9};
  {loc1 = "Kennedy Hall"; loc2 = "Appel Commons"; points = 9};
  {loc1 = "Mann Library"; loc2 = "RPCC"; points = 9};
  {loc1 = "Ecology House"; loc2 = "Forest Home"; points = 8};
  {loc1 = "McGraw Tower"; loc2 = "Undergraduate Admissions"; points = 8};
  {loc1 = "Risley"; loc2 = "Noyes Community Center"; points = 7};
  {loc1 = "Sigma Chi"; loc2 = "CKB Quad"; points = 6};
  {loc1 = "Veterinary School"; loc2 = "Mann Library"; points = 5};
  {loc1 = "Plantations"; loc2 = "Bartels Hall"; points = 4};
]

let tfst (x,_,_) = x
let tsnd (_,y,_) = y
let tthd (_,_,z) = z
let fs (x,y,_) = (x,y)

let rec remove_n n lst =
  if n > (List.length lst) then lst else
  match lst with
  | [] -> []
  | h::t -> if n=0 then t else h::(remove_n (n-1) t)

let rec remove item = function
  | [] -> []
  | h::t -> if h=item then t else h::remove item t

let random_int n =
  try Random.int (n) with
  | Invalid_argument _ -> 0

let rec shuffler from to_list len =
  match len with
  | 0 -> to_list
  | _ -> let i = random_int (len) in shuffler (remove_n i from) ((List.nth from i)::to_list) (len-1)

let rec drop n lst =
  if n = 0 then lst else match lst with
    | [] -> []
    | x::xs -> drop (n-1) xs

let rec count item = function
  | [] -> 0
  | h::t -> if h=item then 1 + count item t else count item t

let rec checkify lst = match lst with
  | [] -> true
  | h::t -> if (count h lst) > 2 then false else checkify t


module type TrainDeck = sig
  type card = train_color
  type t = card list
  type tr = card list
  val shuffle : t -> tr -> t * tr
  (*val discard : card -> tr -> tr*)
  val init_deck : unit -> t
  val init_trash : tr
  val draw_card : t -> tr -> (card * t * tr)
  val five_faceup : t -> tr -> (card list * card list * card list)
  val add_faceup : card list -> card list -> card list -> (card list * card list * card list)
  val init_faceup : unit -> card list
  val draw_faceup : card list ->int -> card list -> card list -> card * (card list * card list * card list)
end

module type DestinationDeck = sig
  type card = destination_ticket
  type t = card list
  type tr = card list
  val shuffle : t -> tr -> t * tr
  val discard : card list -> tr -> tr
  val init_deck : unit -> t
  val init_trash : tr
  val draw_card : t -> tr -> (card list * t)
end

module TrainDeck = struct
  type card = train_color
  type t = card list
  (*type f = card list*)
  type tr = card list
  let rec shuffle tr t  = let shuf = shuffler tr [] (List.length tr) in (shuf,[])
  let rec draw_card t tr = if t <> [] then (List.hd t, List.tl t,tr) else
      let shuff = shuffle tr t in draw_card (fst shuff) []
  (*let discard c tr = c::tr*)
  let init_deck =  fun () -> fst (shuffle train_deck [])
  let init_trash = []
  let rec five_faceup t tr =
    let d1 = draw_card t tr in
    let d2 = draw_card (tsnd d1) (tthd d1) in
    let d3 = draw_card (tsnd d2) (tthd d2) in
    let d4 = draw_card (tsnd d3) (tthd d3) in
    let d5 = draw_card (tsnd d4) (tthd d4) in
    let start = (tfst d1)::(tfst d2)::(tfst d3)::(tfst d4)::(tfst d5)::[] in
    let trash = tthd d5 in
    if checkify start then (start,(tsnd d5),trash) else five_faceup (tsnd d5) (start@trash)
  let add_faceup t tr f  =
    let drawn = draw_card t tr in
    let faceup = ((tfst drawn)::f, (tsnd drawn), (tthd drawn)) in
    if checkify (tfst faceup) then faceup else five_faceup (tsnd faceup) ((tfst faceup)@tr)
  let draw_faceup t i f tr =
    let c = List.nth f i in
    let removed = remove c f in
    (c, add_faceup t tr removed)
  let init_faceup = fun () ->
    let d1 = draw_card (init_deck ()) init_trash in
    let d2 = draw_card (tsnd d1) init_trash in
    let d3 = draw_card (tsnd d2) init_trash in
    let d4 = draw_card (tsnd d3) init_trash in
    let d5 = draw_card (tsnd d4) init_trash in
    let start = (tfst d1)::(tfst d2)::(tfst d3)::(tfst d4)::(tfst d5)::[] in
    if checkify start then start else tfst (five_faceup (tsnd d5) start)
end

module DestinationDeck = struct
  type card = destination_ticket
  type t = card list
  type tr = card list
  let rec shuffle tr t  = let shuf = shuffler tr [] (List.length tr) in (shuf,[])
  let rec draw_card t tr = if List.length t > 2 then ([List.hd t; List.nth t 1; List.nth t 2], (drop 3 t)) else
        let shuff = shuffle tr [] in draw_card (t@(fst shuff)) []
  let discard c tr = c@tr
  let init_deck = fun () -> fst (shuffle dest_ticket_deck [])
  let init_trash = []
end
