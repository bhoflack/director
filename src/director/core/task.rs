use core::PackageRef;

#[deriving(Show, Eq, PartialEq)]
pub struct Task {
    Name:       String,
    Depends:    Vec<PackageRef>,
    Command:    String,
}

