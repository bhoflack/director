use core::Task;
use serialize::{json};

#[deriving(Show, Eq, PartialEq)]
pub struct Project {
    name:       String,
    version:    String,
    tasks:      Vec<Task>,
}

pub fn from_json(manifest: &str) -> Option<Project> {
    match json::from_str(manifest) {
        Ok(json::Json::Object(obj)) => {
            let project = Project {
                name: obj.get("Name"),
                version: obj.get("Version"),
                tasks: obj.get("Tasks")};
            Some(project)
        }
        _               => None
    }
}

#[cfg(test)]
mod test {

    use core::Project;
    use core::project::from_json;

    #[test]
    pub fn test_project_from_json() {
        let manifest = "{\"Name\": \"test-project\", \"Version\": \"1.0.0\", \"Tasks\": []}";
        let expected = Project {Name: String::from_str("test-project"), 
                                Version: String::from_str("1.0.0"),
                                Tasks: Vec::new()};
        assert_eq!(expected, from_json(manifest).unwrap());
    }
}
