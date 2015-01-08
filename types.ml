open Sexplib
open Sexplib.Std

type source = 
    | GitSource of string
    | Path of string
    with sexp

type resolved_source =
    | ResolvedGitRepo of Gitsource.t
    | ResolvedPath of Filesource.t
    with sexp

type dependency_ref = { dr_name: string; 
                        dr_version: string;
                        dr_task_name: string; 
                        dr_source: source } with sexp

type dependency = { d_name: string;
                    d_version: string;
                    d_source: resolved_source;
                    d_task_name: string;
                    d_dependencies: dependency list;
                  } with sexp

type task_ref = { tr_name: string; 
                  tr_dependencies: dependency_ref list;
                  tr_command: string option;
                } with sexp

type task = { t_name: string;
              t_dependencies: (resolved_source * task) list;
              t_command: string option;
            } with sexp

type project = { name: string; version: string; tasks: task_ref list } with sexp

exception Invalid_Projectname
