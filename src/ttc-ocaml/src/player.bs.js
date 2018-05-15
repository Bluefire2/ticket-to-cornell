// Generated by BUCKLESCRIPT VERSION 3.0.0, PLEASE EDIT WITH CARE
'use strict';

var List = require("bs-platform/lib/js/list.js");
var Board = require("./board.bs.js");
var Caml_obj = require("bs-platform/lib/js/caml_obj.js");
var Pervasives = require("bs-platform/lib/js/pervasives.js");

function color_of_int(n) {
  if (n > 4 || n < 0) {
    return Pervasives.failwith("impossible");
  } else {
    return n;
  }
}

function destination_tickets(p) {
  return p[/* destination_tickets */1];
}

function routes(p) {
  return p[/* routes */4];
}

function update_destination_tickets(p, tickets) {
  return /* record */[
          /* color */p[/* color */0],
          /* destination_tickets */Pervasives.$at(tickets, p[/* destination_tickets */1]),
          /* train_cards */p[/* train_cards */2],
          /* score */p[/* score */3],
          /* routes */p[/* routes */4],
          /* trains_remaining */p[/* trains_remaining */5],
          /* first_turn */false,
          /* last_turn */p[/* last_turn */7],
          /* bot */p[/* bot */8]
        ];
}

function increase_score(p, n) {
  return /* record */[
          /* color */p[/* color */0],
          /* destination_tickets */p[/* destination_tickets */1],
          /* train_cards */p[/* train_cards */2],
          /* score */p[/* score */3] + n | 0,
          /* routes */p[/* routes */4],
          /* trains_remaining */p[/* trains_remaining */5],
          /* first_turn */p[/* first_turn */6],
          /* last_turn */p[/* last_turn */7],
          /* bot */p[/* bot */8]
        ];
}

function completed_destination_tickets(p) {
  var _p = p;
  var _param = p[/* destination_tickets */1];
  while(true) {
    var param = _param;
    var p$1 = _p;
    if (param) {
      var t = param[1];
      var match = param[0];
      if (Board.completed(match[/* loc1 */0], match[/* loc2 */1], p$1[/* routes */4], /* [] */0)) {
        _param = t;
        _p = increase_score(p$1, match[/* points */2]);
        continue ;
      } else {
        _param = t;
        continue ;
      }
    } else {
      return p$1;
    }
  };
}

function train_cards(p) {
  return p[/* train_cards */2];
}

function score(p) {
  return p[/* score */3];
}

function first_turn(p) {
  return p[/* first_turn */6];
}

function last_turn(p) {
  return p[/* last_turn */7];
}

function color(p) {
  return p[/* color */0];
}

function is_bot(p) {
  return p[/* bot */8];
}

function trains_remaining(p) {
  return p[/* trains_remaining */5];
}

function add_train_cards(_lst, c, _acc) {
  while(true) {
    var acc = _acc;
    var lst = _lst;
    if (lst) {
      var t = lst[1];
      var match = lst[0];
      var b = match[1];
      var a = match[0];
      if (Caml_obj.caml_equal(c, a)) {
        return Pervasives.$at(acc, /* :: */[
                    /* tuple */[
                      a,
                      b + 1 | 0
                    ],
                    t
                  ]);
      } else {
        _acc = Pervasives.$at(acc, /* :: */[
              /* tuple */[
                a,
                b
              ],
              /* [] */0
            ]);
        _lst = t;
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function init_players(n, bot) {
  if (n !== 0) {
    var p_000 = /* color */color_of_int(n - 1 | 0);
    var p_002 = /* train_cards : :: */[
      /* tuple */[
        /* Red */0,
        0
      ],
      /* :: */[
        /* tuple */[
          /* Blue */2,
          0
        ],
        /* :: */[
          /* tuple */[
            /* Green */1,
            0
          ],
          /* :: */[
            /* tuple */[
              /* Yellow */3,
              0
            ],
            /* :: */[
              /* tuple */[
                /* Black */7,
                0
              ],
              /* :: */[
                /* tuple */[
                  /* White */6,
                  0
                ],
                /* :: */[
                  /* tuple */[
                    /* Pink */4,
                    0
                  ],
                  /* :: */[
                    /* tuple */[
                      /* Wild */8,
                      0
                    ],
                    /* :: */[
                      /* tuple */[
                        /* Orange */5,
                        0
                      ],
                      /* [] */0
                    ]
                  ]
                ]
              ]
            ]
          ]
        ]
      ]
    ];
    var p = /* record */[
      p_000,
      /* destination_tickets : [] */0,
      p_002,
      /* score */0,
      /* routes : [] */0,
      /* trains_remaining */45,
      /* first_turn */true,
      /* last_turn */false,
      /* bot */bot
    ];
    return /* :: */[
            p,
            init_players(n - 1 | 0, bot)
          ];
  } else {
    return /* [] */0;
  }
}

function draw_train_card(p, c) {
  return /* record */[
          /* color */p[/* color */0],
          /* destination_tickets */p[/* destination_tickets */1],
          /* train_cards */add_train_cards(p[/* train_cards */2], c, /* [] */0),
          /* score */p[/* score */3],
          /* routes */p[/* routes */4],
          /* trains_remaining */p[/* trains_remaining */5],
          /* first_turn */p[/* first_turn */6],
          /* last_turn */p[/* last_turn */7],
          /* bot */p[/* bot */8]
        ];
}

function remove_color(n, c, lst) {
  if (n === 0) {
    return lst;
  } else {
    var _acc = /* [] */0;
    var _param = lst;
    while(true) {
      var param = _param;
      var acc = _acc;
      if (param) {
        var t = param[1];
        var match = param[0];
        var a2 = match[1];
        var a1 = match[0];
        if (Caml_obj.caml_equal(a1, c)) {
          return Pervasives.$at(acc, Pervasives.$at(/* :: */[
                          /* tuple */[
                            a1,
                            a2 - n | 0
                          ],
                          /* [] */0
                        ], t));
        } else {
          _param = t;
          _acc = Pervasives.$at(acc, /* :: */[
                /* tuple */[
                  a1,
                  a2
                ],
                /* [] */0
              ]);
          continue ;
        }
      } else {
        return acc;
      }
    };
  }
}

function place_train(p, r, wild) {
  var wild_removed = remove_color(wild, /* Wild */8, p[/* train_cards */2]);
  var cards = remove_color(Board.get_length(r) - wild | 0, Board.get_color(r), wild_removed);
  return /* record */[
          /* color */p[/* color */0],
          /* destination_tickets */p[/* destination_tickets */1],
          /* train_cards */cards,
          /* score */p[/* score */3] + Board.route_score(r) | 0,
          /* routes : :: */[
            r,
            p[/* routes */4]
          ],
          /* trains_remaining */p[/* trains_remaining */5] - Board.get_length(r) | 0,
          /* first_turn */p[/* first_turn */6],
          /* last_turn */p[/* last_turn */7],
          /* bot */p[/* bot */8]
        ];
}

function set_last_turn(p) {
  return /* record */[
          /* color */p[/* color */0],
          /* destination_tickets */p[/* destination_tickets */1],
          /* train_cards */p[/* train_cards */2],
          /* score */p[/* score */3],
          /* routes */p[/* routes */4],
          /* trains_remaining */p[/* trains_remaining */5],
          /* first_turn */p[/* first_turn */6],
          /* last_turn */true,
          /* bot */p[/* bot */8]
        ];
}

function between_before(l, _acc, _param) {
  while(true) {
    var param = _param;
    var acc = _acc;
    if (param) {
      if (Caml_obj.caml_equal(param[0], l)) {
        return Pervasives.$at(acc, /* :: */[
                    l,
                    /* [] */0
                  ]);
      } else {
        _param = param[1];
        _acc = Pervasives.$at(acc, /* :: */[
              l,
              /* [] */0
            ]);
        continue ;
      }
    } else {
      return acc;
    }
  };
}

function calculate_paths(l1, l2, locations, paths) {
  if (List.mem(l1, locations)) {
    var loop = function (_acc, _param) {
      while(true) {
        var param = _param;
        var acc = _acc;
        if (param) {
          var t = param[1];
          var match = param[0];
          var last = match[2];
          var between = match[1];
          var hd = match[0];
          if (Caml_obj.caml_equal(l1, last)) {
            _param = t;
            _acc = Pervasives.$at(acc, /* :: */[
                  /* tuple */[
                    hd,
                    Pervasives.$at(between, /* :: */[
                          l1,
                          /* [] */0
                        ]),
                    l2
                  ],
                  /* [] */0
                ]);
            continue ;
          } else if (List.mem(l1, between)) {
            _param = t;
            _acc = Pervasives.$at(acc, Pervasives.$at(/* :: */[
                      /* tuple */[
                        hd,
                        between,
                        last
                      ],
                      /* [] */0
                    ], /* :: */[
                      /* tuple */[
                        hd,
                        between_before(l1, /* [] */0, between),
                        l2
                      ],
                      /* [] */0
                    ]));
            continue ;
          } else {
            _param = t;
            _acc = Pervasives.$at(acc, Pervasives.$at(/* :: */[
                      /* tuple */[
                        hd,
                        between,
                        last
                      ],
                      /* [] */0
                    ], /* :: */[
                      /* tuple */[
                        l1,
                        /* [] */0,
                        l2
                      ],
                      /* [] */0
                    ]));
            continue ;
          }
        } else {
          return acc;
        }
      };
    };
    return /* tuple */[
            locations,
            loop(/* [] */0, paths)
          ];
  } else {
    return /* tuple */[
            /* :: */[
              l1,
              locations
            ],
            /* :: */[
              /* tuple */[
                l1,
                /* [] */0,
                l2
              ],
              paths
            ]
          ];
  }
}

function length(_acc, _param) {
  while(true) {
    var param = _param;
    var acc = _acc;
    if (param) {
      _param = param[1];
      _acc = acc + Board.get_length(param[0]) | 0;
      continue ;
    } else {
      return acc;
    }
  };
}

function longest_route(p) {
  var _longest = 0;
  var _locations = /* [] */0;
  var _paths = /* [] */0;
  var _param = p[/* routes */4];
  while(true) {
    var param = _param;
    var paths = _paths;
    var locations = _locations;
    var longest = _longest;
    if (param) {
      var t = param[1];
      var match = param[0];
      var n1 = Board.name(match[0]);
      var n2 = Board.name(match[1]);
      var match$1 = calculate_paths(n1, n2, locations, paths);
      var match$2 = calculate_paths(n2, n1, match$1[0], match$1[1]);
      var paths$prime = match$2[1];
      var locations$prime = match$2[0];
      var loop2 = function (_acc, _param) {
        while(true) {
          var param = _param;
          var acc = _acc;
          if (param) {
            var match = param[0];
            var p$1 = Board.path_routes(p[/* routes */4], Pervasives.$at(/* :: */[
                      match[0],
                      /* [] */0
                    ], Pervasives.$at(match[1], /* :: */[
                          match[2],
                          /* [] */0
                        ])));
            _param = param[1];
            _acc = Pervasives.$at(acc, /* :: */[
                  p$1,
                  /* [] */0
                ]);
            continue ;
          } else {
            return acc;
          }
        };
      };
      var paths$prime$prime = loop2(/* [] */0, paths$prime);
      var loop3 = function (_best, _param) {
        while(true) {
          var param = _param;
          var best = _best;
          if (param) {
            var t = param[1];
            var l = length(0, param[0]);
            _param = t;
            if (l >= best) {
              _best = l;
              continue ;
            } else {
              continue ;
            }
          } else {
            return best;
          }
        };
      };
      var l2 = loop3(0, paths$prime$prime);
      _param = t;
      _paths = paths$prime;
      _locations = locations$prime;
      if (l2 >= longest) {
        _longest = l2;
        continue ;
      } else {
        continue ;
      }
    } else {
      return longest;
    }
  };
}

exports.destination_tickets = destination_tickets;
exports.update_destination_tickets = update_destination_tickets;
exports.increase_score = increase_score;
exports.completed_destination_tickets = completed_destination_tickets;
exports.train_cards = train_cards;
exports.score = score;
exports.color = color;
exports.is_bot = is_bot;
exports.routes = routes;
exports.first_turn = first_turn;
exports.last_turn = last_turn;
exports.trains_remaining = trains_remaining;
exports.init_players = init_players;
exports.draw_train_card = draw_train_card;
exports.place_train = place_train;
exports.set_last_turn = set_last_turn;
exports.longest_route = longest_route;
/* Board Not a pure module */
