pub struct Project {
    name:       String,
    version:    String,
    tasks:      Vec<Task>,
}

impl Project {

}


#[cfg(test)]
mod test {

    #[test]
    pub fn test_project_from_toml() {
        let manifest = "name: test-project
                        version: 1.0.0"
        let expected = Project {name: "test-project", version: "1.0.0"}
        assert_eq!(expected, from_toml(manifest))
    }
}
