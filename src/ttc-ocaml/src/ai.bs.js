// Generated by BUCKLESCRIPT VERSION 3.0.0, PLEASE EDIT WITH CARE
'use strict';

var List = require("bs-platform/lib/js/list.js");
var Board = require("./board.bs.js");
var Js_exn = require("bs-platform/lib/js/js_exn.js");
var Random = require("bs-platform/lib/js/random.js");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");
var Caml_builtin_exceptions = require("bs-platform/lib/js/caml_builtin_exceptions.js");

function max(a, b, c) {
  return Caml_obj.caml_max(c, Caml_obj.caml_max(a, b));
}

function min(a, b, c) {
  return Caml_obj.caml_min(c, Caml_obj.caml_min(a, b));
}

function ai_setup(_, dlist) {
  if (dlist) {
    var match = dlist[1];
    if (match) {
      var match$1 = match[1];
      if (match$1 && !match$1[1]) {
        var match$2 = match[0];
        var d = match$2[/* loc2 */1];
        var c = match$2[/* loc1 */0];
        var match$3 = dlist[0];
        var b = match$3[/* loc2 */1];
        var a = match$3[/* loc1 */0];
        if (a === c || a === d || b === c || b === d) {
          return /* :: */[
                  0,
                  /* :: */[
                    1,
                    /* [] */0
                  ]
                ];
        } else {
          var match$4 = match$1[0];
          var f = match$4[/* loc2 */1];
          var e = match$4[/* loc1 */0];
          if (a === e || a === f || b === e || b === f) {
            return /* :: */[
                    0,
                    /* :: */[
                      2,
                      /* [] */0
                    ]
                  ];
          } else if (c === e || c === f || d === e || d === f) {
            return /* :: */[
                    1,
                    /* :: */[
                      2,
                      /* [] */0
                    ]
                  ];
          } else {
            var z = match$4[/* points */2];
            var y = match$2[/* points */2];
            var x = match$3[/* points */2];
            if (max(x, y, z) === x && min(x, y, z) === y) {
              return /* :: */[
                      0,
                      /* :: */[
                        1,
                        /* [] */0
                      ]
                    ];
            } else if (max(x, y, z) === x && min(x, y, z) === z) {
              return /* :: */[
                      0,
                      /* :: */[
                        2,
                        /* [] */0
                      ]
                    ];
            } else {
              return /* :: */[
                      1,
                      /* :: */[
                        2,
                        /* [] */0
                      ]
                    ];
            }
          }
        }
      } else {
        return Pervasives.failwith("not possible");
      }
    } else {
      return Pervasives.failwith("not possible");
    }
  } else {
    return Pervasives.failwith("not possible");
  }
}

function get_val(param) {
  if (param) {
    return param[0];
  } else {
    throw [
          Caml_builtin_exceptions.failure,
          "Not_available"
        ];
  }
}

function contains(x, _param) {
  while(true) {
    var param = _param;
    if (param) {
      if (Caml_obj.caml_equal(param[0], x)) {
        return true;
      } else {
        _param = param[1];
        continue ;
      }
    } else {
      return false;
    }
  };
}

function check_faceup(_clist, faceup) {
  while(true) {
    var clist = _clist;
    if (clist) {
      var h = clist[0];
      if (contains(h, faceup) || h === /* Grey */9) {
        return true;
      } else {
        _clist = clist[1];
        continue ;
      }
    } else {
      return false;
    }
  };
}

function priorize_build(_count, _acc, _param) {
  while(true) {
    var param = _param;
    var acc = _acc;
    var count = _count;
    if (param) {
      var h = param[0];
      var l = h[2];
      var t = param[1];
      _param = t;
      if (l > count) {
        _acc = /* Some */[h];
        _count = l;
        continue ;
      } else {
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function only_color(c, _param) {
  while(true) {
    var param = _param;
    if (param) {
      var match = param[0];
      if (Caml_obj.caml_equal(c, match[0])) {
        return match[1];
      } else {
        _param = param[1];
        continue ;
      }
    } else {
      return 0;
    }
  };
}

function extract_hand_colors(c, _acc, _param) {
  while(true) {
    var param = _param;
    var acc = _acc;
    if (param) {
      var t = param[1];
      var match = param[0];
      var c$prime = match[0];
      _param = t;
      if (c === c$prime || c$prime === /* Wild */8) {
        _acc = acc + match[1] | 0;
        continue ;
      } else {
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function desired_colors(_goal_routes, p, _acc) {
  while(true) {
    var acc = _acc;
    var goal_routes = _goal_routes;
    if (goal_routes) {
      var t = goal_routes[1];
      var match = goal_routes[0];
      var c = match[3];
      if (match[4] === /* None */0 && (match[2] - extract_hand_colors(c, 0, p[/* train_cards */2]) | 0) > 0) {
        _acc = /* :: */[
          c,
          acc
        ];
        _goal_routes = t;
        continue ;
      } else {
        _goal_routes = t;
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function extract_goal(rts) {
  var last_el = List.nth(rts, List.length(rts) - 1 | 0);
  return Board.get_string(last_el[1]);
}

function extract_strings(rts) {
  if (rts) {
    var match = rts[0];
    return /* :: */[
            match[1][0],
            /* :: */[
              match[0][0],
              extract_strings(rts[1])
            ]
          ];
  } else {
    return /* [] */0;
  }
}

function enough_cards(_hand, n) {
  while(true) {
    var hand = _hand;
    if (hand) {
      if (Caml_obj.caml_greaterequal(hand[0][1], n)) {
        return true;
      } else {
        _hand = hand[1];
        continue ;
      }
    } else {
      return false;
    }
  };
}

function best_paths(param) {
  if (param) {
    var match = param[0];
    return /* :: */[
            Board.get_paths(match[/* loc1 */0], match[/* loc2 */1], /* [] */0),
            best_paths(param[1])
          ];
  } else {
    return /* [] */0;
  }
}

function best_routes(st_routes, param) {
  if (param) {
    return /* :: */[
            Board.path_routes(st_routes, param[0]),
            best_routes(st_routes, param[1])
          ];
  } else {
    return /* [] */0;
  }
}

function other_player(p, param) {
  var x = param[4];
  if (x) {
    return Caml_obj.caml_notequal(/* Some */[p[/* color */0]], x);
  } else {
    return false;
  }
}

function check_routes(p, st_routes, _rts, _acc) {
  while(true) {
    var acc = _acc;
    var rts = _rts;
    if (rts) {
      var rt = rts[0];
      if (other_player(p, rt)) {
        var goal = extract_goal(rts);
        var l1 = rt[0];
        try {
          var new_l = get_val(Board.get_next_loc(l1, goal, /* None */0, -1, /* :: */[
                    Board.get_string(rt[1]),
                    extract_strings(acc)
                  ], Board.get_neighbors(l1)));
          var new_path = Board.get_paths(new_l, goal, extract_strings(acc));
          var reroute = Board.path_routes(st_routes, new_path);
          return check_routes(p, st_routes, reroute, /* [] */0);
        }
        catch (raw_exn){
          var exn = Js_exn.internalToOCamlException(raw_exn);
          if (exn[0] === Caml_builtin_exceptions.failure) {
            return /* [] */0;
          } else {
            throw exn;
          }
        }
      } else {
        _acc = /* :: */[
          rt,
          acc
        ];
        _rts = rts[1];
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function check_routes_list(p, st_routes, rtss) {
  if (rtss) {
    return /* :: */[
            check_routes(p, st_routes, rtss[0], /* [] */0),
            check_routes_list(p, st_routes, rtss[1])
          ];
  } else {
    return /* :: */[
            /* [] */0,
            /* [] */0
          ];
  }
}

function count_route(p, _rts) {
  while(true) {
    var rts = _rts;
    if (rts) {
      var t = rts[1];
      var match = rts[0];
      if (Caml_obj.caml_equal(match[4], /* Some */[p[/* color */0]])) {
        _rts = t;
        continue ;
      } else {
        return match[2] + count_route(p, t) | 0;
      }
    } else {
      return 0;
    }
  };
}

function dest_ticket_helper(_clist, st_routes, _acc, p, _n) {
  while(true) {
    var n = _n;
    var acc = _acc;
    var clist = _clist;
    if (clist) {
      var h = clist[0];
      var y = h[/* loc2 */1];
      var x = h[/* loc1 */0];
      var t = clist[1];
      if (Board.completed(x, y, st_routes, /* [] */0)) {
        _n = n + 1 | 0;
        _acc = Pervasives.$at(acc, /* :: */[
              n,
              /* [] */0
            ]);
        _clist = t;
        continue ;
      } else {
        var path = Board.get_paths(x, y, /* [] */0);
        var pathroute = Board.path_routes(st_routes, path);
        var confirmed = check_routes(p, st_routes, pathroute, /* [] */0);
        if (count_route(p, confirmed) > p[/* trains_remaining */5]) {
          _n = n + 1 | 0;
          _clist = t;
          continue ;
        } else if (count_route(p, confirmed) >= 9) {
          _n = n + 1 | 0;
          _acc = Pervasives.$at(acc, /* :: */[
                n,
                /* [] */0
              ]);
          _clist = t;
          continue ;
        } else {
          _n = n + 1 | 0;
          _clist = t;
          continue ;
        }
      }
    } else {
      return acc;
    }
  };
}

function get_smallest_path(_clist, st_routes, p, _count, _acc, _n) {
  while(true) {
    var n = _n;
    var acc = _acc;
    var count = _count;
    var clist = _clist;
    if (clist) {
      var h = clist[0];
      var t = clist[1];
      var path = Board.get_paths(h[/* loc1 */0], h[/* loc2 */1], /* [] */0);
      var pathroute = Board.path_routes(st_routes, path);
      var confirmed = check_routes(p, st_routes, pathroute, /* [] */0);
      var num = count_route(p, confirmed);
      _n = n + 1 | 0;
      if (num < count) {
        _acc = n;
        _count = num;
        _clist = t;
        continue ;
      } else {
        _clist = t;
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function ai_take_dticket(p, rts, dest_choice) {
  var keep = dest_ticket_helper(dest_choice, rts, /* [] */0, p, 0);
  if (List.length(keep) === 0) {
    var min_path = get_smallest_path(dest_choice, rts, p, 0, -1, 0);
    if (min_path > p[/* trains_remaining */5]) {
      return Pervasives.failwith("impossible");
    } else {
      return /* :: */[
              min_path,
              /* [] */0
            ];
    }
  } else {
    return keep;
  }
}

function place_on_grey(len, _hand) {
  while(true) {
    var hand = _hand;
    if (hand) {
      var c = hand[0][0];
      if (extract_hand_colors(c, 0, hand) >= len) {
        return c;
      } else {
        _hand = hand[1];
        continue ;
      }
    } else {
      return Pervasives.failwith("not possible");
    }
  };
}

function can_build(_goal_routes, p) {
  while(true) {
    var goal_routes = _goal_routes;
    if (goal_routes) {
      var h = goal_routes[0];
      var c = h[3];
      var l = h[2];
      var t = goal_routes[1];
      if (h[4] === /* None */0 && extract_hand_colors(c, 0, p[/* train_cards */2]) === l || c === /* Grey */9 && enough_cards(p[/* train_cards */2], l)) {
        return /* :: */[
                h,
                can_build(t, p)
              ];
      } else {
        _goal_routes = t;
        continue ;
      }
    } else {
      return /* [] */0;
    }
  };
}

function ai_place_train(cpu, rts) {
  var goal_routes = best_routes(rts, best_paths(cpu[/* destination_tickets */1]));
  var routes = check_routes_list(cpu, rts, goal_routes);
  var goal_routes$1 = List.flatten(routes);
  var build_options = can_build(goal_routes$1, cpu);
  var build = get_val(priorize_build(0, /* None */0, build_options));
  var color = Board.get_color(build);
  if (color === /* Grey */9) {
    var choose_color = place_on_grey(Board.get_length(build), cpu[/* train_cards */2]);
    if (only_color(choose_color, cpu[/* train_cards */2]) < Board.get_length(build)) {
      return /* tuple */[
              build,
              choose_color,
              Board.get_length(build) - only_color(choose_color, cpu[/* train_cards */2]) | 0
            ];
    } else {
      return /* tuple */[
              build,
              choose_color,
              0
            ];
    }
  } else if (only_color(color, cpu[/* train_cards */2]) < Board.get_length(build)) {
    return /* tuple */[
            build,
            color,
            Board.get_length(build) - only_color(color, cpu[/* train_cards */2]) | 0
          ];
  } else {
    return /* tuple */[
            build,
            color,
            0
          ];
  }
}

function ai_facing_up(p, rts, faceup) {
  var goal_routes = best_routes(rts, best_paths(p[/* destination_tickets */1]));
  var routes = check_routes_list(p, rts, goal_routes);
  var goal_routes$1 = List.flatten(routes);
  var colors = desired_colors(goal_routes$1, p, /* [] */0);
  var match = priorize_build(0, /* None */0, goal_routes$1);
  if (match) {
    var c = match[0][3];
    if (contains(c, faceup)) {
      var _n = 0;
      var c$1 = c;
      var _param = faceup;
      while(true) {
        var param = _param;
        var n = _n;
        if (param) {
          if (Caml_obj.caml_equal(param[0], c$1)) {
            return n;
          } else {
            _param = param[1];
            _n = n + 1 | 0;
            continue ;
          }
        } else {
          return Pervasives.failwith("out of bounds");
        }
      };
    } else {
      var _colors = colors;
      var faceup$1 = faceup;
      var _n$1 = 0;
      while(true) {
        var n$1 = _n$1;
        var colors$1 = _colors;
        if (contains(/* Grey */9, colors$1)) {
          return Random.$$int(5);
        } else if (faceup$1 && !contains(faceup$1[0], colors$1)) {
          _n$1 = n$1 + 1 | 0;
          _colors = faceup$1[1];
          continue ;
        } else {
          return n$1;
        }
      };
    }
  } else {
    throw [
          Caml_builtin_exceptions.match_failure,
          [
            "ai.ml",
            197,
            6
          ]
        ];
  }
}

function completed_dtickets(p, _dtickets) {
  while(true) {
    var dtickets = _dtickets;
    if (dtickets) {
      var match = dtickets[0];
      if (Board.completed(match[/* loc1 */0], match[/* loc2 */1], p[/* routes */4], /* [] */0)) {
        _dtickets = dtickets[1];
        continue ;
      } else {
        return false;
      }
    } else {
      return true;
    }
  };
}

function next_move(rts, sec_draw, faceup, cpu) {
  if (sec_draw) {
    var goal_routes = best_routes(rts, best_paths(cpu[/* destination_tickets */1]));
    var routes = check_routes_list(cpu, rts, goal_routes);
    var goal_routes$1 = List.flatten(routes);
    var colors = desired_colors(goal_routes$1, cpu, /* [] */0);
    if (check_faceup(colors, faceup)) {
      return /* Take_Faceup */2;
    } else {
      return /* Take_Deck */3;
    }
  } else if (completed_dtickets(cpu, cpu[/* destination_tickets */1]) && cpu[/* trains_remaining */5] > 5) {
    return /* Take_DTicket */0;
  } else {
    var goal_routes$2 = best_routes(rts, best_paths(cpu[/* destination_tickets */1]));
    var routes$1 = check_routes_list(cpu, rts, goal_routes$2);
    var goal_routes$3 = List.flatten(routes$1);
    var build_options = can_build(goal_routes$3, cpu);
    if (List.length(build_options) > 0) {
      return /* Place_Train */1;
    } else {
      var colors$1 = desired_colors(goal_routes$3, cpu, /* [] */0);
      if (check_faceup(colors$1, faceup)) {
        return /* Take_Faceup */2;
      } else {
        return /* Take_Deck */3;
      }
    }
  }
}

exports.next_move = next_move;
exports.ai_facing_up = ai_facing_up;
exports.ai_take_dticket = ai_take_dticket;
exports.ai_place_train = ai_place_train;
exports.ai_setup = ai_setup;
/* Board Not a pure module */
