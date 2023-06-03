let
  oxalica_overlay = import (builtins.fetchTarball
    "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  nixpkgs = import <nixpkgs> { overlays = [ oxalica_overlay ]; };

  # Rolling updates, not deterministic.
  rust_channel = nixpkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain;

in with nixpkgs; 
pkgs.mkShell {

  buildInputs = [
    pkgs.cargo
    pkgs.rustc
    pkgs.libusb1
    gnumake
    pkgsCross.arm-embedded.buildPackages.gcc
    #pkgsCross.muslpi.buildPackages.gcc
  ];

  nativeBuildInputs = [
    (rust_channel.override{
      extensions = [ "rust-src" "rust-std" ];
    })
    llvmPackages.clang
    pkgconfig

    # tools
    codespell
  ];

  RUST_BACKTRACE = 1;

  # compilation of -sys packages requires manually setting LIBCLANG_PATH
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

}
