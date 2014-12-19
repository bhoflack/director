open Core.Std
open Types
open Yojson.Basic.Util

let from_string json =
    let name = json |> member "name" |> to_string in
    let version = json |> member "version" |> to_string in
    name >>= fun (name) ->
    version >>= fun (version) ->         
    { name = name;
      version = version;
      tasks = []
    }
