pub trait Source {

    // Download all package refs from the source.  Resolve them to packages.
    fn download(package_refs: &Package_ref[]) -> Vec<Package>;
}
