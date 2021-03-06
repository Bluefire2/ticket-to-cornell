open Components

type location = Location of string * float * float * string list

type leftRightRoute = LeftRoute | RightRoute

type route = location * location * int * train_color * player_color option * bool * leftRightRoute option

let get_length (_,_,x,_,_,_,_) = x

let get_color (_,_,_,x,_,_,_) = x

let get_player (_,_,_,_,x,_,_) = x

(* [contains x] checks to see if an element [x] is contained in a list. *)
let rec contains x = function
  | [] -> false
  | h::t -> if h=x then true else contains x t

let route_score r =
  match r with
  | (_,_,1,_,_,_,_) -> 1
  | (_,_,2,_,_,_,_) -> 2
  | (_,_,3,_,_,_,_) -> 4
  | (_,_,4,_,_,_,_) -> 7
  | (_,_,5,_,_,_,_) -> 10
  | (_,_,6,_,_,_,_) -> 15
  | _ -> failwith "Not possible"

let is_taken r =
  match r with
  | (_,_,_,_,None,_,_) -> false
  | _ -> true

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

let locations = [ eco_house; a_lot; golf; hasbrouck; rpcc; appel; mcgraw; risley;
                  eddy; noyes; bartels; schoellkopf; dairy_bar; kennedy; bridge;
                  museum; sigma_chi; undergrad; ckb; forest_home; beebe; island;
                  psb; mann; engineering; commons; maplewood; vet; riley_robb;
                  barton; farm_barn; plantations; arboretum; filtration; creek;
                  becker ]

let name l = match l with | Location (x, _, _, _) -> x

(* [lst l] returns the neighbors of a given location.*)
let lst l = match l with | Location (_, _, _, x) -> x

(* Routes which are later filled in to become [routes] below. *)
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
    (plantations,mann,2,Grey,None, true, Some LeftRoute);
    (plantations,mann,2,Grey,None, true, Some RightRoute);
    (undergrad,risley,2,Green,None, true, Some LeftRoute);
    (undergrad,risley,2,White,None, true, Some RightRoute);
    (dairy_bar,plantations,2,White,None, true, Some LeftRoute);
    (dairy_bar,plantations,2,Green,None, true, Some RightRoute);
    (mann,kennedy,2,Grey,None, false, None);
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

(* [update_locations n nei locs] add [nei] to the locations with name [n] in
 * [locs]. *)
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
    | (l1, l2, _, _, _, _, _)::t ->
      let n1 = name l1 in
      let n2 = name l2 in
      let loc = update_locations n1 n2 acc in
      loop (update_locations n2 n1 loc) t ) in
  loop locations route_connections

(* [get_location s locs] is the location with name [s] in [locs].
 * raise: "not found" if [s] not in [locs]. *)
let rec get_location s locations =
  let rec loop = ( function
      | [] -> failwith "not found"
      | (Location (s', x, y, lst))::t ->
        if s' = s then (Location (s', x, y, lst))
        else loop t ) in
  loop locations

let routes =
  let rec loop acc = function
    | [] -> acc
    | (l1, l2, pts, clr, ply, double, lr)::t ->
      let n1 = name l1 in
      let n2 = name l2 in
      let new_r = ((get_location n1 locations), (get_location n2 locations),
                   pts, clr, ply, double, lr) in
      loop (acc @ [new_r]) t in
  loop [] route_connections

let get_string (Location (s, _,_,_)) = s

let get_neighbors (Location (_,_,_,x)) = x

(* [get_route s1 s2 routes] returns a route that connects the two locations.
 * requires: s1 and s2 are adjacent to each other. If they are not adjacent,
 * raises impossible. *)
let rec get_route s1 s2 routes =
  match routes with
  | [] -> failwith "impossible"
  | (x,y,a,b,c,n,lr)::t -> if (s1 = get_string x) && (s2 = get_string y) ||
  (s1 = get_string y) && (s2 = get_string x) then (x,y,a,b,c,n,lr) else
  get_route s1 s2 t

(* [distance a b] calculates the coordinate distance formula between two points. *)
let distance a b = match a with
  | Location (_,x1,y1,_) -> ( match b with
                      | Location (_,x2,y2,_) -> sqrt ((x2 -. x1)**2. +. (y2 -. y1)**2.) )

let rec get_next_loc l1 goal acc count visited = function
  | [] -> acc
  | h::t -> if contains h visited then get_next_loc l1 goal acc count visited t else
    let e = (get_location goal locations) in
    let coor = get_location h locations in
    if (((distance coor e) < count) || count = -1.) then get_next_loc l1 goal (Some h) (distance coor e) visited t else
    get_next_loc l1 goal acc count visited t

(* [get_val] returns the value of an option. Raises Not_available if None. *)
let get_val = function
    | None ->  raise (Failure "Not_available")
    | Some x -> x

let rec get_paths s1 s2 acc =
    if s1 = s2 then (s2::acc) else
    let l1 = get_location s1 locations in
    let next_loc = get_val (get_next_loc l1 s2 None (-1.) acc (get_neighbors l1) ) in
    get_paths next_loc s2 (s1::acc)

let rec path_routes (rts:route list) paths = match paths with
  | [] -> []
  | h1::h2::t -> (get_route h1 h2 rts)::(path_routes rts (h2::t))
  | _::t -> []

let rec completed loc1 loc2 routes prev =
    match routes with
    | [] -> false
    | h::t -> ( match h with
        | ((Location (l1,_,_,_)),(Location (l2,_,_,_)),_,_,_,_,_) ->
          if loc1 = l1 then
            if loc2 = l2 then true else
              completed l2 loc2 t (h::prev) || completed l2 loc2 prev [] || completed loc1 loc2 t (h::prev)
          else
          if loc1 = l2 then
            if loc2 = l1 then true else
              completed l1 loc2 t (h::prev) || completed l1 loc2 prev [] || completed loc1 loc2 t (h::prev)
          else
          if loc2 = l1 then
            if loc1 = l2 then true else
              completed loc1 l2 t (h::prev) || completed loc1 l2 prev [] || completed loc1 loc2 t (h::prev)
          else
          if loc2 = l2 then
            if loc1 = l1 then true else
              completed loc1 l1 t (h::prev) || completed loc1 l1 prev [] || completed loc1 loc2 t (h::prev)
          else
              completed loc1 loc2 t (h::prev) )
