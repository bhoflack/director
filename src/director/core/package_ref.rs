use core::SourceRef;

#[deriving(Show, Eq, PartialEq)]
pub struct PackageRef {
    Name:       String,
    Version:    String,
    SourceRef:  SourceRef,
}
