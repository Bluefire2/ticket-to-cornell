type command = (string*string)

(* Helper function:
 * [find str chr] gives the same result as [String.index str chr] except that
 * if chr is not in str it returns -1 instead of an exception.
 * Inspired by Python's find function. *)
let find str chr =
  try String.index str chr with
  | _ -> -1

(* [parse str] returns a tuple representing the command that str is.
 * It divides str in placing everything before the first space in the first
 * index of a tuple and everything after the first space in the second index
 * of the tuple. If there is no space, it returns (str, "") *)
let parse str =
  let str = String.lowercase_ascii str in
  let space_index = find str ' ' in
  if space_index != -1 then
    let verb = String.sub str 0 space_index in
    let len_obj = (String.length str - space_index - 1) in
    let obj = String.sub str (space_index+1) len_obj in
    verb, obj
  else (str, "")
