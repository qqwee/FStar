module Ex01a 
//safe-read-write

// CH: Are we sure we want to get rid of all modules here
//     (as opposed to split this between some files)?

// CH: I tried to hook this up so that at least it prints something
//     every time read or write are executed

type filename = string

(* canWrite is a function specifying whether or not a file f can be written *)
let canWrite (f:filename) = 
  match f with 
    | "demo/tempfile" -> true
    | _ -> false

(* canRead is also a function ... *)
let canRead (f:filename) = 
  canWrite f               (* writeable files are also readable *)
  || f="demo/README"       (* and so is this file *)
// END: ACLs

val read  : f:filename{canRead f}  -> string
let read f  = FStar.IO.print_string ("Dummy read of file " ^ f ^ "\n"); f

val write : f:filename{canWrite f} -> string -> unit
let write f s = FStar.IO.print_string ("Dummy write of string " ^ s ^ " to file " ^ f ^ "\n")

let passwd  = "demo/password"
let readme  = "demo/README"
let tmp     = "demo/tempfile"


let staticChecking () =
  let v1 = read tmp in
  let v2 = read readme in
  (* let v3 = read passwd in -- invalid read, fails type-checking *)
  write tmp "hello!"
  (* ; write passwd "junk" -- invalid write , fails type-checking *)



exception InvalidRead
val checkedRead : filename -> string
let checkedRead f =
  if canRead f then read f else raise InvalidRead



val checkedWrite : filename -> string -> unit
// BEGIN: CheckedWrite

exception InvalidWrite
let checkedWrite f s =
  if canWrite f then write f s else raise InvalidWrite
// END: CheckedWrite


let dynamicChecking () =
  let v1 = checkedRead tmp in
  let v2 = checkedRead readme in
  let v3 = checkedRead passwd in (* this raises exception *)
  checkedWrite tmp "hello!";
  checkedWrite passwd "junk" (* this raises exception *)

let main = staticChecking (); dynamicChecking ()
