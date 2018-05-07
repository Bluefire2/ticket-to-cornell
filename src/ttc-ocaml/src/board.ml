open Components

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


let becker = ("House Becker", 0.,0.)
let bethe = ("House Bethe", 0.,0.)
let noyes = ("Noyes Community Center", 0.,0.)
let risley = ("Risley", 0.,0.)
let rpcc = ("RPCC", 0.,0.)
let helen_newman = ("Helen Newman", 0.,0.)
let appel = ("Appel Commons", 0.,0.)
let mcgraw = ("McGraw Tower", 0.,0.)
let wsh = ("Willard Straight Hall", 0.,0.)
let psb = ("Physical Sciences Building", 0.,0.)
let gannett = ("Cornell Health", 0.,0.)
let store = ("Cornell Store", 0.,0.)
let schwartz = ("Schwartz Center", 0.,0.)
let eddy = ("Eddy Gate", 0.,0.)
let casc = ("Cascadilla Gorge", 0.,0.)
let ctb = ("Collegetown Bagels", 0.,0.)
let olin = ("Olin Hall", 0.,0.)
let carpenter = ("Carpenter Hall", 0.,0.)
let rhodes = ("Rhodes Hall", 0.,0.)
let duffield = ("Duffield Hall", 0.,0.)
let statler = ("Statler Hotel", 0.,0.)
let uris = ("Uris Hall", 0.,0.)
let gates = ("Gates Hall", 0.,0.)
let klarman = ("Klarman Hall", 0.,0.)
let trillium = ("Trillium", 0.,0.)
let kennedy = ("Kennedy Hall", 0.,0.)
let warren = ("Warren Hall", 0.,0.)
let mann = ("Mann Library", 0.,0.)
let ives = ("Ives Hall", 0.,0.)
let barton = ("Barton Hall", 0.,0.)
let teagle = ("Teagle Hall", 0.,0.)
let schoellkopf = ("Schoellkopf Field", 0.,0.)
let dairy_bar = ("Dairy Bar", 0.,0.)
let mvr = ("Martha Van Rensselaer Hall", 0.,0.)
let barn = ("Big Red Barn", 0.,0.)
let bailey = ("Bailey Hall", 0.,0.)


let routes =
[
(becker,bethe,1,Grey,None);
(becker,bethe,1,Grey,None);
]