open OUnit2
open Components
open State
open Board
open Player


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
  {loc1 = "Hasbrouck Community Center"; loc2 = "Engineering Quad"; points = 16};
  {loc1 = "Appel Commons"; loc2 = "Schoellkopf Field"; points = 13};
  {loc1 = "Risley"; loc2 = "The Commons"; points = 13};
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


let rec eco_house = Location ("Ecology House", 574., 141., [rpcc; sigma_chi; a_lot; undergrad])
and a_lot = Location ("A LOT", 1051., 106., [eco_house; rpcc; hasbrouck; golf])
and golf = Location ("Golf Center", 1676., 187., [a_lot; hasbrouck; forest_home; arboretum])
and hasbrouck = Location ("Hasbrouck Community Center", 1408., 290., [a_lot; golf; appel; rpcc; forest_home])
and rpcc = Location ("RPCC", 1015.,322., [eco_house; a_lot; hasbrouck; ckb; undergrad])
and appel = Location ("Appel Commons", 1107.,539., [hasbrouck; ckb; rpcc; beebe; island; forest_home])
and mcgraw = Location ("McGraw Tower", 501.,1097., [noyes; engineering; becker; psb; kennedy])
and risley = Location ("Risley", 718.,579., [ckb; undergrad; beebe; psb; museum])
and eddy = Location ("Eddy Gate", 341.,1549., [engineering; commons; noyes; creek])
and noyes = Location ("Noyes Community Center", 338.,1189., [eddy; mcgraw; becker; commons])
and bartels = Location ("Bartels Hall",1094.,1256., [schoellkopf; kennedy; dairy_bar])
and schoellkopf = Location ("Schoellkopf Field", 940.,1400., [bartels; creek; barton; engineering; farm_barn; riley_robb])
and dairy_bar = Location ("Dairy Bar", 1486.,1078., [bartels; riley_robb; plantations; vet; kennedy])
and kennedy = Location ("Kennedy Hall", 893.,1021., [dairy_bar; mcgraw; mann; psb; barton; bartels])
and bridge = Location ("Stewart Ave Bridge", 184., 644., [museum; becker; undergrad; sigma_chi])
and museum = Location ("Johnson Museum", 428., 785., [undergrad; bridge; becker; psb; risley])
and sigma_chi = Location ("Sigma Chi", 95., 257., [eco_house; undergrad; bridge])
and undergrad = Location ("Undergraduate Admissions", 498., 498., [museum; sigma_chi; eco_house; risley; bridge; rpcc])
and ckb = Location ("CKB Quad", 934., 468., [rpcc; appel; risley])
and forest_home = Location ("Forest Home", 1673., 677., [golf; appel; filtration; arboretum; island; hasbrouck])
and beebe = Location ("Beebe Lake", 967., 699., [appel; risley; island])
and island = Location ("Werly Island", 1208., 780., [forest_home; beebe; plantations; appel; psb])
and psb = Location ("Physical Sciences Building", 726.,875., [mcgraw; risley; kennedy; museum; island; becker])
and mann = Location ("Mann Library", 1086.,972., [kennedy; plantations])
and engineering = Location ("Engineering Quad", 615., 1362., [mcgraw; eddy; schoellkopf; barton])
and commons = Location ("The Commons", 65., 1673., [eddy; noyes; becker])
and maplewood = Location ("Maplewood Park", 1156., 1671., [creek; farm_barn])
and vet = Location ("Veterinary School", 1863., 1107., [dairy_bar; filtration; arboretum; plantations; farm_barn; riley_robb])
and riley_robb = Location ("Riley-Robb Hall", 1430., 1245., [schoellkopf; dairy_bar; vet; farm_barn])
and barton = Location ("Barton Hall", 801.,1235., [schoellkopf; kennedy; engineering])
and farm_barn = Location ("Blair Farm Barn", 1562., 1492., [schoellkopf; maplewood; vet; riley_robb])
and plantations = Location ("Plantations", 1359., 845., [dairy_bar; island; mann; vet; filtration])
and arboretum = Location ("Newman Arboretum", 2028., 712., [golf; forest_home; vet; filtration])
and filtration = Location ("Filtration Plant", 1787., 858., [plantations; arboretum; forest_home; vet])
and creek = Location ("Cascadilla Creek", 842., 1579., [eddy; schoellkopf; maplewood])
and becker = Location ("House Becker", 198.,994., [mcgraw; noyes; bridge; museum; psb; commons])


let locations = [ eco_house; a_lot; golf; hasbrouck; rpcc; appel; mcgraw; risley;
                  eddy; noyes; bartels; schoellkopf; dairy_bar; kennedy; bridge;
                  museum; sigma_chi; undergrad; ckb; forest_home; beebe; island;
                  psb; mann; engineering; commons; maplewood; vet; riley_robb;
                  barton; farm_barn; plantations; arboretum; filtration; creek;
                  becker ]

let routes =
[
(ckb,appel,1,Grey,None);
(ckb,appel,1,Grey,None);
(dairy_bar,riley_robb,1,Grey,None);
(dairy_bar,riley_robb,1,Grey,None);
(rpcc,ckb,1,Grey,None);
(rpcc,ckb,1,Grey,None);
(rpcc,appel,1,Grey,None);
(island,plantations,1,Grey,None);
(island,plantations,1,Grey,None);
(ckb,risley,2,Blue,None);
(noyes,mcgraw,2,Grey,None);
(noyes,mcgraw,2,Grey,None);
(creek,schoellkopf,2,Grey,None);
(creek,schoellkopf,2,Grey,None);
(beebe,appel,2,Pink,None);
(engineering,barton,2,Grey,None);
(engineering,barton,2,Grey,None);
(beebe,island,2,Black,None);
(beebe,island,2,Orange,None);
(kennedy,mann,2,Grey,None);
(kennedy,mann,2,Grey,None);
(undergrad,risley,2,Green,None);
(undergrad,risley,2,White,None);
(dairy_bar,plantations,2,White,None);
(dairy_bar,plantations,2,Green,None);
(mann,plantations,2,Grey,None);
(barton,schoellkopf,2,Yellow,None);
(barton,schoellkopf,2,Red,None);
(undergrad,museum,2,Grey,None);
(psb,kennedy,2,Grey,None);
(psb,kennedy,2,Grey,None);
(schoellkopf,bartels,2,Grey,None);
(schoellkopf,bartels,2,Grey,None);
(engineering,schoellkopf,2,Grey,None);
(a_lot,rpcc,2,Grey,None);
(forest_home,filtration,2,Grey,None);
(museum,bridge,2,Grey,None);
(filtration,vet,2,Grey,None);
(becker,noyes,2,Grey,None);
(risley,beebe,2,Grey,None);
(kennedy,barton,2,Grey,None);
(mcgraw,engineering,2,Grey,None);
(becker,mcgraw,2,Grey,None);
(appel,island,2,Grey,None);
(kennedy,bartels,2,Grey,None);
(becker,museum,3,Yellow,None);
(becker,museum,3,Pink,None);
(eddy,engineering,3,Grey,None);
(hasbrouck,golf,3,Green,None);
(museum,psb,3,Red,None);
(museum,psb,3,Yellow,None);
(risley,psb,3,White,None);
(becker,bridge,3,Blue,None);
(commons,eddy,3,Black,None);
(creek,maplewood,3,Orange,None);
(creek,maplewood,3,Black,None);
(riley_robb,farm_barn,3,Grey,None);
(bartels,dairy_bar,3,Orange,None);
(bridge,undergrad,3,Pink,None);
(mcgraw,psb,3,Grey,None);
(dairy_bar,vet,3,Grey,None);
(plantations,filtration,3,Blue,None);
(becker,psb,3,Red,None);
(filtration,arboretum,3,Grey,None);
(museum,risley,3,Grey,None);
(schoellkopf,farm_barn,4,Yellow,None);
(a_lot,hasbrouck,4,Grey,None);
(arboretum,forest_home,4,Grey,None);
(appel,hasbrouck,4,Green,None);
(eddy,noyes,4,Blue,None);
(mcgraw,kennedy,4,Pink,None);
(psb,island,4,Red,None);
(island,forest_home,4,Yellow,None);
(island,forest_home,4,Orange,None);
(eco_house,rpcc,4,Red,None);
(rpcc,hasbrouck,4,Black,None);
(undergrad,rpcc,4,Blue,None);
(sigma_chi,undergrad,4,Pink,None);
(hasbrouck,forest_home,4,White,None);
(maplewood,farm_barn,4,Black,None);
(maplewood,farm_barn,4,Orange,None);
(arboretum,vet,5,Red,None);
(vet,plantations,5,White,None);
(eddy,creek,5,Yellow,None);
(undergrad,eco_house,5,Green,None);
(schoellkopf,riley_robb,5,Orange,None);
(schoellkopf,riley_robb,5,White,None);
(bridge,sigma_chi,5,Black,None);
(sigma_chi,eco_house,5,Green,None);
(sigma_chi,eco_house,5,Pink,None);
(riley_robb,vet,5,Blue,None);
(commons,becker,6,Blue,None);
(a_lot,golf,6,Yellow,None);
(golf,forest_home,6,Black,None);
(appel,forest_home,6,White,None);
(eco_house,a_lot,6,Green,None);
(commons,noyes,6,Orange,None);
(golf,arboretum,6,Grey,None);
(farm_barn,vet,6,Pink,None);
(kennedy,dairy_bar,6,Red,None);
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
trains_remaining = 45
}

let p2 =
{
color = PYellow;
destination_tickets = [];
train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
score = 0;
routes = [];
trains_remaining = 45
}

let default1 =
{
  color = PBlue;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45
}

let default2 =
{
  color = PRed;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45
}

let default3 =
{
  color = PYellow;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45
}

let default4 =
{
  color = PGreen;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45
}

let default5 =
{
  color = PBlack;
  destination_tickets = [];
  train_cards = [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                  (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)];
  score = 0;
  routes = [];
  trains_remaining = 45
}

let ppd =
{
color = PBlue;
destination_tickets = [{loc1 = "Plantations"; loc2 = "Bartels Hall"; points = 4}];
train_cards = [];
score = 90;
routes = [(dairy_bar,plantations,2,White,None); (bartels,dairy_bar,3,Orange,None)];
trains_remaining = 19
}




let tests =
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



  (* State Tests *)
  "state1" >:: (fun _ -> assert_equal 45 State.(init_state 5 |> current_player |> Player.trains_remaining));
  "state2" >:: (fun _ -> assert_equal 0 State.(init_state 5 |> State.current_player |> Player.score));
  "state3" >:: (fun _ -> assert_equal [] State.(init_state 5 |> current_player |> Player.destination_tickets));
  "state4" >:: (fun _ -> assert_equal [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                                       (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)] State.(init_state 5 |> current_player |> Player.train_cards));

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
    trains_remaining = 45
    })
    (Player.update_destination_tickets p1 [test1]));
  "update destination_tickets2" >:: (fun _ -> assert_equal
    ({
    color = PBlue;
    destination_tickets = [test1;gates;gates;toclass];
    train_cards = [(Red,1);(Blue,1);(Green,1);(Orange,1);(Yellow,1);(Pink,1);(Wild,1);(Black,1);(White,1)];
    score = 34;
    routes = [];
    trains_remaining = 45
    })
    (Player.update_destination_tickets p1 [test1;gates]));
  "update destination_tickets3" >:: (fun _ -> assert_equal
    ({
    color = PYellow;
    destination_tickets = [toclass];
    train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
    score = 0;
    routes = [];
    trains_remaining = 45
    })
    (Player.update_destination_tickets p2 [toclass]));
  "update destination_tickets4" >:: (fun _ -> assert_equal
    ({
    color = PYellow;
    destination_tickets = [toclass;gates;test1];
    train_cards = [(Red,0);(Blue,0);(Green,0);(Orange,0);(Yellow,0);(Pink,0);(Wild,0);(Black,0);(White,0)];
    score = 0;
    routes = [];
    trains_remaining = 45
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
  "init 2 players" >:: (fun _ -> assert_equal ([default2;default1]) (Player.init_players 2));
  "init 3 players" >:: (fun _ -> assert_equal ([default3;default2;default1]) (Player.init_players 3));
  "init 4 players" >:: (fun _ -> assert_equal ([default4;default3;default2;default1]) (Player.init_players 4));
  "init 5 players" >:: (fun _ -> assert_equal ([default5;default4;default3;default2;default1]) (Player.init_players 5));
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

  (* test place_trains after some routes are written. *)

  (* Board Tests *)
  "checking completed1" >:: (fun _ -> assert_equal (true)
    (Board.completed (List.hd ppd.destination_tickets).loc1 (List.hd ppd.destination_tickets).loc2 ppd.routes ));
  "checking completed2" >:: (fun _ -> assert_equal (false)
    (Board.completed "Plantations" "Bartels" default5.routes));
]

let suite =
  "Ticket to Cornell test suite"
  >::: tests

let _ = run_test_tt_main suite
