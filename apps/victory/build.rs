fn main() {
    println!("cargo:rustc-link-arg-bin=victory=/EXPORT:D3D12SDKVersion,DATA");
    println!("cargo:rustc-link-arg-bin=victory=/EXPORT:D3D12SDKPath,DATA");
}
