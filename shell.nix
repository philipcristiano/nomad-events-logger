let
  sysPkg = import <nixpkgs> { };
  releasedPkgs = sysPkg.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "23.05";
    sha256 = "sha256-btHN1czJ6rzteeCuE/PNrdssqYD2nIA4w48miQAFloM=";
  };
  pkgs = import releasedPkgs {};
  stdenv = pkgs.stdenv;
  extraInputs = sysPkg.lib.optionals stdenv.isDarwin (with sysPkg.darwin.apple_sdk.frameworks; [
    Cocoa
    CoreServices]);

in stdenv.mkDerivation {
  name = "env";
  buildInputs = [ pkgs.gnumake
                  pkgs.wget
                  pkgs.cargo
                  pkgs.rustc
                  pkgs.libiconv # https://stackoverflow.com/questions/68679040/error-linking-with-cc-failed-exit-code-1-for-cargo-run
                  pkgs.rust-analyzer

                ] ++ extraInputs;
  shellHook = ''

  '';
}
