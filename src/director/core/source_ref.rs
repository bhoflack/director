use serialize::{json, Decodable, Decoder};

#[deriving(Show, Eq, PartialEq)]
pub enum SourceRef {
    // A git source,  with the ref as a path
    Git(String),
}
