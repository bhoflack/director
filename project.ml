open Core.Std
open Types
open Yojson.Basic.Util

let to_list_or_default def el =
    if phys_equal el `Null
    then def
    else to_list el

let from_string str =
    let parse_dependency dep = { dependency_name = dep |> member "name" |> to_string;
                                 dependency_version = dep |> member "version" |> to_string;
                                 dependency_task_name = dep |> member "task_name" |> to_string;
                                 source = GitSource (dep |> member "git" |> to_string)
                               } in
    let parse_task task = let dependencies = task |> member "depends" |> to_list_or_default [] in
                          { task_name = task |> member "task_name" |> to_string;
                            dependencies = List.map dependencies ~f: parse_dependency} in
                          

    try
        let json = Yojson.Basic.from_string str in
        let name = json |> member "name" |> to_string in
        let version = json |> member "version" |> to_string in
        let tasks = json |> member "tasks" |> to_list_or_default [] in
        let tasks' = List.map tasks ~f: parse_task in
        Some { name = name;
               version = version;
               tasks = tasks'
             }
    with
      | Yojson.Basic.Util.Type_error(_,_) -> None
