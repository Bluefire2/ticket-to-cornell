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
  {loc1 = "Bailey Hall"; loc2 = "Dairy Bar"; points = 12};
  {loc1 = "McGraw Tower"; loc2 = "Eddy Gate"; points = 8};
  {loc1 = "Appel Commons"; loc2 = "Schoellkopf Field"; points = 13};
  {loc1 = "RPCC"; loc2 = "Duffield Hall"; points = 12};
  {loc1 = "House Becker"; loc2 = "Appel Commons"; points = 20};
  {loc1 = "Kennedy Hall"; loc2 = "Olin Hall"; points = 9};
  {loc1 = "Martha Van Rensselaer Hall"; loc2 = "Teagle Hall"; points = 6};
  {loc1 = "House Bethe"; loc2 = "Eddy Gate"; points = 9};
  {loc1 = "Eddy Gate"; loc2 = "Kennedy Hall"; points = 16};
  {loc1 = "Noyes Community Center"; loc2 = "Eddy Gate"; points = 11};
  {loc1 = "Risley"; loc2 = "Cornell Health"; points = 7};
  {loc1 = "Appel Commons"; loc2 = "Teagle Hall"; points = 9};
  {loc1 = "Risley"; loc2 = "Eddy Gate"; points = 13};
  {loc1 = "RPCC"; loc2 = "Gates Hall"; points = 11};
  {loc1 = "Physical Sciences Building"; loc2 = "Duffield Hall"; points = 8};
  {loc1 = "Uris Hall"; loc2 = "Duffield Hall"; points = 5};
  {loc1 = "Eddy Gate"; loc2 = "Martha Van Rensselaer Hall"; points = 21};
  {loc1 = "Schwartz Center"; loc2 = "Teagle Hall"; points = 17};
  {loc1 = "Willard Straight Hall"; loc2 = "Mann Library"; points = 11};
  {loc1 = "Noyes Community Center"; loc2 = "Ives Hall"; points = 17};
  {loc1 = "House Becker"; loc2 = "Olin Hall"; points = 13};
  {loc1 = "Kennedy Hall"; loc2 = "Schoellkopf Field"; points = 12};
  {loc1 = "Willard Straight Hall"; loc2 = "Carpenter Hall"; points = 4};
  {loc1 = "Physical Sciences Building"; loc2 = "Carpetner Hall"; points = 10};
  {loc1 = "Helen Newman Hall"; loc2 = "Ives Hall"; points = 12};
  {loc1 = "Eddy Gate"; loc2 = "Dairy Bar"; points = 20};
  {loc1 = "Warren Hall"; loc2 = "Dairy Bar"; points = 10};
  {loc1 = "Rhodes Hall"; loc2 = "Martha Van Rensselaer Hall"; points = 11};
  {loc1 = "House Bethe"; loc2 = "Martha Van Rensselaer Hall"; points = 22};
  {loc1 = "Helen Newman Hall"; loc2 = "Statler Hall"; points = 9};

]

let test_list1 =
[ Red; Red; Red]

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

  "draw faceup" >:: (fun _ -> assert_equal ([Red],[Blue;Green;Red;Pink],[]) (Components.TrainDeck.draw_faceup [Red;Blue;Green;Red;Pink] Red [Red] [] ));
  "draw faceup deck empty" >:: (fun _ -> assert_equal ([Red],[Red;Red],[]) (Components.TrainDeck.draw_faceup [] Red [Red] [Red;Red;Red] ));
  "draw faceup causing redo" >:: (fun _ -> assert_equal ([Pink;Blue;Green;Yellow;Orange], [], [Red;Red;Blue;Red;Yellow])
    (Components.TrainDeck.draw_faceup [Red;Pink;Blue;Green;Yellow;Orange] Green [Red;Blue;Green;Red;Yellow] []));




  (* checked [init_faceup] in utop. It shuffles every time, with no more than two of the
   * same card showing at a given time. *)





  (* DestinationDeck Tests *)
  "draw card" >:: (fun _ -> assert_equal (get_top_3 dest_ticket_deck,
                                          drop 3 dest_ticket_deck) (Components.DestinationDeck.draw_card dest_ticket_deck []));

  (* State Tests *)
  "state1" >:: (fun _ -> assert_equal 45 State.(init_state 5 |> current_player |> Player.trains_remaining));
  "state2" >:: (fun _ -> assert_equal 0 State.(init_state 5 |> State.current_player |> Player.score));
  "state3" >:: (fun _ -> assert_equal [] State.(init_state 5 |> current_player |> Player.destination_tickets));
  "state4" >:: (fun _ -> assert_equal [(Red,0);(Blue,0);(Green,0);(Yellow,0);
                                       (Black,0);(White,0);(Pink,0);(Wild,0);(Orange,0)] State.(init_state 5 |> current_player |> Player.train_cards));

]

let suite =
  "Ticket to Cornell test suite"
  >::: tests

let _ = run_test_tt_main suite
