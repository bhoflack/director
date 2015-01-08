open Core.Std
open Types
open Yojson.Basic.Util

exception Task_Not_Found of string

let to_list_or_default def el =
    if phys_equal el `Null
    then def
    else to_list el

let from_string str =
    let parse_dependency dep = { dr_name = dep |> member "name" |> to_string;
                                 dr_version = dep |> member "version" |> to_string;
                                 dr_task_name = dep |> member "task_name" |> to_string;
                                 dr_source = GitSource (dep |> member "git" |> to_string)
                               } in
    let parse_task task = let dependencies = task |> member "depends" |> to_list_or_default [] in
                          let command = task |> member "command" |> to_string_option in
                          { tr_name = task |> member "task_name" |> to_string;
                            tr_command = command;
                            tr_dependencies = List.map dependencies ~f: parse_dependency} in
                          

    let json = Yojson.Basic.from_string str in
    let name = json |> member "name" |> to_string in
    let version = json |> member "version" |> to_string in
    let tasks = json |> member "tasks" |> to_list_or_default [] in
    let tasks' = List.map tasks ~f: parse_task in
    { name = name; version = version; tasks = tasks' }

let find_task_ref
    ~task_name
    project =
        match (List.find project.tasks ~f:(fun task -> task.tr_name = task_name)) with
          | Some tr -> tr
          | None -> raise (Task_Not_Found task_name)
