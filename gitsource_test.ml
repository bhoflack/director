open Core.Std
open OUnit2

let generate_dirname _ = 
  assert_equal "cache/platform-b17b4f"
               (Gitsource.generate_dirname "git@github.com:bhoflack/platform");
  assert_equal "cache/platform-32bdb5"
               (Gitsource.generate_dirname "git@github.com:bhoflack/platform.git")

let suite =
  "Git tests" >:::
    ["generate a dirname for a git repository" >:: generate_dirname]

let () =
  run_test_tt_main suite
