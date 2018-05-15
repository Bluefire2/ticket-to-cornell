open OUnit2
open Components
open State
open Board
open Player
open Ai

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

let lst l = match l with | Location (_, _, _, x) -> x

let eco_house = Location ("Ecology House", 574., 141., [])
let a_lot = Location ("A LOT", 1051., 106., [])
let golf = Location ("Golf Center", 1676., 187., [])
let hasbrouck = Location ("Hasbrouck Community Center", 1408., 290., [])
let rpcc = Location ("RPCC", 1015.,322., [])
let appel = Location ("Appel Commons", 1107.,539., [])
let mcgraw = Location ("McGraw Tower", 501.,1097., [])
let risley = Location ("Risley", 718.,579., [])
let eddy = Location ("Eddy Gate", 341.,1549., [])
let noyes = Location ("Noyes Community Center", 338.,1189., [])
let bartels = Location ("Bartels Hall",1094.,1256., [])
let schoellkopf = Location ("Schoellkopf Field", 940.,1400., [])
let dairy_bar = Location ("Dairy Bar", 1486.,1078., [])
let kennedy = Location ("Kennedy Hall", 893.,1021., [])
let bridge = Location ("Stewart Ave Bridge", 184., 644., [])
let museum = Location ("Johnson Museum", 428., 785., [])
let sigma_chi = Location ("Sigma Chi", 95., 257., [])
let undergrad = Location ("Undergraduate Admissions", 498., 498., [])
let ckb = Location ("CKB Quad", 934., 468., [])
let forest_home = Location ("Forest Home", 1673., 677., [])
let beebe = Location ("Beebe Lake", 967., 699., [])
let island = Location ("Werly Island", 1208., 780., [])
let psb = Location ("Physical Sciences Building", 726.,875., [])
let mann = Location ("Mann Library", 1086.,972., [])
let engineering = Location ("Engineering Quad", 615., 1362., [])
let commons = Location ("The Commons", 65., 1673., [])
let maplewood = Location ("Maplewood Park", 1156., 1671., [])
let vet = Location ("Veterinary School", 1863., 1107., [])
let riley_robb = Location ("Riley-Robb Hall", 1430., 1245., [])
let barton = Location ("Barton Hall", 801.,1235., [])
let farm_barn = Location ("Blair Farm Barn", 1562., 1492., [])
let plantations = Location ("Plantations", 1359., 845., [])
let arboretum = Location ("Newman Arboretum", 2028., 712., [])
let filtration = Location ("Filtration Plant", 1787., 858., [])
let creek = Location ("Cascadilla Creek", 842., 1579., [])
let becker = Location ("House Becker", 198.,994., [])

let route_connections =
  [
    (ckb,appel,1,Grey,None, true, Some LeftRoute);
    (ckb,appel,1,Grey,None, true, Some RightRoute);
    (dairy_bar,riley_robb,1,Grey,None, true, Some LeftRoute);
    (dairy_bar,riley_robb,1,Grey,None, true, Some RightRoute);
    (rpcc,ckb,1,Grey,None, true, Some LeftRoute);
    (rpcc,ckb,1,Grey,None, true, Some RightRoute);
    (rpcc,appel,1,Grey,None, false, None);
    (island,plantations,1,Grey,None, true, Some LeftRoute);
    (island,plantations,1,Grey,None, true, Some RightRoute);
    (ckb,risley,2,Blue,None, false, None);
    (noyes,mcgraw,2,Grey,None, true, Some LeftRoute);
    (noyes,mcgraw,2,Grey,None, true, Some RightRoute);
    (creek,schoellkopf,2,Grey,None, true, Some LeftRoute);
    (creek,schoellkopf,2,Grey,None, true, Some RightRoute);
    (beebe,appel,2,Pink,None, false, None);
    (engineering,barton,2,Grey,None, true, Some LeftRoute);
    (engineering,barton,2,Grey,None, true, Some RightRoute);
    (beebe,island,2,Black,None, true, Some LeftRoute);
    (beebe,island,2,Orange,None, true, Some RightRoute);
    (kennedy,mann,2,Grey,None, true, Some LeftRoute);
    (kennedy,mann,2,Grey,None, true, Some RightRoute);
    (undergrad,risley,2,Green,None, true, Some LeftRoute);
    (undergrad,risley,2,White,None, true, Some RightRoute);
    (dairy_bar,plantations,2,White,None, true, Some LeftRoute);
    (dairy_bar,plantations,2,Green,None, true, Some RightRoute);
    (mann,plantations,2,Grey,None, false, None);
    (barton,schoellkopf,2,Yellow,None, true, Some LeftRoute);
    (barton,schoellkopf,2,Red,None, true, Some RightRoute);
    (undergrad,museum,2,Grey,None, false, None);
    (psb,kennedy,2,Grey,None, true, Some LeftRoute);
    (psb,kennedy,2,Grey,None, true, Some RightRoute);
    (schoellkopf,bartels,2,Grey,None, true, Some LeftRoute);
    (schoellkopf,bartels,2,Grey,None, true, Some RightRoute);
    (engineering,schoellkopf,2,Grey,None, false, None);
    (a_lot,rpcc,2,Grey,None, false, None);
    (forest_home,filtration,2,Grey,None, false, None);
    (museum,bridge,2,Grey,None, false, None);
    (filtration,vet,2,Grey,None, false, None);
    (becker,noyes,2,Grey,None, false, None);
    (risley,beebe,2,Grey,None, false, None);
    (kennedy,barton,2,Grey,None, false, None);
    (mcgraw,engineering,2,Grey,None, false, None);
    (becker,mcgraw,2,Grey,None, false, None);
    (appel,island,2,Grey,None, false, None);
    (kennedy,bartels,2,Grey,None, false, None);
    (becker,museum,3,Yellow,None, true, Some LeftRoute);
    (becker,museum,3,Pink,None, true, Some RightRoute);
    (eddy,engineering,3,Grey,None, false, None);
    (hasbrouck,golf,3,Green,None, false, None);
    (museum,psb,3,Red,None, true, Some LeftRoute);
    (museum,psb,3,Yellow,None, true, Some RightRoute);
    (risley,psb,3,White,None, false, None);
    (becker,bridge,3,Blue,None, false, None);
    (commons,eddy,3,Black,None, false, None);
    (creek,maplewood,3,Orange,None, true, Some LeftRoute);
    (creek,maplewood,3,Black,None, true, Some RightRoute);
    (riley_robb,farm_barn,3,Grey,None, false, None);
    (bartels,dairy_bar,3,Orange,None, false, None);
    (bridge,undergrad,3,Pink,None, false, None);
    (mcgraw,psb,3,Grey,None, false, None);
    (dairy_bar,vet,3,Grey,None, false, None);
    (plantations,filtration,3,Blue,None, false, None);
    (becker,psb,3,Red,None, false, None);
    (filtration,arboretum,3,Grey,None, false, None);
    (museum,risley,3,Grey,None, false, None);
    (schoellkopf,farm_barn,4,Yellow,None, false, None);
    (a_lot,hasbrouck,4,Grey,None, false, None);
    (arboretum,forest_home,4,Grey,None, false, None);
    (appel,hasbrouck,4,Green,None, false, None);
    (eddy,noyes,4,Blue,None, false, None);
    (mcgraw,kennedy,4,Pink,None, false, None);
    (psb,island,4,Red,None, false, None);
    (island,forest_home,4,Yellow,None, true, Some LeftRoute);
    (island,forest_home,4,Orange,None, true, Some RightRoute);
    (eco_house,rpcc,4,Red,None, false, None);
    (rpcc,hasbrouck,4,Black,None, false, None);
    (undergrad,rpcc,4,Blue,None, false, None);
    (sigma_chi,undergrad,4,Pink,None, false, None);
    (hasbrouck,forest_home,4,White,None, false, None);
    (maplewood,farm_barn,4,Black,None, true, Some LeftRoute);
    (maplewood,farm_barn,4,Orange,None, true, Some RightRoute);
    (arboretum,vet,5,Red,None, false, None);
    (vet,plantations,5,White,None, false, None);
    (eddy,creek,5,Yellow,None, false, None);
    (undergrad,eco_house,5,Green,None, false, None);
    (schoellkopf,riley_robb,5,Orange,None, true, Some LeftRoute);
    (schoellkopf,riley_robb,5,White,None, true, Some RightRoute);
    (bridge,sigma_chi,5,Black,None, false, None);
    (sigma_chi,eco_house,5,Green,None, false, None);
    (sigma_chi,eco_house,5,Pink,None, false, None);
    (riley_robb,vet,5,Blue,None, false, None);
    (commons,becker,6,Blue,None, false, None);
    (a_lot,golf,6,Yellow,None, false, None);
    (golf,forest_home,6,Black,None, false, None);
    (appel,forest_home,6,White,None, false, None);
    (eco_house,a_lot,6,Green,None, false, None);
    (commons,noyes,6,Orange,None, false, None);
    (golf,arboretum,6,Grey,None, false, None);
    (farm_barn,vet,6,Pink,None, false, None);
    (kennedy,dairy_bar,6,Red,None, false, None);
  ]


let test_list1 =
[ Red; Red; Red]

let test_list2 =
[  {loc1 = "Rhodes Hall"; loc2 = "Martha Van Rensselaer Hall"; points = 11};
  {loc1 = "House Bethe"; loc2 = "Martha Van Rensselaer Hall"; points = 22};
  {loc1 = "Helen Newman Hall"; loc2 = "Statler Hall"; points = 9}
]

let test_list3 =
[
{loc1 = "Gates Hall"; loc2 = "Gates Hall"; points = 0};
{loc1 = "Gates Hall"; loc2 = "Gates Hall"; points = 0};
{loc1 = "Gates Hall"; loc2 = "Gates Hall"; points = 0}
]

let gates = {loc1 = "Gates Hall"; loc2 = "Gates Hall"; points = 0}
let toclass = {loc1 = "House Becker";loc2 = "Olin Hall"; points = 10}
let test1 = {loc1 = "Klarman Hall"; loc2 = "McGraw Tower"; points=13}

let get_top_3 = function
| h1::h2::h3::t -> h1::h2::h3::[]
| _ -> []

let rec drop n lst =
  if n = 0 then lst else match lst with
    | [] -> []
    | x::xs -> drop (n-1) xs

(* [check_el l1 l2] checks if the elements of two lists are the same, in any order.
 * requires: [l1] and [l2] are the same size. *)
let rec check_el l1 l2=
  match l1 with
  | [] -> true
  | h::t -> if (List.mem h l2) then check_el t l2 else false

(* [same_lst l1 l2] checks if the elements of two lists are the same,
 * in any order. *)
let same_lst l1 l2 =
  if (List.length l1 <> List.length l2) then false
  else check_el l1 l2

let tfst (x,_,_) = x
let tsnd (_,y,_) = y
let tthd (_,_,z) = z
let fs (x,y,_) = (x,y)

let p1 =
{
color = PBlue;
destination_tickets = [gates;toclass];
train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)];
score = 34;
routes = [];
trains_remaining = 45;
first_turn = false;
last_turn = false;
bot = false;
}

let p2 =
{
color = PYellow;
destination_tickets = [];
train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
score = 0;
routes = [];
trains_remaining = 45;
first_turn = false;
last_turn = false;
bot = false;
}


let default1 =
{
  color = PBlue;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false;
  bot = false;
}


let default2 =
{
  color = PRed;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false;
  bot = false;
}


let default3 =
{
  color = PYellow;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false;
  bot = false;
}


let default4 =
{
  color = PGreen;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false;
  bot = false;
}


let default5 =
{
  color = PBlack;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false;
  bot = false;
}


let find_location s locations =
  let rec loop = ( function
      | [] -> failwith "not found"
      | (Board.Location (s', x, y, lst))::t ->
        if s' = s then (Board.Location (s', x, y, lst))
        else loop t ) in
  loop locations

let ppd =
{
color = PBlue;
destination_tickets = [{loc1 = "Plantations"; loc2 = "Bartels Hall"; points = 4}];
train_cards = [];
score = 90;
routes = [(dairy_bar,plantations,2,White,None, false, None); (bartels,dairy_bar,3,Orange,None, false, None)];
trains_remaining = 19;
first_turn = false;
last_turn = false;
bot = false;
}

let p3 =
  {
    color= PYellow;
    destination_tickets = [{loc1 = "Risley"; loc2 = "The Commons"; points = 13};
                           {loc1 = "Werly Island"; loc2 = "Engineering Quad"; points = 11}];
    train_cards = [(Red,3);(Blue,1);(Green,2);(Yellow,2);
                   (Black,0);(White,2);(Pink,0);(Wild,1);(Orange,0)];
    score = 18;
    routes = [
      (beebe,island,2,Orange,None, false, None);
      (psb,kennedy,2,Grey,None, false, None);
      (risley,beebe,2,Grey,None, false, None);
      (commons,eddy,3,Black,None, false, None);
      (psb,island,4,Red,None, false, None);
      (engineering,barton,2,Grey,None, false, None);
      (kennedy,barton,2,Grey,None, false, None);
      (eddy,engineering,3,Grey,None, false, None)];
    trains_remaining = 18;
    first_turn = false;
    last_turn = false;
    bot = false;
  }

let p4 = {p3 with
          color = PRed;
          destination_tickets = [{loc1 = "A LOT"; loc2 = "Blair Farm Barn"; points = 20};
                                 {loc1 = "Stewart Ave Bridge"; loc2 = "Riley-Robb Hall"; points = 12};
                                 {loc1 = "Sigma Chi"; loc2 = "CKB Quad"; points = 6}];
          routes =
            [
              (sigma_chi,undergrad,4,Pink,None, false, None);
              (bridge,sigma_chi,5,Black,None, false, None);
              (ckb,risley,2,Blue,None, false, None);
              (undergrad,risley,2,White,None, false, None);
              (dairy_bar,riley_robb,1,Grey,None, false, None);
              (rpcc,appel,1,Grey,None, false, None);
              (island,plantations,1,Grey,None, false, None);
              (beebe,appel,2,Pink,None, false, None);
              (beebe,island,2,Black,None, false, None);
              (dairy_bar,plantations,2,Green,None, false, None);
              (a_lot,rpcc,2,Grey,None, false, None);
              (riley_robb,farm_barn,3,Grey,None, false, None);
            ]
         }

let ppd' = {ppd with destination_tickets = [{loc1 = "Sigma Chi"; loc2 = "CKB Quad"; points = 6}]}

let ppd'' = {ppd with routes = [(dairy_bar,plantations,2,White,None, false, None)]}

let train_deck = TrainDeck.init_deck ()
let dest_ticket_deck = DestinationDeck.init_deck ()

let components_tests =
[
  (* TrainDeck Tests *)
  "shuffle1" >:: (fun _ -> assert_equal (test_list1,[]) (Components.TrainDeck.shuffle test_list1 []));
  "shuffle2" >:: (fun _ -> assert_equal true (same_lst (train_deck) (fst (Components.TrainDeck.shuffle train_deck []))));
  "draw card" >:: (fun _ -> assert_equal (List.hd train_deck,
                                          List.tl train_deck, []) (Components.TrainDeck.draw_card train_deck []));
  "draw with empty deck" >:: (fun _ -> assert_equal (Red,
                                          List.tl test_list1, []) (Components.TrainDeck.draw_card [] test_list1));
  "draw with one card" >:: (fun _ -> assert_equal (Pink, [], train_deck) (Components.TrainDeck.draw_card [Pink] train_deck));

  "init_deck" >:: (fun _ -> assert_equal true (same_lst (train_deck) (Components.TrainDeck.init_deck ())));
  "init_trash" >:: (fun _ -> assert_equal ([]) (Components.TrainDeck.init_trash));

  "five faceup" >:: (fun _ -> assert_equal ( ([Blue;Red;Orange;Yellow;Green], [], []) ) (Components.TrainDeck.five_faceup [Blue;Red;Orange;Yellow;Green] []));
  "five faceup, four in deck" >:: (fun _ -> assert_equal ( ([Blue;Red;Orange;Yellow;Green], [], []) )
    (Components.TrainDeck.five_faceup [Blue;Red;Orange;Yellow] [Green]));
  "five faceup, three in deck 1" >:: (fun _ -> assert_equal (true) (same_lst
    ([Blue;Red;Orange;Yellow;Green]) (tfst (Components.TrainDeck.five_faceup [Blue;Red;Orange] [Yellow;Green]))));
  "five faceup, three in deck 2" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tsnd (Components.TrainDeck.five_faceup [Blue;Red;Orange] [Yellow;Green]))));
  "five faceup, three in deck 3" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tthd (Components.TrainDeck.five_faceup [Blue;Red;Orange] [Yellow;Green]))));
  "five faceup two in deck 1" >:: (fun _ -> assert_equal (true) (same_lst
    ([Blue;Red;Orange;Yellow;Green]) (tfst (Components.TrainDeck.five_faceup [Blue;Red] [Orange;Yellow;Green]))));
  "five faceup two in deck 2" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tsnd (Components.TrainDeck.five_faceup [Blue;Red] [Orange;Yellow;Green]))));
  "five faceup two in deck 3" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tthd (Components.TrainDeck.five_faceup [Blue;Red] [Orange;Yellow;Green]))));
  "five faceup one in deck 1" >:: (fun _ -> assert_equal (true) (same_lst
    ([Blue;Red;Orange;Yellow;Green]) (tfst (Components.TrainDeck.five_faceup [Blue] [Red;Orange;Yellow;Green]))));
  "five faceup one in deck 2" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tsnd (Components.TrainDeck.five_faceup [Blue] [Red;Orange;Yellow;Green]))));
  "five faceup one in deck 3" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tthd (Components.TrainDeck.five_faceup [Blue] [Red;Orange;Yellow;Green]))));
  "five faceup empty deck 1" >:: (fun _ -> assert_equal (true) (same_lst
    ([Blue;Red;Orange;Yellow;Green]) (tfst (Components.TrainDeck.five_faceup [] [Blue;Red;Orange;Yellow;Green]))));
  "five faceup empty deck 2" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tsnd (Components.TrainDeck.five_faceup [] [Blue;Red;Orange;Yellow;Green]))));
  "five faceup empty deck 3" >:: (fun _ -> assert_equal (true) (same_lst
    ([]) (tthd (Components.TrainDeck.five_faceup [] [Blue;Red;Orange;Yellow;Green]))));

  "add faceup" >:: (fun _ -> assert_equal ([Red; Blue], [Green;Yellow], []) (Components.TrainDeck.add_faceup [Red;Green;Yellow] [] [Blue]));
  "add faceup with empty deck" >:: (fun _ -> assert_equal ([Red], [Red;Red],[]) (Components.TrainDeck.add_faceup [] test_list1 []));
  "add faceup causing redo 1" >:: (fun _ -> assert_equal (true) (same_lst ([Red;Blue;Green;Red;Green])  (tfst (Components.TrainDeck.add_faceup
  [Red;Blue;Red;Red;Green;Green;Red] [] [Red;Red]) ) ) );
  "add faceup causing redo 2" >:: (fun _ -> assert_equal (true) (same_lst ([Red])  (tsnd (Components.TrainDeck.add_faceup
  [Red;Blue;Red;Red;Green;Green;Red] [] [Red;Red]) ) ) );
  "add faceup causing redo 3" >:: (fun _ -> assert_equal (true) (same_lst ([Red;Red;Red])  (tthd (Components.TrainDeck.add_faceup
  [Red;Blue;Red;Red;Green;Green;Red] [] [Red;Red]) ) ) );

  "draw faceup" >:: (fun _ -> assert_equal (Red, ([Red],[Blue;Green;Red;Pink],[])) (Components.TrainDeck.draw_faceup [Red;Blue;Green;Red;Pink] 0 [Red] [] ));
  "draw faceup deck empty" >:: (fun _ -> assert_equal (Red, ([Red],[Red;Red],[])) (Components.TrainDeck.draw_faceup [] 0 [Red] [Red;Red;Red] ));
  "draw faceup causing redo" >:: (fun _ -> assert_equal (Green, ([Pink;Blue;Green;Yellow;Orange], [], [Red;Red;Blue;Red;Yellow]))
    (Components.TrainDeck.draw_faceup [Red;Pink;Blue;Green;Yellow;Orange] 2 [Red;Blue;Green;Red;Yellow] []));
  (* checked [init_faceup] in utop. It shuffles every time, with no more than two of the
   * same card showing at a given time. *)

  (* DestinationDeck Tests *)
  "shuffle1" >:: (fun _ -> assert_equal (test_list3,[]) (Components.DestinationDeck.shuffle test_list3 []));
  "shuffle2" >:: (fun _ -> assert_equal true (same_lst (dest_ticket_deck) (fst (Components.DestinationDeck.shuffle dest_ticket_deck []))));
  "draw card" >:: (fun _ -> assert_equal (get_top_3 dest_ticket_deck,
                                          drop 3 dest_ticket_deck) (Components.DestinationDeck.draw_card dest_ticket_deck []));
  "draw card empty deck" >:: (fun _ -> assert_equal (get_top_3 test_list3, []) (Components.DestinationDeck.draw_card [] test_list3));
  "draw card, two cards in deck" >:: (fun _ -> assert_equal (get_top_3 test_list3, []) (Components.DestinationDeck.draw_card [gates;gates] [gates]));
  "draw card, one card in deck" >:: (fun _ -> assert_equal (get_top_3 test_list3, []) (Components.DestinationDeck.draw_card [gates] [gates;gates]));
  "discard" >:: (fun _ -> assert_equal ([gates]) (Components.DestinationDeck.discard [gates] []));
  "discard two cards" >:: (fun _ -> assert_equal ([gates;toclass]) (Components.DestinationDeck.discard [gates;toclass] []));
  "discard with existing trash" >:: (fun _ -> assert_equal ([gates;toclass]@test_list3) (Components.DestinationDeck.discard [gates;toclass] test_list3));
  "discard nothing" >:: (fun _ -> assert_equal [] (Components.DestinationDeck.discard [] []));
  "discard nothing with existing trash" >:: (fun _ -> assert_equal [toclass] (Components.DestinationDeck.discard [] [toclass]));
  "init_deck" >:: (fun _ -> assert_equal true (same_lst (dest_ticket_deck) (Components.DestinationDeck.init_deck ())));
  "init_trash" >:: (fun _ -> assert_equal ([]) (Components.DestinationDeck.init_trash));
]

let board_tests =
[
  (* Board tests *)
  "loc1" >:: (fun _ -> assert_equal true (same_lst ["Appel Commons"; "Risley"; "RPCC"] (lst (find_location "CKB Quad" Board.locations))));
  "loc2" >:: (fun _ -> assert_equal true (same_lst ["Bartels Hall"; "Cascadilla Creek"; "Barton Hall"; "Engineering Quad"; "Blair Farm Barn"; "Riley-Robb Hall"] (lst (find_location "Schoellkopf Field" Board.locations))));
  "checking completed1" >:: (fun _ -> assert_equal (true)
                                (Board.completed (List.hd ppd.destination_tickets).loc1 (List.hd ppd.destination_tickets).loc2 ppd.routes [] ));
  "checking completed2" >:: (fun _ -> assert_equal (false)
                                (Board.completed "Plantations" "Bartels" default5.routes []));
  "checking completed3" >:: (fun _ -> assert_equal (false)
                                (Board.completed (List.hd ppd'.destination_tickets).loc1 (List.hd ppd'.destination_tickets).loc2 ppd'.routes [] ));
  "checking completed4" >:: (fun _ -> assert_equal (false)
                                (Board.completed (List.hd ppd''.destination_tickets).loc1 (List.hd ppd''.destination_tickets).loc2 ppd''.routes [] ));
  "checking completed5" >:: (fun _ -> assert_equal (true)
                                (Board.completed "Risley" "The Commons" p3.routes []));
  "checking completed6" >:: (fun _ -> assert_equal (true)
                                (Board.completed "Werly Island" "Engineering Quad" p3.routes []));
  "checking completed7" >:: (fun _ -> assert_equal (false)
                                (Board.completed "Risley" "Noyes Community Center" p3.routes []));
  "checking completed8" >:: (fun _ -> assert_equal (false)
                                (Board.completed "Werly Island" "House Becker" p3.routes []));
  "checking completed9" >:: (fun _ -> assert_equal (true)
                                (Board.completed "Engineering Quad" "Werly Island" p3.routes []));
  "checking completed10" >:: (fun _ -> assert_equal (true)
                                 (Board.completed "The Commons" "Risley" p3.routes []));
  "checking completed11" >:: (fun _ -> assert_equal (true)
                                 (Board.completed "Sigma Chi" "CKB Quad" p4.routes []));
  "checking completed11" >:: (fun _ -> assert_equal (true)
                                 (Board.completed "Sigma Chi" "CKB Quad" p4.routes []));
  "checking completed12" >:: (fun _ -> assert_equal (true)
                                 (Board.completed "A LOT" "Blair Farm Barn" p4.routes []));
  "checking completed13" >:: (fun _ -> assert_equal (false)
                                 (Board.completed  "Stewart Ave Bridge" "Riley-Robb Hall" p4.routes []));
  "checking completed14" >:: (fun _ -> assert_equal (false)
                                 (Board.completed  "Stewart Ave Bridge" "Riley-Robb Hall" (shuffler p4.routes [] (List.length p4.routes)) []));
  (*    "checking completed15" >:: (fun _ -> assert_equal (true)
        (Board.completed  "A LOT" "Blair Farm Barn" (shuffler p4.routes [] (List.length p4.routes)) [])); *)
]

let r = List.nth (Board.routes) 21
let r' = match r with | (s1, s2, n, clr', _, b, lr) -> (s1, s2, n, clr', Some PYellow, b, lr)
let p3' = {p3 with train_cards = [(Red,3);(Blue,1);(Green,0);(Yellow,2);
                                  (Black,0);(White,2);(Pink,0);(Wild,1);(Orange,0)];
                   score = p3.score + 2;
                   routes = r'::p3.routes;
                   trains_remaining = p3.trains_remaining - 2}

let player_tests =
[
  (* Player Tests *)
  "destination tickets" >:: (fun _ -> assert_equal ([gates;toclass]) (Player.destination_tickets p1 ));
  "destination tickets empty" >:: (fun _ -> assert_equal ([]) (Player.destination_tickets p2));
  "update destination_tickets1" >:: (fun _ -> assert_equal
    ({
    color = PBlue;
    destination_tickets = [test1;gates;toclass];
    train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)];
    score = 34;
    routes = [];
    trains_remaining = 45;
    first_turn = false;
    last_turn = false;
    bot = false;
    })
    (Player.update_destination_tickets p1 [test1]));
  "update destination_tickets2" >:: (fun _ -> assert_equal
    ({
    color = PBlue;
    destination_tickets = [test1;gates;gates;toclass];
    train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)];
    score = 34;
    routes = [];
    trains_remaining = 45;
    first_turn = false;
    last_turn = false;
    bot = false;
    })
    (Player.update_destination_tickets p1 [test1;gates]));
  "update destination_tickets3" >:: (fun _ -> assert_equal
    ({
    color = PYellow;
    destination_tickets = [toclass];
    train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
    score = 0;
    routes = [];
    trains_remaining = 45;
    first_turn = false;
    last_turn = false;
    bot = false;
    })
    (Player.update_destination_tickets p2 [toclass]));
  "update destination_tickets4" >:: (fun _ -> assert_equal
    ({
    color = PYellow;
    destination_tickets = [toclass;gates;test1];
    train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
    score = 0;
    routes = [];
    trains_remaining = 45;
    first_turn = false;
    last_turn = false;
    bot = false;
    })
    (Player.update_destination_tickets p2 [toclass;gates;test1]));
  "train cards1" >:: (fun _ -> assert_equal [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)]
    (Player.train_cards p1));
  "train card2" >:: (fun _ -> assert_equal [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)]
    (Player.train_cards p2));
  "score1" >:: (fun _ -> assert_equal (34) (Player.score p1));
  "score2" >:: (fun _ -> assert_equal (0) (Player.score p2));
  "trains_remaining" >:: (fun _ -> assert_equal (45) (Player.trains_remaining p1));
  "color1" >:: (fun _ -> assert_equal (PBlue) (Player.color p1));
  "color2" >:: (fun _ -> assert_equal (PYellow) (Player.color p2));
  "init 2 players" >:: (fun _ -> assert_equal ([default2;default1]) (Player.init_players 2 false 0));
  "init 3 players" >:: (fun _ -> assert_equal ([default3;default2;default1]) (Player.init_players 3 false 0));
  "init 4 players" >:: (fun _ -> assert_equal ([default4;default3;default2;default1]) (Player.init_players 4 false 0));
  "init 5 players" >:: (fun _ -> assert_equal ([default5;default4;default3;default2;default1]) (Player.init_players 5 false 0));
  "draw card1" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,1);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Red));
  "draw card2" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,1);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Blue));
  "draw card3" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,1);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Green));
  "draw card4" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,1);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Orange));
  "draw card5" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,1);(Pink,0);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Yellow));
  "draw card6" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,1);(Wild,0);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Pink));
  "draw card7" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,1);(Black,0);(White,0)]})
    (Player.draw_train_card p2 Wild));
  "draw card8" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,1);(White,0)]})
    (Player.draw_train_card p2 Black));
  "draw card9" >:: (fun _ -> assert_equal
    ({p2 with train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,1)]})
    (Player.draw_train_card p2 White));
  "draw card10" >:: (fun _ -> assert_equal
    ({p1 with train_cards = [(Red,2);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)] })
  (Player.draw_train_card p1 Red));
  "draw card11" >:: (fun _ -> assert_equal
    ({p1 with train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,2);(Pink,1);(Wild,1);(Black,1);(White,1)] })
  (Player.draw_train_card p1 Yellow));
  "draw card12" >:: (fun _ -> assert_equal
    ({p1 with train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,2)] })
  (Player.draw_train_card p1 White));

  "place_train1" >:: (fun _ -> assert_equal p3' (place_train p3 Green r' 0));
]

let num_cards cards =
  let rec loop acc = function
    | [] -> acc
    | (_, n)::t -> loop (acc + n) t in
  loop 0 cards

let diff_cards old nw =
  (num_cards nw) - (num_cards old)


let error = "Player only chose 1 tickets, must take at least 2."
let error2 = "Can't setup when it is not the first turn."

let p_end =
  {
    color= PRed;
    destination_tickets = [];
    train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                   (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
    score = 18;
    routes = [];
    trains_remaining = 2;
    first_turn = false;
    last_turn = false;
    bot = false;
  }

let p5 = {p3 with color = PBlack}

let st1 = (decided_routes (init_state 2 0 |> setup_state) [0])
let st2 = (decided_routes (init_state 2 0 |> setup_state) [0; 1])
let st3 = (decided_routes (init_state 2 0 |> setup_state) [0; 1; 2])
let st3' = (decided_routes (st3 |> next_player |> setup_state) [0;1;2])
let st3'' = (st3' |> next_player)
let st4 = { player_index = 0;
            players = [p3; p4];
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
            last_round = false;
            winner = None;
            cards_grabbed = 0;
            success = ""}
let r8 = List.nth (Board.routes) 49
let st5 = {st4 with players = [p5; p3; p4]}

let fill_in r = match r with | (s1, s2, n, clr', _, b, lr) -> (s1, s2, n, clr', Some PYellow, b, lr)
let fill_in_blk r = match r with | (s1, s2, n, clr', _, b, lr) -> (s1, s2, n, clr', Some PBlack, b, lr)
let fill_in_red r = match r with | (s1, s2, n, clr', _, b, lr) -> (s1, s2, n, clr', Some PRed, b, lr)
let r_select = select_route st4 r None 0
let r'' = List.nth (r_select |> State.routes) 21
let r2 = List.nth (r_select |> State.routes) 9
let r2' = fill_in r2
let r3 = List.nth (r_select |> State.routes) 28
let r3' = fill_in r3
let r4 = fill_in (List.nth (r_select |> State.routes) 91)
let r5 = fill_in (List.nth (r_select |> State.routes) 45)
let r6 = fill_in (List.nth (r_select |> State.routes) 73)
let r7 = fill_in (List.nth (r_select |> State.routes) 71)

let tick = {loc1 = "Undergraduate Admissions";
            loc2  = "Risley";
            points = 15}
let p_end2 = {p_end with score = 15}
let p_end3 = {p_end with destination_tickets = [tick];
              color = PYellow;
                         routes = [r']}
let p_end4 = {p_end3 with destination_tickets = []}
let p_end5 = {p_end3 with routes = [r'; r2']}
let p_end6 = {p_end5 with routes = r3'::p_end5.routes}
let p_end7 = {p_end5 with routes = [r4;r5]}
let p_end8 = {p_end5 with routes = [r6;r7]}

let st_end = { player_index = 0;
               players = [p_end; p_end2];
               routes = Board.routes;
               destination_deck = DestinationDeck.init_deck ();
               destination_trash = DestinationDeck.init_trash;
               choose_destinations = [];
               train_deck = TrainDeck.init_deck ();
               facing_up_trains = TrainDeck.init_faceup ();
               train_trash = TrainDeck.init_trash;
               taking_routes = false;
               error = "";
               turn_ended = true;
               last_round = false;
               winner = None;
               cards_grabbed = 0;
               success = ""}
let st_end' = {st_end with players = [p_end; p_end3]}
let st_end'' = {st_end with players = [p_end; p_end4]}
let st_end_over st = st |> next_player |> draw_card_pile |> draw_card_pile |> next_player
                     |> draw_card_pile |> draw_card_pile |> next_player
let st_end2 = {st_end with players = [p_end5; p_end3]}
let st_end3 = {st_end with players = [p_end; p_end3; p_end5]}
let st_end4 = {st_end with players = [p_end6; p_end5]}
let st_end5 = {st_end with players = [p_end7; p_end8]}

let error3 = "You still need to grab another card from the pile or facing up cards."

let state_tests =
[
  (* init state *)
  "state1" >:: (fun _ -> assert_equal 45 (init_state 5 0 |> current_player |> trains_remaining));
  "state2" >:: (fun _ -> assert_equal 0 (init_state 5 0 |> current_player |> score));
  "state3" >:: (fun _ -> assert_equal [] (init_state 5 0 |> current_player |> destination_tickets));
  "state4" >:: (fun _ -> assert_equal [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                                       (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)]
                   (init_state 5 0 |> current_player |> train_cards));
  (* setup state *)
  "state5" >:: (fun _ -> assert_equal 3 (init_state 2 0 |> setup_state |> choose_destinations |> List.length));
  "state6" >:: (fun _ -> assert_equal 4 (diff_cards
                (init_state 2 0 |> current_player |> train_cards)
                (init_state 2 0 |> setup_state |> current_player |> train_cards)));
  "state7" >:: (fun _ -> assert_equal false (init_state 2 0 |> setup_state |> turn_ended));
  "state8" >:: (fun _ -> assert_equal true (st3 |> turn_ended));
  "state9" >:: (fun _ -> assert_equal true (st2 |> turn_ended));
  "state10" >:: (fun _ -> assert_equal false (st1 |> turn_ended));
  "state11" >:: (fun _ -> assert_equal error (st1 |> State.error));
  "state12" >:: (fun _ -> assert_equal false (st3 |> next_player |> turn_ended));
  "state13" >:: (fun _ -> assert_equal true (st3' |> turn_ended));
  "state14" >:: (fun _ -> assert_equal false (st3' |> current_player |> first_turn));
  "state15" >:: (fun _ -> assert_equal error2 (st3'' |> setup_state |> State.error));

  (* draw_card_pile *)
  "state16" >:: (fun _ -> assert_equal false (st3'' |> draw_card_pile |> turn_ended));
  "state17" >:: (fun _ -> assert_equal true (st3'' |> draw_card_pile |> draw_card_pile |> turn_ended));
  "state17" >:: (fun _ -> assert_equal "" (st3'' |> draw_card_pile |> State.error));
  "state18" >:: (fun _ -> assert_equal 1 (diff_cards
                (st3'' |> current_player |> train_cards)
                (st3'' |> draw_card_pile |> current_player |> train_cards)));

  (* draw_card_facing_up *)
  "state19" >:: (fun _ -> assert_equal false ((draw_card_facing_up st3'' 0) |> turn_ended));
  "state20" >:: (fun _ -> assert_equal error3 ((draw_card_facing_up st3'' 0) |> next_player |> State.error));
  "state21" >:: (fun _ -> assert_equal error3 ((draw_card_facing_up st3'' 0) |> take_route |> State.error));
  "state22" >:: (fun _ -> assert_equal true ((draw_card_facing_up st3'' 0) |> draw_card_pile |> turn_ended));
  "state23" >:: (fun _ -> assert_equal 2 (diff_cards
                (st3'' |> current_player |> train_cards)
                ((draw_card_facing_up (st3'' |> draw_card_pile) 1)|> current_player |> train_cards)));

  "state24" >:: (fun _ -> assert_equal true ((draw_card_facing_up (draw_card_facing_up st3'' 0) 1) |> turn_ended));
  (* select_route *)
  "state25" >:: (fun _ -> assert_equal ~-2 (diff_cards
                (st4 |> current_player |> train_cards)
                (select_route st4 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> current_player |> train_cards)));
  "state26" >:: (fun _ -> assert_equal true (same_lst
               ((dairy_bar,plantations,2,Green,Some PYellow, false, None)::(st4 |> current_player |> routes))
               (select_route st4 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> current_player |> routes)));
  "state27" >:: (fun _ -> assert_equal 20 (select_route st4 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> current_player |> score));
  "state28" >:: (fun _ -> assert_equal r' (List.nth (r_select |> State.routes) 21));
  "state29" >:: (fun _ -> assert_equal "Route already taken."
                    ((select_route (r_select |> next_player) r'' None 0) |> State.error));
  "state29" >:: (fun _ -> assert_equal true (same_lst
               ((dairy_bar,plantations,2,Green,Some PBlack, false, None)::(st5 |> current_player |> routes))
               (select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> current_player |> routes)));
  (* "state29-2" >:: (fun _ -> assert_equal (fill_in r8) (List.nth ((select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0) |> State.routes) 49)); *)
  "statetrial" >:: (fun _ -> assert_equal "" ((select_route ((select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0) |> next_player) r8 None 0) |> State.error));
  "state31" >:: (fun _ -> assert_equal true (same_lst
              ((fill_in r8)::((select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> next_player) |> current_player |> routes))
              ((select_route (select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0 |> next_player) r8 None 0) |> current_player |> routes)));
  "state32" >:: (fun _ -> assert_equal (fill_in r8) (List.nth ((select_route ((select_route st5 (dairy_bar,plantations,2,Green,None, false, None) None 0) |> next_player) r8 None 0) |> State.routes) 49));
  (* end game *)
  "state30" >:: (fun _ -> assert_equal true (st_end |> next_player |> last_round));
  "state31" >:: (fun _ -> assert_equal "" (st_end
                                             |> next_player
                                             |> draw_card_pile
                                             |> draw_card_pile
                                             |> next_player
                                             |> State.error));
  "state32" >:: (fun _ -> assert_equal "Game has ended." (st_end_over st_end
                                                          |> State.error));
  "state33" >:: (fun _ -> assert_equal (Some (List.nth (st_end_over st_end |> players) 0))
                    (st_end_over st_end |> winner));
  "state34" >:: (fun _ -> assert_equal (Some (List.nth (st_end_over st_end' |> players) 1))
                    (st_end_over st_end' |> winner));
  "state35" >:: (fun _ -> assert_equal (Some (List.nth (st_end_over st_end'' |> players) 1))
                    (st_end_over st_end'' |> winner));

  (* take_route *)
  "state36" >:: (fun _ -> assert_equal false (st3'' |> take_route |> turn_ended));
  "state37" >:: (fun _ -> assert_equal 3 (List.length (st3'' |> take_route |> choose_destinations)));
  "state38" >:: (fun _ -> assert_equal "Player only chose 0 tickets, must take at least 1."
                    ((decided_routes (st3'' |> take_route) []) |> State.error));
  "state39" >:: (fun _ -> assert_equal "" ((decided_routes (st3'' |> take_route) [0;1;2]) |> State.error));
  "state40" >:: (fun _ -> assert_equal true ((decided_routes (st3'' |> take_route) [0;1;2]) |> turn_ended));
  "state41" >:: (fun _ -> assert_equal [] ((decided_routes (st3'' |> take_route) [0;1;2]) |> choose_destinations));
  "state42" >:: (fun _ -> assert_equal ((List.nth (st3'' |> take_route |> choose_destinations) 0)::(st3'' |> current_player |> destination_tickets))
                    ((decided_routes (st3'' |> take_route) [0]) |> current_player |> destination_tickets));

  (* longest_route_player *)
  "state43" >:: (fun _ -> assert_equal 1 (st_end' |> longest_route_player));
  "state44" >:: (fun _ -> assert_equal 0 (st_end2 |> longest_route_player));
  "state45" >:: (fun _ -> assert_equal 2 (st_end3 |> longest_route_player));
  "state46" >:: (fun _ -> assert_equal 0 (st_end4 |> longest_route_player));
  "state47" >:: (fun _ -> assert_equal 0 (st_end5 |> longest_route_player));
]

(* let cpu =
  {
  color = PBlue;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                     (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45;
  first_turn = true;
  last_turn = false ;
  bot = true
   } *)


let ai_tests =
[
 (*  (* init_ai *)
  "ai1" >:: (fun _ -> assert_equal true (init_state 0 2 |> current_player |> is_bot));
  "ai2" >:: (fun _ -> assert_equal true (init_state 0 2 |> ai_setup |> turn_ended));
  "ai3" >:: (fun _ -> assert_equal false (init_state 0 2 |> ai_setup |> current_player |> first_turn));
  "ai4" >:: (fun _ -> assert_equal false (init_state 0 2 |> ai_setup |> current_player |> last_turn));
  "ai5" >:: (fun _ -> assert_equal 2 (init_state 0 2 |> ai_setup |> current_player |> destination_tickets |> List.length));
  "ai6" >:: (fun _ -> assert_equal 4 ((diff_cards
                (init_state 0 2 |> current_player |> train_cards)
                (init_state 0 2 |> setup_state |> current_player |> train_cards))));
  "ai7" >:: (fun _ -> assert_equal true (init_state 0 2 |> next_player |> current_player |> is_bot)); *)

]

let suite =
  "Ticket to Cornell test suite"
  >::: components_tests @ board_tests @ player_tests @ state_tests @ ai_tests

let _ = run_test_tt_main suite
