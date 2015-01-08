open Core.Std

type t = {
    dirname: string;
  } with sexp

let from_path 
      path = { dirname = path }

let dir t = t.dirname

