open State

type action = Take_DTicket | Place_Train | Take_Faceup | Take_Deck

val next_move : state -> action

(* [ai_move] represents the next move taken by the AI.*)
val ai_move : state -> state

val ai_setup : state -> state

val dest_ticket_action: state -> Components.destination_ticket list -> int list

(* what train color you want to use to place the train and how many number of wildcards *)
val place_action : state -> Components.train_color -> int