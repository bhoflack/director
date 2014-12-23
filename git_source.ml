let git_clone (GitSource ref) = print_endline ref

let download packages = 
    List.map packages ~f: (fun package -> package.source)
    |> List.map ~f: git_clone
