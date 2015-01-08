open Core.Std
open Types
open OUnit2

let decode_simple_project _ = 
  assert_equal ({name = "test-project";
                 version = "1.0.0";
                 tasks = []})
               (Project.from_string "{\"name\": \"test-project\", \"version\": \"1.0.0\"}")

let decode_invalid_project _ =
  try
    let _ = Project.from_string "{\"name\": \"blaat\"}" in
    assert_failure "Should trigger exception"
  with
    _ -> ()

let decode_project_with_tasks _ =
  assert_equal 
    {name = "test-project";
     version = "1.0.0";
     tasks = [ { tr_name = "latest";
                 tr_command = None;
                 tr_dependencies = [{dr_name = "platform";
                                     dr_version = "1.0.0-SNAPSHOT";
                                     dr_task_name = "latest";
                                     dr_source = GitSource "git@github.com:blaat/platform"}]};
               { tr_name = "release";
                 tr_command = None;
                 tr_dependencies = [{dr_name = "platform";
                                     dr_version = "1.0.0";
                                     dr_task_name = "release";
                                     dr_source = GitSource "git@github.com:blaat/platform"}]}]}
    (Project.from_string "{\"name\": \"test-project\",
                          \"version\": \"1.0.0\",
                          \"tasks\": [ {\"task_name\": \"latest\",
                          \"depends\": [{\"name\": \"platform\",
                          \"version\": \"1.0.0-SNAPSHOT\",
                          \"task_name\": \"latest\",
                          \"git\": \"git@github.com:blaat/platform\"}]},
                          {\"task_name\": \"release\",
                          \"depends\": [{\"name\": \"platform\",
                          \"version\": \"1.0.0\",
                          \"task_name\": \"release\",
                          \"git\": \"git@github.com:blaat/platform\"}]}]}")

let suite =
  "JSON decoding" >:::
    ["decode simple project" >:: decode_simple_project;
     "decode invalid project" >:: decode_invalid_project;
     "decode project with tasks" >:: decode_project_with_tasks ]

let () =
  run_test_tt_main suite
