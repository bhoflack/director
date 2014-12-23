open Sexplib
open Sexplib.Std

type source = 
    | GitSource of string
    | Path of string
    with sexp

type dependency_ref = { dependency_name: string; 
                        dependency_version: string;
                        dependency_task_name: string; 
                        source: source } with sexp
type task = { task_name: string; dependencies: dependency_ref list } with sexp
type project = { name: string; version: string; tasks: task list } with sexp

