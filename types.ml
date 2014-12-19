type source = 
    | GitSource of string
    | Path of string
type dependency_ref = { name: string; version: string; task_name: string; source: source }
type task = { name: string; dependencies: dependency_ref list }
type project = { name: string; version: string; tasks: task list }

