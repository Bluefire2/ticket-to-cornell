// Generated by BUCKLESCRIPT VERSION 3.0.0, PLEASE EDIT WITH CARE
'use strict';

var List = require("bs-platform/lib/js/list.js");
var Player = require("./player.bs.js");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Caml_int32 = require("bs-platform/lib/js/caml_int32.js");
var Components = require("./components.bs.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

function init_state(num) {
  var players = Player.init_players(num);
  return /* record */[
          /* player_index */0,
          /* players */players,
          /* routes : [] */0,
          /* destination_deck */Components.DestinationDeck[/* init_deck */2](/* () */0),
          /* destination_trash */Components.DestinationDeck[/* init_trash */3],
          /* choose_destinations : [] */0,
          /* train_deck */Components.TrainDeck[/* init_deck */1](/* () */0),
          /* facing_up_trains */Components.TrainDeck[/* init_faceup */6](/* () */0),
          /* train_trash */Components.TrainDeck[/* init_trash */2],
          /* taking_routes */false,
          /* error */""
        ];
}

function current_player(st) {
  return List.nth(st[/* players */1], st[/* player_index */0]);
}

function players(st) {
  return st[/* players */1];
}

function routes(st) {
  return st[/* routes */2];
}

function destination_items(st) {
  return /* tuple */[
          st[/* destination_deck */3],
          st[/* destination_trash */4]
        ];
}

function train_items(st) {
  return /* tuple */[
          st[/* train_deck */6],
          st[/* facing_up_trains */7],
          st[/* train_trash */8]
        ];
}

function message(st) {
  return st[/* error */10];
}

function score(st, _) {
  return Player.score(current_player(st));
}

function next_player(st) {
  return /* record */[
          /* player_index */Caml_int32.mod_(st[/* player_index */0] + 1 | 0, List.length(st[/* players */1])),
          /* players */st[/* players */1],
          /* routes */st[/* routes */2],
          /* destination_deck */st[/* destination_deck */3],
          /* destination_trash */st[/* destination_trash */4],
          /* choose_destinations */st[/* choose_destinations */5],
          /* train_deck */st[/* train_deck */6],
          /* facing_up_trains */st[/* facing_up_trains */7],
          /* train_trash */st[/* train_trash */8],
          /* taking_routes */st[/* taking_routes */9],
          /* error */st[/* error */10]
        ];
}

function update_players(i, new_p, lst) {
  var _i = 0;
  var new_i = i;
  var new_p$1 = new_p;
  var _acc = /* [] */0;
  var _param = lst;
  while(true) {
    var param = _param;
    var acc = _acc;
    var i$1 = _i;
    if (param) {
      var t = param[1];
      if (i$1 === new_i) {
        return Pervasives.$at(acc, Pervasives.$at(/* :: */[
                        new_p$1,
                        /* [] */0
                      ], t));
      } else {
        _param = t;
        _acc = Pervasives.$at(acc, /* :: */[
              param[0],
              /* [] */0
            ]);
        _i = i$1 + 1 | 0;
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function draw_card_facing_up(st, c) {
  var match = Components.TrainDeck[/* draw_faceup */7](st[/* train_deck */6], c, st[/* facing_up_trains */7], st[/* train_trash */8]);
  var p$prime = Player.draw_train_card(current_player(st), c);
  var i = st[/* player_index */0];
  return /* record */[
          /* player_index */st[/* player_index */0],
          /* players */update_players(i, p$prime, st[/* players */1]),
          /* routes */st[/* routes */2],
          /* destination_deck */st[/* destination_deck */3],
          /* destination_trash */st[/* destination_trash */4],
          /* choose_destinations */st[/* choose_destinations */5],
          /* train_deck */match[1],
          /* facing_up_trains */match[0],
          /* train_trash */match[2],
          /* taking_routes */st[/* taking_routes */9],
          /* error */st[/* error */10]
        ];
}

function draw_card_pile(st) {
  var tr = st[/* train_trash */8];
  var match = Components.TrainDeck[/* draw_card */3](st[/* train_deck */6], tr);
  var match$1 = Components.TrainDeck[/* draw_card */3](match[1], tr);
  var p$prime = Player.draw_train_card(current_player(st), match[0]);
  var p$prime$prime = Player.draw_train_card(p$prime, match$1[0]);
  var i = st[/* player_index */0];
  return /* record */[
          /* player_index */st[/* player_index */0],
          /* players */update_players(i, p$prime$prime, st[/* players */1]),
          /* routes */st[/* routes */2],
          /* destination_deck */st[/* destination_deck */3],
          /* destination_trash */st[/* destination_trash */4],
          /* choose_destinations */st[/* choose_destinations */5],
          /* train_deck */match$1[1],
          /* facing_up_trains */st[/* facing_up_trains */7],
          /* train_trash */match$1[2],
          /* taking_routes */st[/* taking_routes */9],
          /* error */st[/* error */10]
        ];
}

function take_route(st) {
  var deck = st[/* destination_deck */3];
  var tr = st[/* destination_trash */4];
  var match = Components.DestinationDeck[/* draw_card */4](deck, tr);
  return /* record */[
          /* player_index */st[/* player_index */0],
          /* players */st[/* players */1],
          /* routes */st[/* routes */2],
          /* destination_deck */match[1],
          /* destination_trash */st[/* destination_trash */4],
          /* choose_destinations */match[0],
          /* train_deck */st[/* train_deck */6],
          /* facing_up_trains */st[/* facing_up_trains */7],
          /* train_trash */st[/* train_trash */8],
          /* taking_routes */true,
          /* error */st[/* error */10]
        ];
}

function decided_routes(st, tickets) {
  if (List.length(tickets) > 1) {
    var p = current_player(st);
    var p$prime = Player.update_destination_tickets(p, tickets);
    var i = st[/* player_index */0];
    return /* record */[
            /* player_index */st[/* player_index */0],
            /* players */update_players(i, p$prime, st[/* players */1]),
            /* routes */st[/* routes */2],
            /* destination_deck */st[/* destination_deck */3],
            /* destination_trash */st[/* destination_trash */4],
            /* choose_destinations : [] */0,
            /* train_deck */st[/* train_deck */6],
            /* facing_up_trains */st[/* facing_up_trains */7],
            /* train_trash */st[/* train_trash */8],
            /* taking_routes */false,
            /* error */""
          ];
  } else {
    return /* record */[
            /* player_index */st[/* player_index */0],
            /* players */st[/* players */1],
            /* routes */st[/* routes */2],
            /* destination_deck */st[/* destination_deck */3],
            /* destination_trash */st[/* destination_trash */4],
            /* choose_destinations */st[/* choose_destinations */5],
            /* train_deck */st[/* train_deck */6],
            /* facing_up_trains */st[/* facing_up_trains */7],
            /* train_trash */st[/* train_trash */8],
            /* taking_routes */st[/* taking_routes */9],
            /* error */"Must at least take 1 ticket"
          ];
  }
}

function update_routes(routes, old_r, new_r) {
  var _acc = /* [] */0;
  var _param = routes;
  while(true) {
    var param = _param;
    var acc = _acc;
    if (param) {
      var t = param[1];
      if (Caml_obj.caml_equal(param[0], old_r)) {
        return Pervasives.$at(acc, /* :: */[
                    new_r,
                    t
                  ]);
      } else {
        _param = t;
        _acc = /* :: */[
          new_r,
          acc
        ];
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function check_cards(cards, n, clr) {
  var loop = function (_param) {
    while(true) {
      var param = _param;
      if (param) {
        var match = param[0];
        if (Caml_obj.caml_equal(match[0], clr)) {
          return match[1];
        } else {
          _param = param[1];
          continue ;
        }
      } else {
        return 0;
      }
    };
  };
  return loop(cards) === n;
}

function select_route(st, r) {
  var clr = r[3];
  if (r[4]) {
    return /* record */[
            /* player_index */st[/* player_index */0],
            /* players */st[/* players */1],
            /* routes */st[/* routes */2],
            /* destination_deck */st[/* destination_deck */3],
            /* destination_trash */st[/* destination_trash */4],
            /* choose_destinations */st[/* choose_destinations */5],
            /* train_deck */st[/* train_deck */6],
            /* facing_up_trains */st[/* facing_up_trains */7],
            /* train_trash */st[/* train_trash */8],
            /* taking_routes */st[/* taking_routes */9],
            /* error */"Route already taken"
          ];
  } else if (clr >= 9) {
    return /* record */[
            /* player_index */st[/* player_index */0],
            /* players */st[/* players */1],
            /* routes */st[/* routes */2],
            /* destination_deck */st[/* destination_deck */3],
            /* destination_trash */st[/* destination_trash */4],
            /* choose_destinations */st[/* choose_destinations */5],
            /* train_deck */st[/* train_deck */6],
            /* facing_up_trains */st[/* facing_up_trains */7],
            /* train_trash */st[/* train_trash */8],
            /* taking_routes */st[/* taking_routes */9],
            /* error */"Choose a train card color"
          ];
  } else {
    var st$1 = st;
    var r$1 = r;
    var clr$1 = clr;
    var cards = Player.train_cards(current_player(st$1));
    if (check_cards(cards, r$1[2], clr$1)) {
      var p$prime = Player.place_train(current_player(st$1), r$1);
      var i = st$1[/* player_index */0];
      var p_clr = p$prime[/* color */0];
      var r$prime_000 = r$1[0];
      var r$prime_001 = r$1[1];
      var r$prime_002 = r$1[2];
      var r$prime_003 = r$1[3];
      var r$prime_004 = /* Some */[p_clr];
      var r$prime = /* tuple */[
        r$prime_000,
        r$prime_001,
        r$prime_002,
        r$prime_003,
        r$prime_004
      ];
      return /* record */[
              /* player_index */st$1[/* player_index */0],
              /* players */update_players(i, p$prime, st$1[/* players */1]),
              /* routes */update_routes(st$1[/* routes */2], r$1, r$prime),
              /* destination_deck */st$1[/* destination_deck */3],
              /* destination_trash */st$1[/* destination_trash */4],
              /* choose_destinations */st$1[/* choose_destinations */5],
              /* train_deck */st$1[/* train_deck */6],
              /* facing_up_trains */st$1[/* facing_up_trains */7],
              /* train_trash */st$1[/* train_trash */8],
              /* taking_routes */st$1[/* taking_routes */9],
              /* error */""
            ];
    } else {
      return /* record */[
              /* player_index */st$1[/* player_index */0],
              /* players */st$1[/* players */1],
              /* routes */st$1[/* routes */2],
              /* destination_deck */st$1[/* destination_deck */3],
              /* destination_trash */st$1[/* destination_trash */4],
              /* choose_destinations */st$1[/* choose_destinations */5],
              /* train_deck */st$1[/* train_deck */6],
              /* facing_up_trains */st$1[/* facing_up_trains */7],
              /* train_trash */st$1[/* train_trash */8],
              /* taking_routes */st$1[/* taking_routes */9],
              /* error */"Not enough train cards"
            ];
    }
  }
}

function longest_route(st) {
  var first = List.hd(st[/* players */1]);
  var _plyrs = st[/* players */1];
  var _best = first;
  while(true) {
    var best = _best;
    var plyrs = _plyrs;
    if (List.length(plyrs) > 0) {
      var p = List.hd(plyrs);
      var rest = List.tl(plyrs);
      if (Player.score(p) > Player.score(best)) {
        _best = p;
        _plyrs = rest;
        continue ;
      } else {
        _plyrs = rest;
        continue ;
      }
    } else {
      return best;
    }
  };
}

exports.init_state = init_state;
exports.current_player = current_player;
exports.players = players;
exports.routes = routes;
exports.destination_items = destination_items;
exports.train_items = train_items;
exports.message = message;
exports.score = score;
exports.next_player = next_player;
exports.draw_card_pile = draw_card_pile;
exports.draw_card_facing_up = draw_card_facing_up;
exports.take_route = take_route;
exports.decided_routes = decided_routes;
exports.select_route = select_route;
exports.longest_route = longest_route;
/* No side effect */
