open State

type action = Take_DTicket | Place_Train | Take_Faceup | Take_Deck

val next_move : state -> action

(* [ai_move] represents the next move taken by the AI.*)
val ai_move : state -> state

val ai_setup : state -> state