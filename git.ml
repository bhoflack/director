open Core.Std

(* Generate a unique dirname for a git ref *)
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
          Option.map project ~f:(fun project -> project ^ "-" ^ digest)

let clone
    ~dir
    ref = let pid = Unix.fork_exec ~prog: "git"
                                   ~args: ["git"; "clone"; ref; dir]
                                   () in
          Unix.waitpid_exn pid



let fetch
    ~dir
    () = let pid = Unix.fork_exec ~prog: "git"
                                  ~args: ["git"; "-C"; dir; "fetch"; "origin"]
                                  () in
         Unix.waitpid_exn pid
