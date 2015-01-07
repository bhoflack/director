open Core.Std
open Async.Std
open Types

let (>>|?) c f =
    c >>= fun oc ->
        match oc with
            | None -> return None
            | Some v -> return (Some (f v))

let flatten o =
    match o with
        | Some (Some el) -> Some el
        | _ -> None

let load_project 
    path
    =
    Reader.file_contents path
    >>| Project.from_string

let resolve_source
    source =
        match source with
          | GitSource src -> 
                  let gs = Gitsource.from_ref src in
                  Gitsource.update gs; ResolvedGitRepo gs
          | Path src -> ResolvedPath (Filesource.from_path src)

let dependency_path src = match src with
    | ResolvedGitRepo src -> Gitsource.dir src
    | ResolvedPath src -> Filesource.dir src

(* Resolve a task ref to a task *)
let rec resolve_task
    task_ref =
        (* Find the task ref corresponding to the given dependency ref *)
        let resolve_dependency dep =
            let resolved_source = resolve_source dep.dr_source in
            let dep_path = dependency_path resolved_source in
            let project_path = "cache/" ^ dep_path ^ "/director.json" in
            load_project project_path
            >>| Project.find_task_ref ~task_name: dep.dr_task_name
        in
        Deferred.all (List.map task_ref.tr_dependencies ~f: resolve_dependency)
        >>= (fun task_refs -> Deferred.all (List.map task_refs ~f: resolve_task))
        >>= fun tasks ->
            return 
                { t_name = task_ref.tr_name;
                  t_command = task_ref.tr_command;
                  t_dependencies = tasks;
                }

let resolve_tasks
    ~project_path
    ~task_name =
        load_project project_path
        >>| Project.find_task_ref ~task_name
        >>= resolve_task

let rec run_tasks
        task =
            Deferred.all (List.map task.t_dependencies ~f: run_tasks) 
            >>| fun _ -> (Option.map task.t_command 
                                    ~f: (fun cmd ->
                                        print_endline ("Running command " ^ cmd);
                                        Unix.fork_exec ~prog: "/bin/dash"
                                                       ~args: ["dash"; "-c"; cmd]
                                                       ()
                                        >>= Unix.waitpid))

let run
    ~task_name = 
        resolve_tasks ~project_path: "director.json" ~task_name
        >>= run_tasks
        >>= fun _ -> Deferred.unit
        

let () =
    Command.async_basic
        ~summary: "Execute tasks with dependencies"
        Command.Spec.(
            empty
            +> flag "-task" (required string)
                ~doc: "Task to execute"
        )
        (fun task () -> run ~task_name: task)
        |> Command.run
