open Core.Std

type t = {
    dirname: string;
    ref: string;
  } with sexp

exception Invalid_Projectname

let generate_dirname 
      ref = let extract_projectname ref =
              match (List.last (String.split ref ~on:'/')) with
              | Some project ->
                 (match List.hd (String.split project ~on:'.') with
                  | Some project -> Some project
                  | _ -> Some project)
              | None -> None in
            let digest = String.slice (Digest.to_hex (Digest.string ref)) 0 6 in
            let project = extract_projectname ref in
            match project with
            | Some project -> "cache/" ^ project ^ "-" ^ digest
            | None -> raise Invalid_Projectname

let is_dir d =
  try
    let stats = Unix.stat d in
    stats.st_kind = S_DIR
  with
    Unix.Unix_error _ -> false

let ensure_dir d =
  if not (is_dir d)
  then Unix.mkdir d

(* Generate a gitsource from a string reference *)
let from_ref ref =
  let dirname = generate_dirname ref in
  { dirname; ref }

(* Update the gitsource *)
let update t =
  ensure_dir "cache";
  if not (is_dir (t.dirname ^ "/.git"))
  then Git.clone ~dir:t.dirname t.ref
  else Git.fetch ~dir:t.dirname ()


let dir t = t.dirname
