open Components

type location = Location of string * float * float * string list

type route = location * location * int * train_color * player_color option (* may need to change to be a list if more than one can be placed*)

let get_length (_,_,x,_,_) = x

let get_color (_,_,_,x,_) = x

let route_score r =
  match r with
  | (_,_,1,_,_) -> 1
  | (_,_,2,_,_) -> 2
  | (_,_,3,_,_) -> 4
  | (_,_,4,_,_) -> 7
  | (_,_,5,_,_) -> 10
  | (_,_,6,_,_) -> 15
  | _ -> failwith "Not possible; deal with later"

let is_taken r =
  match r with
  | (_,_,_,_,None) -> false
  | _ -> true

let rec eco_house = Location ("Ecology House", 574., 141., [])
and a_lot = Location ("A LOT", 1051., 106., [])
and golf = Location ("Golf Center", 1676., 187., [])
and hasbrouck = Location ("Hasbrouck Community Center", 1408., 290., [])
and rpcc = Location ("RPCC", 1015.,322., [])
and appel = Location ("Appel Commons", 1107.,539., [])
and mcgraw = Location ("McGraw Tower", 501.,1097., [])
and risley = Location ("Risley", 718.,579., [])
and eddy = Location ("Eddy Gate", 341.,1549., [])
and noyes = Location ("Noyes Community Center", 338.,1189., [])
and bartels = Location ("Bartels Hall",1094.,1256., [])
and schoellkopf = Location ("Schoellkopf Field", 940.,1400., [])
and dairy_bar = Location ("Dairy Bar", 1486.,1078., [])
and kennedy = Location ("Kennedy Hall", 893.,1021., [])
and bridge = Location ("Stewart Ave Bridge", 184., 644., [])
and museum = Location ("Johnson Museum", 428., 785., [])
and sigma_chi = Location ("Sigma Chi", 95., 257., [])
and undergrad = Location ("Undergraduate Admissions", 498., 498., [])
and ckb = Location ("CKB Quad", 934., 468., [])
and forest_home = Location ("Forest Home", 1673., 677., [])
and beebe = Location ("Beebe Lake", 967., 699., [])
and island = Location ("Werly Island", 1208., 780., [])
and psb = Location ("Physical Sciences Building", 726.,875., [])
and mann = Location ("Mann Library", 1086.,972., [])
and engineering = Location ("Engineering Quad", 615., 1362., [])
and commons = Location ("The Commons", 65., 1673., [])
and maplewood = Location ("Maplewood Park", 1156., 1671., [])
and vet = Location ("Veterinary School", 1863., 1107., [])
and riley_robb = Location ("Riley-Robb Hall", 1430., 1245., [])
and barton = Location ("Barton Hall", 801.,1235., [])
and farm_barn = Location ("Blair Farm Barn", 1562., 1492., [])
and plantations = Location ("Plantations", 1359., 845., [])
and arboretum = Location ("Newman Arboretum", 2028., 712., [])
and filtration = Location ("Filtration Plant", 1787., 858., [])
and creek = Location ("Cascadilla Creek", 842., 1579., [])
and becker = Location ("House Becker", 198.,994., [])

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

let name l = match l with | Location (x, _, _, _) -> x
let lst l = match l with | Location (_, _, _, x) -> x

let update_locations n neighbor locations =
  let rec loop acc = ( function
      | [] -> acc
      | Location (s, x, y, lst)::t ->
        if (s = n && not (List.mem neighbor lst)) then (
            ( loop (acc @ [Location (s, x, y,(neighbor::lst))]) t) )
        else
          loop (acc @ [Location (s, x, y, lst)]) t ) in
  loop [] locations


let locations =
  let rec loop acc = ( function
    | [] -> acc
    | (l1, l2, _, _, _)::t ->
      let n1 = name l1 in
      let n2 = name l2 in
      let loc = update_locations n1 n2 acc in
      loop (update_locations n2 n1 loc) t ) in
  loop locations routes
