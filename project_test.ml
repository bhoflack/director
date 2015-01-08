open Types
open OUnit2

let find_task_not_found _ =
    let project = { name = "test-project";
                    version = "1.0.0";
                    tasks = [] } in
    try
        let _ = Project.find_task_ref ~task_name: "test" project in
        assert_failure "Should trigger task not found exception"
    with
        Project.Task_Not_Found _ -> ()

let find_task _ =
    let task = { tr_name = "latest"; tr_command = None; tr_dependencies = [] } in
    let project = { name = "test-project";
                    version = "1.0.0";
                    tasks = [task]} in
    assert_equal task (Project.find_task_ref ~task_name: "latest" project)

let suite =
    "Project tests" >:::
        ["Task not found" >:: find_task_not_found;
         "Task found" >:: find_task]

let () = run_test_tt_main suite
