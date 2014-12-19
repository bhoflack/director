open Types
open OUnit2

let decode_simple_project _ = 
    assert_equal (Some {name = "test-project";
                        version = "1.0.0";
                        tasks = []})
                 (Project.from_string "{\"name\": \"test-project\", \"version\": \"1.0.0\"}")

let suite =
    "JSON decoding" >:::
        ["decode simple project" >:: decode_simple_project]

let () =
    run_test_tt_main suite
