open Components

type location = string * float * float

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
let bartels = ("Bartels Hall",0.,0.)


let routes =
[
(becker,bethe,1,Grey,None);
(becker,bethe,1,Grey,None);
(becker,risley,3,Grey,None);
(bethe,noyes,1,Grey,None);
(bethe,noyes,1,Grey,None);
(bethe,risley,4,Grey,None);
(bethe,mcgraw,6,Yellow,None);
(noyes,schwartz,5,Green,None);
(noyes,schwartz,5,Pink,None);
(noyes,gannett,6,Blue,None);
(schwartz,eddy,3,Yellow,None);
(schwartz,eddy,3,Pink,None);
(schwartz,gannett,5,Orange,None);
(schwartz,gannett,5,White,None);
(eddy,casc,2,Grey,None);
(eddy,ctb,3,Grey,None);
(eddy,carpenter,6,Black,None);
(casc,gannett,3,Orange,None);
(gannett,mcgraw,3,Pink,None);
(gannett,wsh,3,Red,None);
(gannett,wsh,3,Yellow,None);
(risley,mcgraw,4,Grey,None);
(risley,rpcc,6,White,None);
(mcgraw,wsh,4,Green,None);
(mcgraw,klarman,5,Red,None);
(mcgraw,psb,6,Orange,None);
(mcgraw,rpcc,4,Blue,None);
(wsh,store,4,Pink,None);
(wsh,uris,4,Black,None);
(wsh,uris,4,Orange,None);
(wsh,statler,4,Red,None);
(wsh,olin,2,Grey,None);
(wsh,ctb,5,White,None);
(ctb,olin,3,Grey,None);
(ctb,carpenter,3,Grey,None);
(olin,carpenter,2,Grey,None);
(olin,statler,3,Blue,None);
(carpenter,statler,5,Yellow,None);
(carpenter,rhodes,4,Red,None);
(carpenter,duffield,6,Green,None);
(rpcc,psb,4,Black,None);
(rpcc,helen_newman,6,Grey,None);
(psb,klarman,2,Grey,None);
(psb,klarman,2,Grey,None);
(psb,kennedy,3,Red,None);
(psb,warren,6,Pink,None);
(psb,helen_newman,3,Grey,None);
(klarman,uris,1,Grey,None);
(klarman,uris,1,Grey,None);
(klarman,kennedy,4,Blue,None);
(uris,statler,2,Grey,None);
(uris,statler,2,Grey,None);
(uris,trillium,2,Blue,None);
(uris,trillium,2,Pink,None);
(statler,rhodes,2,Grey,None);
(statler,rhodes,2,Grey,None);
(statler,gates,2,Grey,None);
(rhodes,duffield,1,Grey,None);
(rhodes,duffield,1,Grey,None);
(rhodes,gates,2,Grey,None);
(duffield,schoellkopf,2,Grey,None);
(helen_newman,appel,5,Black,None);
(helen_newman,warren,2,Grey,None);
(warren,kennedy,4,White,None);
(warren,mann,2,Grey,None);
(warren,appel,3,Grey,None);
(kennedy,trillium,2,Green,None);
(kennedy,trillium,2,White,None);
(kennedy,mann,3,Orange,None);
(kennedy,mann,3,Black,None);
(trillium,gates,2,Grey,None);
(trillium,ives,2,Grey,None);
(trillium,mann,5,Green,None);
(gates,schoellkopf,3,Green,None);
(gates,ives,3,White,None);
(schoellkopf,teagle,4,Yellow,None);
(schoellkopf,teagle,4,Orange,None);
(schoellkopf,dairy_bar,6,Red,None);
(appel,mvr,3,Blue,None);
(appel,bailey,2,Grey,None);
(appel,bailey,2,Grey,None);
(bailey,mvr,2,Yellow,None);
(bailey,mvr,2,Red,None);
(mann,ives,4,Yellow,None);
(mann,barton,2,Grey,None);
(mann,barn,2,Grey,None);
(mann,mvr,2,White,None);
(mann,mvr,2,Green,None);
(ives,teagle,1,Grey,None);
(ives,barton,3,Black,None);
(teagle,dairy_bar,5,Blue,None);
(teagle,bartels,2,Grey,None);
(teagle,barton,2,Grey,None);
(teagle,barton,2,Grey,None);
(mvr,barn,2,Black,None);
(mvr,barn,2,Orange,None);
(barn,barton,2,Grey,None);
(barn,barton,2,Grey,None);
(barton,bartels,2,Grey,None);
(bartels,dairy_bar,4,Pink,None);
]
